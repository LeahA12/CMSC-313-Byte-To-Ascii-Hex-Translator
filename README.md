# CMSC 313 Homework 11 - Byte to ASCII Hex Translator

## AUTHORING:
* Leah Arfa (UE23179)
* Affiliation: UMBC, CMSC 313 (Computer Organization and Assembly Language Programming), Spring 2025
* Date: May 12, 2025

## PURPOSE OF SOFTWARE:
This software takes a predefined sequence of bytes as input and translates each byte into its corresponding two-character ASCII hexadecimal representation. The resulting hexadecimal string is then printed to the standard output, with spaces separating the representations of each original byte, followed by a newline character.

## FILES:
* `hw11translate2Ascii.asm`: This is the assembly language source code file containing the program logic for reading the input bytes, converting them to their ASCII hexadecimal representation, storing the result in a buffer, and then printing the buffer to the screen.

## BUILD INSTRUCTIONS:
To assemble and link the program on a Linux system, follow these steps:

1.  **Assemble:** Use the Netwide Assembler (NASM) to assemble the assembly code into an object file:
    ```
    nasm -f elf32 -g -F dwarf -o hw11translate2Ascii.o hw11translate2Ascii.asm
    ```
    (This command generates a 32-bit ELF object file with debugging information.)

2.  **Link:** Use the GNU linker (`ld`) to link the object file into an executable:
    ```
    ld -m elf_i386 -o hw11translate2Ascii hw11translate2Ascii.o
    ```
    (This command creates a 32-bit executable file named `hw11translate2Ascii`.)

3.  **Make Executable (if necessary):** Ensure the executable has the necessary permissions to run:
    ```bash
    chmod +x hw11translate2Ascii
    ```

## TESTING METHODOLOGY:
1.  **Compilation:** Compile the assembly code using the provided build instructions. Any errors during compilation should be addressed.
2.  **Execution:** Run the generated executable from the terminal using the command:
    ```bash
    ./hw11translate2Ascii
    ```
3.  **Output Verification:** The program should print the hexadecimal ASCII representation of the bytes defined in the `inputBuf` section of the assembly code, with spaces separating each byte's representation, followed by a newline. The expected output for the given `inputBuf` (`0x83,0x6A,0x88,0xDE,0x9A,0xC3,0x54,0x9A`) is:
    ```
    83 6A 88 DE 9A C3 54 9A
    ```
    Visually inspect the output to ensure it matches this expected format.

## ADDITIONAL INFORMATION:
* The program utilizes the `sys_write` system call (number 4) to print the output to the standard output (file descriptor 1) and the `sys_exit` system call (number 1) to terminate the program.
* The program operates in 32-bit x86 mode, as specified by the `-f elf32` and `-m elf_i386` flags during assembly and linking.
* The `inputBuf` in the `.data` section defines the sequence of bytes that the program will process. To test with different byte sequences, modify the contents of `inputBuf`.
* The program reserves space in the `.bss` section for the `outputBuf`, which stores the ASCII hexadecimal representation before printing. The size of this buffer is overestimated to ensure sufficient space.
* The program includes internal documentation within the assembly code to explain the purpose of different code sections and instructions.
