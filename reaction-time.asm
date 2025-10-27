; reaction_intro.asm  
; 32-bit MASM (Windows) version  
; Prints the game intro message and exits.  

.386  
.model flat, stdcall  
option casemap:none  

INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib

.data  
welcome db "Welcome to our reaction time game!",13,10,\
        "Once you press the space bar you will be randomly given 0 to 3 seconds to press the space bar again, and we will measure your reaction speed!",13,10,0  
pressMsg db "Press the space bar when ready...",13,10,0
goMsg    db "GO! Press space again!",13,10,0
resultMsg  BYTE "Reaction time: ",0
secMsg     BYTE " seconds",13,10,0
dot        BYTE ".",0
lastMsg1 BYTE "You geussed in ",0
lastMsg2 BYTE " times the delay time, Congrats!",13,10,0


bytesWritten dd ?
randomMillis dd ?    ;random delay
inputRec INPUT_RECORD <>
eventsRead  dd ?
startTime  DWORD ?
elapsedMS  DWORD ?

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

    ; Print GO
    mov edx, OFFSET goMsg
    call WriteString

    ; start timer
    call GetMseconds
    mov startTime, eax

    ; --- Wait for second space bar ---
WaitSecond:
    call ReadKey
    cmp al, ' '
    jne WaitSecond

   ; stop timer and compute elapsed (ms)
    call GetMseconds
    sub eax, startTime
    mov elapsedMS, eax

    ; convert to seconds + ms remainder
    mov eax, elapsedMS
    mov ebx, 1000
    xor edx, edx
    div ebx
    mov ecx,edx

    ; Print result
    mov edx, OFFSET resultMsg
    call WriteString

    call WriteDec        ; print whole seconds

    mov edx, OFFSET dot
    call WriteString

    mov eax, ecx         ; remainder ms
    call Print3Digits

    mov edx, OFFSET secMsg
    call WriteString

    ;calculate percentage time geussed
    mov eax, elapsedMS
    mov ebx, randomMillis
    xor edx, edx
    div ebx
    mov ecx,edx

    ; Print result
    mov edx, OFFSET lastMsg1
    call WriteString

    call WriteDec        ; print whole seconds

    mov edx, OFFSET dot
    call WriteString

    mov eax, ecx         ; remainder ms
    call Print3Digits

    mov edx, OFFSET lastMsg2
    call WriteString

    ; Exit program  
    INVOKE ExitProcess, 0  
main ENDP  

; Prints number in EAX as exactly 3 digits (000�999)
Print3Digits PROC
    push ebx
    push ecx
    push edx

    mov ebx, 100
    xor edx, edx
    div ebx              ; hundreds
    add al, '0'
    call WriteChar

    mov eax, edx
    mov ebx, 10
    xor edx, edx
    div ebx              ; tens
    add al, '0'
    call WriteChar

    add dl, '0'
    mov al, dl
    call WriteChar

    pop edx
    pop ecx
    pop ebx
    ret
Print3Digits ENDP


END main  
