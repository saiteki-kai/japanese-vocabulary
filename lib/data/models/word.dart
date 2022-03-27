import 'package:collection/collection.dart';
import 'package:objectbox/objectbox.dart';

import './review.dart';

@Entity()
class Word {
  /// Auto increment id
  int id = 0;

  /// Text of this word.
  @Index()
  String text;

  /// Reading of this word.
  @Index()
  String reading;

  /// A number corresponding to the JLPT level N5 to N1 of this word.
  @Property(type: PropertyType.byte)
  int jlpt;

  /// List of meanings of this word.
  List<String> meanings = [];

  /// List of part of speeches of this word.
  List<String> pos = [];

  Word({
    required this.id,
    required this.text,
    required this.reading,
    required this.jlpt,
    required this.meanings,
    required this.pos,
  });

  /// Review related to meaning of this word.
  final meaningReview = ToOne<Review>();

  /// Review related to reading of this word.
  final readingReview = ToOne<Review>();

  Word copyWith({
    String? text,
    String? reading,
    int? jlpt,
    List<String>? meanings,
    List<String>? pos,
  }) {
    return Word(
      id: id,
      text: text ?? this.text,
      reading: reading ?? this.reading,
      jlpt: jlpt ?? this.jlpt,
      meanings: meanings ?? this.meanings,
      pos: pos ?? this.pos,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'reading': reading,
      'jlpt': jlpt,
      'meanings': meanings,
      'pos': pos,
    };
  }

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      id: map['id']?.toInt() ?? 0,
      text: map['text'] ?? '',
      reading: map['reading'] ?? '',
      jlpt: map['jlpt']?.toInt() ?? 0,
      meanings: List<String>.from(map['meanings']),
      pos: List<String>.from(map['pos']),
    );
  }

  @override
  String toString() {
    return 'Word(id: $id, text: $text, reading: $reading, jlpt: $jlpt, meanings: $meanings, pos: $pos)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is Word &&
        other.id == id &&
        other.text == text &&
        other.reading == reading &&
        other.jlpt == jlpt &&
        listEquals(other.meanings, meanings) &&
        listEquals(other.pos, pos);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        text.hashCode ^
        reading.hashCode ^
        jlpt.hashCode ^
        meanings.hashCode ^
        pos.hashCode;
  }
}
