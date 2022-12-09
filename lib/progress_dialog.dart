import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/completed.dart';

enum ValuePosition { center, right }

enum ProgressType { normal, valuable }

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

  ProgressDialog({required context}) {
    this._context = context;
  }

  /// [update] Pass the new value to this method to update the status.
  //  Msg not required.
  void update({required int value, String? msg}) {
    _progress.value = value;
    if (msg != null) _msg.value = msg;
  }

  /// [close] Closes the progress dialog.
  void close() {
    if (_dialogIsOpen) {
      Navigator.pop(_context);
      _dialogIsOpen = false;
    }
  }

  ///[isOpen] Returns whether the dialog box is open.
  bool isOpen() {
    return _dialogIsOpen;
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

  /// [hideValue] If you are not using the progress value, you can hide it.
  // Default (Default: false)

  show({
    required int max,
    required String msg,
    Completed? completed,
    ProgressType progressType: ProgressType.normal,
    ValuePosition valuePosition: ValuePosition.right,
    Color backgroundColor: Colors.white,
    Color barrierColor: Colors.transparent,
    Color progressValueColor: Colors.blueAccent,
    Color progressBgColor: Colors.blueGrey,
    Color valueColor: Colors.black87,
    Color msgColor: Colors.black87,
    TextAlign msgTextAlign: TextAlign.center,
    FontWeight msgFontWeight: FontWeight.bold,
    FontWeight valueFontWeight: FontWeight.normal,
    double valueFontSize: 15.0,
    double msgFontSize: 17.0,
    int msgMaxLines: 1,
    double elevation: 5.0,
    double borderRadius: 15.0,
    bool barrierDismissible: false,
    bool hideValue: false,
  }) {
    _dialogIsOpen = true;
    _msg.value = msg;
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
                if (completed == null)
                  close();
                else {
                  Future.delayed(Duration(milliseconds: completed.closedDelay),
                      () {
                    close();
                  });
                }
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                          child: Text(
                            value == max && completed != null
                                ? completed.completedMsg
                                : _msg.value,
                            textAlign: msgTextAlign,
                            maxLines: msgMaxLines,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: msgFontSize,
                              color: msgColor,
                              fontWeight: msgFontWeight,
                            ),
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
                      : Container()
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
