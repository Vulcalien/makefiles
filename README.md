# Makefiles

Over the years, developing side projects using the C programming
languages, I've written these two makefiles to make building programs
and libraries easier. These are `library.mk` and `executable.mk`.

Both makefiles are setup to support Unix-like systems and Windows,
allowing for compilation on either system and even Linux-to-Windows
cross-compilation.

Multiple source directories are supported. By default, the `src`
directory is used as top-level directory and any subdirectory can be
listed in the `SRC_SUBDIRS` variable (if multiple top-level directories
are needed, `SRC_DIRS` can be manually set).

## Commands

| Command           | Result                    | Library | Executable |
| ----------------- | ----------------------------- | :-: | :--------: |
| make              | Build the program/library     | x   | x          |
| make clean        | Remove all build files        | x   | x          |
| make run          | Execute the program           |     | x          |
| make build-static | Build only the static library | x   |            |
| make build-shared | Build only the shared library | x   |            |

## License
To avoid discouraging anyone that might find these files useful, I
release them under the CC0 public domain licence.

<a rel="license"
   href="http://creativecommons.org/publicdomain/zero/1.0/">
    <img src="http://i.creativecommons.org/p/zero/1.0/88x31.png"
         style="border-style: none;" alt="CC0"/>
</a>
