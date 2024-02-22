# Vulcalien's Executable Makefile
# version 0.3.0

# === Detect OS ===
ifeq ($(OS),Windows_NT)
    CURRENT_OS := WINDOWS
else
    CURRENT_OS := UNIX
endif
TARGET_OS := $(CURRENT_OS)

# === Basic Info ===
OUT_FILENAME := exename

SRC_DIRS := src

OBJ_DIR := obj
BIN_DIR := bin

# === C Flags ===
CPPFLAGS := -Iinclude -MMD -MP
CFLAGS   := -Wall -pedantic

# === Linker Flags ===
ifeq ($(TARGET_OS),UNIX)
    # UNIX
    LDFLAGS :=
    LDLIBS  :=
else ifeq ($(TARGET_OS),WINDOWS)
    ifeq ($(CURRENT_OS),WINDOWS)
        # WINDOWS
        LDFLAGS :=
        LDLIBS  :=
    else ifeq ($(CURRENT_OS),UNIX)
        # UNIX to WINDOWS cross-compile
        LDFLAGS :=
        LDLIBS  :=
    endif
endif

# === Compilers ===
ifeq ($(TARGET_OS),UNIX)
    # UNIX
    CC := gcc
else ifeq ($(TARGET_OS),WINDOWS)
    ifeq ($(CURRENT_OS),WINDOWS)
        # WINDOWS
        CC := gcc
    else ifeq ($(CURRENT_OS),UNIX)
        # UNIX to WINDOWS cross-compile
        CC := x86_64-w64-mingw32-gcc
    endif
endif

# === OS Specific ===
ifeq ($(TARGET_OS),UNIX)
    OBJ_EXT    := o
    OUT_SUFFIX :=
else ifeq ($(TARGET_OS),WINDOWS)
    OBJ_EXT    := obj
    OUT_SUFFIX := .exe
endif

ifeq ($(CURRENT_OS),UNIX)
    MKDIR      := mkdir
    MKDIRFLAGS := -p

    RM      := rm
    RMFLAGS := -rfv
else ifeq ($(CURRENT_OS),WINDOWS)
    MKDIR      := mkdir
    MKDIRFLAGS :=

    RM      := rmdir
    RMFLAGS := /Q /S
endif

# === Resources ===

# list of source file extensions
SRC_EXT := c

# list of source files
SRC := $(foreach DIR,$(SRC_DIRS),\
         $(foreach EXT,$(SRC_EXT),\
           $(wildcard $(DIR)/*.$(EXT))))

# list of object files
OBJ := $(SRC:%=$(OBJ_DIR)/%.$(OBJ_EXT))

# list of object directories
OBJ_DIRS := $(SRC_DIRS:%=$(OBJ_DIR)/%)

# output file
OUT := $(BIN_DIR)/$(OUT_FILENAME)$(OUT_SUFFIX)

# === Targets ===

.PHONY: all run build clean

all: build

run:
	./$(OUT)

build: $(OUT)

clean:
	@$(RM) $(RMFLAGS) $(BIN_DIR) $(OBJ_DIR)

# generate output file
$(OUT): $(OBJ) | $(BIN_DIR)
	$(CC) $(LDFLAGS) $^ $(LDLIBS) -o $@

# compile .c files
$(OBJ_DIR)/%.c.$(OBJ_EXT): %.c | $(OBJ_DIRS)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

# create directories
$(BIN_DIR) $(OBJ_DIRS):
	$(MKDIR) $(MKDIRFLAGS) "$@"

-include $(OBJ:.$(OBJ_EXT)=.d)
