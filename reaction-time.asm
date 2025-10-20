; reaction_intro.asm  
; 32-bit MASM (Windows) version  
; Prints the game intro message and exits.  

.386  
.model flat, stdcall  
option casemap:none  

INCLUDE Irvine32.inc

.data  
welcome db "Welcome to our reaction time game!",13,10,\
        "Once you press the space bar you will be randomly given 0 to 3 seconds to press the space bar again, and we will measure your reaction speed!",13,10,0  
pressMsg db "Press the space bar when ready...",13,10,0

bytesWritten dd ?
randomMillis dd ?    ;random delay
inputRec INPUT_RECORD <>
eventsRead  dd ?

.code  
main PROC  
    ; Print welcome and prompt
    mov edx, OFFSET welcome
    call WriteString
    mov edx, OFFSET pressMsg
    call WriteString

    ; --- Wait for first space bar ---
WaitFirst:
    call ReadKey
    cmp al, ' '         ; space bar?
    jne WaitFirst
    
    ; initialize random number generator
    call Randomize
    ; generate a random number between 0 and 3000 (inclusive)
    mov  eax, 3001             ; upper bound (exclusive)
    call RandomRange           ; EAX = random number between 0 and 3000
    mov  randomMillis, eax     ; store result

    ; Delay that many milliseconds
    mov eax, randomMillis
    call Delay

    ; display the generated value, this will be removed later
    mov  eax, randomMillis
    call WriteDec
    call Crlf

    ; Exit program  
    INVOKE ExitProcess, 0  
main ENDP  

END main  
