import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../config/routes.gr.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            AutoRouter.of(context).push(const ReviewSessionScreen());
          },
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Start review session"),
          ),
        ),
      ),
    );
  }
}
