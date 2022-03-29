import 'package:objectbox/objectbox.dart';

import './word.dart';

@Entity()
class Review {
  /// Auto increment id
  int id = 0;

  /// Easiness factor for the spaced repetition algorithm.
  ///
  /// Default value 2.5.
  double ef = 2.5;

  /// Number of days for the next review.
  int interval = 0;

  /// Number of consecutive correct answers.
  @Property(type: PropertyType.byte)
  int repetition = 0;

  /// Number of correct answers.
  int correctAnswers = 0;

  /// Number of incorrect answers.
  int incorrectAnswers = 0;

  /// Date of the next review.
  @Property(type: PropertyType.date)
  DateTime? nextDate;

  /// Type of this review (meaning or reading).
  String type;

  /// Word related of this review.
  final word = ToOne<Word>();

  Review({
    required this.id,
    required this.ef,
    required this.interval,
    required this.repetition,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.nextDate,
    required this.type,
  });

  Review copyWith({
    double? ef,
    int? interval,
    int? repetition,
    int? correctAnswers,
    int? incorrectAnswers,
    DateTime? nextDate,
    String? type,
  }) {
    return Review(
      id: id,
      ef: ef ?? this.ef,
      interval: interval ?? this.interval,
      repetition: repetition ?? this.repetition,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      incorrectAnswers: incorrectAnswers ?? this.incorrectAnswers,
      nextDate: nextDate ?? this.nextDate,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ef': ef,
      'interval': interval,
      'repetition': repetition,
      'correctAnswers': correctAnswers,
      'incorrectAnswers': incorrectAnswers,
      'nextDate': nextDate?.millisecondsSinceEpoch,
      'type': type,
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id']?.toInt() ?? 0,
      ef: map['ef']?.toDouble() ?? 0.0,
      interval: map['interval']?.toInt() ?? 0,
      repetition: map['repetition']?.toInt() ?? 0,
      correctAnswers: map['correctAnswers']?.toInt() ?? 0,
      incorrectAnswers: map['incorrectAnswers']?.toInt() ?? 0,
      nextDate: map['nextDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['nextDate'])
          : null,
      type: map['type'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Review(id: $id, ef: $ef, interval: $interval, repetition: $repetition, correctAnswers: $correctAnswers, incorrectAnswers: $incorrectAnswers, nextDate: $nextDate, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Review &&
        other.id == id &&
        other.ef == ef &&
        other.interval == interval &&
        other.repetition == repetition &&
        other.correctAnswers == correctAnswers &&
        other.incorrectAnswers == incorrectAnswers &&
        other.nextDate == nextDate &&
        other.type == type;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        ef.hashCode ^
        interval.hashCode ^
        repetition.hashCode ^
        correctAnswers.hashCode ^
        incorrectAnswers.hashCode ^
        nextDate.hashCode ^
        type.hashCode;
  }
}
