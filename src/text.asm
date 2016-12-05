/* Clear the screen to black, then display a message without using jsr $e716 subroutine */

.pc =$0801 
	:BasicUpstart($1000)
	
.pc = $1000

init:
	// set background and border to black
	lda #$0
	ldx #$0
    sta $d021
    sta $d020	
	jsr clear

// we want to display the message stored at the msg label
	ldx #$0
main:
	lda msg, x  // load a byte of message	
	cmp #$040  // if the char > $40, we need to convert it to correct set of characters (see http://tnd64.unikat.sk/assemble_it3.html)
	bcc display_char // carry clear = not over $040, so we display the character
	sec // clear the carry
	sbc #$40  // substract $40 to have the correct character

display_char:
	sta $0400, x
	inx
	cpx #$0b //hard coded compare to test if we have reached the end of the message, could improve by adding a zero byte after the message
	bcs loop
	jmp main

// busy loop
loop:
	jmp loop

// clear the screen

// can use this subroutine too jsr $e544
clear:

	lda #$20
	sta $0400, x
	sta $0500, x
	sta $0600, x
	sta $0700, x	
	inx
	bne clear	
	rts	

msg:	
	.text "HELLO WORLD"
	.byte $0