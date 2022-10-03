CC       = gcc
AR       = ar
CFLAGS  += -O3 -Wall -Wpointer-arith -g
SRC_DIR  = source
OBJ_DIR  = obj
DST_DIR  = dst
LDFLAGS +=
SOURCES := $(wildcard $(SRC_DIR)/*.c)
OBJECTS := $(SOURCES:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)
TARGET   = $(DST_DIR)/libfatfs.a

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(AR) $(ARFLAGS) $@ $?


$(OBJECTS): $(OBJ_DIR)/%.o : $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@
	@echo "Compiled "$<" successfully!"

clean:
	rm -f $(OBJECTS) *~ $(TARGET)
