	area example, code, readonly
num equ 20
	entry
start
	ldr r0, =src            ;r0设置为源基地址
	ldr r1, =dst            ;r1设置为目标基地址
	mov r2, #num            ;num变量为转移大小
	ldr sp, =0x40000100
	
copywords
	
	movs r3, r2, lsr #3     ;r3 = r2 / 8
	beq trans1reg
		
	stmfd sp!, {r4-r11}     ;将接下来要用到的寄存器入栈保存
trans8reg
	ldmia r0!, {r4-r11}     ;将以r0为基地址的8个内存单元依次放到r4-r11寄存器中
	stmia r1!, {r4-r11}     ;将r4-r11寄存器中内容存储到以r1为基地址的8个内存单元
	subs r3, r3, #1
	bne trans8reg
	ldmfd sp!, {r4-r11}     ;将方才入栈保存的寄存器出栈还原
	
	ands r2, r2, #7         ;r2 = r2 % 8
	beq stop
trans1reg
	ldr r4, [r0], #4
	str r4, [r1], #4
	subs r2, r2, #1
	bne trans1reg
    
	area mydata, data, readwrite
src dcd 1,2,3,4,5,6,7,8,1,2,3,4,5,6,7,8,1,2,3,4       ;使用dcd开辟内存空间，大小为20*4Bytes，内容为其后数字
dst dcd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	end
