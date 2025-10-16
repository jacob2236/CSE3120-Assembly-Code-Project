; reaction_intro.asm
; 32-bit MASM (Windows) version
; Prints the game intro message and exits.

.386
.model flat, stdcall
option casemap:none

INCLUDE Irvine32.inc

.data
msg db "Welcome to our reaction time game! Once you press the space bar you will be randomly given 0-3 seconds to press the space bar again and we will measure your reaction speed!", 13,10,0
bytesWritten dd ?

.code
main PROC
    ; Get handle to console output
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov ebx, eax

    ; Write the message
    INVOKE WriteConsoleA, ebx, ADDR msg, LENGTHOF msg - 1, ADDR bytesWritten, NULL

    ; Exit program
    INVOKE ExitProcess, 0
main ENDP

END main
