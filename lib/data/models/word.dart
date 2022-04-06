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

  /// Meaning of this word.
  @Index()
  String meaning;

  /// Part of speech of this word.
  @Index()
  String pos;

  Word({
    id,
    required this.text,
    required this.reading,
    required this.jlpt,
    required this.meaning,
    required this.pos,
  });

  /// Review related to meaning of this word.
  final meaningReview = ToOne<Review>();

  /// Review related to reading of this word.
  final readingReview = ToOne<Review>();

  double get meanAccuracy {
    if (meaningReview.target != null || readingReview.target != null) {
      return 0.0;
    }
    return (meaningReview.target!.getReviewAccuracy() +
            readingReview.target!.getReviewAccuracy()) /
        2;
  }

  DateTime? get nextReview {
    if (meaningReview.target?.nextDate == null &&
        readingReview.target?.nextDate == null) return null;

    var r1 = 8640000000000000; // maxMillisecondsSinceEpoch
    var r2 = 8640000000000000; // maxMillisecondsSinceEpoch

    if (meaningReview.target?.nextDate != null) {
      r1 = meaningReview.target!.nextDate!.millisecondsSinceEpoch;
    }
    if (readingReview.target?.nextDate != null) {
      r2 = readingReview.target!.nextDate!.millisecondsSinceEpoch;
    }

    if (r1 < r2) return readingReview.target!.nextDate;
    return readingReview.target!.nextDate;
  }

  Word copyWith({
    String? text,
    String? reading,
    int? jlpt,
    String? meaning,
    String? pos,
  }) {
    return Word(
      id: id,
      text: text ?? this.text,
      reading: reading ?? this.reading,
      jlpt: jlpt ?? this.jlpt,
      meaning: meaning ?? this.meaning,
      pos: pos ?? this.pos,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'reading': reading,
      'jlpt': jlpt,
      'meaning': meaning,
      'pos': pos,
    };
  }

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      id: map['id']?.toInt() ?? 0,
      text: map['text'] ?? '',
      reading: map['reading'] ?? '',
      jlpt: map['jlpt']?.toInt() ?? 0,
      meaning: map['meaning'] ?? '',
      pos: map['pos'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Word(id: $id, text: $text, reading: $reading, jlpt: $jlpt, meaning: $meaning, pos: $pos)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Word &&
        other.id == id &&
        other.text == text &&
        other.reading == reading &&
        other.jlpt == jlpt &&
        other.meaning == meaning &&
        other.pos == pos;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        text.hashCode ^
        reading.hashCode ^
        jlpt.hashCode ^
        meaning.hashCode ^
        pos.hashCode;
  }
}
