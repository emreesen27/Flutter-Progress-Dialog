# sn_progress_dialog example

```dart
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
        child: Text('Sn Progress Example'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.download_sharp),
        onPressed: () async {
          /// Create progress dialog
          ProgressDialog pd = ProgressDialog(context: context);

          /// Set options
          pd.show(max: 100, msg: 'file Downloading');

          for (int i = 0; i <= 100; i++) {
            /// You don't need to update state, just pass the value.
            pd.update(i);
            i++;
            await Future.delayed(Duration(milliseconds: 100));
          }
        },
      ),
    );
  }
}
```
