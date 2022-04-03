import 'package:flutter/material.dart';
import 'package:japanese_vocabulary/ui/widgets/insert_word_widget.dart';

import 'insert_item_screens/insert_item_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: Center(
          child: InsertItemScreen(),
        ),
      ),
    );
  }
}
