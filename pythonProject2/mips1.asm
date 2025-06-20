# ReferenceStandard_ProduitMatrice.asm
# Code pour calculer une performance de référence.
# Francis Gratton et Clovis Langevin
# Dept. GE & GI U. de S. 
#
# Problématique/Rapport
#
.data 0x10010000

# vec_sortie doit donner 30, 70, 110, 150

# $z son nos vecteur            
               
.text 0x400000
.eqv N 4

main:
addi $sp, $sp, -16
li $t0, 1
sw $t0, 0($sp)
li $t0, 2
sw $t0, 4($sp)
li $t0, 3
sw $t0, 8($sp)
li $t0, 4
sw $t0, 12($sp)

    lwv $z2, 0($sp)
    
    addi $sp, $sp, -16
    swv $z2, 0($sp)
    
    lwv $z1, 0($sp)
    addv $z0, $z2, $z1
    
    minv $t1, $z1, $z1

    addi $v0, $zero, 10     # fin du programme
    syscall
    

