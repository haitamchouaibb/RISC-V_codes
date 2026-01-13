.equ num_righe 2  
.equ num_colonne 2  

.data  
matrice: .byte 10, 20, 30, 40  
msg: .string "Massimo: "  

.text  
main:  
    addi sp, sp, -4  
    sw ra, 0(sp)  
    la a0, matrice  
    li a1, num_righe  
    li a2, num_colonne  
    jal trovaMax  
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
    
trovaMax:
    li t0,0 # Massimo 
    li t1,0 # Indice riga
    
riga:
    beq t1,a1,fine
    li t2,0 # Indice colonna
    
colonna:
    beq t2,a2,prossima_riga
    mul t3,t1,a2
    add t3,t3,t2
    add t3,t3,a0
    lbu t3,0(t3)
    bgt t3,t0,update
    
update:
    mv t0,t3
    addi t2,t2,1
    j colonna
    
prossima_riga:
    addi t1,t1,1
    j riga
    
fine:
    mv a0,t0
    jr ra
    
    

    
    
