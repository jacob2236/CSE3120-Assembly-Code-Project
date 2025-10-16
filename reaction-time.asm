; reaction_intro.asm  
; 32-bit MASM (Windows) version  
; Prints the game intro message and exits.  

.386  
.model flat, stdcall  
option casemap:none  

INCLUDE Irvine32.inc  

.data  
msg db "Welcome to our reaction time game!", 13,10, \
        "Once you press the space bar you will be randomly given 0-3 seconds to press the space bar again and we will measure your reaction speed!", 13,10,0  
bytesWritten dd ?  

randomMillis  dd  ?            ; will store the random delay (0–3000)

.code  
main PROC  
    ; Get handle to console output  
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE  
    mov ebx, eax  
    ; Write the message  
    INVOKE WriteConsoleA, ebx, ADDR msg, LENGTHOF msg - 1, ADDR bytesWritten, NULL  

    mov ecx, 3
    ; initialize random number generator
    call Randomize
    ; generate a random number between 0 and 3000 (inclusive)
    mov  eax, 3001             ; upper bound (exclusive)
    call RandomRange           ; EAX = random number between 0 and 3000
    mov  randomMillis, eax     ; store result

    ; display the generated value, this will be removed later
    mov  eax, randomMillis
    call WriteDec
    call Crlf

    ; Exit program  
    INVOKE ExitProcess, 0  
main ENDP  

END main  
