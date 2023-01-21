# Sn Progress Dialog

Progress dialog package for flutter

## Getting Started

You must add the library as a dependency to your project.
```yaml
dependencies:
 sn_progress_dialog: ^1.1.0
```

You should then run `flutter packages get`

Now in your Dart code, you can use:

```dart
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
```

 Normal Progress          |  Valuable Progress
:-------------------------:|:-------------------------:
![](https://github.com/emreesen27/Flutter-Progress-Dialog/blob/assets/normal.gif?raw=true) | ![](https://github.com/emreesen27/Flutter-Progress-Dialog/blob/assets/valuable.gif?raw=true)

 Preparing Progress          |  Custom Progress
:-------------------------:|:-------------------------:
![](https://github.com/emreesen27/Flutter-Progress-Dialog/blob/assets/preparing.gif?raw=true) | ![](https://github.com/emreesen27/Flutter-Progress-Dialog/blob/assets/custom.gif?raw=true)

## Usage Example

* [You can review the sample codes for detailed usage.](https://github.com/emreesen27/Flutter-Progress-Dialog/tree/master/example)

<!-- Place this tag where you want the button to render. -->
<a class="github-button" href="https://github.com/emreesen27/Flutter-Progress-Dialog" data-icon="octicon-star" aria-label="Star emreesen27/Flutter-Progress-Dialog on GitHub">Star</a>

Create Progress Dialog

```dart
ProgressDialog pd = ProgressDialog(context: context);
```
Set options

```dart
pd.show(max: 100, msg: 'File Downloading...');
```

You don't need to update state, just pass the value.
You can also update the msg value(optional)
 
```dart
pd.update(progress value);
```

### Completed Type
* Use this to update the dialog when the process is finished. If it is Empty, progress automatically closes.

<img src = "https://github.com/emreesen27/Flutter-Progress-Dialog/blob/assets/completed_type.png?raw=true" width=300>


```dart
 completed: Completed() // To use with default values
 completed: Completed(completedMsg: "Downloading Done !", completedImage: AssetImage("image path"), completionDelay: 2500)
```

### Cancel Option
* Use the "cancel" class to create a cancel button

```dart
cancel: Cancel() // To use with default values
cancel: Cancel( cancelImageSize: 20.0, cancelImageColor: Colors.blue, cancelImage: AssetImage("image path"), cancelClicked: () {})
```

### Dialog Status
* Returns the current state of the dialog.

```dart
onStatusChanged: (status) {
 if (status == DialogStatus.opened)
   print("opened");
 else if (status == DialogStatus.closed)
   print("closed");
 else if (status == DialogStatus.completed) 
   print("completed");
}
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
    pd.update(value: progress);
  },
);
```
#### If you like the library, you can support the [github](https://github.com/emreesen27/Flutter-Progress-Dialog) repo by giving a star.
