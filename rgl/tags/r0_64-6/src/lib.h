#ifndef LIB_H
#define LIB_H

// C++ header file
// This file is part of RGL
//
// $Id: lib.h 72 2003-11-19 22:51:55Z  $

bool lib_init();
void lib_quit();

// lib services:

void   printMessage(const char* string);
double getTime();

#endif /* LIB_H */
