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
.align 2
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
	# Explicitly mark the end of translated tokens with 0x20000003
    	li t4, 0x20000003
    	sw t4, 0(t0)
	
	#at this point, t0 contains sorted digits and operators. Now we need to 
	#turn the individual digits into full numbers
	
	#want to get the beginning and ending points of the number
	#temps are t2, t5, and t6
	la t0, translatedAscii
	la t1, numberedTranslation
	li t2, 0x20000003
	sw t2, 0(t1)
	sw t2, 4(t1)
	sw t2, 8(t1)
	sw t2, 12(t1)
	sw t2, 16(t1)
	sw t2, 20(t1)
	sw t2, 24(t1)
	sw t2, 28(t1)
	li t2, 0
	
	combine_loop:
	lw t3, 0(t0)               # Load current word from translatedAscii
	
	# Check if it is the end-of-string / space marker (0x20000003)
	li t4, 0x20000003
	beq t3, t4, combine_end
	
	# Check if t3 is an operator (operators start at or above 0x20000000)
	li t4, 0x20000000
	bge t3, t4, handle_operator_token
	
	# Otherwise, it is a single digit (0-9). Accumulate it: t2 = (t2 * 10) + digit
	li t4, 10
	mul t2, t2, t4
	add t2, t2, t3
	
	addi t0, t0, 4             # Advance source pointer
	j combine_loop
	
	handle_operator_token:
	# 1. Store the completed accumulated number into numberedTranslation
	sw t2, 0(t1)
	addi t1, t1, 4             # Advance destination pointer past the number
	
	# 2. Store the operator word right after it
	sw t3, 0(t1)
	addi t1, t1, 4             # Advance destination pointer past the operator
	
	li t2, 0                   # Reset accumulator for the next number
	addi t0, t0, 4             # Advance source pointer
	j combine_loop
	
	combine_end:
	# Store the final accumulated number (for the last number in the expression)
	sw t2, 0(t1)
	
	#at this point, we have an array with numbers and operators and whitespaces
	#now we need to do the operators, and leave the array as one singular number
	#then we submit this number for good boy points (opposite of bad boy points)
	
	#Calculate the total word count in numberedTranslation
	la t0, numberedTranslation
	sub t5, t1, t0
	srai t5, t5, 2
	addi t5, t5, 1       # t5 = total word count
	
	# If the expression is just a single number, return it immediately
	li t3, 1
	bne t5, t3, parse_multiplications
	lw a0, 0(t0)
	j calc_exit
	
	parse_multiplications:
	li t2, 0            # t2 = scan index i = 0
	
	mul_scan_loop:
	bge t2, t5, mul_scan_done
	
	# Load word at index t2
	slli t3, t2, 2
	add t4, t0, t3
	lw t6, 0(t4)        # t6 = current token
	
	li t1, 0x20000002   # Multiply operator code (* = 0x20000002)
	beq t6, t1, do_multiplication
	
	addi t2, t2, 1
	j mul_scan_loop
	
	do_multiplication:
	# t2 is the index of *. Left operand at t2-1, right operand at t2+1
	slli t3, t2, 2
	add t4, t0, t3      # t4 points to the '*' operator
	
	lw t1, -4(t4)       # t1 = left number
	lw t6, 4(t4)        # t6 = right number
	mul t1, t1, t6      # t1 = left * right
	sw t1, -4(t4)       # Store product in place of the left number
	
	# Shift remaining elements left by 2 positions to remove * and right number
	mv t3, t2           # Destination index = t2 (starts overwriting at operator
	addi t6, t2, 2      # Source index = t2 + 2 (skips operator and right number)
	
	shift_loop:
	bge t6, t5, shift_done
	
	slli t1, t6, 2
	add t1, t0, t1
	lw t1, 0(t1)        # Load source word
	
	slli t4, t3, 2
	add t4, t0, t4
	sw t1, 0(t4)        # Store at destination
	
	addi t3, t3, 1
	addi t6, t6, 1
	j shift_loop
	
	shift_done:
	addi t5, t5, -2     # Reduce word count by 2
	li t2, 0            # Restart multiplication scan from the beginning
	j mul_scan_loop
	
	mul_scan_done:
	
	#Addition and Subtraction Pass (Left-to-Right)
	la t1, numberedTranslation
	lw t0, 0(t1)        # t0 = running accumulator result (starts with first number)
	li t2, 1            # t2 = index of the first operator (index 1)
	
	add_sub_loop:
	bge t2, t5, add_sub_done
	
	# Load operator at index t2
	slli t3, t2, 2
	add t3, t1, t3
	lw t4, 0(t3)        # t4 = operator
	
	# Load next number at index t2 + 1
	addi t6, t2, 1
	slli t6, t6, 2
	add t6, t1, t6
	lw t6, 0(t6)        # t6 = next number
	
	li t3, 0x20000000   # Plus code (+)
	beq t4, t3, do_addition
	
	# Otherwise it is minus (-)
	sub t0, t0, t6
	j add_sub_next
	
	do_addition:
	add t0, t0, t6
	
	add_sub_next:
	addi t2, t2, 2      # Advance by 2 to the next operator
	j add_sub_loop
	
	add_sub_done:
	mv a0, t0           # Final result placed in output register x10 (a0)
	
	calc_exit:
	
	#don't touch this
	lw ra, 0(sp)		# restore the return address
	addi sp, sp, 4		# deallocate the stack frame
	ret			# return to the calling point



	
