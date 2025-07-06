
START:
    LDA #$0D                        ; green
    LDX #$1F                        ; to fill one line we need to iterate 32 times
LINEFILL:
    STA $0400,X
    DEX                             ; decrease X
    BPL LINEFILL

