CXX := gcc
SRC_DIR := src
BIN_DIR := bin
INCLUDE_DIR := include
LIB_DIR := lib
TARGET := $(BIN_DIR)/main.exe

define find_c_files
	$(wildcard $(1)/*.c) $(foreach d,$(wildcard $(1)/*),$(call find_c_files,$d))
endef

define MAKE_DIR
	@if not exist "$(dir $@)" mkdir "$(dir $@)"
endef

ALL_LIB_DIRS := $(wildcard $(LIB_DIR)/*)
LIB_INCLUDE_DIRS := $(foreach lib_dir,$(ALL_LIB_DIRS),$(lib_dir)/$(INCLUDE_DIR))

SRCS := $(call find_c_files,$(SRC_DIR))
OBJS := $(patsubst $(SRC_DIR)/%.c,$(BIN_DIR)/%.o,$(SRCS))

CXXFLAGS := -Wall -I$(INCLUDE_DIR) $(foreach lib_include,$(LIB_INCLUDE_DIRS),-I$(lib_include))
LDFLAGS = $(foreach lib_dir, $(ALL_LIB_DIRS),-L$(lib_dir) -l$(patsubst $(LIB_DIR)/%,%,$(lib_dir)))

define COMPILE
	$(CXX) $(CXXFLAGS) -c $< -o $@
endef

compile_all: $(TARGET)

$(BIN_DIR)/%.o: $(SRC_DIR)/%.c
	$(MAKE_DIR)
	$(COMPILE)

$(TARGET): $(OBJS)
	$(CXX) $(OBJS) -o $@ $(LDFLAGS)

# COMPILING A LIBRARY
LIB_NAME ?= 

LIB_SRCS := $(call find_c_files,$(LIB_DIR)/$(LIB_NAME)/src)
LIB_OBJS := $(patsubst $(LIB_DIR)/$(LIB_NAME)/$(SRC_DIR)/%.c,$(LIB_DIR)/$(LIB_NAME)/$(BIN_DIR)/%.o,$(LIB_SRCS))
LIB_TARGET := $(LIB_DIR)/$(LIB_NAME)/lib$(LIB_NAME).a

$(LIB_DIR)/$(LIB_NAME)/$(BIN_DIR)/%.o: $(LIB_DIR)/$(LIB_NAME)/$(SRC_DIR)/%.c
	$(MAKE_DIR)
	$(COMPILE)

$(LIB_TARGET): $(LIB_OBJS)
	ar rcs $@ $^

compile_lib: $(LIB_TARGET)

run: $(TARGET)
	@$<

clean:
	@if exist "$(BIN_DIR)" rmdir /S /Q "$(BIN_DIR)"
	@for /D %%L in ($(LIB_DIR)\*) do ( \
		if exist "%%L\lib%%~nxL.a" del /F /Q "%%L\lib%%~nxL.a" & \
		if exist "%%L\bin" rmdir /S /Q "%%L\bin" \
	)
.PHONY: compile_all compile_lib run clean