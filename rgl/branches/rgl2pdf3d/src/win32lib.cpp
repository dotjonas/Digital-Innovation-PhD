#include "config.h"
#ifdef RGL_W32
// ---------------------------------------------------------------------------
// W32 Library Implementation
// $Id: win32lib.cpp 1116 2014-07-18 19:22:01Z murdoch $
// ---------------------------------------------------------------------------
#include "lib.h"
#include "win32gui.h"
#include "NULLgui.h"
#include <windows.h>
#include "assert.h"
#include "R.h"

using namespace rgl;

// ---------------------------------------------------------------------------
// GUI Factory
// ---------------------------------------------------------------------------
Win32GUIFactory* gpWin32GUIFactory = NULL;
NULLGUIFactory* gpNULLGUIFactory = NULL;
// ---------------------------------------------------------------------------
GUIFactory* rgl::getGUIFactory(bool useNULLDevice)
{
  if (useNULLDevice)
    return (GUIFactory*) gpNULLGUIFactory;
  else if (gpWin32GUIFactory)
    return (GUIFactory*) gpWin32GUIFactory;
  else
    error("wgl device not initialized");
}
// ---------------------------------------------------------------------------
const char * rgl::GUIFactoryName(bool useNULLDevice)
{
  return useNULLDevice ? "null" : "wgl";
}
// ---------------------------------------------------------------------------
// printMessage
// ---------------------------------------------------------------------------
void rgl::printMessage( const char* string ) {
  warning("RGL: %s\n", string);
}
// ---------------------------------------------------------------------------
// getTime
// ---------------------------------------------------------------------------
double rgl::getTime() {
  return ( (double) ::GetTickCount() ) * ( 1.0 / 1000.0 );
}
// ---------------------------------------------------------------------------
// init
// ---------------------------------------------------------------------------
bool rgl::init(bool useNULLDevice)
{
  if (!useNULLDevice)
    gpWin32GUIFactory = new Win32GUIFactory();  
  gpNULLGUIFactory = new NULLGUIFactory();
  return true;
}
// ---------------------------------------------------------------------------
// quit
// ---------------------------------------------------------------------------
void rgl::quit()
{
  assert(gpWin32GUIFactory != NULL && gpNULLGUIFactory != NULL);
  delete gpWin32GUIFactory;
  delete gpNULLGUIFactory;
  gpWin32GUIFactory = NULL;
  gpNULLGUIFactory = NULL;
}
// ---------------------------------------------------------------------------
#endif // RGL_W32

