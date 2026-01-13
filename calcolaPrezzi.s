.equ Paesi, 4
.equ Prodotti, 5

.data
MatricePrezzi:
    .word 700, 620, 680, 690
    .word 400, 460, 430, 420
    .word 50, 20, 40, 52
    .word 28, 30, 27, 26
    .word 25000, 21000, 24000, 23000

MatriceDazi:
    .word 25, 25, 25, 25
    .word 20, 75, 40, 45
    .word 65, 10, 20, 65
    .word 40, 65, 20, 25
    .word 50, 75, 62, 50

.text
main:
    la a0, MatricePrezzi
    la a1, MatriceDazi
    li a2, Paesi      # numero di colonne (paesi)
    li a3, Prodotti   # numero di righe (prodotti)
    jal CalcolaPrezzi
    li a7, 10
    ecall
    
CalcolaPrezzi:
    li t0,0 # Indice riga
    
loop_righe:
    beq t0,a3,fine
    li t1,0 # Indice colonna
    mul t2,t0,a2
loop_colonne:
    beq t1,a2,prossima_riga
    add t3,t2,t1
    
    slli t4,t3,2
    add t5,a0,t4
    lw t6,0(t5)
    add s4,a1,t4
    lw s1,0(s4)
    mul s2,t6,s1
    li s3,100
    divu s2,s2,s3
    add t6,t6,s2
    sw t6,0(t5)
    addi t1,t1,1
    j loop_colonne
    
prossima_riga:
    addi t0,t0,1
    j loop_colonne
    
fine:
    jr ra
    

    