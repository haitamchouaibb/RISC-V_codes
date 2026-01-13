.equ num_righe 2  
.equ num_colonne 3  

.data  
matrice: .byte 1, 2, 3, 4, 5, 6  
msg: .string "Somma: "  

.text  
main:  
    addi sp, sp, -4  
    sw ra, 0(sp)  
    la a0, matrice  
    li a1, num_righe  
    li a2, num_colonne  
    jal sommaMatrice  
    mv s0, a0  # Salva risultato  
    la a0, msg  
    li a7, 4  
    ecall  
    mv a0, s0  
    li a7, 1  
    ecall  
    lw ra, 0(sp)  
    addi sp, sp, 4  
    li a7, 10  
    ecall
    
sommaMatrice:
    li t0,0 # Contatore somma
    li t1,0 # Indice riga
    
loop_righe:
    beq t1,a1,fine
    li t2,0
    
loop_colonne:
    beq t2,a2,prossima_riga
    mul t3,t1,a2
    add t3,t3,t2
    add t3,a0,t3
    lbu t3,0(t3)
    add t0,t0,t3
    addi t2,t2,1 
    j loop_colonne
    
prossima_riga:
    addi t1,t1,1
    j loop_righe
    
fine:
    mv a0,t0
    jr ra