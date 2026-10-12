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
.globl rldecode

	rldecode:
	    # addi sp, sp, -4    # allocate the stack frame
	    # sw ra, 0(sp)        # save the return address
	
	    mv t0, a0
	    
	    # this will hold our final output word
	    li t1, 0
	
	    # numero uno
	    srli t2, t0, 28       # get count
	    srli t3, t0, 24       # get value
	    andi t3, t3, 0xf      # mask value to 4 bits
	    slli t0, t0, 8        # shift input to bring next pair to the front
	
	    pair1_repeat:
	    beqz t2, pair1_done
	    slli t1, t1, 4    # make room in output
	    or t1, t1, t3     # put value in
	    addi t2, t2, -1
	    j pair1_repeat
	    
	    pair1_done:
	
	    # futatsu
	    srli t2, t0, 28
	    srli t3, t0, 24
	    andi t3, t3, 0xf
	    slli t0, t0, 8
	
	    pair2_repeat:
	    beqz t2, pair2_done
	    slli t1, t1, 4
	    or t1, t1, t3
	    addi t2, t2, -1
	    j pair2_repeat
	    
	    pair2_done:
	
	    # mittsu
	    srli t2, t0, 28
	    srli t3, t0, 24
	    andi t3, t3, 0xf
	    slli t0, t0, 8
	
	    pair3_repeat:
	    beqz t2, pair3_done
	    slli t1, t1, 4
	    or t1, t1, t3
	    addi t2, t2, -1
	    j pair3_repeat
	    
	    pair3_done:
	
	    # yottsu
	    srli t2, t0, 28
	    srli t3, t0, 24
	    andi t3, t3, 0xf
	    # no need to shift t0 anymore, we are at the end
	
	    pair4_repeat:
	    beqz t2, pair4_done
	    slli t1, t1, 4
	    or t1, t1, t3
	    addi t2, t2, -1
	    j pair4_repeat
	    
	    pair4_done:
	
	    # move final answer to return register
	    mv a0, t1
	    
	    # lw ra, 0(sp)
	    # addi sp, sp, 4
	    ret
	    
	    