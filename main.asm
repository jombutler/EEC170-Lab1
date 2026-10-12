.data

# An example array for problem 4, strided array sum. This is the array in
# the handout's worked example: with n = 3 and s = 2 it reads indices 0, 2
# and 4 and returns 10 + 30 + 50 = 90.
example_array:	.word 10, 20, 30, 40, 50, 60, 70, 80

.text

# macro to terminate the simulation
.macro exit ()
.text
li a7,10
ecall
.end_macro

# macro to print a integer value
.macro print_int (%reg)
.text
li a7,1
add x10, %reg, x0 
ecall
.end_macro

# macro to print an unsigned integer value
.macro print_intu (%reg)
.text
li a7,36
add x10, %reg, x0 
ecall
.end_macro

# marco to print a hexadecimal value
.macro print_hex (%reg)
.text
li a7,34
add x10, %reg, x0 
ecall
.end_macro

# macro to print a string
.macro print_str (%str)
.data
str_label: .string %str
.text
li a7, 4
la x10, str_label
ecall
.end_macro

# macro to place a 4-char ASCII string in a0
.macro test_str (%str)
.data
str_label: .string %str
.text
la x10, str_label

lb x15, (x10)
slli x15, x15, 24

lb x16, 1(x10)
slli x16, x16, 16
or x15, x16, x15

lb x16, 2(x10)
slli x16, x16, 8
or x15, x16, x15

lb x16, 3(x10)
or x15, x16, x15

mv x10, x15

li x15, 0
li x16, 0
.end_macro

# macro to place an 8-char ASCII string in a0 (first four characters) and
# a1 (last four), which is how problem 6 receives its input. Pad shorter
# expressions with spaces to exactly eight characters.
# Use this macro at most once: the string label it declares is not unique.
.macro test_str8 (%str)
.data
str8_label: .string %str
.text
la x10, str8_label

li x15, 0
lb x16, 0(x10)
slli x16, x16, 24
or x15, x15, x16
lb x16, 1(x10)
slli x16, x16, 16
or x15, x15, x16
lb x16, 2(x10)
slli x16, x16, 8
or x15, x15, x16
lb x16, 3(x10)
or x15, x15, x16

li x17, 0
lb x16, 4(x10)
slli x16, x16, 24
or x17, x17, x16
lb x16, 5(x10)
slli x16, x16, 16
or x17, x17, x16
lb x16, 6(x10)
slli x16, x16, 8
or x17, x17, x16
lb x16, 7(x10)
or x17, x17, x16

mv x10, x15
mv x11, x17

li x15, 0
li x16, 0
li x17, 0
.end_macro


.globl main
main: 

# Use the following labels for functions
	# problem 1: byteswap
	# problem 2: ctz
	# problem 3: satadd
	# problem 4: stridedsum
	# problem 5: rldecode
	# problem 6: calculator

	# Each block below sets up one problem's inputs and expected answer.
	# Uncomment the call and the prints for the problem you are working on.

	# to test byteswap function            expect 0x78563412
	# print_str("\nOutput of byteswap function\n")
	li x10, 0x12345678 # pass inputs
	#call byteswap
	mv t0, a0
	#print_str("Value stored in x10:")
	#print_hex(t0)

	# to test ctz function                 expect 25
	# print_str("\nOutput of ctz function\n")
	# li x10, 0x80000000 # pass inputs
	# call ctz
	# mv t0, a0
	# print_str("Value stored in x10:")
	# print_int(t0)

	# to test satadd function              expect 0x7fffffff
	# print_str("\nOutput of satadd function\n")
	li x10, 0x00000005
	li x11, 0xfffffffb # pass inputs
	#call satadd
	mv t0, a0
	#print_str("Value stored in x10:")
	#print_hex(t0)

	# to test stridedsum function          expect 90
	# print_str("\nOutput of stridedsum function\n")
	la x10, example_array
	li x11, 3          # n
	li x12, 2          # stride, in elements
	# call stridedsum
	mv t0, a0
	# print_str("Value stored in x10: ")
	# print_int(t0)

	# to test rldecode function            expect 0xAAABBCDD
	# print_str("\nOutput of rldecode function\n")
	li x10, 0x3A2B1C2D # pass inputs
	# call rldecode
	mv t0, a0
	# print_str("Value stored in x10: ")
	# print_hex(t0)

	# to test calculator function          expect 14
	# print_str("\nOutput of calculator function\n")
	test_str8("2+3*4-7 ") # pass inputs, padded to eight characters
	# call calculator
	mv t0, a0
	print_str("Value stored in x10: ")
	print_int(t0)

	exit()



	
