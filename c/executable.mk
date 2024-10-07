# Vulcalien's Executable Makefile
# version 0.3.4

TARGET := UNIX

# === Basic Info ===
OUT_FILENAME := exename

SRC_DIR := src
OBJ_DIR := obj
BIN_DIR := bin

SRC_SUBDIRS :=

# === Compilation ===
CPPFLAGS := -Iinclude -MMD -MP
CFLAGS   := -Wall -pedantic

ifeq ($(TARGET),UNIX)
    # UNIX-like
    CC := gcc

    CPPFLAGS +=
    CFLAGS   +=

    LDFLAGS :=
    LDLIBS  :=
else ifeq ($(TARGET),WINDOWS)
    # UNIX-like to WINDOWS cross-compile
    CC := x86_64-w64-mingw32-gcc

    CPPFLAGS +=
    CFLAGS   +=

    LDFLAGS :=
    LDLIBS  :=
endif

# === Extensions & Commands ===
ifeq ($(TARGET),UNIX)
    OBJ_EXT    := o
    OUT_SUFFIX :=
else ifeq ($(TARGET),WINDOWS)
    OBJ_EXT    := obj
    OUT_SUFFIX := .exe
endif

MKDIR := mkdir -p
RM    := rm -rfv

# === Resources ===

# list of source file extensions
SRC_EXT := c

# list of source directories
SRC_DIRS := $(SRC_DIR)\
            $(foreach SUBDIR,$(SRC_SUBDIRS),$(SRC_DIR)/$(SUBDIR))

# list of source files
SRC := $(foreach DIR,$(SRC_DIRS),\
         $(foreach EXT,$(SRC_EXT),\
           $(wildcard $(DIR)/*.$(EXT))))

# list of object directories
OBJ_DIRS := $(SRC_DIRS:%=$(OBJ_DIR)/%)

# list of object files
OBJ := $(SRC:%=$(OBJ_DIR)/%.$(OBJ_EXT))

# output file
OUT := $(BIN_DIR)/$(OUT_FILENAME)$(OUT_SUFFIX)

# === Targets ===

.PHONY: all run build clean

all: build

run:
	./$(OUT)

build: $(OUT)

clean:
	@$(RM) $(BIN_DIR) $(OBJ_DIR)

# generate output file
$(OUT): $(OBJ) | $(BIN_DIR)
	$(CC) $(LDFLAGS) $^ $(LDLIBS) -o $@

# compile .c files
$(OBJ_DIR)/%.c.$(OBJ_EXT): %.c | $(OBJ_DIRS)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

# create directories
$(BIN_DIR) $(OBJ_DIRS):
	$(MKDIR) "$@"

-include $(OBJ:.$(OBJ_EXT)=.d)
