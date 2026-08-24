#include "clipboard_handler.h"

#include <flutter/standard_method_codec.h>
#include <windows.h>

#include <vector>

#pragma pack(push, 1)
typedef struct {
  WORD  bfType;
  DWORD bfSize;
  WORD  bfReserved1;
  WORD  bfReserved2;
  DWORD bfOffBits;
} BMPFILEHEADER;
#pragma pack(pop)

// Intenta leer CF_DIB del portapapeles y devuelve bytes BMP.
// Retorna true si tuvo éxito.
static bool ReadDibFromClipboard(std::vector<uint8_t> &out) {
  HANDLE hData = ::GetClipboardData(CF_DIB);
  if (hData == NULL) return false;

  LPVOID pDIB = ::GlobalLock(hData);
  if (pDIB == NULL) return false;

  SIZE_T dibSize = ::GlobalSize(hData);
  BITMAPINFOHEADER *bmi = reinterpret_cast<BITMAPINFOHEADER *>(pDIB);

  BMPFILEHEADER bfh = {};
  bfh.bfType = 0x4D42;
  bfh.bfOffBits = sizeof(BMPFILEHEADER) + bmi->biSize +
                   (bmi->biClrUsed * sizeof(RGBQUAD));
  bfh.bfSize = static_cast<DWORD>(sizeof(BMPFILEHEADER) + dibSize);

  out.resize(sizeof(BMPFILEHEADER) + dibSize);
  memcpy(out.data(), &bfh, sizeof(BMPFILEHEADER));
  memcpy(out.data() + sizeof(BMPFILEHEADER), pDIB, dibSize);

  ::GlobalUnlock(hData);
  return true;
}

// Intenta leer CF_BITMAP y convertirlo a CF_DIB.
static bool ReadBitmapFromClipboard(std::vector<uint8_t> &out) {
  HANDLE hData = ::GetClipboardData(CF_BITMAP);
  if (hData == NULL) return false;

  HBITMAP hBmp = static_cast<HBITMAP>(hData);
  if (hBmp == NULL) return false;

  BITMAP bmp = {};
  if (!::GetObject(hBmp, sizeof(bmp), &bmp)) return false;

  BITMAPINFOHEADER bi = {};
  bi.biSize = sizeof(BITMAPINFOHEADER);
  bi.biWidth = bmp.bmWidth;
  bi.biHeight = -bmp.bmHeight;  // top-down
  bi.biPlanes = 1;
  bi.biBitCount = 32;
  bi.biCompression = BI_RGB;

  int rowBytes = bmp.bmWidth * 4;
  int pixelBytes = rowBytes * bmp.bmHeight;

  HDC hdc = ::GetDC(NULL);
  if (hdc == NULL) return false;

  std::vector<uint8_t> pixels(pixelBytes);
  int result = ::GetDIBits(hdc, hBmp, 0, bmp.bmHeight, pixels.data(),
                           reinterpret_cast<BITMAPINFO *>(&bi), DIB_RGB_COLORS);
  ::ReleaseDC(NULL, hdc);
  if (result == 0) return false;

  // Build BITMAPFILEHEADER + BITMAPINFOHEADER + pixels
  BMPFILEHEADER bfh = {};
  bfh.bfType = 0x4D42;
  bfh.bfOffBits = sizeof(BMPFILEHEADER) + sizeof(BITMAPINFOHEADER);
  bfh.bfSize = static_cast<DWORD>(sizeof(BMPFILEHEADER) + sizeof(BITMAPINFOHEADER) + pixelBytes);

  out.resize(sizeof(BMPFILEHEADER) + sizeof(BITMAPINFOHEADER) + pixelBytes);
  memcpy(out.data(), &bfh, sizeof(BMPFILEHEADER));
  memcpy(out.data() + sizeof(BMPFILEHEADER), &bi, sizeof(BITMAPINFOHEADER));
  memcpy(out.data() + sizeof(BMPFILEHEADER) + sizeof(BITMAPINFOHEADER),
         pixels.data(), pixelBytes);
  return true;
}

void ClipboardHandler::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method_call.method_name().compare("readImage") != 0) {
    result->NotImplemented();
    return;
  }

  if (!::OpenClipboard(NULL)) {
    result->Error("CLIPBOARD_ERROR", "No se pudo abrir el portapapeles");
    return;
  }

  std::vector<uint8_t> bmpData;
  bool ok = ReadDibFromClipboard(bmpData);
  if (!ok) ok = ReadBitmapFromClipboard(bmpData);

  ::CloseClipboard();

  if (!ok || bmpData.empty()) {
    result->Error("CLIPBOARD_EMPTY",
                  "El portapapeles no contiene una imagen");
    return;
  }

  flutter::EncodableValue bytes(bmpData);
  result->Success(bytes);
}
