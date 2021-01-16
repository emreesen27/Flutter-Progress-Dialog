# Sn Progress Dialog

Progress dialog package for flutter

## Getting Started

You must add the library as a dependency to your project.
```yaml
dependencies:
 sn_progress_dialog: ^0.0.2
```

You should then run `flutter packages get`

Now in your Dart code, you can use:

```dart
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
```

<img src='https://github.com/emreesen27/Flutter-Progress-Dialog/blob/assets/egg.gif?raw=true'/>

## Usage Example

Create Progress Dialog

```dart
ProgressDialog pd = ProgressDialog(context: context);
```
Set options

```dart
pd.show(max: 100, msg: 'File Downloading...');
```

You don't need to update state, just pass the value.
 
```dart
pd.update(prrogress value);
```

### Other Properties

Dialog closes automatically when its progress status equals the max value.
Use this method if you want to turn it close manually.

```dart
pd.close();
```
Returns whether the dialog box is open.

```dart
pd.isOpen();
```

### Example Use With Dio

```dart 
var dio = new Dio();
ProgressDialog pd = ProgressDialog(context: context);
pd.show(max: 100, msg: 'File Downloading...');
await dio.download(
  'your download_url',
  'your path',
  onReceiveProgress: (rec, total) {
    int progress = (((rec / total) * 100).toInt());
    pd.update(progress);
  },
);
```

### Customization

```dart
pd.show(
  max: 100,
  msg: 'File Downloading...',
  msgColor: Colors.white,
  backgroundColor: Color(0xff212121),
  progressValueColor: Color(0xff3550B4),
  valueColor: Colors.white,
);
```
<img src='https://github.com/emreesen27/Flutter-Progress-Dialog/blob/assets/egs.png?raw=true'/>
