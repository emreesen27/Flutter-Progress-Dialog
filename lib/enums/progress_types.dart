enum ProgressType {
  /// Indeterminate progress indicator
  @Deprecated(
      'Use indeterminate instead. This will be removed in the next major version.')
  normal,

  /// Progress indicator with value
  @Deprecated(
      'Use determinate instead. This will be removed in the next major version.')
  valuable,

  /// Shows an infinite spinning progress indicator without specific progress value
  indeterminate,

  /// Shows progress with specific value (0-100%)
  determinate,
}

extension ProgressTypeHelper on ProgressType {
  bool get isIndeterminate =>
      this == ProgressType.normal || this == ProgressType.indeterminate;

  bool get isDeterminate =>
      this == ProgressType.valuable || this == ProgressType.determinate;
}
