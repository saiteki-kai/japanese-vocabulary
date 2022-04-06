import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';

/// A widget that allow you to select a quality level from 0 to 5.+
///
/// The selection is made through several buttons, each of which represents a specific quality level from 0 to 5.
class ReviewQualitySelector extends StatelessWidget {
  /// Create a widget that allow you to select a quality level from 0 to 5.
  ///
  /// The [disabled] and [onQualitySelected] parameters are required and must not be null.
  const ReviewQualitySelector({
    Key? key,
    required this.disabled,
    required this.onQualitySelected,
  }) : super(key: key);

  /// A boolean value that enable or disable all the buttons.
  final ValueListenable<bool> disabled;

  /// Called when a option is selected and returns its quality value.
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
