import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/word_bloc.dart';
import '../../../data/repositories/word_repository.dart';
import '../../widgets/insert_word_widget.dart';

class InsertItemScreen extends StatefulWidget {
  const InsertItemScreen({Key? key}) : super(key: key);

  @override
  State<InsertItemScreen> createState() => _InsertItemScreenState();
}

class _InsertItemScreenState extends State<InsertItemScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WordBloc(
        repository: WordRepository(),
      ),
      child: InsertWord(),
    );
  }
}
