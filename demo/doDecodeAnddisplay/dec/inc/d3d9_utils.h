
#ifndef WELS_D3D9_UTILS_H__
#define WELS_D3D9_UTILS_H__

#include <stdio.h>
#include "codec_def.h"

#if defined(_MSC_VER) && (_MSC_VER>=1500) // vs2008 and upper
#ifdef WINAPI_FAMILY
#include <winapifamily.h>
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)
#define ENABLE_DISPLAY_MODULE // enable/disable the render feature
#endif
#else /* defined(WINAPI_FAMILY) */
#define ENABLE_DISPLAY_MODULE // enable/disable the render feature
#endif
#endif

#ifdef ENABLE_DISPLAY_MODULE
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#include <d3d9.h>
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class CD3D9Utils {
 public:
  CD3D9Utils();
  ~CD3D9Utils();

 public:
  HRESULT Init (BOOL bWindowed);
  HRESULT Uninit (void);
  HRESULT Process (void* pDst[3], SBufferInfo* Info, FILE* pFile = NULL);

 private:
  HRESULT InitResource (void* pSharedHandle, SBufferInfo* pInfo);
  HRESULT Render (void* pDst[3], SBufferInfo* pInfo);
  HRESULT Dump (void* pDst[3], SBufferInfo* pInfo, FILE* pFile);

 private:
  HMODULE               m_hDll;
  HWND                  m_hWnd;
  unsigned char*        m_pDumpYUV;
  BOOL                  m_bInitDone;
  int                   m_nWidth;
  int                   m_nHeight;

  LPDIRECT3D9           m_lpD3D9;
  LPDIRECT3DDEVICE9     m_lpD3D9Device;

  D3DPRESENT_PARAMETERS m_d3dpp;
  LPDIRECT3DSURFACE9    m_lpD3D9RawSurfaceShare;
};

class CD3D9ExUtils {
 public:
  CD3D9ExUtils();
  ~CD3D9ExUtils();

 public:
  HRESULT Init (BOOL bWindowed);
  HRESULT Uninit (void);
  HRESULT Process (void* dst[3], SBufferInfo* Info, FILE* fp = NULL);

 private:
  HRESULT InitResource (void* pSharedHandle, SBufferInfo* Info);
  HRESULT Render (void* pDst[3], SBufferInfo* Info);
  HRESULT Dump (void* pDst[3], SBufferInfo* Info, FILE* fp);

 private:
  HMODULE               m_hDll;
  HWND                  m_hWnd;
  unsigned char*        m_pDumpYUV;
  BOOL                  m_bInitDone;
  int                   m_nWidth;
  int                   m_nHeight;

  LPDIRECT3D9EX         m_lpD3D9;
  LPDIRECT3DDEVICE9EX   m_lpD3D9Device;

  D3DPRESENT_PARAMETERS m_d3dpp;
  LPDIRECT3DSURFACE9    m_lpD3D9RawSurfaceShare;
};
#endif

enum {
  OS_UNSUPPORTED = 0,
  OS_XP,
  OS_VISTA_UPPER
};

class CUtils {
 public:
  CUtils();
  ~CUtils();

  int Process (void* dst[3], SBufferInfo* Info, FILE* fp);

 private:
  int CheckOS (void);

 private:
  int iOSType;
  void* hHandle;
};

#endif//WELS_D3D9_UTILS_H__

