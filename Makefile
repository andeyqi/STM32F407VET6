
CROSS_COMPILE = arm-none-eabi-
AS		= $(CROSS_COMPILE)as
LD		= $(CROSS_COMPILE)ld
CC		= $(CROSS_COMPILE)gcc
CPP		= $(CC) -E
AR		= $(CROSS_COMPILE)ar
NM		= $(CROSS_COMPILE)nm

STRIP		= $(CROSS_COMPILE)strip
OBJCOPY		= $(CROSS_COMPILE)objcopy
OBJDUMP		= $(CROSS_COMPILE)objdump

export AS LD CC CPP AR NM
export STRIP OBJCOPY OBJDUMP

CFLAGS := -Wall -Os -DUSE_STDPERIPH_DRIVER  -DSTM32F40_41xxx-v -std=gnu99
CFLAGS += -I $(shell pwd)/driver  -I $(shell pwd)/cm_backtrace -I $(shell pwd)/stlib -I $(shell pwd)/stlib/inc -I $(shell pwd)/stlib/cminc  
CFLAGS += -mcpu=cortex-m4 -mthumb 
CFLAGS += -ffunction-sections -fdata-sections
CFLAGS += -g

LDFLAGS := -Tstlib/stm32_flash.ld
LDFLAGS += -mcpu=cortex-m4 -mthumb
#LDFLAGS += -specs=nano.specs
#LFLAGS  += -u_printf_float #Use this option if you want print float
LDFLAGS += -Wl,--gc-sections -Wl,-Map=stm32.map,--cref
export CFLAGS LDFLAGS

TOPDIR := $(shell pwd)
export TOPDIR

TARGET := stm32.elf

obj-y += driver/
obj-y += src/
obj-y += stlib/
#obj-y += cm_backtrace/

all : 
	make -C ./ -f $(TOPDIR)/Makefile.build
	$(CC) $(LDFLAGS) -o $(TARGET) built-in.o
	$(OBJCOPY) -O binary -S $(TARGET) stm32.bin 

clean:
	rm -f $(shell find -name "*.o")
	rm -f $(shell find -name "*.bin")
	rm -f $(TARGET)

distclean:
	rm -f $(shell find -name "*.o")
	rm -f $(shell find -name "*.bin")
	rm -f $(shell find -name "*.d")
	rm -f $(TARGET)
	