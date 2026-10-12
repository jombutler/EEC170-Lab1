# Template for one Project 1 function.
#
# Copy this file once per problem, rename it to the filename the handout
# gives for that problem, and rename the label to match. Both the filename
# and the function name have to be exactly right or the autograder cannot
# find your work.
#
#   problem 1: byteswap.asm    byteswap     a0            -> a0
#   problem 2: ctz.asm         ctz          a0            -> a0
#   problem 3: satadd.asm      satadd       a0, a1        -> a0
#   problem 4: stridedsum.asm  stridedsum   a0, a1, a2    -> a0
#   problem 5: rldecode.asm    rldecode     a0            -> a0
#   problem 6: calculator.asm  calculator   a0, a1        -> a0
#
# Problem 7 (valid parentheses) is optional and is not submitted.
#
# The stack frame below is commented out because none of these six problems
# requires one: each can be written as a leaf function, which is one that
# calls nothing else and therefore never needs to preserve ra. Uncomment it
# if your solution does call another function --- problem 7, if you attempt
# it, is the natural place --- and save any saved registers (s0-s11) you use
# in the same frame.

# Declare the label global so the grader's harness can call it.
.data
allchars: .space 64
noscrubs: .space 64
translatedAscii: .space 256 #32 bits per words, 8 words
numberedTranslation: .space 256

.text
.globl calculator

calculator:
	addi sp, sp, -4	# allocate the stack frame
	sw ra, 0(sp)		# save the return address
	#don't touch this
	
	

	# your code here
	la t0, allchars
	la t1, noscrubs
	#li a0 0x322b332a , corresponds to 2+3*4-7 
	#li a1 0x342d3720
	li a0 0x322b332a
	li a1 0x342d3737
	
	#add a0 and a1 to array
	sw a1, 0(t0)
	sw a0, 4(t0)
	
	
	#set everything in t1 to spaces
	li t2, 0x20202020
	sw t2, 0(t1)
	sw t2, 4(t1)
	
	
	li t2, 7 #total byte counter
	li t3, 7 #non whitespace byte counter
	mv t4, t1 #t4 is temp for t1 address
	li t5, 0x00000020 #base space
	
	
	add t4, t3, t4  #7[t4] or 7[t1]
	add t0, t2, t0 #7[t0]
	
	loopspinner:
	blt t2, zero, endloopspinner
	lb t6, 0(t0)
	
	addi t0, t0, -1
	addi t2, t2, -1
	
	beq t5, t6, mawaru
	#the character in t0 isn't whitespace
	sb t6, 0(t4)
	
	addi t4, t4, -1
	addi t3, t3, -1
	
	mawaru:
	beq zero, zero, loopspinner
	
	endloopspinner:
	
	#at this point, t1 array contains the sorted a0 and a1
	#a0 is in 7-4 (read in reverse though, so 7,6,5,4 = a0
	#a1 is in 3-0 (3,2,1,0 = a1)
	
	#now, we have to extract the numbers and the operators
	#There will be at most four numbers and three operators
	#After this, we can do operations
	#useful register at this point is t1, because it has the sorted array
	lw t2, 4(t1)
	lw t3, 0(t1)
	la t0, translatedAscii
	mv t2, t1
	#t0 is translatedAscii,  t2 is sorted array
	#words 0-9 is numbers 0-9, 10 is + (0x2000 0000), 11 is - (0x2000 0001), 12 is * (0x2000 0002),
	#spaces are 0x2000 0003
	
	li t4, 0x20000003
	sw t4, 0(t0)
	sw t4, 4(t0)
	sw t4, 8(t0)
	sw t4, 12(t0)
	sw t4, 16(t0)
	sw t4, 20(t0)
	sw t4, 24(t0)
	sw t4, 28(t0)
	
	mv t6, t2
	addi t6, t6, 7 # t6 = 7(sortedArray)
	
	settingLoop:
	mv t4, t2
	blt t6, t4, endOfTranslation
	
	li t3, 0
	lb t3, 0(t6) #t3 is the temp register
	addi t6, t6, -1
	
	li t4, 0x00000030
	bge t3, t4, setNumber
	
	li t4, 0x0000002b
	beq t3, t4, setPlus
	
	li t4, 0x0000002d
	beq t3, t4, setMinus
	
	li t4, 0x0000002a
	beq t3, t4, setMultiply
	
	#exit if space
	beq zero, zero, endOfTranslation
	
	setNumber:
	
	addi t3, t3, -48 #remove the 30
	sw t3, 0(t0)
	addi t0, t0, 4
	beq zero, zero, settingLoop
	
	setPlus:
	li t4, 0x20000000
	sw t4, 0(t0)
	addi t0, t0, 4
	beq zero, zero, settingLoop
	
	setMinus:
	li t4, 0x20000001
	sw t4, 0(t0)
	addi t0, t0, 4
	beq zero, zero, settingLoop
	
	setMultiply: 
	li t4, 0x20000002
	sw t4, 0(t0)
	addi t0, t0, 4
	beq zero, zero, settingLoop
	
	endOfTranslation:
	
	#at this point, t0 contains sorted digits and operators. Now we need to 
	#turn the individual digits into full numbers
	
	#want to get the beginning and ending points of the number
	la t0, translatedAscii
	la t1, numberedTranslation
	li t2, 0x0000003a
	
	la
	
	
	
	#don't touch this
	lw ra, 0(sp)		# restore the return address
	addi sp, sp, 4		# deallocate the stack frame
	ret			# return to the calling point

asciiToNumbers:

	
