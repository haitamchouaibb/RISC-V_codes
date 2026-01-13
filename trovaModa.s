.equ N 8

.data
array: .word 3, 7, 3, 5, 7, 3, 9, 7
msg: .string "Elemento più frequente: "

.text
main:
    addi sp, sp, -4
    sw ra, 0(sp)
    la a0, array
    li a1, N
    jal trovaModa
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

trovaModa:
    li t0, 0      # Massima frequenza trovata
    li t1, 0      # Elemento con massima frequenza (risultato)
    li t2, 0      # Indice loop esterno
    
esterno:
    beq t2, a1, fine_esterno
    
    # Carica elemento corrente da analizzare
    slli t3, t2, 2        # t2 * 4 (offset in byte)
    add t3, t3, a0        # indirizzo base + offset
    lw t3, 0(t3)          # carica elemento
    
    # Conta quante volte appare questo elemento nell'array
    li t6, 0              # contatore occorrenze
    li t4, 0              # indice loop interno
    
interno:
    beq t4, a1, fine_interno
    
    # Carica elemento per il confronto
    slli t5, t4, 2
    add t5, t5, a0
    lw t5, 0(t5)
    
    # Se è uguale all'elemento corrente, incrementa contatore
    bne t5, t3, non_uguale
    addi t6, t6, 1
    
non_uguale:
    addi t4, t4, 1
    j interno
    
fine_interno:
    # Se frequenza attuale > massima, aggiorna
    ble t6, t0, non_aggiornare
    mv t0, t6             # aggiorna massima frequenza
    mv t1, t3             # salva l'elemento
    
non_aggiornare:
    addi t2, t2, 1
    j esterno
    
fine_esterno:
    mv a0, t1             # restituisci l'elemento più frequente
    jr ra
    