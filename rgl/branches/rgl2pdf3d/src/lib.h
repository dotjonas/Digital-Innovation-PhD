#ifndef RGL_LIB_H
#define RGL_LIB_H
// ---------------------------------------------------------------------------
// $Id: lib.h 1116 2014-07-18 19:22:01Z murdoch $
// ---------------------------------------------------------------------------

namespace rgl {

// ---------------------------------------------------------------------------
bool init(bool onlyNULLDevice);
const char * GUIFactoryName(bool useNULLDevice);    
void quit();
void printMessage(const char* string);
double getTime();
// ---------------------------------------------------------------------------

} // namespace rgl

#endif // RGL_LIB_H

