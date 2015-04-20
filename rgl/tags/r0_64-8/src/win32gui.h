#ifndef WIN32_GUI_H
#define WIN32_GUI_H

// C++ header file
// This file is part of RGL
//
// $Id: win32gui.h 98 2004-01-04 09:52:32Z  $


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

