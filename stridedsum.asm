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
.globl stridedsum

stridedsum:

	# addi sp, sp, -4	# allocate the stack frame
	# sw ra, 0(sp)		# save the return address

	# your code here
	#x10-t2 is array, x11-t3 is number of elements to add, x12 is stride
	
	li t0, 0 #the summing temp
	li t1, 0 #number times added
	mv t2, x10
	mv t3, x11
	
	addingPortion:
	beq x11, zero, endOfLine #if no elements to add, leave
	
	lw t5, 0(t2)#t5 gets the element from the array
	
	add t0, t0, t5 #add the element to t0
	addi t1,t1, 1 #another element added
	
	beq t1, x11, endOfLine #if no more elements to add, skedaddle (prevents overflow)
	
	#update t2 so it matches stride
	li t5, 0
	li t6, 0
	li s4, 4
	#multiply stride length by four b4 adding it 
	keepMultiplying:
	add t6, t6, s4
	addi t5, t5, 1
	bne t5,x12 keepMultiplying
	add t2, t2, t6
	
	beq zero, zero, addingPortion
	
	
	endOfLine:
	mv x10, t0

	# lw ra, 0(sp)		# restore the return adddress
	# addi sp, sp, 4	# deallocate the stack frame
	ret			# return to the calling point
