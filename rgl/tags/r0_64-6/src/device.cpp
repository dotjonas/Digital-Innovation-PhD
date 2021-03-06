// C++ source
// This file is part of RGL.
//
// $Id: device.cpp 72 2003-11-19 22:51:55Z  $

#include "device.h"
#include "rglview.h"
#include "gui.h"

Device::Device()
{
  destroyHandler = NULL;

  scene   = new Scene();
  rglview = new RGLView(scene);
  window  = new Window( rglview, getGUIFactory() );

  window->setDestroyHandler(this, window);
}

Device::~Device()
{
  if (destroyHandler)
    destroyHandler->notifyDestroy(destroyHandler_userdata);

  if (window) {
    window->setDestroyHandler(NULL, NULL);
    delete window;
  }

  delete scene;
}

void Device::notifyDestroy(void* userdata)
{
  window = NULL;
  delete this;
}

void Device::setDestroyHandler(DestroyHandler* inDestroyHandler, void* userdata)
{
  destroyHandler = inDestroyHandler;
  destroyHandler_userdata = userdata;
}

void Device::setName(const char* string)
{
  window->setTitle(string);
}

void Device::update()
{
//  window->update();
}

bool Device::open(void)
{
  window->setVisibility(true);
  return true;
}

void Device::close(void)
{
  delete this;
}

//
// scene management:
//

bool Device::clear(TypeID stackTypeID)
{
  bool success;
  if ( success = scene->clear(stackTypeID) )
    rglview->update();
  return success;
}

bool Device::add(SceneNode* node) 
{
  bool success;
  if ( success = scene->add(node) )
    rglview->update();
  return success;
}

bool Device::pop(TypeID stackTypeID)
{  
  bool success;
  if ( success = scene->pop(stackTypeID) )
    rglview->update();
  return success;
}

//
// export 
//

bool Device::snapshot(int format, const char* filename)
{
  return rglview->snapshot( (PixmapFileFormatID) format, filename);
}
