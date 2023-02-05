import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/options/completed.dart';
import 'package:sn_progress_dialog/options/cancel.dart';

enum ValuePosition { center, right }

enum ProgressType { determinate, indeterminate }

enum DialogStatus { opened, closed, completed }

class ProgressDialog {
  /// [_progress] Listens to the value of progress.
  //  Not directly accessible.
  final ValueNotifier _progress = ValueNotifier(0);

  /// [_message] Listens to the msg value.
  // Value assignment is done later.
  final ValueNotifier _message = ValueNotifier('');

  /// [_dialogIsOpen] Shows whether the dialog is open.
  //  Not directly accessible.
  bool _dialogIsOpen = false;

  /// [_context] Required to show the alert.
  // Can only be accessed with the constructor.
  late BuildContext _context;

  /// [_onStatusChanged] Keeps track of the current status of the dialog window.
  // Value assignment is done later.
  ValueChanged<DialogStatus>? _onStatusChanged;

  int? _maxValue;
  late ProgressType _progressType;
  Completed? _completed;
  Cancel? _cancel;
  ValuePosition _valuePosition = ValuePosition.right;
  Color _backgroundColor = Colors.white;
  Color _barrierColor = Colors.transparent;
  Color _progressValueColor = Colors.blueAccent;
  Color _progressBgColor = Colors.blueGrey;
  Color _valueColor = Colors.black87;
  Color _messageTextColor = Colors.black87;
  TextAlign _messageTextAlign = TextAlign.center;
  FontWeight _messageFontWeight = FontWeight.bold;
  FontWeight _valueFontWeight = FontWeight.normal;
  double _valueFontSize = 15.0;
  double _messageFontSize = 17.0;
  int _messageMaxLines = 1;
  double _elevation = 5.0;
  double _borderRadius = 15.0;
  bool _barrierDismissible = false;
  bool _hideValue = false;
  int _closeWithDelay = 100;

  ProgressDialog.indeterminate({
    required BuildContext context,
    required String message,
    Cancel? cancel,
    Color? backgroundColor,
    Color? barrierColor,
    Color? progressValueColor,
    Color? progressBgColor,
    Color? messageTextColor,
    TextAlign? messageTextAlign,
    FontWeight? messageFontWeight,
    double? messageFontSize,
    int? messageMaxLines,
    double? elevation,
    double? borderRadius,
    bool? barrierDismissible,
  }) {
    _context = context;
    _message.value = message;
    _cancel = cancel;
    _backgroundColor = backgroundColor ?? Colors.white;
    _barrierColor = barrierColor ?? Colors.transparent;
    _progressValueColor = progressValueColor ?? Colors.blueAccent;
    _progressBgColor = progressBgColor ?? Colors.blueGrey;
    _messageTextColor = messageTextColor ?? Colors.black87;
    _messageTextAlign = messageTextAlign ?? TextAlign.center;
    _messageFontWeight = messageFontWeight ?? FontWeight.bold;
    _messageFontSize = messageFontSize ?? 17.0;
    _messageMaxLines = messageMaxLines ?? 1;
    _elevation = elevation ?? 5.0;
    _borderRadius = borderRadius ?? 15.0;
    _barrierDismissible = barrierDismissible ?? false;
    _progressType = ProgressType.indeterminate;
  }

  ProgressDialog.determinate({
    required context,
    required String message,
    required int maxValue,
    Completed? completed,
    Cancel? cancel,
    ValuePosition? valuePosition,
    Color? backgroundColor,
    Color? barrierColor,
    Color? progressValueColor,
    Color? progressBgColor,
    Color? valueColor,
    Color? messageTextColor,
    TextAlign? messageTextAlign,
    FontWeight? messageFontWeight,
    FontWeight? valueFontWeight,
    double? valueFontSize,
    double? messageFontSize,
    int? messageMaxLines,
    double? elevation,
    double? borderRadius,
    bool? barrierDismissible,
    bool? hideValue,
    int? closeWithDelay,
  }) {
    _context = context;
    _message.value = message;
    _maxValue = maxValue;
    _cancel = cancel;
    _valuePosition = valuePosition ?? ValuePosition.right;
    _completed = completed;
    _backgroundColor = backgroundColor ?? Colors.white;
    _barrierColor = barrierColor ?? Colors.transparent;
    _progressValueColor = progressValueColor ?? Colors.blueAccent;
    _progressBgColor = progressBgColor ?? Colors.blueGrey;
    _valueColor = valueColor ?? Colors.black87;
    _messageTextColor = messageTextColor ?? Colors.black87;
    _messageTextAlign = messageTextAlign ?? TextAlign.center;
    _messageFontWeight = messageFontWeight ?? FontWeight.bold;
    _valueFontWeight = valueFontWeight ?? FontWeight.normal;
    _valueFontSize = valueFontSize ?? 15.0;
    _messageFontSize = messageFontSize ?? 17.0;
    _messageMaxLines = messageMaxLines ?? 1;
    _elevation = elevation ?? 5.0;
    _borderRadius = borderRadius ?? 15.0;
    _barrierDismissible = barrierDismissible ?? false;
    _hideValue = hideValue ?? false;
    _closeWithDelay = closeWithDelay ?? 100;
    _progressType = ProgressType.determinate;
  }

  /// [update] Pass the new value to this method to update the status.
  //  Msg not required.
  void update({int? value, String? message}) {
    if (_progressType == ProgressType.determinate) {
      if (value == null)
        throw Exception(
            "update value cannot be empty for the determinate dialog!");
      _progress.value = value;
    } else {
      if (message == null)
        throw Exception(
            "update message cannot be empty for the indeterminate dialog!");
      _message.value = value;
    }
  }

  /// [close] Closes the progress dialog.
  void close({int delay = 0}) {
    Future.delayed(Duration(milliseconds: delay), () {
      if (_dialogIsOpen) {
        Navigator.pop(_context);
        _dialogIsOpen = false;
        _setDialogStatus(DialogStatus.closed);
      }
    });
  }

  ///[isOpen] Returns whether the dialog box is open.
  bool isOpen() {
    return _dialogIsOpen;
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
    ValueChanged<DialogStatus>? onStatusChanged,
  }) async {
    _dialogIsOpen = true;
    _onStatusChanged = onStatusChanged;
    _setDialogStatus(DialogStatus.opened);
    return showDialog(
      barrierDismissible: _barrierDismissible,
      barrierColor: _barrierColor,
      context: _context,
      builder: (context) => WillPopScope(
        child: AlertDialog(
          backgroundColor: _backgroundColor,
          elevation: _elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(_borderRadius),
            ),
          ),
          content: _progressType == ProgressType.determinate
              ? _createDeterminate()
              : _createIndeterminate(),
        ),
        onWillPop: () {
          if (_barrierDismissible) {
            _dialogIsOpen = false;
          }
          return Future.value(_barrierDismissible);
        },
      ),
    );
  }

  Widget _createCancelButton() {
    return Align(
      alignment: Alignment.topRight,
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          close();
          if (_cancel!.cancelClicked != null) _cancel!.cancelClicked!();
        },
        child: Image(
          width: _cancel!.cancelImageSize,
          height: _cancel!.cancelImageSize,
          color: _cancel!.cancelImageColor,
          image: _cancel!.cancelImage ??
              AssetImage(
                "images/cancel.png",
                package: "sn_progress_dialog",
              ),
        ),
      ),
    );
  }

  Widget _createDeterminate() {
    return ValueListenableBuilder(
      valueListenable: _progress,
      builder: (BuildContext context, dynamic value, Widget? child) {
        if (value == _maxValue) {
          _setDialogStatus(DialogStatus.completed);
          _completed == null
              ? close(delay: _closeWithDelay)
              : close(delay: _completed!.completionDelay);
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_cancel != null) ...[
              _cancel!.autoHidden && value == _maxValue
                  ? SizedBox.shrink()
                  : _createCancelButton(),
            ],
            Row(
              children: [
                value == _maxValue && _completed != null
                    ? Image(
                        width: 40,
                        height: 40,
                        image: _completed!.completedImage ??
                            AssetImage(
                              "images/completed.png",
                              package: "sn_progress_dialog",
                            ),
                      )
                    : Container(
                        width: 35.0,
                        height: 35.0,
                        child: value == 0
                            ? _normalProgress(
                                bgColor: _progressBgColor,
                                valueColor: _progressValueColor,
                              )
                            : _valueProgress(
                                valueColor: _progressValueColor,
                                bgColor: _progressBgColor,
                                value: (value / _maxValue) * 100,
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
                      value == _maxValue && _completed != null
                          ? _completed!.completedMsg
                          : _message.value,
                      textAlign: _messageTextAlign,
                      maxLines: _messageMaxLines,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: _messageFontSize,
                        color: _messageTextColor,
                        fontWeight: _messageFontWeight,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            _hideValue == false
                ? Align(
                    child: Text(
                      value <= 0 ? '' : '${_progress.value}/$_maxValue',
                      style: TextStyle(
                        fontSize: _valueFontSize,
                        color: _valueColor,
                        fontWeight: _valueFontWeight,
                        decoration: value == _maxValue
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    alignment: _valuePosition == ValuePosition.right
                        ? Alignment.bottomRight
                        : Alignment.bottomCenter,
                  )
                : SizedBox.shrink()
          ],
        );
      },
    );
  }

  Widget _createIndeterminate() {
    return ValueListenableBuilder(
      valueListenable: _message,
      builder: (BuildContext context, dynamic value, Widget? child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_cancel != null) ...[
              _createCancelButton(),
            ],
            Row(
              children: [
                Container(
                  width: 35.0,
                  height: 35.0,
                  child: _normalProgress(
                    bgColor: _progressBgColor,
                    valueColor: _progressValueColor,
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
                      _message.value,
                      textAlign: _messageTextAlign,
                      maxLines: _messageMaxLines,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: _messageFontSize,
                        color: _messageTextColor,
                        fontWeight: _messageFontWeight,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
