import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

void main() {
  runApp(MyExample());
}

class MyExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  _normalProgress(context) async {
    /// Create progress dialog
    ProgressDialog pd = ProgressDialog(context: context);

    /// Set options
    /// Max and msg required
    pd.show(
      max: 100,
      msg: 'File Downloading...',
      progressBgColor: Colors.transparent,
      cancel: Cancel(
        cancelClicked: () {
          /// ex: cancel the download
        },
      ),
    );
    for (int i = 0; i <= 100; i++) {
      /// You don't need to update state, just pass the value.
      pd.update(value: i);
      i++;
      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  /// Shows a progress dialog with a determinate progress bar.
  _valuableProgress(context) async {
    ProgressDialog pd = ProgressDialog(context: context);

    pd.show(
      max: 100,
      msg: 'File Downloading...',
      progressType: ProgressType.valuable,
    );
    for (int i = 0; i <= 100; i++) {
      pd.update(value: i);
      i++;
      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  /// Shows a progress dialog that starts with a preparation message,
  /// then switches to a downloading message.
  _preparingProgress(context) async {
    ProgressDialog pd = ProgressDialog(context: context);

    pd.show(
      max: 100,
      msg: 'Preparing Download...',
      progressType: ProgressType.determinate,
    );

    await Future.delayed(Duration(milliseconds: 3000));
    for (int i = 0; i <= 100; i++) {
      pd.update(value: i, msg: 'File Downloading...');
      i++;
      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  /// Shows a customizable progress dialog with a dark theme.
  _customProgress(context) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(
        max: 100,
        msg: 'Preparing Download...',
        progressType: ProgressType.determinate,
        backgroundColor: Color(0xff212121),
        progressValueColor: Color(0xff3550B4),
        progressBgColor: Colors.white70,
        msgColor: Colors.white,
        valueColor: Colors.white);
    await Future.delayed(Duration(milliseconds: 3000));
    for (int i = 0; i <= 100; i++) {
      pd.update(value: i, msg: 'File Downloading...');
      i++;
      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  /// Shows a progress dialog that completes with a custom completion widget.
  _completedProgress(context) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(
      max: 100,
      msg: 'File Downloading...',
      completed: Completed(),
      // Completed values can be customized
      // Completed(completedMsg: "Downloading Done !", completedImage: AssetImage("images/completed.png"), completionDelay: 2500,),
      progressBgColor: Colors.transparent,
    );
    for (int i = 0; i <= 100; i++) {
      pd.update(value: i);
      i++;
      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  /// Shows a message-only progress dialog without a progress bar.
  _onlyMessageProgress(context) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(
      barrierDismissible: true,
      msg: "Please waiting...",
      hideValue: true,
    );

    await Future.delayed(Duration(milliseconds: 1000));
    pd.update(msg: "Almost done...");

    await Future.delayed(Duration(milliseconds: 1000));
    pd.close();
  }

  /// Shows a message-only progress dialog that completes automatically.
  _onlyMessageWithCompletionProgress(context) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(
      barrierDismissible: true,
      msg: "Please waiting...",
      hideValue: true,
      completed: Completed(completionDelay: 1500), // Set Completed
    );
    await Future.delayed(Duration(milliseconds: 1000));

    pd.update(msg: "Almost done...");

    await Future.delayed(Duration(milliseconds: 1000));
    /**
     * if you can't assign value and want to use completed object. You should set the Value to 100.
     * The dialog will close automatically.
     * **/
    pd.update(value: 100);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Sn Progress Example',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              MaterialButton(
                  color: Color(0xfff7f7f7),
                  child: Text('Normal Progress'),
                  onPressed: () {
                    _normalProgress(context);
                  }),
              MaterialButton(
                  color: Color(0xfff7f7f7),
                  child: Text('Valuable Progress'),
                  onPressed: () {
                    _valuableProgress(context);
                  }),
              MaterialButton(
                  color: Color(0xfff7f7f7),
                  child: Text('Preparing Progress'),
                  onPressed: () {
                    _preparingProgress(context);
                  }),
              MaterialButton(
                  color: Color(0xfff7f7f7),
                  child: Text('Custom Progress'),
                  onPressed: () {
                    _customProgress(context);
                  }),
              MaterialButton(
                  color: Color(0xfff7f7f7),
                  child: Text('Completed Progress'),
                  onPressed: () {
                    _completedProgress(context);
                  }),
              MaterialButton(
                  color: Color(0xfff7f7f7),
                  child: Text('Message Progress'),
                  onPressed: () {
                    _onlyMessageProgress(context);
                  }),
              MaterialButton(
                  color: Color(0xfff7f7f7),
                  child: Text('Message Progress With Completed'),
                  onPressed: () {
                    _onlyMessageWithCompletionProgress(context);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
