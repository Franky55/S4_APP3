.data 0x10010000
#donnees

Metriques: .word 3,4,2,3  
	   .word 5,2,2,3
	   .word 3,4,2,3
	   .word 3,0,4,5  # 4x4 array
	  
Si: .word 2,0,2,2
So: .word 2,0,2,2

m250: .word 250, 250, 250, 250

.eqv N 4
.eqv NbBytes 4

# $z? son nos vecteurs


.text 0x400000
.globl main

main:
	la $a0, Metriques
	la $a1, Si
	la $a2, So

	jal calculSurvivants		# calcule avec Metriques et Si
	
	addi $v0, $0, 0xA
	syscall

acs:
	add $t0, $zero, $zero
	
	lw $t4, 0($a0)		# $t1 = met[i]							VVVVVVVVVV
	lw $t5, 0($a1)		# $t2 = si[i]							VVVVVVVVVV
	add $t6, $t4, $t5 	# adding to the temp = met[j] + sinput[j]			VVVVVVVVVV
	
	add $t2, $t6, $t6 		# trouve la valeur la plus petite du vecteur		VVVVVVVVVV
	move $t7, $a2		# move &soutput[i] dans $
	lw $t1, 0($t7)		# pogne la valeur de $t7 (*soutput) dans $t1
	slt $t8, $t2, $t1	# if (temp < souput[i]) $t6 = 1;
	li $t1, 1
	beq $t8, $t1, skip	# jump to while2 if $t1 != 1
	jr $ra 
	nop
skip:
	sw $t3, 0($t7)		# met la valeur dans *soutput
	jr $ra 				# jump back to original function


# fonction for calculating Surviver
calculSurvivants:
	addi $sp, $sp, -32 	# adjust stack *4 a cause 32 bits, (return adress,)
	sw $ra, 0($sp)  	# save the return address, will need to add to make room for stack
	sw $a0, 4($sp)		# save met
	sw $a2, 8($sp)		# save soutput
	sw $a1, 12($sp)		# saved a1
	sw $s0, 16($sp)		# saved value of $s0
				
	add $s0, $zero, $zero
	
	lw $t4, m250		# addi $t5, $zero, 250							VVVVVVVVVV
	sw $t5, 0($a2)		# Storing the value 250 at the position of the soutput			VVVVVVVVVV
	
	while1:
		beq $s0, N, finwh1	# if 
	
		#reset parameters
		lw $a0, 4($sp)
		lw $a2, 8($sp)
		lw $a1, 12($sp)
	
		mul $t2, $s0, NbBytes	# number of bytes offset ( i * NbBytes )
		mul $t1, $t2, N		# number of bytes offset ( i * N )
		add $t3, $a2, $t2	# $t3 is at the right position to store the value	
		
		move $a2, $t3		# Set $a2 = &soutput[i]
		add $t3, $a0, $t1
		move $a0, $t3		# Set $a0 = &met[i*n]
		
		
		jal acs
	
		addi $s0, $s0, 1	# i++
		j while1
	finwh1:
	
	lw $s0, 16($sp)		# load original value of $s0
	lw   $ra, 0($sp)  	# restore the return address
	addi $sp, $sp, 32  	# adjust stack pointer
	jr $ra 			# jump back to original function
