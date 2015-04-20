#ifndef RGL_W32_GUI_H
#define RGL_W32_GUI_H
// ---------------------------------------------------------------------------
// $Id: win32gui.h 1116 2014-07-18 19:22:01Z murdoch $
// ---------------------------------------------------------------------------
#include "gui.h"
// ---------------------------------------------------------------------------
#include <windows.h>

namespace rgl {

// ---------------------------------------------------------------------------
class Win32GUIFactory : public GUIFactory
{
public:
  Win32GUIFactory();
  virtual ~Win32GUIFactory();
  WindowImpl* createWindowImpl(Window* window);
#ifndef WGL_WGLEXT_PROTOTYPES
  PFNWGLCHOOSEPIXELFORMATARBPROC wglChoosePixelFormatARB;
#endif
};
// ---------------------------------------------------------------------------

} // namespace rgl

#endif // RGL_W32_GUI_H

