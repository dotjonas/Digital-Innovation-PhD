// C++ source
// This file is part of RGL.
//
// $Id: x11lib.cpp 14 2003-05-21 11:08:25Z  $

#include "lib.h"


//
// ===[ GUI IMPLEMENTATION ]=================================================
//

#include "x11gui.h"

gui::X11GUIFactory* gpX11GUIFactory = NULL;

gui::GUIFactory* getGUIFactory()
{
  return (gui::GUIFactory*) gpX11GUIFactory;
}

//
// ===[ R INTEGRATION ]=======================================================
//

#include <R.h>
#include <R_ext/eventloop.h>

static InputHandler* R_handler;

static void R_event_handler(void * userData)
{
  gpX11GUIFactory->processEvents();
}

static void set_R_handler()
{
  // add R input handler (R_ext/eventloop.h)
  // approach taken from GtkDevice ... good work guys!
  
  R_handler = ::addInputHandler(R_InputHandlers, gpX11GUIFactory->getFD(), R_event_handler, -1);
  
  if (R_handler == NULL) 
    printMessage("unable to install input handler");
}

static void unset_R_handler()
{
  if (R_handler) {
    ::removeInputHandler(&R_InputHandlers, R_handler);
    R_handler = NULL;
  }
}

bool lib_init()
{
  bool success = false;
  gpX11GUIFactory = new gui::X11GUIFactory(NULL);
 
  if ( gpX11GUIFactory->isConnected() ) {
    set_R_handler();
    success = true;
  }
  return success;
}

void lib_quit()
{
  unset_R_handler();
  delete gpX11GUIFactory;
}

//
// ===[ LIB SERVICES ]=======================================================
//

//
// printMessage
//

#include <stdio.h>

void printMessage( const char* string ) {
  fprintf(stderr, "RGL: ");
  fprintf(stderr, string );
  fprintf(stderr, "\n" );
}

//
// getTime
//

#include <sys/time.h>
#include <unistd.h>

double getTime() {
  struct timeval t;
  gettimeofday(&t,NULL);
  return ( (double) t.tv_sec ) * 1000.0 + ( ( (double) t.tv_usec ) / 1000.0 ); 
}
