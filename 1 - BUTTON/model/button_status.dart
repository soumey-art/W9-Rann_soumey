class ButtonStatus {
  final String title;
  final bool selected;

  const ButtonStatus({required this.title, required this.selected});

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

  ButtonStatus copyWith({String? title, bool? selected}) => ButtonStatus(
    title: title ?? this.title,
    selected: selected ?? this.selected,
  );
}
