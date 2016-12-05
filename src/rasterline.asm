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

ldy #$0
main:
	ldx $d012
	cpx #$80
	bne main
	
wait_raster1:	
	lda #$aa
	sta $d020
	sta $d021
	
wait_raster2:
	ldx $d012
	cpx #$90
	
	bne wait_raster1
	lda #$0
	sta $d020
	sta $d021
	iny
	jmp main
	
clear:
	lda #$20
	sta $0400, x
	sta $0500, x
	sta $0600, x
	sta $0700, x	
	inx
	bne clear	
	rts	