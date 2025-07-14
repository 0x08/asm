
    LDA #$00
    LDX #$00
LOOP:
    STA $0200,X                     ; Fill page 2
    ADC #$0D
    STA $0300,X                     ; Fill page 3
    ADC #$07
    STA $0400,X                     ; Fill page 4
    ADC #$11
    STA $0500,X                     ; Fill page 5
    ADC #$13
    INX
    JMP LOOP
