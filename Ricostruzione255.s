.equ DIM 7

.data
vettore: .byte 11 255 1 255 255 2 12
msg1: .string "\nElementi corretti:\n"
msg2: .string "\nVettore corretto:\n"

.text

main: 
    addi sp, sp, -4
    sw ra, 0(sp)
    la a0, vettore
    li a1, DIM
    jal Ricostruzione
    mv t0, a0
    li a7, 4
    la a0, msg1
    ecall
    li a7, 1
    mv a0, t0
    ecall
    li a7, 4
    la a0, msg2
    ecall
    la t2, vettore
    li t0, 0
start_loop:
    li t1, DIM
    beq t0, t1, end_loop
    add t1, t2, t0
    li a7, 1
    lbu a0, 0(t1)
    ecall
    li a7, 11
    li a0, 0x20 # spazio
    ecall
    addi t0, t0, 1
    j start_loop
end_loop:
    lw ra, 0(sp)
    addi sp, sp, 4
    li a7, 10
    ecall
    
Ricostruzione:
    li t0,0 # Numero di valori corretti
    li t1,0 # Indice della scansione
    
Ric_start_loop:
    beq t1,a1,Ric_end_loop
    add t2,t1,a0
    lbu t3,0(t2) # Elemento corrente
    li t4,255
    bne t3,t4, Ric_no_255
    
Ric_first_255:
    lbu t3,1(t2)
    bne t3,t4,Ric_one_255
    
Ric_two_255:
    lbu t3,-2(t2)
    lbu t4,-1(t2)
    lbu t5,2(t2)
    lbu t6,3(t2)
    add t3,t3,t4
    add t3,t3,t5
    add t3,t3,t6
    srli t3,t3,2
    sb t3,0(t2)
    sb t3,1(t2)
    addi t0,t0,2
    j Ric_no_255
    
Ric_one_255:
    lbu t3,-1(t2)
    lbu t4,1(t2)
    add t3,t3,t4
    srli t3,t3,1
    sb t3,0(t2)
    addi t0,t0,1
    
Ric_no_255:
    addi t1,t1,1
    j Ric_start_loop
    
Ric_end_loop:
    mv a0,t0
    jr ra
