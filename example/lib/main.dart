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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(
            'Sn Progress Example',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.download_sharp),
        onPressed: () async {
          /// Create progress dialog
          ProgressDialog pd = ProgressDialog(context: context);

          /// Set options
          ///max and msg required
          pd.show(
            max: 100,
            msg: 'Preparing Download...',
            progressType: ProgressType.valuable
          );
          await Future.delayed(Duration(milliseconds: 3000));
          for (int i = 0; i <= 100; i++) {
            /// You don't need to update state, just pass the value.
            /// only value required
            pd.update(value: i, msg: 'File Downloading...');
            i++;
            await Future.delayed(Duration(milliseconds: 100));
          }
        },
      ),
    );
  }
}
