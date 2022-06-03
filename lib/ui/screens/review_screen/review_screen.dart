import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/review_bloc.dart';
import '../../../config/routes.gr.dart';
import '../../widgets/loading_indicator.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ReviewBloc, ReviewState>(
        bloc: BlocProvider.of<ReviewBloc>(context)..add(ReviewSessionStarted()),
        builder: (context, state) {
          if (state is ReviewLoaded || state is ReviewEmpty) {
            final total = state is ReviewLoaded ? state.total : 0;
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "$total items",
                    style: const TextStyle(fontSize: 24.0),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed:
                        total > 0 ? () => _onStartSession(context) : null,
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text("Start Review Session"),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: LoadingIndicator(message: "Loading reviews..."),
            );
          }
        },
      ),
    );
  }

  void _onStartSession(context) {
    AutoRouter.of(context).push(const ReviewSessionScreen());
  }
}
