import 'package:objectbox/objectbox.dart';

@Entity()
class Sentence {
  Sentence({
    this.id = 0,
    required this.text,
    required this.translation,
  });

  /// Auto increment id
  int id;

  /// Text of this word.
  @Index()
  String text;

  /// Reading of this word.
  @Index()
  String translation;

  Sentence copyWith({
    String? text,
    String? translation,
  }) {
    return Sentence(
      id: id,
      text: text ?? this.text,
      translation: translation ?? this.translation,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'translation': translation,
    };
  }

  factory Sentence.fromMap(Map<String, dynamic> map) {
    return Sentence(
      id: map['id']?.toInt() ?? 0,
      text: map['text'] ?? '',
      translation: map['translation'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Sentece(id: $id, text: $text, translation: $translation)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Sentence &&
        other.id == id &&
        other.text == text &&
        other.translation == translation;
  }

  @override
  int get hashCode {
    return id.hashCode ^ text.hashCode ^ translation.hashCode;
  }
}
