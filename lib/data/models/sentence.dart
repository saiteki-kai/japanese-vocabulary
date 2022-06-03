import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
// ignore: must_be_immutable
class Sentence extends Equatable {
  Sentence({
    this.id = 0,
    required this.text,
    required this.translation,
  });

  /// Auto increment id
  int id;

  /// Text of this sentence.
  final String text;

  /// Translation of this sentence.
  final String translation;

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

  @override
  String toString() {
    return 'Sentence(id: $id, text: $text, translation: $translation)';
  }

  @override
  List<Object?> get props => [id, text, translation];
}
