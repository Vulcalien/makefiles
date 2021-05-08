# Vulcalien's Library Makefile
# version 0.1.1
#
# This Makefile can create both
# Static and Shared libraries

# ========= CONFIG =========
OUT_FILENAME := libname

SRC_DIR := src
OBJ_DIR := obj
BIN_DIR := bin

CPPFLAGS := -Iinclude -MMD -MP
CFLAGS   := -Wall -pedantic

# Unix LDFLAGS and LDLIBS
UNI_LDFLAGS := -shared -Llib
UNI_LDLIBS  :=

# Windows LDFLAGS and LDLIBS
WIN_LDFLAGS := -shared -Llib
WIN_LDLIBS  :=

# ========= OS SPECIFIC =========
UNI_OBJ_EXT    := .o
UNI_STATIC_EXT := .a
UNI_SHARED_EXT := .so

WIN_OBJ_EXT    := .obj
WIN_STATIC_EXT := -win.a
WIN_SHARED_EXT := .dll

ifeq ($(OS),Windows_NT)
	CC := gcc

	OBJ_EXT    := $(WIN_OBJ_EXT)
	STATIC_EXT := $(WIN_STATIC_EXT)
	SHARED_EXT := $(WIN_SHARED_EXT)

	LDFLAGS := $(WIN_LDFLAGS)
	LDLIBS  := $(WIN_LDLIBS)

	RM      := del
	RMFLAGS := /Q
else
	CC := gcc

	OBJ_EXT    := $(UNI_OBJ_EXT)
	STATIC_EXT := $(UNI_STATIC_EXT)
	SHARED_EXT := $(UNI_SHARED_EXT)

	LDFLAGS := $(UNI_LDFLAGS)
	LDLIBS  := $(UNI_LDLIBS)

	RM      := rm
	RMFLAGS := -rfv
endif

# ========= OTHER =========
SRC := $(wildcard $(SRC_DIR)/*.c)
OBJ := $(SRC:$(SRC_DIR)/%.c=$(OBJ_DIR)/%$(OBJ_EXT))

OUT_STATIC := $(BIN_DIR)/$(OUT_FILENAME)$(STATIC_EXT)
OUT_SHARED := $(BIN_DIR)/$(OUT_FILENAME)$(SHARED_EXT)

.PHONY: all build-static build-shared clean

all: build-static build-shared

build-static: $(OUT_STATIC)

build-shared: $(OUT_SHARED)

$(OUT_STATIC): $(OBJ) | $(BIN_DIR)
	$(AR) rcs $@ $^

$(OUT_SHARED): $(OBJ) | $(BIN_DIR)
	$(CC) $(LDFLAGS) $^ $(LDLIBS) -o $@

$(OBJ_DIR)/%$(OBJ_EXT): $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

$(BIN_DIR) $(OBJ_DIR):
	mkdir $@

clean:
	@$(RM) $(RMFLAGS) $(BIN_DIR) $(OBJ_DIR)

-include $(OBJ:$(OBJ_EXT)=.d)
