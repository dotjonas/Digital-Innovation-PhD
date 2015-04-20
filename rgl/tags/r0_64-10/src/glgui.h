#ifndef GL_GUI_H
#define GL_GUI_H

// C++ header
// This file is part of rgl
//
// $Id: glgui.h 135 2004-03-04 00:07:52Z  $

#include "opengl.h"

//
// CLASS
//   GLBitmapFont
//

class GLBitmapFont
{
public:
  GLBitmapFont() {};

  void enable() {
    glListBase(listBase);
  };

  void draw(char* text, int length, int justify);

  GLuint listBase;
  GLuint firstGlyph;
  GLuint nglyph;
  unsigned int* widths;

};


#endif /* GL_GUI_H */

