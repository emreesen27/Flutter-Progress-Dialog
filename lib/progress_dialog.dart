import 'package:flutter/material.dart';

enum ValuePosition {
  center,
  right,
}

class ProgressDialog {
  /// [_progress] listens to the value of progress.
  //  not directly accessible
  final ValueNotifier _progress = ValueNotifier(0);
  final ValueNotifier _msg = ValueNotifier('');

  /// shows whether the dialog is open.
  //  not directly accessible
  bool _dialogIsOpen = false;

  // can only be accessed with the constructor.
  BuildContext _context;

  ProgressDialog({@required context}) {
    this._context = context;
  }

  //  Pass the new value to this method to update the status.
  //  msg not required
  void update({@required int value, String msg}) {
    _progress.value = value;
    if (msg != null) _msg.value = msg;
  }

  //  closes the progress dialog.
  void close() {
    if (_dialogIsOpen) {
      Navigator.pop(_context);
      _dialogIsOpen = false;
    }
  }

  //  Returns whether the dialog box is open.
  bool isOpen() {
    return _dialogIsOpen;
  }

  /// [max] assign the maximum value of the upload. @required
  //  Dialog closes automatically when its progress status equals the max value.

  /// [msg] show a message @required

  /// [ValuePosition] location of progress value @not required
  // center or right  default: right

  show({
    @required int max,
    @required String msg,
    Color backgroundColor: Colors.white,
    Color progressValueColor: Colors.blueAccent,
    double msgFontSize: 17.0,
    Color msgColor: Colors.black87,
    FontWeight msqFontWeight: FontWeight.bold,
    double valueFontSize: 15.0,
    Color valueColor: Colors.black87,
    ValuePosition valuePosition: ValuePosition.right,
  }) {
    assert(max != null, 'max is null !');
    assert(msg != null, 'msg (message) is null !');

    _dialogIsOpen = true;
    _msg.value = msg;
    return showDialog(
      barrierDismissible: false,
      context: _context,
      builder: (context) => AlertDialog(
        backgroundColor: backgroundColor,
        content: ValueListenableBuilder(
          valueListenable: _progress,
          builder: (BuildContext context, value, Widget child) {
            if (value == max) close();
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 35.0,
                      height: 35.0,
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(progressValueColor),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15.0,
                        top: 8.0,
                        bottom: 8.0,
                      ),
                      child: Text(
                        _msg.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: msgFontSize,
                            color: msgColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Align(
                  child: Text(
                    value <= 0 ? '' : '${_progress.value}/$max',
                    style: TextStyle(
                      fontSize: valueFontSize,
                      color: valueColor,
                    ),
                  ),
                  alignment: valuePosition == ValuePosition.right
                      ? Alignment.bottomRight
                      : Alignment.bottomCenter,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
