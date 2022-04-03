import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';

class ReviewQualitySelector extends StatelessWidget {
  const ReviewQualitySelector({
    Key? key,
    required this.disabled,
    required this.onQualitySelected,
  }) : super(key: key);

  final ValueNotifier<bool> disabled;
  final void Function(int) onQualitySelected;

  /// The possible values of quality to be selected
  final _options = const [0, 1, 2, 3, 4, 5];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: disabled,
      builder: (BuildContext _, bool value, Widget? __) {
        return GroupButton(
          options: GroupButtonOptions(
            groupingType: GroupingType.row,
            borderRadius: BorderRadius.circular(8.0),
            spacing: 4.0,
            buttonWidth: 50,
            unselectedColor: Theme.of(context).primaryColorLight,
            unselectedTextStyle: Theme.of(context)
                .textTheme
                .button
                ?.copyWith(color: Theme.of(context).primaryColor),
          ),
          controller: GroupButtonController(
            disabledIndexes: value ? _options : [],
          ),
          buttons: _options.map((e) => e.toString()).toList(),
          onSelected: (i, _) => onQualitySelected(i),
        );
      },
    );
  }
}
