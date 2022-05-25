import 'package:flutter/material.dart';

import '../../../../data/models/sort_option.dart';

const sortFieldText = {
  SortField.text: "Alphabetical",
  SortField.date: "Next Review",
  SortField.accuracy: "Accuracy",
  SortField.streak: "Streak",
};

class SortListItem extends StatelessWidget {
  const SortListItem({
    Key? key,
    required this.field,
    required this.onPressed,
    this.enabled = false,
    this.descending = false,
  }) : super(key: key);

  final bool enabled;

  final SortField field;

  final bool descending;

  final Function(SortField, bool) onPressed;

  IconData get _icon => descending ? Icons.arrow_downward : Icons.arrow_upward;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: () {
          onPressed(field, enabled ? !descending : descending);
        },
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
}
