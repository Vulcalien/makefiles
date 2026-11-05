# Vulcalien's Library Makefile
# version 0.3.8

TARGET := UNIX

# ==================================================================== #
#                              Basic Info                              #
# ==================================================================== #

OUT_FILENAME := libname

SRC_DIR := src
OBJ_DIR := obj
BIN_DIR := bin

SRC_SUBDIRS :=

# ==================================================================== #
#                             Compilation                              #
# ==================================================================== #

ASFLAGS_STATIC :=
ASFLAGS_SHARED :=

CPPFLAGS := -MMD -MP -Iinclude

CFLAGS_STATIC := -Wall -pedantic
CFLAGS_SHARED := -Wall -pedantic -fPIC -fvisibility=hidden

CXXFLAGS_STATIC := -Wall -pedantic
CXXFLAGS_SHARED := -Wall -pedantic -fPIC -fvisibility=hidden

ifeq ($(TARGET),UNIX)
    AS  := as
    CC  := gcc
    CXX := g++

    LDFLAGS := -shared
    LDLIBS  :=
else ifeq ($(TARGET),WINDOWS)
    AS  := x86_64-w64-mingw32-as
    CC  := x86_64-w64-mingw32-gcc
    CXX := x86_64-w64-mingw32-g++

    LDFLAGS := -shared
    LDLIBS  :=
endif

# ==================================================================== #
#                        Extensions & Commands                         #
# ==================================================================== #

ifeq ($(TARGET),UNIX)
    OBJ_EXT    := o
    STATIC_EXT := a
    SHARED_EXT := so
else ifeq ($(TARGET),WINDOWS)
    OBJ_EXT    := obj
    STATIC_EXT := win.a
    SHARED_EXT := dll
endif

MKDIR := mkdir -p
RM    := rm -rfv

# ==================================================================== #
#                              Resources                               #
# ==================================================================== #

SRC_EXT := s c cpp

SRC_DIRS := $(SRC_DIR) $(foreach SUB,$(SRC_SUBDIRS),$(SRC_DIR)/$(SUB))
OBJ_DIRS := $(SRC_DIRS:%=$(OBJ_DIR)/static/%)\
            $(SRC_DIRS:%=$(OBJ_DIR)/shared/%)

SRC := $(foreach DIR,$(SRC_DIRS),\
         $(foreach EXT,$(SRC_EXT),\
           $(wildcard $(DIR)/*.$(EXT))))

OBJ_STATIC := $(SRC:%=$(OBJ_DIR)/static/%.$(OBJ_EXT))
OBJ_SHARED := $(SRC:%=$(OBJ_DIR)/shared/%.$(OBJ_EXT))

OUT_STATIC := $(BIN_DIR)/$(OUT_FILENAME).$(STATIC_EXT)
OUT_SHARED := $(BIN_DIR)/$(OUT_FILENAME).$(SHARED_EXT)

# ==================================================================== #
#                               Targets                                #
# ==================================================================== #

.PHONY: all build-static build-shared clean

all: build-static build-shared

build-static: $(OUT_STATIC)
build-shared: $(OUT_SHARED)

clean:
	@$(RM) $(BIN_DIR) $(OBJ_DIR)

# generate static library file
$(OUT_STATIC): $(OBJ_STATIC) | $(BIN_DIR)
	$(AR) rcs $@ $^

# generate shared library file
$(OUT_SHARED): $(OBJ_SHARED) | $(BIN_DIR)
	$(CC) $(LDFLAGS) $^ $(LDLIBS) -o $@

# compile .s files for static library
$(OBJ_DIR)/static/%.s.$(OBJ_EXT): %.s | $(OBJ_DIRS)
	$(AS) $(ASFLAGS_STATIC) $< -o $@

# compile .s files for shared library
$(OBJ_DIR)/shared/%.s.$(OBJ_EXT): %.s | $(OBJ_DIRS)
	$(AS) $(ASFLAGS_SHARED) $< -o $@

# compile .c files for static library
$(OBJ_DIR)/static/%.c.$(OBJ_EXT): %.c | $(OBJ_DIRS)
	$(CC) $(CPPFLAGS) $(CFLAGS_STATIC) -c $< -o $@

# compile .c files for shared library
$(OBJ_DIR)/shared/%.c.$(OBJ_EXT): %.c | $(OBJ_DIRS)
	$(CC) $(CPPFLAGS) $(CFLAGS_SHARED) -c $< -o $@

# compile .cpp files for static library
$(OBJ_DIR)/static/%.cpp.$(OBJ_EXT): %.cpp | $(OBJ_DIRS)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS_STATIC) -c $< -o $@

# compile .cpp files for shared library
$(OBJ_DIR)/shared/%.cpp.$(OBJ_EXT): %.cpp | $(OBJ_DIRS)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS_SHARED) -c $< -o $@

# create directories
$(BIN_DIR) $(OBJ_DIRS):
	$(MKDIR) $@

-include $(OBJ_STATIC:.$(OBJ_EXT)=.d)
-include $(OBJ_SHARED:.$(OBJ_EXT)=.d)
