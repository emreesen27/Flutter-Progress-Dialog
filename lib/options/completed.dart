import 'package:flutter/material.dart';

class Completed {
  /// Future that resolves to the completion message.
  /// If provided, this message will override [completedMsg] when resolved.
  final Future<String>? completedMsgFuture;

  /// Message to display when progress completes.
  /// Defaults to "Completed !".
  final String completedMsg;

  /// Duration to wait before closing the dialog after completion, in milliseconds.
  /// Defaults to 1500ms.
  final int completionDelay;

  /// Custom image to display when progress completes.
  /// If not provided, uses default completion icon.
  final AssetImage? completedImage;

  Completed({
    this.completedMsgFuture,
    this.completedMsg = "Completed !",
    this.completionDelay = 1500,
    this.completedImage,
  });
}
