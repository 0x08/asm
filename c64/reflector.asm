
; code to ensure that ACME outputs the program to reflector.prg in cbm format
!to "reflector.prg", cbm

; below code is a BASIC stub that auto-runs your assembly code at $0810 when the user types RUN.
* = $0801
!word nextline                            ; pointer to next BASIC line
!word 2023                                ; line number
!byte $9e                                 ; SYS token
!text "2064"
!byte 0                                   ; null terminator
nextline:
!word 0                                   ; end of BASIC program

* = $0810

; ======= actual application begins =======

PADDLE_X     = $FB                                 ; location of our X position in ZP
PADDLE_CHAR  = $3d                                 ; the character used by our paddle: '='
SCREEN       = $0400                               ; base screen memory location on the C64
COLS         = 40                                  ; the number of columns
ROW          = 23                                  ; the row number on which to print our paddle

; Init paddle position
init:
    lda #18
    sta PADDLE_X                             ; the coords of the left-hand side of the paddle
    jsr clear_screen
    jsr draw_border
    jsr draw_paddle

mainloop:
    jsr read_keys
    jmp mainloop

read_keys:
    ; --- Check for A button being pressed ---
    lda #%11111101                           ; row 1 low
    sta $dc00
    lda $dc01
    and #%00000100                           ; bit 2 = A
    beq move_left

    ; --- Check for D button being pressed ---
    lda #%11111011                           ; row 2 low
    sta $dc00
    lda $dc01
    and #%00000100                           ; bit 2 = D
    beq move_right

    rts

move_left:
    lda PADDLE_X
    cmp #02                                  ; avoids the paddle bumping into the left border
    bcc done_left
    jsr clear_paddle
    dec PADDLE_X
done_left:
    jsr draw_paddle
    jsr delay
    rts

move_right:
    lda PADDLE_X
    cmp #36                                  ; avoids the paddle bumping into the right border
    bcs done_right
    jsr clear_paddle
    inc PADDLE_X
done_right:
    jsr draw_paddle
    jsr delay
    rts

; ---------------------------------
draw_paddle:
    lda PADDLE_X
    tax
    lda #PADDLE_CHAR
    sta SCREEN + (ROW * COLS), x
    inx
    sta SCREEN + (ROW * COLS), x
    inx
    sta SCREEN + (ROW * COLS), x
    rts

clear_paddle:
    lda PADDLE_X
    tax
    lda #$20                                 ; space
    sta SCREEN + (ROW * COLS), x
    inx
    sta SCREEN + (ROW * COLS), x
    inx
    sta SCREEN + (ROW * COLS), x
    rts

; -- clears the screen by writing a blank space everywhere --
clear_screen:
    ldy #0
loop:
    lda #$20
    sta $0400, y
    sta $0400 + 250, y
    sta $0400 + 500, y
    sta $0400 + 750, y

    lda #1                                   ; white
    sta $D800, y
    sta $D800 + 250, y
    sta $D800 + 500, y
    sta $D800 + 750, y

    iny
    bne loop
    rts

draw_border:
draw_corners:
    lda #$4f
    sta $0400
    lda #$50
    sta $0400 + 39
    lda #$4c
    sta $0400 + 24 * 40
    lda #$7a
    sta $0400 + 24 * 40 + 39

    ldx #1
draw_top_row:
    lda #$77
    sta $0400, x
    inx
    cpx #39
    bne draw_top_row

    ldx #1
draw_bottom_row:
    lda #$6f
    sta $0400 + 24 * 40, x
    inx
    cpx #39
    bne draw_bottom_row

write_left_edges:
    lda #$65
    sta $0400 + 40 * 1
    sta $0400 + 40 * 2
    sta $0400 + 40 * 3
    sta $0400 + 40 * 4
    sta $0400 + 40 * 5
    sta $0400 + 40 * 6
    sta $0400 + 40 * 7
    sta $0400 + 40 * 8
    sta $0400 + 40 * 9
    sta $0400 + 40 * 10
    sta $0400 + 40 * 11
    sta $0400 + 40 * 12
    sta $0400 + 40 * 13
    sta $0400 + 40 * 14
    sta $0400 + 40 * 15
    sta $0400 + 40 * 16
    sta $0400 + 40 * 17
    sta $0400 + 40 * 18
    sta $0400 + 40 * 19
    sta $0400 + 40 * 20
    sta $0400 + 40 * 21
    sta $0400 + 40 * 22
    sta $0400 + 40 * 23

write_right_edges:
    lda #$67
    sta $0400 + 40 * 1 + 39
    sta $0400 + 40 * 2 + 39
    sta $0400 + 40 * 3 + 39
    sta $0400 + 40 * 4 + 39
    sta $0400 + 40 * 5 + 39
    sta $0400 + 40 * 6 + 39
    sta $0400 + 40 * 7 + 39
    sta $0400 + 40 * 8 + 39
    sta $0400 + 40 * 9 + 39
    sta $0400 + 40 * 10 + 39
    sta $0400 + 40 * 11 + 39
    sta $0400 + 40 * 12 + 39
    sta $0400 + 40 * 13 + 39
    sta $0400 + 40 * 14 + 39
    sta $0400 + 40 * 15 + 39
    sta $0400 + 40 * 16 + 39
    sta $0400 + 40 * 17 + 39
    sta $0400 + 40 * 18 + 39
    sta $0400 + 40 * 19 + 39
    sta $0400 + 40 * 20 + 39
    sta $0400 + 40 * 21 + 39
    sta $0400 + 40 * 22 + 39
    sta $0400 + 40 * 23 + 39

    rts

delay:
    ldy #$40
delay_loop1:
    ldx #$40
delay_loop2:
    dex
    bne delay_loop2
    dey
    bne delay_loop1
    rts
