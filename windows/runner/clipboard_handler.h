#ifndef RUNNER_CLIPBOARD_HANDLER_H_
#define RUNNER_CLIPBOARD_HANDLER_H_

#include <flutter/binary_messenger.h>
#include <flutter/method_channel.h>

class ClipboardHandler {
 public:
  static void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

#endif  // RUNNER_CLIPBOARD_HANDLER_H_
