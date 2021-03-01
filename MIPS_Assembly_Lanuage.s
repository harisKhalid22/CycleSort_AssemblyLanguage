.data
	arr:  .word 	29, 34, 58, 86, 96, 05, 77, 31
	msg:  .asciiz 	", "
	msg2: .asciiz 	"\n"
	msg3: .asciiz 	"Cycle compelete."

.text
.globl main 
main: 
	la $t1, arr	#load address of arr[0] in $t1
	li $t0, 0 	#i=0
	li $t9, 8	#indexValue
	li $t8, 7	#indexValue
	b Print		#Print the starting array

For:
	bgt $t0,$t9,Exit	#jump to Exit if i > 8
	lw $t3,($t1)		#load value at address $t1 in $t3
	li $t5, 0 		#j=0
	li $t6, 0 		#count=0

	######################################################################
	
	beq $t0,0, Add_4_for_0		#jump to Add_4_for_0 if (i = 0)

	Add_4_for_AnyNumber:
		la $t2, arr		#load address of arr[0] in $t2
		mul $t7,$t0,4		#temp = AnyNumber * 4
		add $t2,$t2,$t7		#arr = arr + temp
		b For2			#jump to For2

	Add_4_for_0:
		la $t2, arr		#load address of arr[0] in $t2
		add $t2,$t2,4		#arr = arr + 4
		b For2			#jump to For2

	######################################################################

	For2:
		bgt $t5,$t8,Exit2	#jump to Exit if j > 7
		lw $t4,($t2)		#load value at address $t2 in $t4

		bgt $t3,$t4,Increment	#jump to Increment if (initialValue > nextValue)

		NotIncrement:
			add $t2,$t2,4	#arrNextValue
			add $t5,$t5,1 	#j++
			b For2		#jump to For2

		Increment:
			add $t6,$t6,1 	#count++
			add $t2,$t2,4	#arrNextValue
			add $t5,$t5,1 	#j++
			b For2		#jump to For2

	Exit2:
		add $t6,$t6,$t0		#count = count + i
		beq $t6,$t0,NextValue	#jump to NextValue if (i = count)
		
	######################################################################
	###############  TO GET THE VALUE OF $t6 INTO $t4  ###################
	######################################################################
	
	la $t2, arr		#load address of arr[0] in $t2
	
	mul $t5,$t6,4		#multiply the index by 4
	add $t2,$t2,$t5		#add the value in array
	
	lw $t4,($t2)		#load value at address $t2 in $t4

	######################################################################	
	#########################  PERFORM SWAP  #############################
	######################  BETWEEN $t3 AND $t4  #########################
	######################################################################
	
	move $t5,$t4		#temp = $t4 
	move $t4,$t3		#$t4 = $t3
	move $t3,$t5		#$t3 = temp
	sw $t4,($t2)		#value store to array 
	sw $t3,($t1)		#value store to array 
	b Print			#jump to Print

	######################################################################
	#######################  GO TO NEXT VALUE  ###########################
	######################################################################

	NextValue:
		add $t0,$t0,1		#i++
		sub $t9,$t9,1		#indexValue - 1
		sub $t8,$t8,1		#indexValue - 1
		add $t1,$t1,4		#arrNextValue

		li $v0,4		#print 'Cycle compelete.'
		la $a0,msg3
		syscall

		li $v0,4		#print '\n'
		la $a0,msg2
		syscall

		li $v0,4		#print '\n'
		la $a0,msg2
		syscall
		
	######################################################################
	######################  TO PRINT THE ARRAY  ##########################
	######################################################################

	Print:
		la $t2, arr		#load address of arr[0] in $t2	
		li $t5, 0 		#j=0

	StartPrint:
		bgt $t5,7,NextLine	#jump to Exit if i > 7
		lw $t4,($t2)		#load value at address $t2 in $t4

		li $v0, 1
		move $a0, $t4		#print the value 
		syscall
		
		li $v0,4		#print ', '
		la $a0,msg
		syscall
	
		add $t2,$t2,4		#arrNextValue
		add $t5,$t5,1 		#j++
		b StartPrint		#jump to StartPrint

	######################################################################
	########################  FOR NEXT LINE  #############################
	######################################################################

	NextLine:
		li $v0,4		#print '\n'
		la $a0,msg2
		syscall
		b For			#jump to For
	
Exit:
	li $v0,10		#exitCode
	syscall