#ifndef LIB_H
#define LIB_H

// C++ header file
// This file is part of RGL
//
// $Id: lib.h 98 2004-01-04 09:52:32Z  $

bool lib_init();
void lib_quit();

// lib services:

void   printMessage(const char* string);
double getTime();

#endif /* LIB_H */
