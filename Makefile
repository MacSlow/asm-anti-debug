APP        = anti-debug
APP_64     = anti-debug_64
SNEAKY_64  = sneaky_64
ASM        = nasm
LD		   = ld
ASMFLAGS  = -g -f elf64
#ASMFLAGS   = -f elf64
LDFLAGS    = --format=elf32-x86-64 --oformat=elf32-x86-64 -e _start 
LDFLAGS_64 = -e _start 

ASMSRCS  = anti-debug.nasm
ASMOBJS  = $(ASMSRCS:.nasm=.o)
ASMSRCS_64  = anti-debug_64.nasm
ASMOBJS_64  = $(ASMSRCS_64:.nasm=.o)
SNEAKY_SRCS_64  = sneaky_64.nasm
SNEAKY_OBJS_64  = $(SNEAKY_SRCS_64:.nasm=.o)

all: $(APP) $(APP_64) $(SNEAKY_64)

%.o: %.nasm
	$(ASM) $(ASMFLAGS) -o $@ $<

$(APP):	$(ASMOBJS)
	$(LD) $(LDFLAGS) $(ASMOBJS) -o$(APP)
	strip $(APP)

$(APP_64):	$(ASMOBJS_64)
	$(LD) $(LDFLAGS_64) $(ASMOBJS_64) -o$(APP_64)
	strip $(APP_64)

$(SNEAKY_64):	$(SNEAKY_OBJS_64)
	$(LD) $(LDFLAGS_64) $(SNEAKY_OBJS_64) -o$(SNEAKY_64)
	strip $(SNEAKY_64)

info: $(APP) $(APP_64) $(SNEAKY_64)
	objdump -s -j .data $(APP) ; objdump -d -j .text $(APP)
	echo " "
	objdump -s -j .data $(APP_64) ; objdump -d -j .text $(APP_64)
	echo " "
	objdump -s -j .data $(SNEAKY_64) ; objdump -d -j .text $(SNEAKY_64)

clean:
	rm -f *.o *~ $(APP) $(APP_64) $(SNEAKY_64)

