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
.globl ctz

ctz:

	# addi sp, sp, -4	# allocate the stack frame
	# sw ra, 0(sp)		# save the return address


	beq x10, zero, alula
	li t2, 0x00000000 # t2 is the counter
	li t0, 0x00000001 # t0 is the bit mask
	
	niko:
	and t1, t0, x10 #sets all but the last bit of x10 to 0, then stores it in t1
	beq t0, t1, calamus #if you've met the first bit, leave loop
	addi t2, t2, 1
	slli t0, t0, 1
	beq x0, x0, niko #continue loop if you haven't meet first bit

	#If its zero, immediately set count to 32 (avoids overflow)
	alula: 
	li t2, 32
	
	calamus:
	mv x10, t2
	
	# lw ra, 0(sp)		# restore the return address
	# addi sp, sp, 4	# deallocate the stack frame
	ret			# return to the calling point
