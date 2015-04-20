#ifndef PLX_FPS_H
#define PLX_FPS_H

// C++ header file
// This file is part of RGL
//
// $Id: fps.h 95 2003-11-27 21:12:23Z  $

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

