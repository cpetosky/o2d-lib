#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_INIT([o2d], [0.0.3], [cory@tanatopia.net])
AM_INIT_AUTOMAKE([-Wall -Werror foreign])
AC_PREREQ(2.61)
AC_CONFIG_SRCDIR([src/Editor.cpp])
AC_CONFIG_HEADER([config.h])

# Checks for programs.
AC_PROG_CXX
AC_PROG_RANLIB

# Checks for libraries.
AC_CHECK_LIB([SDL], [main])
AC_CHECK_LIB([SDL_image], [main])
AC_CHECK_LIB([SDL_ttf], [main])
AC_CHECK_LIB([xml++-2.6], [main])
AX_BOOST_BASE([1.33.1])
AX_BOOST_FILESYSTEM

# Checks for header files.

# Checks for typedefs, structures, and compiler characteristics.
AC_HEADER_STDBOOL
AC_C_CONST

AC_CONFIG_FILES([
  Makefile
  src/Makefile
  src/common/Makefile
])
AC_OUTPUT
