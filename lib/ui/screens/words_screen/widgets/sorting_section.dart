import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/settings_bloc.dart';
import '../../../../bloc/word_bloc.dart';
import '../../../../data/models/sort_option.dart';
import 'sort_list_item.dart';

class SortingSection extends StatefulWidget {
  const SortingSection({Key? key}) : super(key: key);

  @override
  State<SortingSection> createState() => _SortingSectionState();
}

class _SortingSectionState extends State<SortingSection> {
  WordBloc? _wordBloc;
  SettingsBloc? _settingsBloc;

  @override
  void initState() {
    _wordBloc = BlocProvider.of<WordBloc>(context);
    _settingsBloc = BlocProvider.of<SettingsBloc>(context);
    _settingsBloc?.add(SettingsRetrieved());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoaded) {
            final settings = state.settings;

            return ListView.builder(
              itemCount: sortFieldText.length,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final field = sortFieldText.keys.elementAt(index);

                return SortListItem(
                  field: field,
                  descending: settings.sortOption.descending,
                  enabled: field == settings.sortOption.field,
                  onPressed: _onSortChanged,
                );
              },
            );
          } else {
            return const Center(child: Text("Loading..."));
          }
        },
      ),
    );
  }

  _onSortChanged(SortField field, bool descending) {
    final sortOption = SortOption(field: field, descending: descending);

    _settingsBloc?.add(SettingsSortChanged(sortOption: sortOption));
    _wordBloc?.add(WordsRetrieved(sort: sortOption));
  }
}
