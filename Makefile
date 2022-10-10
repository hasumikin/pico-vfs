CC         = gcc
AR         = ar
CFLAGS    += -g3 -O0 -Wall -Wpointer-arith
MRBCFLAGS += -DMAX_SYMBOLS_COUNT=1000 -DMRBC_ALLOC_LIBC=1 -DMRBC_USE_MATH=1 -DMRBC_USE_HAL_POSIX=1
SRC_DIR    = src
BUILD_DIR  = build
OBJ_DIR    = $(BUILD_DIR)/obj
LDFLAGS   += -lmruby -lfatfs -lm
SOURCES   := $(wildcard $(SRC_DIR)/**/*.c) $(wildcard $(SRC_DIR)/**/**/*.c) $(SRC_DIR)/main.c
OBJECTS   := $(SOURCES:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)

LIBMRUBY   = ./lib/picoruby/build/host/lib/libmruby.a
LIBFATFS   = ./lib/ff14b/build/lib/libfatfs.a
LIB_DIRS   = $(dir $(LIBMRUBY)) $(dir $(LIBFATFS))
LIBFLAG    = $(foreach d, $(LIB_DIRS), -L$d)

INC_DIRS   = ./lib/picoruby/build/repos/host/mruby-mrubyc/repos/mrubyc/src \
             ./lib/picoruby/build/repos/host/mruby-pico-compiler/include\
             ./lib/ff14b/source
INCFLAG    = $(foreach d, $(INC_DIRS), -I$d)

RUBY_DIR   = $(SRC_DIR)/ruby/os
MRB_DIR    = $(BUILD_DIR)/mrb
PICORBC    = ./lib/picoruby/bin/picorbc
RUBY      := $(wildcard $(RUBY_DIR)/*.rb)
MRB       := $(RUBY:$(RUBY_DIR)/%.rb=$(MRB_DIR)/%.c)

TARGET     = $(BUILD_DIR)/bin/main

#$(warning MRB = $(MRB))

all:
	CFLAGS="-DNDEBUG=1" $(MAKE) $(TARGET)

debug:
	DEBUG=yes $(MAKE) $(TARGET)

$(TARGET): $(OBJECTS) $(LIBFATFS)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -o $@ $(OBJECTS) $(LIBFLAG) $(LDFLAGS)
	@echo "Finished"
	@echo

build/mrb/app.c: src/app.rb
	@mkdir -p $(dir $@)
	$(PICORBC) -Bapp -o build/mrb/app.c src/app.rb
	@echo "Compiled "$<" successfully!"

$(LIBFATFS): FORCE
	cd lib/ff14b && make

# OBJECTS
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c $(MRB) build/mrb/app.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(MRBCFLAGS) $(INCFLAG) -c $< -o $@
	@echo "Compiled "$<" successfully!"

# MRB
$(MRB_DIR)/%.c: $(RUBY_DIR)/%.rb $(PICORBC)
	@mkdir -p $(dir $@)
	$(PICORBC) -B$(basename $(notdir $@)) -o $@ $<
	@echo "Compiled "$<" successfully!"

$(PICORBC):
ifeq ($(DEBUG),yes)
	cd lib/picoruby && rake debug
else
	cd lib/picoruby && rake
endif

clean:
	rm -f $(OBJECTS) $(MRB) *~ $(TARGET)

deep_clean:
	cd lib/picoruby && rake clean
	cd lib/ff14b && make clean
	make clean

FORCE:

