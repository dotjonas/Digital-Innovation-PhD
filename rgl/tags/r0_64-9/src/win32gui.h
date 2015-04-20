#ifndef WIN32_GUI_H
#define WIN32_GUI_H

// C++ header file
// This file is part of RGL
//
// $Id: win32gui.h 129 2004-03-02 22:30:52Z  $


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

