#ifndef WIN32_GUI_H
#define WIN32_GUI_H

// C++ header file
// This file is part of RGL
//
// $Id: win32gui.h 72 2003-11-19 22:51:55Z  $


#include "gui.h"

#include <windows.h>

namespace gui {

  class Win32GUIFactory : public GUIFactory
  {
  
  public:
  
    Win32GUIFactory(HINSTANCE inModuleHandle);
    ~Win32GUIFactory();
  
    WindowImpl* createWindowImpl(Window* window);
      
  };

};


#endif /* WIN32_GUI_H */

