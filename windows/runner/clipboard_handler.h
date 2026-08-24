#ifndef RUNNER_CLIPBOARD_HANDLER_H_
#define RUNNER_CLIPBOARD_HANDLER_H_

#include <flutter/binary_messenger.h>
#include <flutter/method_channel.h>

#include <memory>

class ClipboardHandler {
 public:
  /// Registers the method channel on the given messenger.
  static void RegisterWithMessenger(flutter::BinaryMessenger *messenger);

  // Handles a method call from Flutter. Reads CF_DIB from clipboard,
  // prepends a BITMAPFILEHEADER, and returns BMP bytes.
  static void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

#endif  // RUNNER_CLIPBOARD_HANDLER_H_
