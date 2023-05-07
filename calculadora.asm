#TRABALHO CALCULADORA ASSEMBLY
# Allan Baldissin nUSP 8657904

#
	.data		# inicia segmento de dados
	.align 0	# alinhamento a byte (2^0)
str_menuinicial: .asciiz "\nMenu Inicial\n\nDigite C ou M\n C: Realizar operações\n M: Conferir resultados anteriores\n\n Operação escolhida:"
str_menuC: .asciiz "\n1 - Adição\n2 - Subtração\n3 - Divisão\n4 - Multiplicação\n5 - Potenciação\n6 - Raiz Quadrada\n7 - Tabuada\n8 - Fatorial\n9 - Sequência de Fibonacci\nDigite uma opção:"
str_menuM: .asciiz "\n\n1 - M1\n2 - M2\n3 - M3\nDigite uma opção: "
str_digNum: .asciiz "\nDigite um número: "
str_res: .asciiz "\nO resultado é: "
str_criando: .asciiz "\nem construção"
str_zero: .asciiz "\nO número digitado não pode ser 0."
str_zero_sqf: .asciiz "\nO resultado é: 0"
str_pula: .asciiz "\n"
str_n_perfeita: .asciiz "Não é uma raiz quadrada perfeita"
str_n_resul: .asciiz "Não existe resultado."
str_ult_resul: .asciiz "O resultado da última operação é: "
str_pult_resul: .asciiz "O resultado da penúltima operação é: "
str_apult_resul: .asciiz "O resultado da antepenúltima operação é: "
pos:	.space 4 #reservando 4 bytes na mem (4 caracteres ascii)
str_m1: .asciiz "M1"
str_m2: .asciiz "M2"
str_m3: .asciiz "M3"


	.text				# inicia segmento de texto (instrucoes)
	.globl main			# rotulo main e global

main:					# inicio do programa
	#IMPRIME MENU INCIAL
	li $v0, 4
	la $a0, str_menuinicial
	syscall
	
	j le_char_teclado_menuinicial
	
le_char_teclado_menuinicial:	#LER LETRA DO TECLADO
	
	li $v0, 12 #le string do teclado
	syscall
	move $a0, $v0
	li $v0, 11
	syscall
	j seleciona_op_menuinicial
	
seleciona_op_menuinicial:	#COMPARA VALOR MENU INICIAL
	
	beq $a0, 'C', go_menuC
	beq $a0, 'M', go_menuM
	j fim
	
go_menuC:	#MENU DE OPERAÇÕES

	li $v0, 4
	la $a0, str_menuC
	syscall 
	j le_char_teclado_menuC
	
go_menuM:	#MENU DE RESULTADO

	li $v0, 4
	la $a0, str_menuM
	syscall 
	j le_char_teclado_menuM
	
fim:	#SAI DO PROGRAMA
	li $v0, 10
	syscall
	
le_char_teclado_menuC:	#LE OPÇÃO MENU C
	
	li $v0, 12 #le string do teclado
	syscall
	move $a0, $v0
	li $v0, 11
	syscall
	j seleciona_op_menuC
	
seleciona_op_menuC:	#COMPARA VALOR MENU C
	
	beq $a0, '1', go_add
	beq $a0, '2', go_sub
	beq $a0, '3', go_div
	beq $a0, '4', go_mult
	beq $a0, '5', go_pot
	beq $a0, '6', go_raiz
	beq $a0, '7', go_tab
	beq $a0, '8', go_fat
	beq $a0, '9', go_sqf
	
	j main
	
le_char_teclado_menuM:	#LE OPÇÃO MENU M
	
	li $v0, 8 #le string do teclado
	la $a0, pos
	la $a1, 3
	syscall
	la $t3, str_m3
	la $t2, str_m2
	la $t1, str_m1
	
	j seleciona_op_menuM
	

seleciona_op_menuM:	#SELECIONA OPÇÃO MENU M
	move $t4, $a0
	addi $t1, $t1, 1 #proxima posicao m1
	addi $t2, $t2, 1 #proxima posicao m2
	addi $t3, $t3, 1 #proxima posicao m3
	addi $t4, $t4, 1 #proxima posicao leitura teclado
	lb $t6($t4) #salva char no t6
	lb $t5($t1) #salva no t5 o char da posição do t1  
	beq $t5, $t6 , go_m1 #compara leitura teclado com m1
	lb $t5($t2) #salva no t5 o char da posição do t2
	beq $t5, $t6 , go_m2 #compara leitura teclado com m2
	lb $t5($t3)#salva no t5 o char da posição do t3
	beq $t5, $t6 , go_m3#compara leitura teclado com m3
	
	
	j main
	
sem_resultado:
	li $v0, 4
	la $a0, str_n_resul
	syscall
	j go_menuM
go_m1:
	li $v0, 4
	la $a0, str_pula #PULA LINHA
	syscall
	lw $t6, 0($sp) #LE MEMORIA
	beq $t6, 0, sem_resultado
	li $v0, 4
	la $a0, str_ult_resul
	syscall
	li $v0, 1
	move $a0, $t6 #IMPRIME RESULTADO
	syscall
	j go_menuM
	
go_m2:
	li $v0, 4
	la $a0, str_pula
	syscall
	lw $t6, 4($sp)
	beq $t6, 0, sem_resultado
	li $v0, 4
	la $a0, str_pult_resul
	syscall
	li $v0, 1
	move $a0, $t6
	syscall
	j go_menuM

go_m3:
	li $v0, 4
	la $a0, str_pula
	syscall
	lw $t6, 8($sp)
	beq $t6, 0, sem_resultado
	li $v0, 4
	la $a0, str_apult_resul
	syscall
	li $v0, 1
	move $a0, $t6
	syscall
	j go_menuM

go_add:
	#le primeiro valor
	li $v0, 4
	la $a0, str_digNum #Printa msg
	syscall
	li $v0, 5 #le do teclado
	syscall
	move $t1, $v0 #passa o valor para t1
	
	#le segundo valor
	li $v0, 4
	la $a0, str_digNum #Printa msg
	syscall
	li $v0, 5 #le do teclado
	syscall
	move $t2, $v0 #passa o valor para t2
	
	#Soma
	add $t3, $t1, $t2
	
	#imprime resultado
	li $v0, 4
	la $a0, str_res
	syscall
	li $v0, 1
	move $a0, $t3
	syscall
	#SALVA NA MEMORIA
	addi $sp, $sp, -4
	sw $t3, 0($sp)
	j main
	
go_sub:
	#le primeiro valor
	li $v0, 4
	la $a0, str_digNum #Printa msg
	syscall
	li $v0, 5 #le do teclado
	syscall
	move $t1, $v0 #passa o valor para t1
	
	#le segundo valor
	li $v0, 4
	la $a0, str_digNum #Printa msg
	syscall
	li $v0, 5 #le do teclado
	syscall
	move $t2, $v0 #passa o valor para t2
	
	#subtrair
	sub $t3, $t1, $t2
	
	#imprime resultado
	li $v0, 4
	la $a0, str_res
	syscall
	li $v0, 1
	move $a0, $t3
	syscall
	#SALVA NA MEMORIA
	addi $sp, $sp, -4
	sw $t3, 0($sp)
	
	j main

go_div:
	#le primeiro valor
	li $v0, 4
	la $a0, str_digNum #Printa msg
	syscall
	li $v0, 5 #le do teclado
	syscall
	move $t1, $v0 #passa o valor para t1
	
	#le segundo valor
	li $v0, 4
	la $a0, str_digNum #Printa msg
	syscall
	li $v0, 5 #le do teclado
	syscall
	beq $v0, 0, se_0 #confere se o denominador é 0
	move $t2, $v0 #passa o valor para t2
	
	#dividir
	div $t3, $t1, $t2
	
	#imprime resultado
	li $v0, 4
	la $a0, str_res
	syscall
	li $v0, 1
	move $a0, $t3
	syscall

	#SALVA NA MEMORIA
	addi $sp, $sp, -4
	sw $t3, 0($sp)
		
	j main
	
se_0:
	li $v0, 4
	la $a0, str_zero
	syscall
	j go_div

go_mult:
	#le primeiro valor
	li $v0, 4
	la $a0, str_digNum #Printa msg
	syscall
	li $v0, 5 #le do teclado
	syscall
	move $t1, $v0 #passa o valor para t1
	
	#le segundo valor
	li $v0, 4
	la $a0, str_digNum #Printa msg
	syscall
	li $v0, 5 #le do teclado
	syscall
	move $t2, $v0 #passa o valor para t2
	
	#multiplicar
	mul $t3, $t1, $t2
	
	#imprime resultado
	li $v0, 4
	la $a0, str_res
	syscall
	li $v0, 1
	move $a0, $t3
	syscall
	
	
	#SALVA NA MEMORIA
	addi $sp, $sp, -4
	sw $t3, 0($sp)
	
	j main

go_pot:
	#le primeiro valor
	li $v0, 4
	la $a0, str_digNum #printa msg
	syscall
	li $v0, 5 #le do teclado
	syscall
	move $t0, $v0 #passa o valor para t0
	
	#le segundo valor
	li $v0, 4
	la $a0, str_digNum #printa msg
	syscall
	li $v0, 5 #le do teclado
	syscall
	move $t1, $v0 #passa o valor para t1
	beq $t1, 0, valor0 #se o expoente for 0, a reposta é 1
	beq $t1, 1, valor1 #se o expoente for 1, a resposta é o númerador
	
	jal pot #chama pot
	li $v0, 4
	la $a0, str_res #imprime resposta
	syscall
	li $v0, 1
	la $a0, ($t2)
	syscall
	j main
	
valor0:	li $v0, 4
	la $a0, str_res #imprime resposta
	syscall
	li $v0, 1
	la $a0, 1
	syscall
	#SALVA NA MEMORIA
	addi $sp, $sp, -4
	li $t2, 1
	sw $t2, 0($sp)
	
	j main
valor1:	li $v0, 4
	la $a0, str_res #imprime resposta
	syscall
	li $v0, 1
	la $a0, ($t0)
	syscall
	#SALVA NA MEMORIA
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	j main
	
	
	#SALVA NA MEMORIA
#	addi $sp, $sp, -4
#	sw $t2, 0($sp)


pot:
	sub $sp, $sp, 8
	sw $ra, 4($sp)
	sub $t1, $t1, 1
	beq $t1, 0, return
	jal pot
	lw $t3, 0($sp)
	mul $t2, $t0, $t3
	addi $sp, $sp, 8
	sw $t2, 0($sp)
	lw $t3, 4($sp)
	jr $t3

return:
	sw $t0, 0($sp)
	lw $t3, 4($sp)
	jr $t3

go_raiz:
	#le primeiro valor
	li $v0, 4
	la $a0, str_digNum #printa msg
	syscall
	li $v0, 5 #le do teclado
	syscall
	move $t1, $v0 #passa o valor para t1
	li $t2, 0 #seta t2 como 0 para o calculo da raiz
	jal isqrt
	
isqrt:
	mul $t0, $t2, 2
	add $t0, $t0, 1
	sub $t1, $t1, $t0
	add $t2, $t2, 1
	beq $t1, $zero, raiz_perfeita #raiz perfeita
	slt $t0, $t1, $zero
	beq $t0, 1, raiz_n_perfeita #raiz não perfeita
	j isqrt
	
raiz_n_perfeita:
	la $a0, str_n_perfeita
	la $v0, 4
	syscall
	j main
	
raiz_perfeita:
	li $v0, 4
	la $a0, str_res
	syscall
	la $v0, 1
	la $a0, ($t2)
	syscall
	
	#SALVA NA MEMORIA
	addi $sp, $sp, -4
	sw $t2, 0($sp)
	j main

go_tab:
	#le valor
	li $v0, 4
	la $a0, str_digNum #Printa msg
	syscall
	li $v0, 5 #le do teclado
	syscall
	move $t1, $v0
	#num * 0
	mul $t2, $t1, 0
	
	li $v0, 1
	move $a0, $t2
	syscall
	li $v0, 4
	la $a0, str_pula
	syscall
	#num * 1
	mul $t2, $t1, 1
	
	li $v0, 1
	move $a0, $t2
	syscall	
	li $v0, 4
	la $a0, str_pula
	syscall
	#num * 2
	mul $t2, $t1, 2
	
	li $v0, 1
	move $a0, $t2
	syscall
	li $v0, 4
	la $a0, str_pula
	syscall
	#num * 3
	mul $t2, $t1, 3
	
	li $v0, 1
	move $a0, $t2
	syscall
	li $v0, 4
	la $a0, str_pula
	syscall
	#num * 4
	mul $t2, $t1, 4
	
	li $v0, 1
	move $a0, $t2
	syscall
	li $v0, 4
	la $a0, str_pula
	syscall
	#num * 5
	mul $t2, $t1, 5
	
	li $v0, 1
	move $a0, $t2
	syscall
	li $v0, 4
	la $a0, str_pula
	syscall
	#num * 6
	mul $t2, $t1, 6
	
	li $v0, 1
	move $a0, $t2
	syscall
	li $v0, 4
	la $a0, str_pula
	syscall
	#num * 7
	mul $t2, $t1, 7
	
	li $v0, 1
	move $a0, $t2
	syscall
	li $v0, 4
	la $a0, str_pula
	syscall
	#num * 8
	mul $t2, $t1, 8
	
	li $v0, 1
	move $a0, $t2
	syscall
	li $v0, 4
	la $a0, str_pula
	syscall
	#num * 9
	mul $t2, $t1, 9
	
	li $v0, 1
	move $a0, $t2
	syscall
	li $v0, 4
	la $a0, str_pula
	syscall
	#num * 10
	mul $t2, $t1, 10
	
	li $v0, 1
	move $a0, $t2
	syscall
	li $v0, 4
	la $a0, str_pula
	syscall
	
	
	j main	

go_fat:
	#le valor
	li $v0, 4
	la $a0, str_digNum #Printa msg
	syscall
	li $v0, 5 #le do teclado
	syscall
	addi $a0,$v0,0	#valor lido fica em a0
	jal fact #chama função fact
	addi $a0,$v0,0 #resultado
	li $v0,1		
	syscall
	
	#SALVA NA MEMORIA
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	j main

fact:
	sub $sp,$sp,8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	li $t3, 1
	slt $t0,$a0,$t3	
	beq $t0,$zero,L1

	li $v0,1
	add $sp,$sp,8
	jr $ra

L1:   
	sub $a0,$a0,1 #n-1
	jal fact#fact(n - 1)

	#ponto de retorno da recursão
	lw $a0, 0($sp)	# recupera o argumento passado
	lw $ra, 4($sp)	# recupera o endereço de retorno
	add $sp,$sp,8	# liberta o espaço da stack

	mul $v0,$a0,$v0	#  n * fact (n - 1)
	jr $ra

go_sqf:
	#le valor
	li $v0, 4
	la $a0, str_digNum #Printa msg
	syscall
	li $v0, 5 #le do teclado
	syscall
	#confere se é 0
	beq $v0, 0, se_0_sqf
	
	move $a0, $v0
	#chama função de calculo de fibonacci
	jal fib
	#salva o valor de v0 em a1
	move $a1, $v0
	#printa resultado
	li $v0, 4
	la $a0, str_res
	syscall
	
	li $v0, 1
	move $a0, $a1
	syscall
	
	#SALVA NA MEMORIA
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	
	j main
	
se_0_sqf:
	li $v0, 4
	la $a0, str_zero_sqf
	syscall
	j main

fib:
	addi $sp, $sp, -12
	sw $ra, 8($sp)
	sw $s0, 4($sp)
	sw $s1, 0($sp)
	move $s0, $a0
	li $v0, 1
	ble $s0, 0x2, fib_Exit
	addi $a0, $s0, -1 
	jal fib
	move $s1, $v0
	addi $a0, $s0, -2
	jal fib
	add $v0, $s1, $v0

fib_Exit:
	lw $ra, 8($sp)
	lw $s0, 4($sp)
	lw $s1, 0($sp)
	addi $sp, $sp, 12
	jr $ra
