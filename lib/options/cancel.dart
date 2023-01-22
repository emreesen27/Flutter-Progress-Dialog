import 'package:flutter/material.dart';

class Cancel {
  /// [cancelClicked] If you want to execute an action when the dialog is canceled, pass a void function.
  // (Default: null)
  final GestureTapCallback? cancelClicked;

  /// [cancelImage] The default does not contain any value, if the value is assigned another asset image is created.
  final AssetImage? cancelImage;

  /// [cancelImageSize] set cancel image dimensions
  // (Default: 15.0)
  final double cancelImageSize;

  /// [cancelImageColor] set cancel image color
  // (Default: black)
  final Color? cancelImageColor;

  /// [autoHidden] It hides the cancel button when value and max are equal.
  // (Default: true)
  final bool autoHidden;

  Cancel({
    this.cancelClicked,
    this.cancelImage,
    this.cancelImageSize = 15.0,
    this.cancelImageColor = Colors.black,
    this.autoHidden = true,
  });
}
