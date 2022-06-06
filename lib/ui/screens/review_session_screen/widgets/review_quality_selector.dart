import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';

import '../../../../utils/hint.dart';

/// A widget that allow you to select a quality level from 0 to 5.
///
/// The selection is made through several buttons, each of which represents a
/// specific quality level from 0 to 5.
///
/// The quality levels can be enabled or disabled based on the [hint] value.
class ReviewQualitySelector extends StatelessWidget {
  /// Create a widget that allow you to select a quality level from 0 to 5.
  ///
  /// The [disabled], [hint] and [onQualitySelected] parameters are required and
  /// must not be null.
  const ReviewQualitySelector({
    Key? key,
    required this.disabled,
    required this.hint,
    required this.onQualitySelected,
  }) : super(key: key);

  /// A boolean value that enable or disable all the buttons.
  final ValueListenable<bool> disabled;

  final ValueListenable<Hint> hint;

  /// Called when a option is selected and returns its quality value.
  final void Function(int) onQualitySelected;

  /// The possible values of quality to be selected
  final _options = const [0, 1, 2, 3, 4, 5];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ValueListenableBuilder(
      valueListenable: hint,
      builder: (BuildContext _, Hint hintValue, Widget? __) {
        return ValueListenableBuilder(
          valueListenable: disabled,
          builder: (BuildContext _, bool disabledValue, Widget? __) {
            final disabledIndexes = !disabledValue
                ? _options.toSet().difference(hintValue.values.toSet()).toList()
                : _options;

            return GroupButton(
              options: GroupButtonOptions(
                spacing: 4.0,
                buttonWidth: 50,
                groupingType: GroupingType.row,
                borderRadius: BorderRadius.circular(8.0),
                unselectedColor: theme.primaryColorLight,
                unselectedTextStyle: theme.textTheme.button?.copyWith(
                  color: theme.primaryColor,
                ),
              ),
              controller: GroupButtonController(
                disabledIndexes: disabledIndexes,
              ),
              buttons: _options.map((e) => e.toString()).toList(),
              onSelected: (i, _) => onQualitySelected(i),
            );
          },
        );
      },
    );
  }
}
