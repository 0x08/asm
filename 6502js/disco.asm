COLOUR: .BYTE $01                           ; Current colour

START:  LDA #$01                        ; Start with colour 1 (white) in acc
    STA COLOUR                      ; Store accumulator in memory location COLOUR
 
LOOP:
    LDA COLOUR                      ; Load acc with COLOUR
    LDX #$00                        ; Load X with 0
FILL:
    STA $0200,X                     ; Fill page 2
    STA $0300,X                     ; Fill page 3
    STA $0400,X                     ; Fill page 4
    STA $0500,X                     ; Fill page 5
    INX
    BNE FILL                        ; Loop until X wraps (0 to 255)

    ; Delay loop
    LDY #$20
DELAY1: LDX #$20
DELAY2: DEX
    BNE DELAY2
    DEY
    BNE DELAY1

    ; Next colour
    LDA COLOUR
    CLC                             ; clear carry in case previous math left it set
    ADC #1                          ; add one to colour
    CMP #$10                        ; Wrap after $F
    BNE STORE
    LDA #$01                        ; Restart at $01
STORE:  STA COLOUR
    JMP LOOP
