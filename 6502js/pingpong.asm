; === simple application to create a ball bouncing from left to right
; === when the ball bounces, it will change colour :-)

START:
    LDA #$01                        ; starting colour
    STA $00                         ; store starting colour in zero page address $00
    LDX #$00                        ; index used for left-right
    STA $0400,X                     ; colour the first pixel before we start
RIGHT:
    LDA #$01                        ; we're moving right (+1)
    STA $01                         ; store direction at $01
    LDA #$1F                        ; right edge
    STA $02                         ; store our right edge at $02
    JSR MOVEBALL
LEFT:
    LDA #$FF                        ; we're moving left (-1)
    STA $01                         ; store direction at $01
    LDA #$00                        ; right edge
    STA $02                         ; store our left edge at $02
    JSR MOVEBALL
REPEAT:
    JMP RIGHT                       ; loop forever! :)

; === Subroutine to move the ball in the right direction ===
MOVEBALL:
    LDA #$00                        ; load black into the accumulator
    STA $0400,X                     ; write black to current index location
    TXA                             ; transfer x register to accumulator
    CLC                             ; clear carry
    ADC $01                         ; $01 contains our direction
    TAX                             ; transfer accumulator back to x
    LDA $00                         ; load current colour into the accumulator
    STA $0400,X                     ; write current colour to current index location
    JSR DELAY                       ; call the DELAY subroutine to burn some CPU cycles
    CPX $02                         ; compare X register to $02 which contains boundary, video output is 32 pixels wide
    BNE MOVEBALL                    ; halt loop once 1F has been reached, otherwise repeat MOVEBALL
    INC $00                         ; bump our colour by one
    RTS

; === Simple delay subroutine that just burns some cpu cycles ===
DELAY:
    LDY #$30
D1: DEY
    BNE D1
    RTS
