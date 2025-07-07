; === simple application to create a ball bouncing from left to right
; === when the ball bounces, it will change colour :-)

START:
    LDA #$01                        ; starting colour
    STA $00                         ; store starting colour in zero page address $00
    LDX #$00                        ; index used for left-right
    STA $0400,X                     ; colour the first pixel before we start
RIGHT:
    LDA #$00                        ; load black into the accumulator
    STA $0400,X                     ; write black to current index location
    INX                             ; increase x (next pixel to the right)
    LDA $00                         ; load current colour into the accumulator
    STA $0400,X                     ; write current colour to current index location
    JSR DELAY                       ; call the DELAY subroutine to burn some CPU cycles
    CPX #$1F                        ; compare X register to 1F, video output is 32 pixels wide
    BNE RIGHT                       ; halt loop once 1F has been reached, otherwise repeat RIGHT
    INC $00                         ; bump our colour by one
LEFT:
    LDA #$00                        ; load black into the accumulator
    STA $0400,X                     ; write black to current index location
    DEX                             ; decrease x (next pixel to the left)
    LDA $00                         ; load current colour into the accumulator
    STA $0400,X                     ; write current colour to current index location
    JSR DELAY                       ; call the DELAY subroutine to burn some CPU cycles
    CPX #$00                        ; compare X register to 00, meaning we're on the left side of the video
    BNE LEFT                        ; halt loop once 00 has been reached, otherwise repeat LEFT
    INC $00                         ; bump our colour by one

    JMP RIGHT                       ; loop forever! :)

; === Simple delay subroutine that just burns some cpu cycles ===
DELAY:
    LDY #$30
D1: DEY
    BNE D1
    RTS
