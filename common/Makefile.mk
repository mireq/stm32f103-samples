.PHONY: clean

-include config.mk

BUILD_DIR ?= build/
SOURCE_DIR ?= .

ECHO = echo
FIND = find
MKDIR = mkdir -p
RM = rm -rf

ARCH = armv7m-none-eabi
AS = $(ARCH)-as
CC = $(ARCH)-gcc
GDB = $(ARCH)-gdb
OBJCOPY = $(ARCH)-objcopy
OBJDUMP = $(ARCH)-objdump
SIZE = $(ARCH)-size

DEBUG_CLFAGS = -g3 -ggdb
COMMON_CFLAGS = -Wall -Wextra -ffreestanding -ffunction-sections -fdata-sections -O3 -std=gnu99
ARCH_CFLAGS = -mlittle-endian -mcpu=cortex-m3 -march=armv7-m -mthumb
CFLAGS ?= -nostdlib -nostartfiles -specs=nosys.specs -specs=nano.specs


CFLAGS := ${COMMON_CFLAGS} ${DEBUG_CLFAGS} ${ARCH_CFLAGS} ${CFLAGS}
AFLAGS := --warn --fatal-warnings ${AFLAGS}
LDFLAGS := ${CFLAGS} -Wl,--gc-sections ${LDFLAGS}


TARGET = $(BUILD_DIR)$(PROJECT_NAME)
VPATH = ${SOURCE_DIR}


SOURCES = $(shell $(FIND) ${SOURCE_DIR} -name '*.[cs]' -printf "%P\n")
objects = $(patsubst %.c,%.o,$(patsubst %.s,%.o,$(SOURCES)))
OBJECTS = $(addprefix $(BUILD_DIR), $(objects))
LINKERS = $(shell $(FIND) ${SOURCE_DIR} -name '*.ld')


$(TARGET).elf: $(OBJECTS) $(LINKERS) Makefile config.mk
	$(CC) $(addprefix -T ,$(LINKERS)) -Wl,-Map,$(@:.elf=.map) -o $@ $(OBJECTS) $(LDFLAGS)
	@$(OBJCOPY) -O binary $@ $(@:.elf=.bin)
	@$(OBJCOPY) -O ihex $@ $(@:.elf=.hex)
	@$(ECHO)
	@$(SIZE) $@ | tail -1 - | awk '{print "Size: "$$1+$$2" B"}'


$(BUILD_DIR)%.o: %.c Makefile config.mk
	@$(MKDIR) `dirname $@`
	$(CC) -c -MMD -MP $(CFLAGS) -o $@ $<


$(BUILD_DIR)%.o: %.s Makefile config.mk
	@$(MKDIR) `dirname $@`
	$(AS) $(AFLAGS) -o $@ $<


-include $(OBJECTS:.o=.d)


clean:
	$(RM) $(BUILD_DIR)*


run: $(TARGET).elf
	$(GDB) -command=run.gdb $(TARGET).elf
