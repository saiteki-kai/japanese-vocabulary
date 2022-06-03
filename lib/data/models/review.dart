import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';

import './word.dart';

@Entity()
// ignore: must_be_immutable
class Review extends Equatable {
  Review({
    this.id = 0,
    this.ef = 2.5,
    this.interval = 0,
    this.repetition = 0,
    this.correctAnswers = 0,
    this.incorrectAnswers = 0,
    this.nextDate,
    required this.type,
  });

  /// Auto increment Id
  int id;

  /// Easiness factor for the spaced repetition algorithm.
  ///
  /// Default value 2.5.
  final double ef;

  /// Number of days for the next review.
  final int interval;

  /// Number of consecutive correct answers.
  @Property(type: PropertyType.byte)
  final int repetition;

  /// Number of correct answers.
  final int correctAnswers;

  /// Number of incorrect answers.
  final int incorrectAnswers;

  /// Date of the next review.
  @Property(type: PropertyType.date)
  final DateTime? nextDate;

  /// Type of this review (meaning or reading).
  final String type;

  /// Word related of this review.
  final word = ToOne<Word>();

  /// Return the accuracy of the review.
  ///
  /// Return zero if the sum between the correctAnswers and the incorrectAnswers is zero.
  double getReviewAccuracy() {
    final totalAnswers = correctAnswers + incorrectAnswers;
    if (totalAnswers == 0.0) {
      return 0.0;
    } else {
      return correctAnswers / totalAnswers;
    }
  }

  Review copyWith({
    double? ef,
    int? interval,
    int? repetition,
    int? correctAnswers,
    int? incorrectAnswers,
    DateTime? nextDate,
    String? type,
  }) {
    final review = Review(
      id: id,
      ef: ef ?? this.ef,
      interval: interval ?? this.interval,
      repetition: repetition ?? this.repetition,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      incorrectAnswers: incorrectAnswers ?? this.incorrectAnswers,
      nextDate: nextDate ?? this.nextDate,
      type: type ?? this.type,
    );

    review.word.target = word.target;

    return review;
  }

  @override
  List<Object?> get props {
    return [
      id,
      ef,
      interval,
      repetition,
      correctAnswers,
      incorrectAnswers,
      nextDate,
      type,
      word.targetId,
    ];
  }

  @override
  bool? get stringify => true;
}
