; CMSC 313 HW 11 
; Assignment Goal:     Produce a program that will take a number of bytes of data and print that data to the screen.
; Name:                Leah Arfa
; Student ID:          UE23179
; Assemble with:       nasm -f elf32 -g -F dwarf -o hw11translate2Ascii.o hw11translate2Ascii.asm
; Link and Load with:  ld -m elf_i386 -o hw11translate2Ascii hw11translate2Ascii.o
; Run with:            ./hw11translate2Ascii

section .data
    inputBuf db 0x83,0x6A,0x88,0xDE,0x9A,0xC3,0x54,0x9A  
    ; Defining length or byte num of input, avoiding hardcoding it in.
    inputLength equ $ - inputBuf     ; $ = current location counter

section .bss
    ; Reserving enough bytes for output string.
    outputBuf resb (inputLength * 10)   ; times 10 is overestimation of required size.

section .text
    global _start

_start: 
    ; Pointing inputBuf to ESI because ESI is used as a source ptr of strings.
    mov esi, inputBuf
    ; Pointing outputBuf to EDI because EDI is used as a destination ptr of strings.
    mov edi, outputBuf 
    ; Pointing inputLength to ECX because ECX is used as a counter ptr for loops.
    mov ecx, inputLength

Byte2Ascii_loop:
    ; --- Loading current byte from inputBuf into AL register ---
    mov al, byte [esi]
    inc esi         ; preparing input buffer so it can store the next byte

    ; --- Preparing for division of current byte from inputBuf by 16 ---
    ; Prepare for division by clearing AH (div command inputs remainder into AH register).
    mov ah, 0
    ; Prepare for division by loading 16 into BL (div command requries divisor to be in a 8-bit register).
    mov bl, 16 

    ; --- Dividing current byte from inputBuf by 16 ---
    div bl          ; quotient in AL and remainder in AH

    ; --- Determining if quotient in AL is a hex digit (quotient = 0 to 9) or a hex letter (quotient = 10 to 15) ---
    cmp al, 9
    jle .quotientIsDigit
    add al, 0x37    ; converting quotient digit into Ascii letter
    jmp .saveQuotientAsciiVal
    
.quotientIsDigit:
    add al, 0x30    ; converting quotient digit into Ascii digit
    
.saveQuotientAsciiVal:
    ; --- Loading current quotient from AL into output buffer ---
    mov byte [edi], al
    inc edi         ; preparing output buffer so it can store the next byte

    ; --- Determining if remainder in AH is a hex digit (remainder = 0 to 9) or a hex letter (remainder = 10 to 15) ---
    mov al, ah      ; maintaining AL outputBuf val register consitency (AL register always holds outputBuf val)
    cmp al, 9
    jle .remainderIsDigit
    add al, 0x37    ; converting remainder digit into Ascii letter
    jmp .saveRemainderAsciiVal

.remainderIsDigit:
    add al, 0x30    ; converting remainder digit into Ascii digit
    
.saveRemainderAsciiVal:
    ; --- Loading current remainder from AL into output buffer ---
    mov byte [edi], al
    inc edi         ; preparing output buffer so it can store the next byte

    ; --- Adding a space (0x20) to output buffer if not last byte ---
    cmp esi, inputBuf + inputLength
    je .no_space
    mov byte [edi], 0x20
    inc edi

.no_space:
    loop Byte2Ascii_loop    ; automatically decrements ECX. doesn't execute if ECX = 0.

    ; --- Printing output buffer using SYS_WRITE ---
    mov edx, edi        ; EDX = mem address of last output data.
    sub edx, outputBuf  ; EDX = mem address of last output data MINUS memory address of first output data.
                        ; EDX = outputBuf length
    mov ecx, outputBuf  ; Loading the message to print into ECX.
    mov ebx, 1          ; Preparing EBX for SYS_WRITE: Set EBX to STDOUT's file descriptor (1).
    mov eax, 4          ; Preparing EAX for INT 80h: Set EAX to SYS_WRITE's system call number (4).
    int 80h             ; Interrupting software to execute SYS_WRITE.

    ; --- Printing newline using SYS_WRITE ---
    mov edx, 1          ; EDX = newline length
    mov ecx, 0xA        ; Loading the message to print into ECX.
    mov ebx, 1          ; Preparing EBX for SYS_WRITE: Set EBX to STDOUT's file descriptor (1).
    mov eax, 4          ; Preparing EAX for INT 80h: Set EAX to SYS_WRITE's system call number (4).
    int 80h             ; Interrupting software to execute SYS_WRITE.

    ; --- Exiting program using SYS_EXIT ---
    mov ebx, 0          ; Returning status on exit (0 for No Errors).
    mov eax, 1          ; Preparing EAX for INT 80h: Set EAX to SYS_EXIT's system call number (1).
    int 80h             ; Interrupting software to execute SYS_EXIT.