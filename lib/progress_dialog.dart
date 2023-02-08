import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/options/completed.dart';
import 'package:sn_progress_dialog/options/cancel.dart';

enum ValuePosition { center, right }

enum ProgressType { normal, valuable }

enum DialogStatus { opened, closed, completed }

class ProgressDialog {
  /// [_progress] Listens to the value of progress.
  //  Not directly accessible.
  final ValueNotifier _progress = ValueNotifier(0);

  /// [_msg] Listens to the msg value.
  // Value assignment is done later.
  final ValueNotifier _msg = ValueNotifier('');

  /// [_dialogIsOpen] Shows whether the dialog is open.
  //  Not directly accessible.
  bool _dialogIsOpen = false;

  /// [_context] Required to show the alert.
  // Can only be accessed with the constructor.
  late BuildContext _context;

  /// [_onStatusChanged] Keeps track of the current status of the dialog window.
  // Value assignment is done later.
  ValueChanged<DialogStatus>? _onStatusChanged;

  ProgressDialog({required context}) {
    this._context = context;
  }

  /// [update] Pass the new value to this method to update the status.
  void update({int? value, String? msg}) {
    if (value != null) _progress.value = value;
    if (msg != null) _msg.value = msg;
  }

  /// [close] Closes the progress dialog.
  void close({int? delay = 0}) {
    if (delay == 0 || delay == null) {
      _closeDialog();
      return;
    }
    Future.delayed(Duration(milliseconds: delay), () {
      _closeDialog();
    });
  }

  ///[isOpen] Returns whether the dialog box is open.
  bool isOpen() {
    return _dialogIsOpen;
  }

  void _closeDialog() {
    if (_dialogIsOpen) {
      Navigator.pop(_context);
      _dialogIsOpen = false;
      _setDialogStatus(DialogStatus.closed);
    }
  }

  ///[setDialogStatus] Dialog window sets your new state.
  void _setDialogStatus(DialogStatus status) {
    if (_onStatusChanged != null) _onStatusChanged!(status);
  }

  /// [_valueProgress] Assigns progress properties and updates the value.
  //  Not directly accessible.
  _valueProgress({Color? valueColor, Color? bgColor, required double value}) {
    return CircularProgressIndicator(
      backgroundColor: bgColor,
      valueColor: AlwaysStoppedAnimation<Color?>(valueColor),
      value: value.toDouble() / 100,
    );
  }

  /// [_normalProgress] Assigns progress properties.
  //  Not directly accessible.
  _normalProgress({Color? valueColor, Color? bgColor}) {
    return CircularProgressIndicator(
      backgroundColor: bgColor,
      valueColor: AlwaysStoppedAnimation<Color?>(valueColor),
    );
  }

  /// [max] Assign the maximum value of the upload. @required
  //  Dialog closes automatically when its progress status equals the max value.

  /// [msg] Show a message @required

  /// [valuePosition] Location of progress value @not required
  // Center or right.  (Default: right)

  /// [progressType] Assign the progress bar type.
  // Normal or valuable.  (Default: normal)

  /// [barrierDismissible] Determines whether the dialog closes when the back button or screen is clicked.
  // True or False (Default: false)

  /// [msgMaxLines] Use when text value doesn't fit
  // Int (Default: 1)

  /// [completed] Widgets that will be displayed when the process is completed are assigned through this class.
  // If an assignment is not made, the dialog closes without showing anything.

  /// [cancel] Use it to have a close button on the dialog.
  // Manage other properties related to cancel button via this class.

  /// [hideValue] If you are not using the progress value, you can hide it.
  // Default (Default: false)

  /// [closeWithDelay] The time the dialog window will wait to close
  // If the dialog takes the "completion" object, the value here is ignored.
  // Default (Default: 100ms)

  show({
    int max = 100,
    String msg = "Default Message",
    Completed? completed,
    Cancel? cancel,
    ProgressType progressType = ProgressType.normal,
    ValuePosition valuePosition = ValuePosition.right,
    Color backgroundColor = Colors.white,
    Color barrierColor = Colors.transparent,
    Color progressValueColor = Colors.blueAccent,
    Color progressBgColor = Colors.blueGrey,
    Color valueColor = Colors.black87,
    Color msgColor = Colors.black87,
    TextAlign msgTextAlign = TextAlign.center,
    FontWeight msgFontWeight = FontWeight.bold,
    FontWeight valueFontWeight = FontWeight.normal,
    double valueFontSize = 15.0,
    double msgFontSize = 17.0,
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
    return showDialog(
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      context: _context,
      builder: (context) => WillPopScope(
        child: AlertDialog(
          backgroundColor: backgroundColor,
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadius),
            ),
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
                                if (cancel.cancelClicked != null)
                                  cancel.cancelClicked!();
                              },
                              child: Image(
                                width: cancel.cancelImageSize,
                                height: cancel.cancelImageSize,
                                color: cancel.cancelImageColor,
                                image: cancel.cancelImage ??
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
                              image: completed.completedImage ??
                                  AssetImage(
                                    "images/completed.png",
                                    package: "sn_progress_dialog",
                                  ),
                            )
                          : Container(
                              width: 35.0,
                              height: 35.0,
                              child: progressType == ProgressType.normal
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
                            builder: (BuildContext context, dynamic msgValue,
                                Widget? child) {
                              return Text(
                                value == max && completed != null
                                    ? completed.completedMsg
                                    : msgValue,
                                textAlign: msgTextAlign,
                                maxLines: msgMaxLines,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: msgFontSize,
                                  color: msgColor,
                                  fontWeight: msgFontWeight,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  hideValue == false
                      ? Align(
                          child: Text(
                            value <= 0 ? '' : '${_progress.value}/$max',
                            style: TextStyle(
                              fontSize: valueFontSize,
                              color: valueColor,
                              fontWeight: valueFontWeight,
                              decoration: value == max
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          alignment: valuePosition == ValuePosition.right
                              ? Alignment.bottomRight
                              : Alignment.bottomCenter,
                        )
                      : SizedBox.shrink()
                ],
              );
            },
          ),
        ),
        onWillPop: () {
          if (barrierDismissible) {
            _dialogIsOpen = false;
          }
          return Future.value(barrierDismissible);
        },
      ),
    );
  }
}
