#ifndef PLX_FPS_H
#define PLX_FPS_H

// C++ header file
// This file is part of RGL
//
// $Id: fps.h 2 2003-03-25 00:13:20Z dadler $

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

