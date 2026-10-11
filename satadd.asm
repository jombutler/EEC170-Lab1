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
.globl satadd

satadd:

	# addi sp, sp, -4	# allocate the stack frame
	# sw ra, 0(sp)		# save the return address

	# your code here
	#li x10, 0x7ffffff0
	#li x11, 0x00000020
	li t1, 0
	li t2, 0
	
	#want to know if x and y are both positive, negative, or different
	#t1 is 1 if x10 is neg, t2 is 1 if x10 is pos
	blt x10, zero, ex10negStart
	ex10negEnd:
	blt x11, zero, ex11negStart
	ex11negEnd:
	
	#if t1 doesn't equal t2, they aren't of same sign, overflow is nonissue
	bne t1, t2, siffrin
	
	#at this point, both are numbers of same sign. Now we branch to pos and neg cases
	bne t1, zero, kris
	
	#set to the halfway
	li t3, 0x3fffffff
	li t1, 0
	li t2, 0
	
	bge x10, t3, ex10halfwayPastStartPos
	ex10halfwayPastEndPos:
	bge x11, t3, ex11halfwayPastStartPos
	ex11halfwayPastEndPos:
	
	beq t1, t2, AddOrLeaveEvaluatePos
	#now one register is larger than the halfway, but the other isn't
	bge x10, x11, x10largerx11pos
	mv t1, x11
	mv t2, x10
	beq zero, zero, tempsSetpos
	
	x10largerx11pos:
	mv t1, x10
	mv t2, x11
	beq zero, zero, tempsSetpos
	
	tempsSetpos:
	#t1 is larger,  t2 is smaller. 
	sub t1, t1, t3
	sub t2, t3, t2
	#if t1 remainder can fit in t2 remainder, add them
	ble t1, t2, siffrin
	li x10, 0x7fffffff
	beq zero, zero, susie
	
	
	#negative case
	kris:
	
	#set to the halfway
	li t3, 0xc0000000
	li t1, 0
	li t2, 0
	
	ble x10, t3, ex10halfwayPastStartNeg
	ex10halfwayPastEndNeg:
	ble x11, t3, ex11halfwayPastStartNeg
	ex11halfwayPastEndNeg:
	
	beq t1, t2, AddOrLeaveEvaluateNeg
	#now one register is larger than the halfway, but the other isn't
	
	ble x10, x11, x10largerx11neg
	mv t1, x11
	mv t2, x10
	beq zero, zero, tempsSetneg
	
	x10largerx11neg:
	mv t1, x10
	mv t2, x11
	beq zero, zero, tempsSetneg
	
	tempsSetneg:
	#t1 is more negative, t2 is less negative
	sub t1, t1, t3
	sub t2, t3, t2
	#if t1 remainder can fit in t2 remainder, add them
	#as in, t1 is more negative, so lesser absolute value
	bge t1, t2, siffrin
	li x10, 0x80000000
	beq zero, zero, susie
	
	
	ex10negStart:
	addi t1, t1, 1
	beq zero, zero, ex10negEnd
	
	ex11negStart:
	addi t2, t2, 1
	beq zero, zero, ex11negEnd
	
	ex10halfwayPastStartPos:
	addi t1, t1, 1
	beq zero, zero, ex10halfwayPastEndPos
	
	ex11halfwayPastStartPos:
	addi t2, t2, 1
	beq zero, zero, ex11halfwayPastEndPos
	
	ex10halfwayPastStartNeg:
	addi t1, t1, 1
	beq zero, zero, ex10halfwayPastEndNeg
	
	ex11halfwayPastStartNeg:
	addi t2, t2, 1
	beq zero, zero, ex11halfwayPastEndNeg
	
	AddOrLeaveEvaluatePos:
	#if 0 (both less than halfway) just add em
	#if 1, set it to 1 then leave
	beq t1, zero, siffrin
	li x10, 0x7fffffff
	beq zero, zero, susie
	
	AddOrLeaveEvaluateNeg:
	#if 0 (both less than halfway) just add em
	#if 1, set it to 1 then leave
	beq t1, zero, siffrin
	li x10, 0x80000000
	beq zero, zero, susie
	
	
	siffrin:
	add x10, x10, x11
	
	susie:
	# lw ra, 0(sp)		# restore the return address
	# addi sp, sp, 4	# deallocate the stack frame
	ret			# return to the calling point
