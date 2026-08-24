#ifndef RUNNER_CLIPBOARD_HANDLER_H_
#define RUNNER_CLIPBOARD_HANDLER_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

class ClipboardHandler : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  ClipboardHandler();

  virtual ~ClipboardHandler();

  // Handles a method call from Flutter. Reads CF_DIB from clipboard,
  // prepends a BITMAPFILEHEADER, and returns BMP bytes.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

 private:
  std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>> channel_;
};

#endif  // RUNNER_CLIPBOARD_HANDLER_H_
