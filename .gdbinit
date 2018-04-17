target remote 192.168.247.1:2331
set mem inaccessible-by-default off
monitor speed auto
monitor endian little
monitor reset
monitor flash device = STM32F407VE
monitor flash breakpoints = 1
monitor flash download = 1
load
monitor reg sp = (0x08000000)
monitor reg pc = (0x08000004)
#break ResetHandler
break main
continue