#include "clipboard_handler.h"

#include <flutter/method_codec.h>
#include <flutter/standard_method_codec.h>
#include <windows.h>

#include <sstream>
#include <vector>

// BITMAPFILEHEADER — 14 bytes, must be prepended to CF_DIB data
// to form a valid BMP file that Flutter can decode.
#pragma pack(push, 1)
typedef struct {
  WORD  bfType;       // 0x4D42 = "BM"
  DWORD bfSize;       // total file size
  WORD  bfReserved1;  // 0
  WORD  bfReserved2;  // 0
  DWORD bfOffBits;    // offset to pixel data
} BMPFILEHEADER;
#pragma pack(pop)

void ClipboardHandler::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "com.lycoris.clipboard",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<ClipboardHandler>();

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](
          const flutter::MethodCall<flutter::EncodableValue> &call,
          std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>>
              result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  plugin->channel_ = std::move(channel);
  registrar->AddPlugin(std::move(plugin));
}

ClipboardHandler::ClipboardHandler() {}

ClipboardHandler::~ClipboardHandler() {}

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

  // Check if a bitmap is available in DIB format
  if (!::IsClipboardFormatAvailable(CF_DIB)) {
    ::CloseClipboard();
    result->Error("CLIPBOARD_EMPTY",
                  "El portapapeles no contiene una imagen");
    return;
  }

  HANDLE hData = ::GetClipboardData(CF_DIB);
  if (hData == NULL) {
    ::CloseClipboard();
    result->Error("CLIPBOARD_ERROR",
                  "No se pudo obtener la imagen del portapapeles");
    return;
  }

  LPVOID pDIB = ::GlobalLock(hData);
  if (pDIB == NULL) {
    ::CloseClipboard();
    result->Error("CLIPBOARD_ERROR", "No se pudo bloquear la memoria");
    return;
  }

  SIZE_T dibSize = ::GlobalSize(hData);

  // Read BITMAPINFOHEADER from the DIB data
  BITMAPINFOHEADER *bmi = (BITMAPINFOHEADER *)pDIB;

  // Build BITMAPFILEHEADER (14 bytes)
  BMPFILEHEADER bfh = {};
  bfh.bfType = 0x4D42;  // "BM"
  bfh.bfOffBits =
      sizeof(BMPFILEHEADER) + bmi->biSize +
      (bmi->biClrUsed * sizeof(RGBQUAD));
  bfh.bfSize = (DWORD)(bfh.bfOffBits + dibSize -
                        bmi->biSize);  // Pixel data follows the header
  // For BITMAPINFOHEADER biSize doesn't include color table, so pixel data
  // starts at bfh.bfOffBits and the total file size = bfh.bfOffBits +
  // (dibSize - bmi->biSize)
  // But actually dibSize = biSize + colorTable + pixelData
  // So total = sizeof(BMPFILEHEADER) + dibSize
  bfh.bfSize = (DWORD)(sizeof(BMPFILEHEADER) + dibSize);

  // Copy BMPFILEHEADER + DIB data into a single buffer
  std::vector<uint8_t> bmpData(sizeof(BMPFILEHEADER) + dibSize);
  memcpy(bmpData.data(), &bfh, sizeof(BMPFILEHEADER));
  memcpy(bmpData.data() + sizeof(BMPFILEHEADER), pDIB, dibSize);

  ::GlobalUnlock(hData);
  ::CloseClipboard();

  // Return as uint8 list to Flutter
  flutter::EncodableValue bytes(bmpData);
  result->Success(bytes);
}
