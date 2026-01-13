.data
matrice1: .half -1, 2, 3, 4, -5
          .half 6, -7, 8, -9, 10
          .half 11, 12, -13, 14, 15
          .half 16, -17, 18, -19, 20
matrice2: .half -1, 12, 7, -24, -13, 18
          .half 2, -10, -11, 22, 14, 17
          .half -3, 8, 9, 20, -15, -16

.text

main: 
    addi sp, sp, -4
    sw ra, 0(sp)
    la a0, matrice1
    li a1, 5
    li a2, 2
    la a3, matrice2
    li a4, 6
    li a5, 1
    jal contaUguali
    li a7, 1
    ecall
    lw ra, 0(sp)
    addi sp, sp, 4
    li a7, 10
    ecall
    
    
contaUguali:
    mul a2,a2,a1 # Riga * n.colonne
    slli a2,a2,1 # Converti elementi in byte
    add a0,a0,a2 # Indirizzo base della riga della prima matrice
    mul a5,a5,a4
    slli a5,a5,1
    add a3,a3,a5 # Indirizzo base della riga della seconda matrice
    li t0,0 # Numero elementi uguali in valore assoluto
    li t1,0 # Indice prima matrice
    
cU_start_loop_1:
    beq t1,a1,cU_end_loop_1
    slli t3,t1,1
    add t3,t3,a0
    lh t3,0(t3)
    bge t3,zero,cU_pos_1
    sub t3,zero, t3 # Se è negativo cambia segno
    
cU_pos_1:
    li t2,0 # Indice seconda matrice
    
cU_start_loop_2:
    beq t2,a4,cU_end_loop_2
    slli t4,t2,1
    add t4,t4,a3
    lh t4,0(t4)
    bge t4,zero,cU_pos_2
    sub t4,zero,t4
    
cU_pos_2:
    bne t3,t4,cU_no_update
    addi t0,t0,1
    
cU_no_update:
    addi t2,t2,1
    j cU_start_loop_2
    
cU_end_loop_2:
    addi t1,t1,1
    j cU_start_loop_1
    
cU_end_loop_1:
    mv a0,t0
    jr ra