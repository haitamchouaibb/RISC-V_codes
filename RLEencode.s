# Procedura Assembly RLE_Encode con stampa formattata
.equ lunghezza, 50 
 
.data 
string_ante: .string "AAAAAbbbaBBBBBB9999" 
string_post: .zero lunghezza
newline: .string "\n"
separator: .string " "
header: .string "Stringa originale: "
encoded_header: .string "\nStringa codificata (count char):\n"

.text 
main: 
    # Stampa intestazione e stringa originale
    li a7, 4
    la a0, header
    ecall
    
    li a7, 4
    la a0, string_ante
    ecall
    
    # Esegui encoding RLE
    la a0, string_ante 
    la a1, string_post 
    jal RLE_Encode 
    
    # Salva la lunghezza risultante
    mv s0, a0          # lunghezza in s0
    
    # Stampa intestazione risultato
    li a7, 4
    la a0, encoded_header
    ecall
    
    # Stampa risultato formattato
    la s1, string_post # indirizzo string_post in s1
    li s2, 0           # indice i = 0
    
loop_stampa:
    bge s2, s0, fine_stampa  # se i >= lunghezza esci
    
    # Carica count
    add t0, s1, s2
    lbu t1, 0(t0)      # count in t1
    
    # Carica carattere
    addi s2, s2, 1
    add t0, s1, s2
    lbu t2, 0(t0)      # carattere in t2
    
    # Stampa count come intero
    li a7, 1
    mv a0, t1
    ecall
    
    # Stampa spazio
    li a7, 4
    la a0, separator
    ecall
    
    # Stampa carattere
    li a7, 11
    mv a0, t2
    ecall
    
    # Stampa newline
    li a7, 4
    la a0, newline
    ecall
    
    # Incrementa indice
    addi s2, s2, 1
    j loop_stampa
    
fine_stampa:
    # Termina programma
    li a7, 10 
    ecall

# Procedura RLE_Encode
# Input: a0 = indirizzo stringa sorgente
#        a1 = indirizzo stringa destinazione
# Output: a0 = lunghezza stringa codificata
RLE_Encode:
    li t0, 0    # Indice stringa ante
    li t1, 0    # Indice stringa post
    
loop_esterno:
    add t2, a0, t0      # Indirizzo ante[i]
    lb t3, 0(t2)        # Carica carattere corrente
    beqz t3, fine       # Se è '\0' termina
    
    li t4, 1            # Count = 1
    addi t0, t0, 1      # i++
    
loop_interno:
    add t5, a0, t0      # Indirizzo ante[i]
    lb t6, 0(t5)        # Carica prossimo carattere
    bne t6, t3, fine_interno    # Se diverso esci dal loop interno
    beqz t6, fine_interno       # Se '\0' esci dal loop interno
    
    addi t4, t4, 1      # count++
    addi t0, t0, 1      # i++
    
    li t5, 255
    blt t4, t5, loop_interno    # Se count < 255 continua
    
fine_interno:
    # Salva count in string_post
    add t5, a1, t1
    sb t4, 0(t5)
    addi t1, t1, 1      # j++
    
    # Salva carattere in string_post
    add t5, a1, t1
    sb t3, 0(t5)
    addi t1, t1, 1      # j++
    
    j loop_esterno
    
fine:
    mv a0, t1           # Restituisci lunghezza
    jr ra