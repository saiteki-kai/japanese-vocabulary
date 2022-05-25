import 'dart:core';
import 'dart:math';

import 'package:objectbox/objectbox.dart';

import 'sort_option.dart';
import 'review.dart';
import 'sentence.dart';

@Entity()
class Word {
  Word({
    this.id = 0,
    required this.text,
    required this.reading,
    required this.jlpt,
    required this.meaning,
    required this.pos,
  });

  /// Auto increment id
  int id;

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

  /// Review related to meaning of this word.
  final meaningReview = ToOne<Review>();

  /// Review related to reading of this word.
  final readingReview = ToOne<Review>();

  /// Sentences related to this
  final sentences = ToMany<Sentence>();

  double get meanAccuracy {
    final acc1 = meaningReview.target?.getReviewAccuracy() ?? 0.0;
    final acc2 = readingReview.target?.getReviewAccuracy() ?? 0.0;

    if (meaningReview.target != null && readingReview.target != null) {
      return (acc1 + acc2) / 2;
    }

    return acc1 + acc2;
  }

  DateTime? get nextReview {
    final meaningNextDate = meaningReview.target?.nextDate;
    final readingNextDate = readingReview.target?.nextDate;

    if (meaningNextDate == null && readingNextDate == null) {
      return null;
    }

    const maxMilliseconds = 8640000000000000;

    final r1 = meaningNextDate?.millisecondsSinceEpoch ?? maxMilliseconds;
    final r2 = readingNextDate?.millisecondsSinceEpoch ?? maxMilliseconds;

    if (r1 < r2) {
      return meaningNextDate;
    }

    return readingNextDate;
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

  static int _sortByNextReview(Word a, Word b) {
    const maxMilliseconds = 8640000000000000;

    final dateA = a.nextReview?.millisecondsSinceEpoch ?? maxMilliseconds;
    final dateB = b.nextReview?.millisecondsSinceEpoch ?? maxMilliseconds;

    return dateA.compareTo(dateB);
  }

  static int _sortByStreak(Word a, Word b) {
    final streakAR = a.readingReview.target?.repetition ?? 0;
    final streakAM = a.meaningReview.target?.repetition ?? 0;

    final streakBR = b.readingReview.target?.repetition ?? 0;
    final streakBM = b.meaningReview.target?.repetition ?? 0;

    return max(streakAR, streakAM).compareTo(max(streakBR, streakBM));
  }

  static int _sortByText(Word a, Word b) {
    return a.text.compareTo(b.text);
  }

  static int _sortByAccuracy(Word a, Word b) {
    return a.meanAccuracy.compareTo(b.meanAccuracy);
  }

  static int sortBy(Word a, Word b, {SortField? attribute, bool? descending}) {
    // switch arguments
    if (descending ?? false) {
      final c = a;
      a = b;
      b = c;
    }

    switch (attribute) {
      case SortField.streak:
        return _sortByStreak(a, b);
      case SortField.date:
        return _sortByNextReview(a, b);
      case SortField.accuracy:
        return _sortByAccuracy(a, b);
      case SortField.text:
      default:
        return _sortByText(a, b);
    }
  }
}
