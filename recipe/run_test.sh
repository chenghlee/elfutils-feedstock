#!/bin/bash
set -e

eu-addr2line --help
eu-ar --help
eu-elfcmp --help
eu-findtextrel --help
eu-nm --help
eu-objdump --help
eu-ranlib --help
eu-size --help
eu-strings --help
eu-strip --help
eu-unstrip --help

${CC} test_libdwarf.c -o ./test_libdwarf \
    $(pkg-config --cflags libdw) \
    $(pkg-config --libs libdw)
./test_libdwarf
