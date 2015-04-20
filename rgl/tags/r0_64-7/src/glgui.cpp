// C++ source
// This file is part of RGL.
//
// $Id: glgui.cpp 95 2003-11-27 21:12:23Z  $

#include "types.h"
#include "glgui.h"

//
// CLASS
//   GLBitmapFont
//

void GLBitmapFont::draw(char* text, int length, int justify) {

  if (justify != 1) {
    unsigned int textWidth = 0;

    for(int i=0;i<length;i++)
      textWidth += widths[(text[i]-firstGlyph)];

    if (justify == 0)
      glBitmap(0,0, 0.0f,0.0f, - ((float)textWidth) * 0.5f, 0.0f, NULL);
    else
      glBitmap(0,0, 0.0f,0.0f, - ((float)textWidth), 0.0f, NULL);
  } 

  glCallLists(length, GL_UNSIGNED_BYTE, text);
};

