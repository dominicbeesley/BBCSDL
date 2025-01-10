VPATH = ../../src ../../include ../../../BBCSDL/src ../../../BBCSDL/include

BASE=riscv32-unknown-elf-
ARCH=rv32imc
ABI=ilp32

CC      = ${BASE}gcc
CXX     = ${BASE}gcc
AS      = ${BASE}as
STRIP   = ${BASE}strip
OBJCOPY = ${BASE}objcopy
NM		= ${BASC}nm

OBJ = crt0.o riscv_wrapper_dom.o bbmain.o bbexec.o bbeval.o bbdata.o bbasmb.o

ASFLAGS = -I ../../include -march=${ARCH} -mabi=${ABI}
CFLAGS  = --specs=nano.specs -u _printf_float -Wall -I ../../include -march=${ARCH} -mabi=${ABI} -c -Os
LDFLAGS = --specs=nano.specs -u _printf_float -lm -nostartfiles  -Os

.PRECIOUS:bbcbasic.elf

all: version rvbasic.ssd rvbasic.noi

version build.h:
	./version.sh

crt0.o: crt0.s build.h
	$(AS) $(ASFLAGS) $< -o $@

riscv_wrapper_dom.o: riscv_wrapper_dom.c build.h BBC.h
	$(CXX) $(CFLAGS) -I. $< -o $@

bbmain.o: bbmain.c BBC.h
	$(CXX) $(CFLAGS) $< -o $@

bbexec.o: bbexec.c BBC.h
	$(CXX) $(CFLAGS) $< -o $@

bbeval.o: bbeval.c BBC.h
	$(CXX) -Wno-array-bounds $(CFLAGS) $< -o $@

bbasmb.o: bbasmb_riscv.c BBC.h
	$(CXX) $(CFLAGS) $< -o $@

bbdata.o: ../../src/bbdata_riscv.s
	$(AS) $(ASFLAGS) ../../src/bbdata_riscv.s -o bbdata.o

bbcbasic.elf: $(OBJ) bbcbasic.ld
	$(CXX) $(filter %.o, $^) $(LDFLAGS) -Wl,-T,$(filter %.ld, $^),-Map,$(basename $@).map,--strip-debug  -o $@

rvbasic.noi: bbcbasic.elf
	$(NM) --format=posix $< >$(basename $@).sy1
	sed -n -E 's/^(\w+)\s+\w\s+([0-9a-f]+)/DEF \1 \2/ip' <$(basename $@).sy1 >$(basename $@).noi

RVBASIC: bbcbasic.elf
	$(OBJCOPY) -O binary $< $@
	cp RVBASIC ~/hostfs/romsriscv
	echo "$$.RVBASIC 100000 100000" > ~/hostfs/romsriscv/RVBASIC.inf

rvbasic.ssd: RVBASIC
	rm -f $@
	beeb blank_ssd $@
	beeb title $@ "RISC-V BASIC"
	beeb putfile $@ $<
	beeb putfile $@ examples/*
	beeb opt4 $@ 3
	beeb info $@


clean:
	rm -f $(OBJ) build.h bbcbasic.elf RVBASIC rvbasic.ssd rvbasic.noi rvbasic.sy1
