import 'package:flutter/material.dart';

enum ValuePosition {
  center,
  right,
}

class ProgressDialog {
  final ValueNotifier _progress = ValueNotifier(0);
  bool _dialogIsOpen = false;
  BuildContext _context;

  ProgressDialog({@required context}) {
    this._context = context;
  }

  void update(int value) {
    _progress.value = value;
  }

  void close() {
    if (_dialogIsOpen) {
      Navigator.pop(_context);
      _dialogIsOpen = false;
    }
  }

  bool isOpen() {
    return _dialogIsOpen;
  }

  show({
    @required int max,
    @required String msg,
    Color backgroundColor: Colors.white70,
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
                        msg,
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
                    '${_progress.value}/$max',
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
