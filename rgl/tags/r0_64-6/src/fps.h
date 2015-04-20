#ifndef PLX_FPS_H
#define PLX_FPS_H

// C++ header file
// This file is part of RGL
//
// $Id: fps.h 72 2003-11-19 22:51:55Z  $

#include "scene.h"

//
// FPS COUNTER
//

class FPS
{
private:
  double lastTime;
  int   framecnt;
  char  buffer[12];
public:
  inline FPS() { };
  void init(double t);
  void render(double t, RenderContext* ctx);
};

#endif // PLX_FPS_H

