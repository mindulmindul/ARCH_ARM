	area example, code, readonly
num equ 20
	entry
start
	ldr r0, =src
	ldr r1, =dst
	mov r2, #num
	ldr sp, =0x40000100
	
copywords
	
	movs r3, r2, lsr #3
	beq trans1reg
		
	stmfd sp!, {r4-r11}
trans8reg
	ldmia r0!, {r4-r11}
	stmia r1!, {r4-r11}
	subs r3, r3, #1
	bne trans8reg
	ldmfd sp!, {r4-r11}
	
	ands r2, r2, #7
	beq stop
trans1reg
	ldr r4, [r0], #4
	str r4, [r1], #4
	subs r2, r2, #1
	bne trans1reg
	
stop
	mov r0, #0x18
	ldr r1, =0x20026
	swi 0x123456
		
	area mydata, data, readwrite
src & 1,2,3,4,5,6,7,0x8,1,2,3,4,5,6,7,8,1,2,3,4
dst & 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	end
		
