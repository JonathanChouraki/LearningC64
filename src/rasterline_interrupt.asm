.pc =$0801
	:BasicUpstart($1000)


.pc = $1000

.var startline = $80
.var endline = $89

init:
	// set up interrupt

	sei // turn off interrupt
	lda #$7f
	ldx #$01
	sta $dc0d // turn off CIA 1
	sta $dd0d // turn off CIA 2
	stx $d01a // turn on raster interrupt

	lda #$1b
    ldx #$08
    ldy #$14
    sta $d011    // Clear high bit of $d012, set text mode
    stx $d016    // single-colour
    sty $d018    // screen at $0400, charset at $2000

	lda #<begin_raster // low part of interrupt routine address
	ldx #>begin_raster // high part of interrupt routine address
	ldy #startline // line to trigger interrupt

	sta $0314 // store in interrupt vector
    stx $0315
	sty $d012


	lda $dc0d    // ACK CIA 1 interrupts
	lda $dd0d    // ACK CIA 2 interrupts
	asl $d019    // ACK VIC interrupts

	cli // clear interrupt flag so the cpu respond to interrupt again

	// set background and border to black
	lda #$0
	ldx #$0
    sta $d021
    sta $d020
	jsr clear

main:
	jmp main

begin_raster:
	jsr delay
	lda #$e5
	sta $d020
	sta $d021

	lda #<end_raster // low part of interrupt routine address
	ldx #>end_raster // high part of interrupt routine address
	.eval endline = endline + 1
	ldy #endline // line to trigger interrupt

	sta $0314 // store in interrupt vector
    stx $0315
	sty $d012

	asl $d019    // ACK interrupt (to re-enable it)
	//  restore the register contents from the stack (faster than calling jsr $ea81)
	pla
	tay
	pla
	tax
	pla
	rti // return from interrupt

end_raster:
	jsr delay
	lda #$00
	sta $d020
	sta $d021

	lda #<begin_raster // low part of interrupt routine address
	ldx #>begin_raster // high part of interrupt routine address
	.eval startline++
	ldy #startline // line to trigger interrupt

	sta $0314 // store in interrupt vector
    stx $0315
	sty $d012

	asl $d019    // ACK interrupt (to re-enable it)
	//  restore the register contents from the stack (faster than calling jsr $ea81)
	pla
	tay
	pla
	tax
	pla
	rti // return from interrupt

delay:
	ldx #02
	dex
	bne delay+2
	rts

clear:
	lda #$20
	sta $0400, x
	sta $0500, x
	sta $0600, x
	sta $0700, x
	inx
	bne clear
	rts
