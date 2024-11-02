import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/options/completed.dart';
import 'package:sn_progress_dialog/options/cancel.dart';

enum ValuePosition { center, right }
enum ProgressType { normal, valuable }
enum DialogStatus { opened, closed, completed }

class ProgressDialog {
  final ValueNotifier _progress = ValueNotifier(0);
  final ValueNotifier _msg = ValueNotifier('');
  bool _dialogIsOpen = false;
  late BuildContext _context;
  ValueChanged<DialogStatus>? _onStatusChanged;
  late bool _useRootNavigator;

  ProgressDialog({required context, bool? useRootNavigator}) {
    this._context = context;
    this._useRootNavigator = useRootNavigator ?? true;
  }

  void update({int? value, String? msg}) {
    if (value != null) _progress.value = value;
    if (msg != null) _msg.value = msg;
  }

  void close({int? delay = 0}) {
    if (delay == 0 || delay == null) {
      _closeDialog();
      return;
    }
    Future.delayed(Duration(milliseconds: delay), () {
      _closeDialog();
    });
  }

  bool isOpen() {
    return _dialogIsOpen;
  }

  void _closeDialog() {
    if (_dialogIsOpen) {
      Navigator.of(_context, rootNavigator: _useRootNavigator).pop();
      _dialogIsOpen = false;
      _setDialogStatus(DialogStatus.closed);
    }
  }

  void _setDialogStatus(DialogStatus status) {
    if (_onStatusChanged != null) _onStatusChanged!(status);
  }

  _valueProgress({Color? valueColor, Color? bgColor, required double value}) {
    return CircularProgressIndicator(
      backgroundColor: bgColor,
      valueColor: AlwaysStoppedAnimation<Color?>(valueColor),
      value: value.toDouble() / 100,
    );
  }

  _normalProgress({Color? valueColor, Color? bgColor}) {
    return CircularProgressIndicator(
      backgroundColor: bgColor,
      valueColor: AlwaysStoppedAnimation<Color?>(valueColor),
    );
  }

  show({
    int max = 100,
    String msg = "Default Message",
    Completed? completed,
    Cancel? cancel,
    ProgressType progressType = ProgressType.normal,
    ValuePosition valuePosition = ValuePosition.right,
    Color backgroundColor = Colors.white,
    Color? surfaceTintColor,
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
      useRootNavigator: _useRootNavigator,
      builder: (context) => WillPopScope(
        onWillPop: () async => barrierDismissible,
        child: AlertDialog(
          surfaceTintColor: surfaceTintColor,
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
                                if (cancel.cancelClicked != null) {
                                  cancel.cancelClicked!();
                                }
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
      ),
    );
  }
}
