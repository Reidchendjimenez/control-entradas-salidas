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

void ClipboardHandler::RegisterWithMessenger(flutter::BinaryMessenger *messenger) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          messenger, "com.lycoris.clipboard",
          &flutter::StandardMethodCodec::GetInstance());

  channel->SetMethodCallHandler(
      [](const flutter::MethodCall<flutter::EncodableValue> &call,
         std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>>
             result) {
        HandleMethodCall(call, std::move(result));
      });

  // Transfer ownership so channel lives for the process lifetime.
  // NOLINTNEXTLINE
  static auto *ch = channel.release();
  (void)ch;
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
  BITMAPINFOHEADER *bmi = reinterpret_cast<BITMAPINFOHEADER *>(pDIB);

  BMPFILEHEADER bfh = {};
  bfh.bfType = 0x4D42;
  bfh.bfOffBits = sizeof(BMPFILEHEADER) + bmi->biSize +
                   (bmi->biClrUsed * sizeof(RGBQUAD));
  bfh.bfSize = static_cast<DWORD>(sizeof(BMPFILEHEADER) + dibSize);

  std::vector<uint8_t> bmpData(sizeof(BMPFILEHEADER) + dibSize);
  memcpy(bmpData.data(), &bfh, sizeof(BMPFILEHEADER));
  memcpy(bmpData.data() + sizeof(BMPFILEHEADER), pDIB, dibSize);

  ::GlobalUnlock(hData);
  ::CloseClipboard();

  flutter::EncodableValue bytes(bmpData);
  result->Success(bytes);
}
