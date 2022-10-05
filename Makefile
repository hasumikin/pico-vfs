CC        = gcc
AR        = ar
CFLAGS   += -g3 -O0 -Wall -Wpointer-arith
SRC_DIR   = src
BUILD_DIR = build
OBJ_DIR   = $(BUILD_DIR)/obj
LDFLAGS  +=
SOURCES  := $(wildcard $(SRC_DIR)/**/*.c) $(SRC_DIR)/main.c
OBJECTS  := $(SOURCES:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)

LIBMRUBY  = ./lib/picoruby/build/host/lib/libmruby.a
LIBFATFS  = ./lib/ff14b/build/lib/libfatfs.a
LIB_DIRS  = $(dir $(LIBMRUBY)) $(dir $(LIBFATFS))
LIBFLAG   = $(foreach d, $(LIB_DIRS), -L$d)

INC_DIRS  = ./lib/picoruby/build/repos/host/mruby-mrubyc/repos/mrubyc/src \
            ./lib/picoruby/build/repos/host/mruby-pico-compiler/include\
            ./lib/ff14b/source
INCFLAG   = $(foreach d, $(INC_DIRS), -I$d)

RUBY_DIR  = $(SRC_DIR)/ruby/os
MRB_DIR   = $(BUILD_DIR)/mrb
PICORBC   = ./lib/picoruby/bin/picorbc
RUBY     := $(wildcard $(RUBY_DIR)/*.rb)
MRB      := $(RUBY:$(RUBY_DIR)/%.rb=$(MRB_DIR)/%.c)

TARGET    = $(BUILD_DIR)/bin/main

#$(warning MRB = $(MRB))

all: $(TARGET)

$(TARGET): build/mrb/app.c $(OBJECTS) $(LIBMRUBY) $(LIBFATFS)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -o $@ $(OBJECTS) $(LIBFLAG) -lmruby -lfatfs -lm
	@echo "Finished"
	@echo

build/mrb/app.c: src/app.rb
	@mkdir -p $(dir $@)
	$(PICORBC) -Bapp -o build/mrb/app.c src/app.rb
	@echo "Compiled "$<" successfully!"

$(LIBMRUBY): FORCE
	cd lib/picoruby && rake

$(LIBFATFS): FORCE
	cd lib/ff14b && make

# OBJECTS
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c $(MRB)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -DMRBC_USE_MATH=1 -DMRBC_USE_HAL_POSIX=1 $(INCFLAG) -c $< -o $@
	@echo "Compiled "$<" successfully!"

# MRB
$(MRB_DIR)/%.c: $(RUBY_DIR)/%.rb $(PICORBC)
	@mkdir -p $(dir $@)
	$(PICORBC) -B$(basename $(notdir $@)) -o $@ $<
	@echo "Compiled "$<" successfully!"

$(PICORBC):
	cd lib/picoruby && rake

clean:
	rm -f $(OBJECTS) $(MRB) *~ $(TARGET)

deep_clean:
	cd lib/picoruby && rake clean
	cd lib/ff14b && make clean
	make clean

FORCE:

