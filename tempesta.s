.equ num_righe 5
.equ num_colonne 7

.data
tempesta:	.byte  12, 15, 10, 0, 0, 0, 0
    		.byte  0, 19, 15, 13, 12, 10, 4
	    	.byte  8, 14, 16, 13, 10, 8, 6
		    .byte  0, 0, 8, 4, 3, 0, 0
    		.byte  0, 0, 7, 3, 0, 0, 0

msg1: .string "\n N. celle interessate dalla tempesta"
msg2: .string "-"
msg3: .string "\n"

.text
main:
    addi sp,sp,-4 // Stack pointer per allocare spazio sullo stack
    sw ra,0(sp) // Salva il registro ra nello stack, chiamiamo funzioni e vogliamo tornare qui
    jal print_matrice
    la a0,tempesta // Carica l'indirizzo della matrice in a0
    li a1,num_righe // Carica 5 in a1
    li a2,num_colonne // Carica 7 in a2
    jal previsione // Chiama la funzione previsione, che modifica la matrice e restituisce in a0 il conteggio delle celle interessate
    mv s2,a0 // Copia il risultato in s2 (per usarlo dopo)
    la a0,msg1
    li a7,4
    ecall
    mv a0,s2
    li a7,1
    ecall
    la a0,msg3
    li a7,4
    ecall
    jal print_matrice // Stampare la matrice modificata
    lw ra,0(sp)
    addi sp,sp,4
    li a7,10
    ecall
    
previsione: // Elabora la matrice colonna per colonna, da destra a sinistra (escludendo la prima)
    li t5,0 # Numero di celle con tempesta
    addi t0,a2,-1 # Indice di colonna (esclude la prima)
    
pr_start_ext_loop:
    beq t0,zero,pr_end_ext_loop // non processiamo colonna 0
    li t1,0 # Indice di riga
    
pr_start_int_loop:
    beq t1,a1,pr_end_int_loop
    mul t2,t1,a2
    add t2,t2,t0
    add t2,t2,a0 # Indirizzo della cella da scrivere
    addi t3,t2,-1 # Indirizzo della cella a sinistra di quella corrente
    lbu t3,0(t3)
    andi t4,t3,1 # Controllo se è divisibile per 2
    srli t3,t3,1 # Divido per due
    beq t4,zero, pr_do_not_round
    addi t3,t3,1 // Aggiungo all'elemento +1 se ha bisogno di arrotondamento
    
pr_do_not_round:
    beq t3,zero,pr_no_storm // Se l'elemento è uguale a 0 non c'è tempesta, salta
    addi t5,t5,1 // Se l'elemento è != 0 aumenta il contatore
    
pr_no_storm:
    sb t3,0(t2) // Salva il valore calcolato nella cella corrente !!!!!!!!!!!!!!!
    addi t1,t1,1 # Aumenta indice riga
    j pr_start_int_loop // Elabora nuova riga
    
pr_end_int_loop:
    addi t0,t0,-1 # Decrementa indice colonna
    j pr_start_ext_loop // Elabora nuova colonna

pr_end_ext_loop:
    li t0,0 // Finito di processare la penultia colonna passa all'ultima
    
pr_start_last_loop:
    beq t0,a1,pr_end_last_loop // Processa tutte le righe fino alla fine
    mul t1,t0,a2 // n.col * i.riga
    add t1,t1,a0 // indr.matrice + (n.col * i.riga)
    sb zero,0(t1) // Importa a 0 la cella della prima colonna (e di tutte le altre)
    addi t0,t0,1
    j pr_start_last_loop
    
pr_end_last_loop:
    mv a0,t5 // Sposta il contatore in a0
    jr ra  // Jumpa all'indirizzo di ritorno

print_matrice:
    addi sp,sp,-4
    sw ra,0(sp)
    la t0,tempesta
    li t1,num_righe
    
start_rig:
    beqz t1,fine_rig // Se arrivi a 0 jumpa 
    li t2,num_colonne
    
start_col:
    beqz t2,fine_col // Processiamo per colonne
    lb a0,0(t0) // Carica la cella
    li a7,1 // Stampa
    ecall
    la a0,msg2 // Carica il trattino e stampalo
    li a7,4
    ecall
    addi t0,t0,1 // Incrementa indice
    addi t2,t2,-1 // Decrementa il num_colonne
    j start_col
    
fine_col:
    la a0,msg3
    li a7,4
    ecall
    addi t1,t1,-1
    j start_rig
    
fine_rig:
    lw ra,0(sp)
    addi sp,sp,4
    jr ra

##########################################
# SPIEGAZIONE DEL PROGRAMMA:
##########################################
#
# Questo programma elabora una MATRICE di PRECIPITAZIONI (tempesta di pioggia)
# Matrice: 5 righe × 7 colonne
# Ogni cella contiene un valore che rappresenta l'intensità della pioggia (mm)
#
# FLUSSO PRINCIPALE:
# 1. Stampa la matrice originale
# 2. Chiama la funzione "previsione" che elabora i dati
# 3. Stampa il numero di celle con tempesta prevista
# 4. Stampa la matrice modificata
#
# FUNZIONE "previsione":
# - Elabora la matrice da destra a sinistra (dall'ultima colonna alla seconda)
# - Per ogni colonna, processa tutte le righe
# - Per ogni cella: prende il valore della cella a SINISTRA, lo divide per 2,
#   e lo arrotonda se necessario
# - Se il risultato è diverso da zero → c'è TEMPESTA in quella cella
# - Conta tutte le celle con tempesta (!=0) e le memorizza
# - La prima colonna viene azzerata completamente (posta a zero)
#
# ALGORITMO DI CALCOLO PER OGNI CELLA:
# 1. Leggi il valore dalla cella a sinistra
# 2. Verifica se è dispari (bit meno significativo = 1)
# 3. Se dispari: dividi per 2 e arrotonda per eccesso (+1)
# 4. Se pari: dividi per 2 senza arrotondamento
# 5. Scrivi il valore calcolato nella cella corrente
# 6. Se il valore != 0, incrementa il contatore delle celle con tempesta
#
# FUNZIONE "print_matrice":
# - Stampa la matrice riga per riga
# - Tra ogni elemento stampa un trattino "-"
# - A fine riga stampa un a capo "\n"
#
# RISULTATO FINALE:
# I valori si "propagano" da destra verso sinistra, dimezzandosi ad ogni passo
# Questo simula la diffusione di una tempesta nel tempo



















