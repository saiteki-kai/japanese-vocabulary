import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/review_bloc.dart';
import '../../../../data/models/review.dart';
import '../../../../data/repositories/review_repository.dart';
import '../../../widgets/loading_indicator.dart';
import '../../../widgets/screen_layout.dart';
import 'next_review_button.dart';
import 'review_answer.dart';
import 'review_item.dart';
import 'review_quality_selector.dart';
import 'review_session_appbar.dart';

class ReviewSession extends StatefulWidget implements AutoRouteWrapper {
  const ReviewSession({Key? key}) : super(key: key);

  @override
  State<ReviewSession> createState() => _ReviewSessionState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => ReviewBloc(repository: ReviewRepository()),
      child: this,
    );
  }
}

class _ReviewSessionState extends State<ReviewSession> {
  ReviewBloc? _bloc;

  final _hideAnswer = ValueNotifier(true);
  final _selectedQuality = ValueNotifier(-1);

  @override
  void initState() {
    _bloc = BlocProvider.of<ReviewBloc>(context);
    _bloc?.add(ReviewRetrieved());

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

  void _nextReview(Review review, int quality) {
    _bloc?.add(ReviewUpdated(review, quality));

    _hideAnswer.value = true;
    _selectedQuality.value = -1;
  }

  void _onToggleAnswer() {
    _hideAnswer.value = !_hideAnswer.value;

    if (!_hideAnswer.value) {
      _selectedQuality.value = -1;
    }
  }
}
