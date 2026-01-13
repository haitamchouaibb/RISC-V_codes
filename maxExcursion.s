.equ num_days 7
.equ num_areas 9

.data
temperatures: .byte  23, 25, 25, 24, 23, 26, 24, 22, 26 #giorno1
              .byte  26, 26, 24, 23, 22, 23, 22, 20, 25 #giorno2
              .byte  21, 20, 19, 23, 23, 22, 22, 19, 22 #giorno3
              .byte  17, 16, 17, 19, 18, 20, 21, 20, 19 #giorno4
              .byte  19, 22, 20, 21, 20, 20, 19, 19, 20 #giorno5
              .byte  21, 20, 22, 21, 23, 24, 24, 22, 21 #giorno6
              .byte  22, 21, 20, 20, 19, 22, 22, 21, 20 #giorno7
 
max_day:      .byte 0                # Variabile per memorizzare il giorno della temperatura massima
max_area:     .byte 0                # Variabile per memorizzare l'area della temperatura massima
msg1:         .string "Risultato Ex :"
msg2:         .string "\nRisultato Area :"
msg3:         .string "\nRisultato Day :"


		 
.text

main:	
    addi sp, sp, -4
    sw ra, 0(sp)
    la a0, temperatures
    la a1, max_day
    la a2, max_area
    li a3, num_days
    li a4, num_areas
    jal max_excursion
    mv s2, a0     
    # Print RISULTATO-1
    la a0, msg1   
    li a7, 4             
    ecall       
    mv a0, s2  
    li  a7, 1      
    ecall   
    # Print RISULTATO-2
    la a0, msg2   
    li a7, 4             
    ecall       
    lb a0, max_area  
    li a7, 1      
    ecall   
    # Print RISULTATO-3
    la a0, msg3   
    li a7, 4             
    ecall       
    lb a0, max_day  
    li a7, 1      
    ecall        
    lw ra, 0(sp)
    addi sp, sp, 4	
    li a7, 10
    ecall
    
    
max_excursion:
    li t0,-1 # Massima escursione
    li t1,-1 # Indice di riga della massima escursione
    li t2,-1 # Indice di colonna della massima escursione
    addi a3,a3,-1
    li t3,0 # Indice di riga per la scansione
    
maxe_start_ext_loop:
    beq t3,a3,maxe_end_ext_loop
    li t4,0 # Indice di colonna per la scansione
    
maxe_start_int_loop:
    beq t4,a4,maxe_end_int_loop
    mul t5,t3,a4
    add t5,t5,t4
    add t5,t5,a0
    lbu t6,0(t5)
    add t5,t5,a4 # Indirizzo dell'elemento successivo
    lbu t5,0(t5)
    sub t5,t5,t6
    bge t5,zero,maxe_pos # Massima escursione
    sub t5,zero,t5 # Se negativa cambio segno
    
maxe_pos:
    ble t5,t0,maxe_no_update
    mv t0,t5
    mv t1,t3
    addi t2,t4,1 // Questione solo di output , così stampa Area 1 al posto di Area 0
    
maxe_no_update:
    addi t4,t4,1
    j maxe_start_int_loop
    
maxe_end_int_loop:
    addi t3,t3,1
    j maxe_start_ext_loop
    
maxe_end_ext_loop:
    mv a0,t0
    sb t1,0(a1)
    sb t2,0(a2)
    jr ra

# ============================================================================
# SPIEGAZIONE DEL FUNZIONAMENTO
# ============================================================================
# Questo programma trova la MASSIMA ESCURSIONE TERMICA tra giorni consecutivi
#
# DATO: Matrice 7x9 con temperature di 7 giorni in 9 aree diverse
#
# ALGORITMO:
# 1. Doppio ciclo annidato:
#    - Ciclo esterno (t3): scorre 6 giorni (0-5), poiché confronta giorno i con giorno i+1
#    - Ciclo interno (t4): scorre 9 aree (0-8)
#
# 2. Per ogni coppia (giorno, area):
#    - Calcola: escursione = |temperatura(giorno+1) - temperatura(giorno)|
#    - Aggiorna il massimo se escursione > massimo_precedente
#
# 3. Memorizza:
#    - t0: il valore della massima escursione trovata
#    - t1: il giorno dove avviene la massima escursione
#    - t2: l'area + 1 (shift di 1 per offset nel calcolo dell'indirizzo)
#
# OUTPUT: Stampa
#    - La massima escursione
#    - L'area dove si verifica (max_area)
#    - Il giorno dove si verifica (max_day)
# ============================================================================