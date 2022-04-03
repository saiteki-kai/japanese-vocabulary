import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import '../../../utils/colors.dart';
import '../../widgets/insert_word_widget.dart';
import '../../widgets/screen_layout.dart';

class InsertItemScreen extends StatefulWidget {
  const InsertItemScreen({Key? key}) : super(key: key);

  @override
  State<InsertItemScreen> createState() => _InsertItemScreenState();
}

class _InsertItemScreenState extends State<InsertItemScreen> {
  @override
  Widget build(BuildContext context) {
    return InsertWord();
  }
}
