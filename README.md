# x86-64 Assembly Two-Number Addition

A simple Linux program written in x86-64 assembly that reads two signed integers, adds them, and prints the result.

## Example

```sh
$ ./bin/main
Enter the first number: 42
Enter the second number: -24
The sum is 18
```

## Overview

The program is written in NASM syntax for x86-64 Linux. It does not link against libc. 

## Organization

* `src/main.asm` handles program control flow, user input, addition, and output.
* `src/utils.asm` provides string and integer conversion functions.
* `build/` contains assembled object files.
* `bin/` contains the final executable. 

## Building

Ensure that NASM, GNU Make, and the GNU linker are installed. 

On Arch Linux and Arch-based distributions:

```sh
sudo pacman -S nasm make binutils
```

On Debian and Ubuntu:

`sudo apt install nasm make binutils`

Then build the program from the project directory:

```sh
make
```

The executable will be created at:

```sh
bin/main
```
