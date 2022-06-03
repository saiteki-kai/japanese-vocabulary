import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/review_bloc.dart';
import '../../../data/models/review.dart';
import '../../../data/models/word.dart';
import '../../../utils/hints.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/screen_layout.dart';
import 'widgets/next_review_button.dart';
import 'widgets/review_answer.dart';
import 'widgets/review_hint.dart';
import 'widgets/review_item.dart';
import 'widgets/review_quality_selector.dart';
import 'widgets/review_session_appbar.dart';

/// A widget that handles a review session.
///
/// A session consists of a series of reviews presented in a [ReviewItem],
/// each of which allows you to show or hide the [ReviewAnswer]. When the answer
/// is shown, [ReviewQualitySelector] is enabled and allows you to choose a
/// quality value. Then [NextReviewButton] allows you to move on to the next
/// review or, if there are no more, to go to the summary.
class ReviewSessionScreen extends StatefulWidget {
  const ReviewSessionScreen({Key? key}) : super(key: key);

  @override
  State<ReviewSessionScreen> createState() => _ReviewSessionScreenState();
}

class _ReviewSessionScreenState extends State<ReviewSessionScreen> {
  /// A boolean value that handles when show or hide the [ReviewAnswer] and
  /// enable the [ReviewQualitySelector].
  final _hideAnswer = ValueNotifier<bool>(true);

  /// The selected quality value. If the value is -1 the [NextReviewButton] is
  /// disabled.
  final _selectedQuality = ValueNotifier<int>(-1);

  /// A [Hint] value containing the current hint to show.
  ///
  /// The initial value is set to [Hint.empty].
  final _hint = ValueNotifier<Hint>(Hint.empty());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: ScreenLayout(
          appBar: const ReviewSessionAppBar(),
          child: BlocConsumer<ReviewBloc, ReviewState>(
            builder: (context, state) {
              if (state is ReviewLoaded) {
                final word = state.review.word.target;

                if (word == null) {
                  return const Text("Error");
                }

                // Initialize the value based on the reading of the word
                _hint.value = Hint.fromReading(word.reading);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(flex: 1),
                    // Word information for the review
                    ReviewItem(
                      review: state.review,
                      hidden: _hideAnswer,
                      onToggleAnswer: _onToggleAnswer,
                      hint: _hint,
                      onAskHint: () => _onAskHint(word, state.review.type),
                    ),
                    const Spacer(flex: 1),
                    // Answer to show/hide
                    Expanded(
                      child: ReviewAnswer(
                        review: state.review,
                        hidden: _hideAnswer,
                      ),
                    ),
                    const Spacer(flex: 1),
                    // Hint to show
                    ReviewHint(hint: _hint),
                    const Spacer(flex: 1),
                    // Quality buttons
                    ReviewQualitySelector(
                      disabled: _hideAnswer,
                      hint: _hint,
                      onQualitySelected: (q) => _selectedQuality.value = q,
                    ),
                    // Next/Summary button
                    NextReviewButton(
                      isLast: state.isLast,
                      selectedQuality: _selectedQuality,
                      onPressed: (q) => _nextReview(state.review, q),
                    ),
                  ],
                );
              } else {
                return const LoadingIndicator(message: "Loading Reviews...");
              }
            },
            listener: _reviewBlocListener,
            buildWhen: _reviewBlocBuildWhen,
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    BlocProvider.of<ReviewBloc>(context).add(ReviewSessionStarted());
    return true;
  }

  /// Defines when to build the widget.
  bool _reviewBlocBuildWhen(ReviewState before, ReviewState after) {
    return before is! ReviewFinished;
  }

  /// When there is an error returns to the home page.
  void _reviewBlocListener(BuildContext context, ReviewState state) {
    if (state is ReviewFinished) {
      AutoRouter.of(context).pop();
    }
  }

  /// Updates the review based on the quality value and provide the next one.
  ///
  /// The [_hideAnswer] and [_selectedQuality] are reset.
  void _nextReview(Review review, int quality) {
    final _bloc = BlocProvider.of<ReviewBloc>(context);
    _bloc.add(ReviewSessionUpdated(review: review, quality: quality));

    _hideAnswer.value = true;
    _selectedQuality.value = -1;
  }

  /// Toggles visibility of the answer controlled by [_hideAnswer].
  ///
  /// Resets the [_selectedQuality] to -1.
  void _onToggleAnswer() {
    _hideAnswer.value = !_hideAnswer.value;

    if (_hideAnswer.value) {
      _selectedQuality.value = -1;
    }
  }

  /// Updates the current Hint with the next one based on the [reviewType] of a
  /// given [Word].
  ///
  /// When there are no hints sets [_hideAnswer.value] to false.
  void _onAskHint(Word word, String reviewType) {
    if (reviewType == "reading") {
      _hint.value = _hint.value.getNextReadingHint(word.reading);
    }

    // if there are no more hints show the answer and enable the next button
    if (_hint.value.n == _hint.value.max) {
      _hideAnswer.value = false;
    }
  }
}
