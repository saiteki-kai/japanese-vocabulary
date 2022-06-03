import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/review_bloc.dart';
import '../../../data/models/review.dart';
import '../../../data/models/word.dart';
import '../../../data/repositories/review_repository.dart';
import '../../../utils/hint.dart';
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

/// Also a certain numbers of hints for a word are displayed and accessed by the [ReviewItem].
/// that updates the current [hint] to be displayed in the [ReviewHint] and changes
/// the enabled values of the [ReviewQualitySelector].
/// The [hint] can be of two types [MeaningHint] or [ReadingHint].
class ReviewSessionScreen extends StatefulWidget implements AutoRouteWrapper {
  const ReviewSessionScreen({Key? key}) : super(key: key);

  @override
  State<ReviewSessionScreen> createState() => _ReviewSessionScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => ReviewBloc(
        repository: RepositoryProvider.of<ReviewRepository>(context),
      ),
      child: this,
    );
  }
}

class _ReviewSessionScreenState extends State<ReviewSessionScreen> {
  /// A [ReviewBloc] instance.
  ReviewBloc? _bloc;

  /// A boolean value that handles when show or hide the [ReviewAnswer] and
  /// enable the [ReviewQualitySelector].
  final _hideAnswer = ValueNotifier<bool>(true);

  /// The selected quality value. If the value is -1 the [NextReviewButton] is
  /// disabled.
  final _selectedQuality = ValueNotifier<int>(-1);

  /// A [Hint] value containing the current hint to show.
  ///
  /// The initial value is set to [Hint.empty].
  final _hint = ValueNotifier<Hint>(MeaningHint.empty());

  @override
  void initState() {
    _bloc = BlocProvider.of<ReviewBloc>(context);
    _bloc?.add(ReviewSessionStarted());

    super.initState();
  }

  @override
  void dispose() {
    _bloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ReviewBloc, ReviewState>(
        builder: (context, state) {
          if (state is ReviewLoaded) {
            final word = state.review.word.target;

            if (word == null) {
              return const Text("Error");
            }

            // Initialize the value based on the reading/meaning of the word
            final reviewType = state.review.type;
            if (reviewType == "reading") {
              _hint.value = ReadingHint.fromWord(word);
            } else if (reviewType == "meaning") {
              _hint.value = MeaningHint.fromWord(word);
            }

            return ScreenLayout(
              appBar: ReviewSessionAppBar(
                current: state.current,
                total: state.total,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(flex: 1),
                  // Word information for the review
                  ReviewItem(
                    review: state.review,
                    hidden: _hideAnswer,
                    onToggleAnswer: _onToggleAnswer,
                    hint: _hint,
                    onAskHint: () => _onAskHint(word),
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
              ),
            );
          } else {
            return const LoadingIndicator(message: "Loading Reviews...");
          }
        },
        listener: _reviewBlocListener,
        buildWhen: _reviewBlocBuildWhen,
      ),
    );
  }

  /// Defines when to build the widget.
  bool _reviewBlocBuildWhen(ReviewState before, ReviewState _) {
    return !(before is ReviewError || before is ReviewFinished);
  }

  /// When there is an error returns to the home page.
  void _reviewBlocListener(BuildContext context, ReviewState state) {
    if (state is ReviewError) {
      AutoRouter.of(context).pop();
    }
  }

  /// Updates the review based on the quality value and provide the next one.
  ///
  /// The [_hideAnswer] and [_selectedQuality] are reset.
  void _nextReview(Review review, int quality) {
    _bloc?.add(ReviewSessionUpdated(review: review, quality: quality));

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

  /// Updates the current Hint with the next one based on the review type of a
  /// given [Word].
  ///
  /// When there are no hints sets [_hideAnswer.value] to false.
  void _onAskHint(Word word) {
    _hint.value = _hint.value.getNextHint(word);

    // if there are no more hints show the answer and enable the next button
    if (_hint.value.n == _hint.value.max) {
      _hideAnswer.value = false;
    }
  }
}
