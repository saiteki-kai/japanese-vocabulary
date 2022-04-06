import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/review_bloc.dart';
import '../../../data/models/review.dart';
import '../../../data/repositories/review_repository.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/screen_layout.dart';
import 'widgets/next_review_button.dart';
import 'widgets/review_answer.dart';
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
class ReviewSessionScreen extends StatefulWidget implements AutoRouteWrapper {
  const ReviewSessionScreen({Key? key}) : super(key: key);

  @override
  State<ReviewSessionScreen> createState() => _ReviewSessionScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => ReviewBloc(repository: ReviewRepository()),
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
      body: ScreenLayout(
        appBar: const ReviewSessionAppBar(),
        child: BlocBuilder<ReviewBloc, ReviewState>(
          builder: (context, state) {
            if (state is ReviewLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(flex: 1),
                  // Word information for the review
                  ReviewItem(
                    review: state.review,
                    hidden: _hideAnswer,
                    onToggleAnswer: _onToggleAnswer,
                  ),
                  const Spacer(flex: 1),
                  // Answer to show/hide
                  ReviewAnswer(review: state.review, hidden: _hideAnswer),
                  const Spacer(flex: 2),
                  // Quality buttons
                  ReviewQualitySelector(
                    disabled: _hideAnswer,
                    onQualitySelected: (q) => _selectedQuality.value = q,
                  ),
                  const Spacer(flex: 1),
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
        ),
      ),
    );
  }

  /// Updates the review based on the quality value and provide the next one.
  ///
  /// The [_hideAnswer] and [_selectedQuality] are reset.
  void _nextReview(Review review, int quality) {
    _bloc?.add(ReviewSessionUpdated(review, quality));

    _hideAnswer.value = true;
    _selectedQuality.value = -1;
  }

  /// Toggles visibility of the answer controlled by [_hideAnswer].
  ///
  /// Resets the [_selectedQuality] to -1.
  void _onToggleAnswer() {
    _hideAnswer.value = !_hideAnswer.value;

    if (!_hideAnswer.value) {
      _selectedQuality.value = -1;
    }
  }
}
