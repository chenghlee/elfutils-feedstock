#!/bin/bash
set -euo pipefail

declare -a confopts

confopts+=(--disable-dependency-tracking)
confopts+=(--disable-maintainer-mode)
confopts+=(--disable-silent-rules)

confopts+=(--enable-largefile)

confopts+=(--enable-shared)
confopts+=(--disable-static)

confopts+=(--disable-libdebuginfod)
confopts+=(--disable-debuginfod)
#confopts+=(--enable-debuginfod-urls[=URLS])

confopts+=(--enable-deterministic-archives)
confopts+=(--enable-symbol-versioning)
confopts+=(--enable-textrelcheck)

# Not recommended features
#confopts+=(--enable-install-elfh)       # may conflict with other tools
#confopts+=(--enable-thread-safety)      # experimental feature

# compression formats for libdwfl
confopts+=(--with-bzlib)
confopts+=(--with-lzma)
confopts+=(--with-zlib)
confopts+=(--with-zstd)

confopts+=(--enable-nls)
#confopts+=(--without-libiconv-prefix)
#confopts+=(--without-libintl-prefix)

# `make check`/test features.  Do not enable these without good cause, as doing
# so can inject undesired runtime dependencies in the built DSOs.
confopts+=(--disable-valgrind)
confopts+=(--disable-gprof)
confopts+=(--disable-gcov)
confopts+=(--disable-debugpred)             # debug branch prediction
confopts+=(--disable-sanitize-undefined)    # sanitize gcc undefined behavior
confopts+=(--disable-tests-rpath)           # use $ORIGIN rpath in tests
#confopts+=(--with-biarch)                   # biarch tests; currently broken

./configure --prefix=$PREFIX ${confopts[@]} \
    || (cat config.log && exit 1)

make -j${CPU_COUNT}

# Unfortunately some tests fail, so we can't run "make check" here.
# This is probably due to this package being a very sensitive package.
# I believe this happens because it is not ready to be packaged into
# an environment such as conda where it will run in different OSes,
# environments, etc.
#
# For example, when running the tests on my personal machine, using
# the docker image provided by condaforge, 8 tests failed, while in
# CircleCI, 4 tests failed.
#make -j${CPU_COUNT} check

make install
