enum ProgressType {
  /// Shows an infinite spinning progress indicator without specific progress value
  indeterminate,

  /// Shows progress with specific value (0-100%)
  determinate,
}

extension ProgressTypeHelper on ProgressType {
  bool get isIndeterminate => this == ProgressType.indeterminate;

  bool get isDeterminate => this == ProgressType.determinate;
}
