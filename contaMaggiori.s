.equ num_righe 2  
.equ num_colonne 3  
.equ soglia 15  

.data  
matrice: .byte 5, 10, 15, 20, 25, 30  
msg: .string "Conteggio: "  

.text  
main:  
    addi sp, sp, -4  
    sw ra, 0(sp)  
    la a0, matrice  
    li a1, num_righe  
    li a2, num_colonne  
    li a3, soglia  
    jal contaMaggiori  
    mv s0, a0  
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
    
    
contaMaggiori:
    li t0,0 # Contatore
    li t1,0 # Indice riga
    
riga:
    beq t1,a1,fine
    li t2,0 # Indice colonna
    
colonna:
    beq t2,a2,prossima_riga
    mul t3,t1,a2
    add t3,t3,t2
    add t3,t3,a0
    lbu t4,0(t3)
    bge t4,a3,fuori_soglia
    addi t0,t0,1
    
fuori_soglia:
    addi t2,t2,1
    j colonna
    
prossima_riga:
    addi t1,t1,1
    j riga
    
fine:
    mv a0,t0
    jr ra