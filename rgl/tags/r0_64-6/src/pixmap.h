#ifndef PIXMAP_H
#define PIXMAP_H

// C++ header file
// This file is part of RGL
//
// $Id: pixmap.h 72 2003-11-19 22:51:55Z  $

#include <stdio.h>
#include "opengl.h"

class PixmapFormat;
  
enum PixmapTypeID { INVALID=0, RGB24, RGB32, RGBA32, GRAY8 };

enum PixmapFileFormatID {
PIXMAP_FILEFORMAT_PNG = 0,
PIXMAP_FILEFORMAT_LAST
};

class Pixmap {
public:
  
  Pixmap();
  ~Pixmap();
  bool init(PixmapTypeID typeID, int width, int height, int bits_per_channel);
  bool load(const char* filename);
  bool save(PixmapFormat* format, const char* filename);

  PixmapTypeID typeID;
  int width;
  int height;
  int bits_per_channel;
  int bytesperrow;
  unsigned char *data;
};


class PixmapFormat {
public:
  virtual bool checkSignature(FILE* file) = 0;
  virtual bool load(FILE* file, Pixmap* pixmap) = 0;
  virtual bool save(FILE* file, Pixmap* pixmap) = 0;
};


extern PixmapFormat* pixmapFormat[PIXMAP_FILEFORMAT_LAST];

#endif /* PIXMAP_H */
