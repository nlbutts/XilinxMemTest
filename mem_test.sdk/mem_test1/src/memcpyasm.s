.global memcpyasm
memcpyasm:
    PLD [r1, #0xC0]
    VLDM r1!,{d0-d7}
    VSTM r0!,{d0-d7}
    SUBS r2,r2,#0x40
    BGE memcpyasm
    BX LR
