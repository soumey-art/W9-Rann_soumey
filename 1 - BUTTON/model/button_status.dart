class ButtonStatus {
  final String title;
  final bool selected;

  const ButtonStatus({required this.title, required this.selected});

  /// Converts the raw Firebase JSON (Map<String, dynamic>) into a
  /// ButtonStatus object, asserting the expected keys are present.
  factory ButtonStatus.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('title') || !json.containsKey('selected')) {
      throw const FormatException(
        'Firebase data does not contain the expected keys (title, selected)',
      );
    }
    return ButtonStatus(
      title: json['title'] as String,
      selected: json['selected'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {'title': title, 'selected': selected};

  /// Handy helper to flip the selection locally after a successful update.
  ButtonStatus copyWith({String? title, bool? selected}) => ButtonStatus(
    title: title ?? this.title,
    selected: selected ?? this.selected,
  );
}
