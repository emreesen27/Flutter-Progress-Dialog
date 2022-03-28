import 'package:flutter/material.dart';

class Completed {
  /// [completedMsg] Assign the completed Message
  // (Default: "completed")
  final String completedMsg;

  /// [closedDelay] The time the dialog window will wait to close
  // (Default: 1500 ms)
  final int closedDelay;

  /// [completedImage] The default does not contain any value, if the value is assigned another asset image is created.
  final AssetImage? completedImage;

  Completed({
    this.completedMsg = "Completed !",
    this.closedDelay = 1500,
    this.completedImage,
  });
}
