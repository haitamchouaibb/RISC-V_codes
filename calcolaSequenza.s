.equ N 7

.data
sequenza: .word 5,5,21,21,22,40,42

.text
main:
    addi sp,sp,-4
    sw ra,0(sp)
    la a0,sequenza
    li a1,2
    li a2,N
    jal calcolaSequenza
    li a7,36
    ecall
    lw ra,0(sp)
    addi sp,sp,4
    li a7,10
    ecall
    
calcolaSequenza:
    li t0,1 # Indice del vettore
    li t1,1 # Lunghezza sequenza monotona corrente
    li t5,1 # Lunghezza sequenza monotona più lunga
    lw t2,0(a0) # Sequenza [i -1]
    
cs_start_loop:
    beq t0,a2,cs_end_loop
    slli t3,t0,2 # i *4
    add t3,a0,t3 # Base_address + 4*i
    lw t4,0(t3)
    li t3,2
    beq a1,t3,cs_decrescente # Determina se vogliamo sequenza crescente o decrescente

cs_crescente:
    ble t4,t2,cs_stop_sequenza
    j cs_continue_sequenza
    
cs_decrescente:
    bge t4,t2,cs_stop_sequenza
    j cs_continue_sequenza
    
cs_stop_sequenza:
    li t1,1
    j cs_end_if
    
cs_continue_sequenza:
    addi t1,t1,1
    
cs_end_if:
    ble t1,t5,cs_no_update
    mv t5,t1
    
cs_no_update:
    mv t2,t4 # Ricordo il valore precedente
    addi t0,t0,1 # Aumenta indice vettore
    j cs_start_loop
    
cs_end_loop:
    mv a0,t5 # Ricorda il valore della sequenza monotona più lunga come return value
    jr ra
# =====================================================
# SPIEGAZIONE DEL PROGRAMMA "calcolaSequenza"
# =====================================================
# Questo programma calcola la lunghezza della sequenza monotona più lunga in un array.
# 
# PARAMETRI IN INPUT:
# - a0: indirizzo base dell'array (sequenza)
# - a1: tipo di monotonia (1=crescente, 2=decrescente)
# - a2: numero di elementi nell'array (N)
#
# LOGICA:
# 1. Il programma scorre l'array da sinistra a destra (indice t0)
# 2. Per ogni elemento, verifica se mantiene la monotonia rispetto all'elemento precedente:
#    - Se a1=1 (crescente): ogni elemento deve essere > del precedente
#    - Se a1=2 (decrescente): ogni elemento deve essere < del precedente
# 3. Mantiene un contatore (t1) della lunghezza della sequenza monotona corrente
# 4. Mantiene un contatore (t5) della lunghezza massima trovata finora
# 5. Quando la monotonia si interrompe, azzera il contatore della sequenza corrente
# 6. Aggiorna il massimo (t5) ogni volta che la sequenza corrente supera il massimo precedente
# 7. Al termine del loop, restituisce in a0 la lunghezza della sequenza monotona più lunga
#
# ESEMPIO CON L'ARRAY [5,5,21,21,22,40,42] E MODALITA' CRESCENTE (a1=1):
# - 5→5: non crescente (5 non > 5) → reset a 1
# - 5→21: crescente → lunghezza = 2
# - 21→21: non crescente → reset a 1
# - 21→22: crescente → lunghezza = 2
# - 22→40: crescente → lunghezza = 3
# - 40→42: crescente → lunghezza = 4
# Risultato: la sequenza monotona crescente più lunga ha lunghezza 4 (22,40,42)
# ===================================================== 