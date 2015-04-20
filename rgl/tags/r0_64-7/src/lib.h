#ifndef LIB_H
#define LIB_H

// C++ header file
// This file is part of RGL
//
// $Id: lib.h 95 2003-11-27 21:12:23Z  $

bool lib_init();
void lib_quit();

// lib services:

void   printMessage(const char* string);
double getTime();

#endif /* LIB_H */
