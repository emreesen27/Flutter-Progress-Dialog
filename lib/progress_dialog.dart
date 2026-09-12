import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:sn_progress_dialog/enums/dialog_status.dart';
import 'package:sn_progress_dialog/enums/progress_types.dart';
import 'package:sn_progress_dialog/enums/value_position.dart';
import 'package:sn_progress_dialog/options/cancel.dart';
import 'package:sn_progress_dialog/options/completed.dart';

/// A customizable progress dialog that displays loading states and completion messages.
class ProgressDialog {
  /// Listens to the current progress value.
  final ValueNotifier _progress = ValueNotifier(0);

  /// Listens to the current message text.
  final ValueNotifier _msg = ValueNotifier('');

  /// Listens to the completion message.
  final ValueNotifier<String> _completedMsg = ValueNotifier('');

  /// Indicates whether the dialog is currently displayed.
  bool _dialogIsOpen = false;

  /// The build context used to show the dialog.
  final BuildContext _context;

  /// Callback triggered when dialog status changes.
  ValueChanged<DialogStatus>? _onStatusChanged;

  /// Whether to show dialog in root navigator.
  /// If true, the dialog will be displayed above all other routes.
  final bool _useRootNavigator;

  /// Creates a progress dialog with the given build context.
  ///
  /// [_context] - Required build context for showing the dialog
  /// [useRootNavigator] - Whether to show in root navigator. Defaults to true
  ProgressDialog({required this._context, bool? useRootNavigator})
    : _useRootNavigator = useRootNavigator ?? true;

  /// Updates the dialog's progress value and message.
  ///
  /// [value] - New progress value between 0 and max
  /// [msg] - New message to display
  void update({int? value, String? msg}) {
    if (value != null) _progress.value = value;
    if (msg != null) _msg.value = msg;
  }

  /// Closes the dialog with optional delay.
  ///
  /// [delay] - Milliseconds to wait before closing. Defaults to 0.
  void close({int? delay = 0}) {
    if (delay == 0 || delay == null) {
      _closeDialog();
      return;
    }
    Future.delayed(Duration(milliseconds: delay), () {
      _closeDialog();
    });
  }

  /// Releases resources used by the dialog.
  /// Should be called when the dialog is no longer needed.
  void dispose() {
    _progress.dispose();
    _msg.dispose();
    _completedMsg.dispose();
  }

  /// Returns whether the dialog is currently open.
  bool isOpen() {
    return _dialogIsOpen;
  }

  /// Private method to close the dialog and update its status.
  void _closeDialog() {
    if (_dialogIsOpen) {
      Navigator.of(_context, rootNavigator: _useRootNavigator).pop();
      _dialogIsOpen = false;
      _setDialogStatus(DialogStatus.closed);
    }
  }

  /// Private method to notify status change listeners.
  void _setDialogStatus(DialogStatus status) {
    if (_onStatusChanged != null) _onStatusChanged!(status);
  }

  /// Creates a progress indicator with deterministic value.
  CircularProgressIndicator _valueProgress({
    Color? valueColor,
    Color? bgColor,
    required double value,
  }) {
    return CircularProgressIndicator(
      backgroundColor: bgColor,
      valueColor: AlwaysStoppedAnimation<Color?>(valueColor),
      value: value.toDouble() / 100,
    );
  }

  /// Creates an indeterminate progress indicator.
  CircularProgressIndicator _normalProgress({
    Color? valueColor,
    Color? bgColor,
  }) {
    return CircularProgressIndicator(
      backgroundColor: bgColor,
      valueColor: AlwaysStoppedAnimation<Color?>(valueColor),
    );
  }

  /// Shows the progress dialog with customizable options.
  ///
  /// Parameters:
  /// - [max] Maximum progress value (default: 100). This value determines when the progress is complete.
  /// - [msg] Message to display (default: "Default Message"). Can be updated using [update] method.
  /// - [completed] Configuration for completion state. Use this to customize completion message, delay, and image.
  ///   If not provided, dialog will close immediately upon completion.
  /// - [cancel] Configuration for cancel button. Provides options for custom image and click handling.
  /// - [progressType] Type of progress indicator:
  ///   * indeterminate: Shows spinning indicator
  ///   * determinate: Shows actual progress (0-100%)
  /// - [valuePosition] Position of progress value text (center/right). Only applies when [hideValue] is false.
  /// - [backgroundColor] Dialog background color
  /// - [surfaceTintColor] Dialog surface tint color for Material 3
  /// - [barrierColor] Color of the barrier behind the dialog
  /// - [progressValueColor] Color of the progress indicator's fill
  /// - [progressBgColor] Background color of the progress track
  /// - [valueColor] Color of the progress value text
  /// - [msgTextAlign] Alignment of the message text (default: center)
  /// - [msgMaxLines] Maximum lines for message text before ellipsis (default: 1)
  /// - [valueStyle] Text style applied to the progress value text
  /// - [msgStyle] Text style applied to the [msg] text
  /// - [elevation] Dialog elevation in logical pixels (default: 5.0)
  /// - [borderRadius] Dialog corner radius in logical pixels (default: 15.0)
  /// - [barrierDismissible] Whether clicking outside closes the dialog (default: false)
  /// - [hideValue] Whether to hide the progress value text (default: false)
  /// - [closeWithDelay] Delay before closing in milliseconds (default: 100)
  ///   Note: This is ignored if [completed] is provided.
  /// - [onStatusChanged] Callback for dialog status changes (opened/closed/completed)
  ///
  /// The dialog can be updated using the [update] method and closed manually using [close].
  /// Status changes can be monitored through the [onStatusChanged] callback.
  Future<void> show({
    int max = 100,
    String msg = "Default Message",
    Completed? completed,
    Cancel? cancel,
    ProgressType progressType = ProgressType.indeterminate,
    ValuePosition valuePosition = ValuePosition.right,
    Color? backgroundColor,
    Color? surfaceTintColor,
    Color? barrierColor,
    Color? progressValueColor,
    Color? progressBgColor,
    TextStyle? valueStyle,
    TextStyle? msgStyle,
    TextAlign msgTextAlign = TextAlign.center,
    int msgMaxLines = 1,
    double elevation = 5.0,
    double borderRadius = 15.0,
    bool barrierDismissible = false,
    bool hideValue = false,
    int closeWithDelay = 100,
    ValueChanged<DialogStatus>? onStatusChanged,
  }) {
    _dialogIsOpen = true;
    _msg.value = msg;
    _onStatusChanged = onStatusChanged;
    _setDialogStatus(DialogStatus.opened);

    if (completed?.completedMsgFuture != null) {
      completed!.completedMsgFuture!.then((newMsg) {
        _completedMsg.value = newMsg;
      });
    } else if (completed != null) {
      _completedMsg.value = completed.completedMsg;
    }

    return showDialog(
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      context: _context,
      useRootNavigator: _useRootNavigator,
      builder: (context) => PopScope(
        canPop: barrierDismissible,
        child: AlertDialog(
          surfaceTintColor: surfaceTintColor,
          backgroundColor: backgroundColor,
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          ),
          content: ValueListenableBuilder(
            valueListenable: _progress,
            builder: (BuildContext context, dynamic value, Widget? child) {
              if (value == max) {
                _setDialogStatus(DialogStatus.completed);
                completed == null
                    ? close(delay: closeWithDelay)
                    : close(delay: completed.completionDelay);
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (cancel != null) ...[
                    cancel.autoHidden && value == max
                        ? SizedBox.shrink()
                        : Align(
                            alignment: Alignment.topRight,
                            child: InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                close();
                                if (cancel.cancelClicked != null) {
                                  cancel.cancelClicked!();
                                }
                              },
                              child: Image(
                                width: cancel.cancelImageSize,
                                height: cancel.cancelImageSize,
                                color: cancel.cancelImageColor,
                                image:
                                    cancel.cancelImage ??
                                    AssetImage(
                                      "images/cancel.png",
                                      package: "sn_progress_dialog",
                                    ),
                              ),
                            ),
                          ),
                  ],
                  Row(
                    children: [
                      value == max && completed != null
                          ? Image(
                              width: 40,
                              height: 40,
                              image:
                                  completed.completedImage ??
                                  AssetImage(
                                    "images/completed.png",
                                    package: "sn_progress_dialog",
                                  ),
                            )
                          : SizedBox(
                              width: 35.0,
                              height: 35.0,
                              child: progressType.isIndeterminate
                                  ? _normalProgress(
                                      bgColor: progressBgColor,
                                      valueColor: progressValueColor,
                                    )
                                  : value == 0
                                  ? _normalProgress(
                                      bgColor: progressBgColor,
                                      valueColor: progressValueColor,
                                    )
                                  : _valueProgress(
                                      valueColor: progressValueColor,
                                      bgColor: progressBgColor,
                                      value: (value / max) * 100,
                                    ),
                            ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 15.0,
                            top: 8.0,
                            bottom: 8.0,
                          ),
                          child: ValueListenableBuilder(
                            valueListenable: _msg,
                            builder:
                                (
                                  BuildContext context,
                                  dynamic msgValue,
                                  Widget? child,
                                ) {
                                  return ValueListenableBuilder(
                                    valueListenable: _completedMsg,
                                    builder:
                                        (context, completedMsgValue, child) {
                                          return Text(
                                            value == max && completed != null
                                                ? completedMsgValue
                                                : msgValue,
                                            textAlign: msgTextAlign,
                                            maxLines: msgMaxLines,
                                            overflow: TextOverflow.ellipsis,
                                            style: msgStyle,
                                          );
                                        },
                                  );
                                },
                          ),
                        ),
                      ),
                    ],
                  ),
                  hideValue == false
                      ? Align(
                          alignment: valuePosition == ValuePosition.right
                              ? Alignment.bottomRight
                              : Alignment.bottomCenter,
                          child: Text(
                            value <= 0 ? '' : '${_progress.value}/$max',
                            style: (valueStyle ?? TextStyle(inherit: true))
                                .copyWith(
                                  decoration: value == max
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                          ),
                        )
                      : SizedBox.shrink(),
                ],
              );
            },
          ),
        ),
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            _dialogIsOpen = false;
            _setDialogStatus(DialogStatus.closed);
          }
        },
      ),
    );
  }
}
