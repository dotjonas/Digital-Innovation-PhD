// C++ source
// This file is part of RGL.
//
// $Id: rglview.cpp 825 2011-05-19 22:59:19Z dadler $



#include "rglview.h"
#include "opengl.hpp"
#include <cstdio>
#include "lib.hpp"
#include "rglmath.h"
#include "pixmap.h"
#include "fps.h"
#include "select.h"
#include "gl2ps.h"
#ifdef __sun
#include <locale.h>
#else
#include <locale>
#endif
#include "R.h"		// for error()

//
// CAMERA config
//

#define ZOOM_MIN  0.0001f
#define ZOOM_MAX  10000.0f

RGLView::RGLView(Scene* in_scene)
 : View(0,0,256,256,0), dragBase(0.0f,0.0f),dragCurrent(0.0f,0.0f), autoUpdate(false)
{
  scene = in_scene;
  drag  = 0;
  flags = 0;
  selectState = msNONE;

  setDefaultMouseFunc();
  renderContext.rect.x = 0;
  renderContext.rect.y = 0; // size is set elsewhere
  
  for (int i=0; i<3; i++) {
    beginCallback[i] = NULL;
    updateCallback[i] = NULL;
    endCallback[i] = NULL;
    cleanupCallback[i] = NULL;
    for (int j=0; j<3; j++)
      userData[3*i + j] = NULL;
  }
}

RGLView::~RGLView()
{
  for (int i=0; i<RGLVIEW_MAX_BUTTONS; i++) 
    if (cleanupCallback[i]) 
      (*cleanupCallback[i])(userData + 3*i);
}

void RGLView::show()
{
  fps.init( lib::getTime() );
}

void RGLView::hide()
{
  autoUpdate=false;
}


void RGLView::setWindowImpl(WindowImpl* impl) {
  View::setWindowImpl(impl);
//
// Currently the FreeType font handling in AGL on the Mac is too poor to be worth 
// using, so default to not using it.
//
#if defined HAVE_FREETYPE
  renderContext.font = impl->getFont("sans", 1, 1, true);
#else
  renderContext.font = impl->getDefaultFont(); 
#endif
}

Scene* RGLView::getScene() {
  return scene;
}

void RGLView::resize(int in_width, int in_height) {

  View::resize(in_width, in_height);

  renderContext.rect.width  = in_width;
  renderContext.rect.height = in_height;
  if (drag) captureLost();
}

void RGLView::paint(void) {

  if (!windowImpl) return;
  
  double last = renderContext.time;
  double t    = lib::getTime();

  double dt   = (last != 0.0f) ? t - last : 0.0f;
  
  renderContext.time = t;
  renderContext.deltaTime = dt;

  SAVEGLERROR;  
  
  if (windowImpl->beginGL()) {


    scene->render(&renderContext);
    


    glGetDoublev(GL_MODELVIEW_MATRIX,modelMatrix);
    glGetDoublev(GL_PROJECTION_MATRIX,projMatrix);
    glGetIntegerv(GL_VIEWPORT,viewport);

    if (selectState == msCHANGING)
      select.render(mousePosition);
    if (flags & FSHOWFPS && selectState == msNONE)
      fps.render(renderContext.time, &renderContext );

    glFinish();
    windowImpl->endGL();
    
    SAVEGLERROR;
  }

//  if (flags & FAUTOUPDATE)
//    windowImpl->update();
}

//////////////////////////////////////////////////////////////////////////////
//
// user input
//


void RGLView::keyPress(int key)
{
  switch(key) {
    case GUI_KeyF1:
      flags ^= FSHOWFPS;
      windowImpl->update();
      break;
  }
}

void RGLView::buttonPress(int button, int mouseX, int mouseY)
{
  Viewpoint* viewpoint = scene->getViewpoint();
  if ( viewpoint->isInteractive() ) {
    if (!drag) {
      drag = button;
      windowImpl->captureMouse(this);
      (this->*ButtonBeginFunc[button-1])(mouseX,mouseY);
    }
  }
}


void RGLView::buttonRelease(int button, int mouseX, int mouseY)
{
  if (drag == button) {
    windowImpl->releaseMouse();
    drag = 0;
    (this->*ButtonEndFunc[button-1])();
  }
}

void RGLView::mouseMove(int mouseX, int mouseY)
{
  if (drag) {
    mouseX = clamp(mouseX, 0, width-1);
    mouseY = clamp(mouseY, 0, height-1);
    (this->*ButtonUpdateFunc[drag-1])(mouseX,mouseY);
  }
}

#define ZOOM_STEP  1.05f 
#define ZOOM_PIXELLOGSTEP 0.02f
  
void RGLView::wheelRotate(int dir)
{
  Viewpoint* viewpoint = scene->getViewpoint();
  float zoom = viewpoint->getZoom();
  switch(dir) {
    case GUI_WheelForward:
      zoom *= ZOOM_STEP;
      break;
    case GUI_WheelBackward:
      zoom /= ZOOM_STEP;
      break;
  }
  zoom = clamp( zoom , ZOOM_MIN, ZOOM_MAX);
  viewpoint->setZoom(zoom);
  View::update();
}

void RGLView::captureLost()
{
  if (drag) {
    (this->*ButtonEndFunc[drag-1])();
    drag = 0;
  }
}

//////////////////////////////////////////////////////////////////////////////
//
// INTERACTIVE FEATURE
//   adjustDirection
//

void RGLView::trackballBegin(int mouseX, int mouseY)
{
	rotBase = screenToVector(width,height,mouseX,height-mouseY);
}

void RGLView::trackballUpdate(int mouseX, int mouseY)
{
	Viewpoint* viewpoint = scene->getViewpoint();

  	rotCurrent = screenToVector(width,height,mouseX,height-mouseY);

	if (windowImpl->beginGL()) {
	    viewpoint->updateMouseMatrix(rotBase,rotCurrent);
	    windowImpl->endGL();

	    View::update();
	}
}

void RGLView::trackballEnd()
{
	Viewpoint* viewpoint = scene->getViewpoint();
    viewpoint->mergeMouseMatrix();
}

void RGLView::oneAxisBegin(int mouseX, int mouseY)
{
	rotBase = screenToVector(width,height,mouseX,height/2);
}

void RGLView::oneAxisUpdate(int mouseX, int mouseY)
{
	Viewpoint* viewpoint = scene->getViewpoint();

  	rotCurrent = screenToVector(width,height,mouseX,height/2);

	if (windowImpl->beginGL()) {
	    viewpoint->mouseOneAxis(rotBase,rotCurrent,axis[drag-1]);
	    windowImpl->endGL();

	    View::update();
	}
}

void RGLView::polarBegin(int mouseX, int mouseY)
{
  Viewpoint* viewpoint = scene->getViewpoint();
  
  camBase = viewpoint->getPosition();
  dragBase = screenToPolar(width,height,mouseX,height-mouseY);
}

void RGLView::polarUpdate(int mouseX, int mouseY)
{
  Viewpoint* viewpoint = scene->getViewpoint();
  
  dragCurrent = screenToPolar(width,height,mouseX,height-mouseY);
  PolarCoord newpos = camBase - ( dragCurrent - dragBase );
  newpos.phi = clamp( newpos.phi, -90.0f, 90.0f );
  viewpoint->setPosition( newpos );
  View::update();
}

void RGLView::polarEnd()
{
 // Viewpoint* viewpoint = scene->getViewpoint();
 // viewpoint->mergeMouseMatrix();
}

//////////////////////////////////////////////////////////////////////////////
//
// INTERACTIVE FEATURE
//   adjustFOV
//


void RGLView::adjustFOVBegin(int mouseX, int mouseY)
{
  fovBaseY = mouseY;
}


void RGLView::adjustFOVUpdate(int mouseX, int mouseY)
{
  Viewpoint* viewpoint = scene->getViewpoint();
  
  int dy = mouseY - fovBaseY;
  float py = ((float)dy/(float)height) * 180.0f;
  viewpoint->setFOV( viewpoint->getFOV() + py );
  View::update();
  fovBaseY = mouseY;
}


void RGLView::adjustFOVEnd()
{
}

//////////////////////////////////////////////////////////////////////////////
//
// INTERACTIVE FEATURE
//   user callback
//


void RGLView::userBegin(int mouseX, int mouseY)
{
  int ind = drag - 1;
  activeButton = drag;
  if (beginCallback[ind]) {
    busy = true;
    (*beginCallback[ind])(userData[3*ind+0], mouseX, mouseY);
    busy = false;
  }
}


void RGLView::userUpdate(int mouseX, int mouseY)
{
  int ind = activeButton - 1;
  if (!busy && updateCallback[ind]) {
    busy = true;
    (*updateCallback[ind])(userData[3*ind+1], mouseX, mouseY);
    busy = false;
  }
}

void RGLView::userEnd()
{
  int ind = activeButton - 1;
  if (endCallback[ind])
    (*endCallback[ind])(userData[3*ind+2]);
}


//////////////////////////////////////////////////////////////////////////////
//
// INTERACTIVE FEATURE
//   adjustZoom
//


void RGLView::adjustZoomBegin(int mouseX, int mouseY)
{
  zoomBaseY = mouseY;
}


void RGLView::adjustZoomUpdate(int mouseX, int mouseY)
{
  Viewpoint* viewpoint = scene->getViewpoint();

  int dy = mouseY - zoomBaseY;

  float zoom = clamp ( viewpoint->getZoom() * exp(-dy*ZOOM_PIXELLOGSTEP), ZOOM_MIN, ZOOM_MAX);
  viewpoint->setZoom(zoom);

  View::update();

  zoomBaseY = mouseY;
}


void RGLView::adjustZoomEnd()
{
}

//
// snapshot
//

bool RGLView::snapshot(PixmapFileFormatID formatID, const char* filename)
{
  bool success = false;

  if ( (formatID < PIXMAP_FILEFORMAT_LAST) && (pixmapFormat[formatID])) { 
    if ( windowImpl->beginGL() ) {

      // alloc pixmap memory

      Pixmap snapshot;
   
      snapshot.init(RGB24, width, height, 8);

      // read front buffer

      glPushAttrib(GL_PIXEL_MODE_BIT);

      glReadBuffer(GL_FRONT);
      glPixelStorei(GL_PACK_ALIGNMENT, 1);
      glReadPixels(0,0,width,height,GL_RGB, GL_UNSIGNED_BYTE, (GLvoid*) snapshot.data);

      glPopAttrib();

      success = snapshot.save( pixmapFormat[formatID], filename );

      windowImpl->endGL();
    }
  } else error("pixmap save format not supported in this build");

  return success;
}

bool RGLView::pixels( int* ll, int* size, int component, float* result )
{
  bool success = false;
  GLenum format[] = {GL_RED, GL_GREEN, GL_BLUE, GL_ALPHA, 
                      GL_DEPTH_COMPONENT, GL_LUMINANCE};   
  glEnable(GL_DEPTH_TEST);
  glDepthMask(GL_TRUE);
  
  if ( windowImpl->beginGL() ) {

    // read front buffer

    glPushAttrib(GL_PIXEL_MODE_BIT);
 
    glReadBuffer(GL_FRONT);
    glPixelStorei(GL_PACK_ALIGNMENT, 1);
    glReadPixels(ll[0],ll[1],size[0],size[1],format[component], GL_FLOAT, (GLvoid*) result);

    glPopAttrib();

    success = true;

    windowImpl->endGL();
  }

  return success;
}

void RGLView::setMouseMode(int button, MouseModeID mode)
{
	int index = button-1;
    	mouseMode[index] = mode;
	switch (mode) {
	    case mmTRACKBALL:
	    	ButtonBeginFunc[index] = &RGLView::trackballBegin;
	    	ButtonUpdateFunc[index] = &RGLView::trackballUpdate;
	    	ButtonEndFunc[index] = &RGLView::trackballEnd;
	    	break;
	    case mmXAXIS:
	    case mmYAXIS:
	    case mmZAXIS:
	    	ButtonBeginFunc[index] = &RGLView::oneAxisBegin;
	    	ButtonUpdateFunc[index] = &RGLView::oneAxisUpdate;
	    	ButtonEndFunc[index] = &RGLView::trackballEnd; // No need for separate function
	    	if (mode == mmXAXIS)      axis[index] = Vertex(1,0,0);
	    	else if (mode == mmYAXIS) axis[index] = Vertex(0,1,0);
	    	else                      axis[index] = Vertex(0,0,1);
	    	break;	    	
	    case mmPOLAR:
 	    	ButtonBeginFunc[index] = &RGLView::polarBegin;
	    	ButtonUpdateFunc[index] = &RGLView::polarUpdate;
	    	ButtonEndFunc[index] = &RGLView::polarEnd;
	    	break;
	    case mmSELECTING:
 	    	ButtonBeginFunc[index] = &RGLView::mouseSelectionBegin;
	    	ButtonUpdateFunc[index] = &RGLView::mouseSelectionUpdate;
	    	ButtonEndFunc[index] = &RGLView::mouseSelectionEnd;
	    	break;
	    case mmZOOM:
 	    	ButtonBeginFunc[index] = &RGLView::adjustZoomBegin;
	    	ButtonUpdateFunc[index] = &RGLView::adjustZoomUpdate;
	    	ButtonEndFunc[index] = &RGLView::adjustZoomEnd;
	    	break;
	    case mmFOV:
 	    	ButtonBeginFunc[index] = &RGLView::adjustFOVBegin;
	    	ButtonUpdateFunc[index] = &RGLView::adjustFOVUpdate;
	    	ButtonEndFunc[index] = &RGLView::adjustFOVEnd;
	    	break;
	    case mmUSER:
 	    	ButtonBeginFunc[index] = &RGLView::userBegin;
	    	ButtonUpdateFunc[index] = &RGLView::userUpdate;
	    	ButtonEndFunc[index] = &RGLView::userEnd;
	    	break;	    	
	}
}

void RGLView::setMouseCallbacks(int button, userControlPtr begin, userControlPtr update, 
                                userControlEndPtr end, userCleanupPtr cleanup, void** user)
{
  int ind = button - 1;
  if (cleanupCallback[ind])
    (*cleanupCallback[ind])(userData + 3*ind);
  beginCallback[ind] = begin;
  updateCallback[ind] = update;
  endCallback[ind] = end;
  cleanupCallback[ind] = cleanup;
  userData[3*ind + 0] = *(user++);
  userData[3*ind + 1] = *(user++);
  userData[3*ind + 2] = *user;
  setMouseMode(button, mmUSER);
}

void RGLView::getMouseCallbacks(int button, userControlPtr *begin, userControlPtr *update, 
                                            userControlEndPtr *end, userCleanupPtr *cleanup, void** user)
{
  int ind = button - 1;
  *begin = beginCallback[ind];
  *update = updateCallback[ind];
  *end = endCallback[ind];
  *cleanup = cleanupCallback[ind];
  *(user++) = userData[3*ind + 0];
  *(user++) = userData[3*ind + 1];
  *(user++) = userData[3*ind + 2];
} 

MouseModeID RGLView::getMouseMode(int button)
{
    return mouseMode[button-1];
}

MouseSelectionID RGLView::getSelectState()
{
    	return selectState;
}

void RGLView::setSelectState(MouseSelectionID state)
{
    	selectState = state;
}

double* RGLView::getMousePosition()
{
    	return mousePosition;
}

//////////////////////////////////////////////////////////////////////////////
//
// INTERACTIVE FEATURE
//   mouseSelection
//
void RGLView::mouseSelectionBegin(int mouseX,int mouseY)
{
	mousePosition[0] = (float)mouseX/(float)width;
	mousePosition[1] = (float)(height - mouseY)/(float)height;
	mousePosition[2] = mousePosition[0];
	mousePosition[3] = mousePosition[1];
	selectState = msCHANGING;
}

void RGLView::mouseSelectionUpdate(int mouseX,int mouseY)
{
	mousePosition[2] = (float)mouseX/(float)width;
	mousePosition[3] = (float)(height - mouseY)/(float)height;
	View::update();
}

void RGLView::mouseSelectionEnd()
{
	selectState = msDONE;
	View::update();
}

void RGLView::getUserMatrix(double* dest)
{
	Viewpoint* viewpoint = scene->getViewpoint();

	viewpoint->getUserMatrix(dest);
}

void RGLView::setUserMatrix(double* src)
{
	Viewpoint* viewpoint = scene->getViewpoint();

	viewpoint->setUserMatrix(src);

	View::update();
}

void RGLView::getScale(double* dest)
{
	Viewpoint* viewpoint = scene->getViewpoint();
	
	viewpoint->getScale(dest);
}

void RGLView::setScale(double* src)
{
	Viewpoint* viewpoint = scene->getViewpoint();

	viewpoint->setScale(src);

	View::update();
}

void RGLView::setDefaultFont(const char* family, int style, double cex, bool useFreeType)
{
  renderContext.font = View::windowImpl->getFont(family, style, cex, useFreeType);
}
  
const char* RGLView::getFontFamily() const 
{
  if(renderContext.font)
    return renderContext.font->getFamily();
  return "";
}

void RGLView::setFontFamily(const char *family)
{
  setDefaultFont(family, getFontStyle(), getFontCex(), getFontUseFreeType());
}

int RGLView::getFontStyle() const 
{
  if (renderContext.font)
    return renderContext.font->getStyle();
  else
    return 0;
}

void RGLView::setFontStyle(int style)
{
  setDefaultFont(getFontFamily(), style, getFontCex(), getFontUseFreeType());
}

double RGLView::getFontCex() const 
{
  if (renderContext.font)
    return renderContext.font->getCEX();
  return 0.0;
}

void RGLView::setFontCex(double cex)
{
  setDefaultFont(getFontFamily(), getFontStyle(), cex, getFontUseFreeType());
}

const char* RGLView::getFontname() const 
{
  if (renderContext.font)
    return renderContext.font->getFontName();
  else
    return "";
}

bool RGLView::getFontUseFreeType() const
{
  if (renderContext.font)
    return renderContext.font->isFreeType();
  else
    return false;
}

void RGLView::setFontUseFreeType(bool useFreeType)
{
  setDefaultFont(getFontFamily(), getFontStyle(), getFontCex(), useFreeType);
}

void RGLView::getPosition(double* dest)
{    
    Viewpoint* viewpoint = scene->getViewpoint();
    viewpoint->getPosition(dest);
}

void RGLView::setPosition(double* src)
{
	Viewpoint* viewpoint = scene->getViewpoint();

	viewpoint->setPosition(src);
}


void RGLView::setDefaultMouseFunc()
{
    setMouseMode(1, mmPOLAR);
    setMouseMode(2, mmFOV);
    setMouseMode(3, mmZOOM);
}

bool RGLView::postscript(int formatID, const char* filename, bool drawText)
{
  bool success = false;

  FILE *fp = fopen(filename, "wb");  
  char *oldlocale = setlocale(LC_NUMERIC, "C");
  
  GLint buffsize = 0, state = GL2PS_OVERFLOW;
  GLint vp[4];
  GLint options = GL2PS_SILENT | GL2PS_SIMPLE_LINE_OFFSET | GL2PS_NO_BLENDING |
                  GL2PS_OCCLUSION_CULL | GL2PS_BEST_ROOT;

  if (!drawText) options |= GL2PS_NO_TEXT;
  
  if (windowImpl->beginGL()) {
  
    glGetIntegerv(GL_VIEWPORT, vp);
 
    while( state == GL2PS_OVERFLOW ){ 
      buffsize += 1024*1024;
      gl2psBeginPage ( filename, "Generated by rgl", vp,
                   formatID, GL2PS_BSP_SORT, options,
                   GL_RGBA, 0, NULL, 0, 0, 0, buffsize,
                   fp, filename );

    
      if ( drawText ) {
        // signal gl2ps for text
        scene->invalidateDisplaylists();
        if (formatID == GL2PS_PS || formatID == GL2PS_EPS || 
            formatID == GL2PS_TEX || formatID == GL2PS_PGF)
      	  renderContext.gl2psActive = GL2PS_POSITIONAL;  
        else
          renderContext.gl2psActive = GL2PS_LEFT_ONLY;
      }
    
      // redraw:
    
      scene->render(&renderContext);
      glFinish();
 
      if ( drawText ) {
        scene->invalidateDisplaylists();
        renderContext.gl2psActive = GL2PS_NONE;   
      }
      success = true;

      state = gl2psEndPage();
    }
  
    windowImpl->endGL();
  }
  setlocale(LC_NUMERIC, oldlocale);
  
  fclose(fp);

  return success;
}

