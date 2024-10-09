# Makefiles

Various makefiles I've developed over the years: two makefiles for
building projects written in the C programming language and one for
generating man pages from AsciiDoc files.

## C makefiles
The two makefiles for C projects are `library.mk` and `executable.mk`.
`library.mk` produces static and shared library files, while
`executable.mk` produces an executable file.

These make targets are available:

| Command           | Result                    | Library | Executable |
| ----------------- | ----------------------------- | :-: | :--------: |
| make              | Build the program/library     | x   | x          |
| make clean        | Remove all build files        | x   | x          |
| make run          | Execute the program           |     | x          |
| make build-static | Build only the static library | x   |            |
| make build-shared | Build only the shared library | x   |            |

### Source subdirectories
Subdirectories of the top-level source directory containing code to be
compiled need to be listed in the `SRC_SUBDIRS` variable.

For example, to compile files in `src`, `src/foo` and `src/foo/bar`
write the following:
```make
SRC_DIR := src
...
SRC_SUBDIRS := foo foo/bar
```

### Cross-compilation
By passing the `TARGET=WINDOWS` argument to make, the makefiles will
produce output for Windows, provided that the appropriate cross-compiler
is installed.

## Man pages makefile
The `manuals.mk` makefile converts AsciiDoc files into man pages.
Similarly to the C makefiles, it supports source subdirectories.

## License
I release these makefiles under the [CC0 public domain
license](https://creativecommons.org/publicdomain/zero/1.0/).
