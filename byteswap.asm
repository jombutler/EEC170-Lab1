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
.globl byteswap

byteswap:

	# addi sp, sp, -4	# allocate the stack frame
	# sw ra, 0(sp)		# save the return address

	# your code here
	
	
	li t1, 0xff000000
	li t2, 0x00ff0000
	li t3, 0x0000ff00
	li t4, 0x000000ff
	
	and t5, t5, zero
	and t1, x10, t1
	and t2, x10, t2
	and t3, x10, t3
	and t4, x10, t4

	srli t1, t1, 24
	srli t2, t2, 8
	slli t3, t3, 8
	slli t4, t4, 24
	
	or t5, t1, t5
	or t5, t2, t5
	or t5, t3, t5
	or t5, t4, t5
	
	mv x10, t5
	

	# lw ra, 0(sp)		# restore the return address
	# addi sp, sp, 4	# deallocate the stack frame
	ret			# return to the calling point
