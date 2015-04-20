#ifndef RGL_DEVICE_MANAGER_H
#define RGL_DEVICE_MANAGER_H

// C++ header file
// This file is part of RGL
//
// $Id: DeviceManager.h 1116 2014-07-18 19:22:01Z murdoch $

#include "Device.h"

#include <list>

namespace rgl {

/**
 * Manager component that is used as a front-end for multiple devices access
 * using an 'id' to set the current device.
 **/
class DeviceManager : protected IDisposeListener {

public:
  DeviceManager(bool in_useNULLDevice);	
  virtual ~DeviceManager();
  bool    openDevice(bool useNULL);
  Device* getCurrentDevice(void);
  Device* getAnyDevice(void);
  Device* getDevice(int id);
  bool    setCurrent(int id, bool silent = false);
  int     getCurrent();
  int     getDeviceCount();
  void   getDeviceIds(int *buffer, int bufsize);
protected:
  /**
   * Dispose Listener implementation
   **/
  void notifyDisposed(Disposable*);
private:
  void    nextDevice();
  void    previousDevice();
  typedef std::list<Device*> Container;
  typedef Container::iterator Iterator;

  int       newID;
  Container devices;
  Iterator  current; 
  bool	    useNULLDevice;
};

} // namespace rgl

#endif // DEVICE_MANAGER_H

