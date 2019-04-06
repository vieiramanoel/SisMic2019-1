;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            .data
vec: 		.word 	8, 1, -5, -7, 9, 6, 4, 3, 2
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------

    call #bubblesort
	jmp $
	nop



bubblesort: mov #0, r7  	; r7 é o 'trocado'
			mov #vec, R5
			mov @r5+, r6	; r6 tem o tamanho
   		    dec r6			; precisamos ir até length - 1
repeat:     mov @r5+, r8	; r8 segura o atual
			cmp @r5, r8		; compara proximo com o atual
			jge troca		; (if signed <) troca
			jmp continue	; else continue
troca:		mov @r5, r9
			mov r9, -2(r5)  ; move r9(prox) para a posição do anterior
			mov r8, 0(r5)	; move r8(ant) para a posição do próximo
			mov #1, r7		; trocado = 1
continue:	dec r6			; decrementa 1 do contador
			cmp r6, r3
			jnz repeat		; se não for o fim do vetor, repete
			cmp r7, r3		; se for o fim do vetor e tiver havido troca,
			jnz bubblesort	; entao goto loop externo
finish: 	ret


;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            
