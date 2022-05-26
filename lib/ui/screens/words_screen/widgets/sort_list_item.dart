import 'package:flutter/material.dart';

import '../../../../data/models/sort_option.dart';
import '../../../../utils/sort.dart';

/// A Widget that displays a sort option.
class SortListItem extends StatelessWidget {
  /// Creates a [SortListItem] with a [field] on which to sort and a boolean
  /// value [descending]. A [enabled] value is provided to indicate if this
  /// item is currently selected. A [onPressed] callback is called when this
  /// item is pressed.
  const SortListItem({
    Key? key,
    required this.field,
    required this.onPressed,
    this.enabled = false,
    this.descending = false,
  }) : super(key: key);

  /// A boolean value indicating if this item is selected.
  final bool enabled;

  /// The field on which to sort.
  final SortField field;

  /// A boolean value indicating the if the order is descending or not.
  final bool descending;

  /// A callback called when this item is pressed.
  ///
  /// If called when this item is already enabled the order is reversed.
  final Function(SortField, bool) onPressed;

  /// The icon that shows the sort order.
  IconData get _icon => descending ? Icons.arrow_downward : Icons.arrow_upward;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: _onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: enabled ? Colors.indigo[400] : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              height: 24,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    sortFieldText[field] ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.white),
                  ),
                  if (enabled) Icon(_icon, color: Colors.white, size: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _onTap() {
    onPressed(field, enabled ? !descending : descending);
  }
}
