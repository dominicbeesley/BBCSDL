
        .global _start
        .global error_handler
        .global escape_handler

_start:

#zero bss area
        la      a0, _bss_start
        la      a1, _bss_end
        li      a2, 0
        beq     a0, a1, bsssk
bsslp:  sw      a2, 0(a0)
        addi    a0, a0, 4
        bne     a0, a1, bsslp
bsssk:
#enter main code
        j       _main

# Called with a0 pointing to the error code
error_handler:
   addi    a1, a0, 4          # a1 = error smessage
   lw      a0, (a0)           # a0 = error code
   andi    a0, a0, 0xFF       # DB: bodge to >0, <256
# pass on to BBC Basic's error handler:
#     void error(int, const char *);
# this never returns
   j       error

# Called with a0 bit 6 being the escape flag
escape_handler:
   andi    a0, a0, 64         # mask escape flag
   slli    a0, a0, 1          # shift escape flag into bit 7
   la      t1, flags          # get the address of the flags variable
   lb      t0, (t1)           # read the flags variable from memory
   andi    t0, t0, 0xffffff7f # clear bit 7
   or      t0, t0, a0         # copy escape flag to bit 7
   sb      t0, (t1)           # write the flags variable back to memory
   ret
