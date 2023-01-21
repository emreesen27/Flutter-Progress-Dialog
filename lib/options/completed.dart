import 'package:flutter/material.dart';

class Completed {
  /// [completedMsg] Assign the completed Message
  // (Default: "completed")
  String completedMsg;

  /// [completionDelay] The time the dialog window will wait to close
  // (Default: 1500 ms)
  final int completionDelay;

  /// [completedImage] The default does not contain any value, if the value is assigned another asset image is created.
  final AssetImage? completedImage;

  Completed({
    this.completedMsg = "Completed !",
    this.completionDelay = 1500,
    this.completedImage,
  });
}
