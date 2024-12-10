import 'package:flutter/material.dart';

class Cancel {
  /// Callback function that will be executed when cancel button is tapped.
  final GestureTapCallback? cancelClicked;

  /// Custom image to use for the cancel button.
  /// If not provided, uses default cancel icon.
  final AssetImage? cancelImage;

  /// Size of the cancel button image in pixels.
  /// Defaults to 15.0.
  final double cancelImageSize;

  /// Color to apply to the cancel button image.
  /// Defaults to Colors.black.
  final Color? cancelImageColor;

  /// Whether to automatically hide the cancel button when progress completes.
  /// When true, the button will be hidden when progress value equals max value.
  /// Defaults to true.
  final bool autoHidden;

  Cancel({
    this.cancelClicked,
    this.cancelImage,
    this.cancelImageSize = 15.0,
    this.cancelImageColor = Colors.black,
    this.autoHidden = true,
  });
}
