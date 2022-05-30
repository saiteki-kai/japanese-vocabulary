import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/models/settings.dart';
import '../data/models/sort_option.dart';
import '../data/repositories/settings_repository.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({required this.repository}) : super(SettingsInitial()) {
    on<SettingsRetrieved>(_onSettingsRetrieved);
    on<SettingsSortChanged>(_onSortChanged);
  }

  final SettingsRepository repository;

  _onSettingsRetrieved(SettingsRetrieved _, Emitter<SettingsState> emit) async {
    emit(const SettingsLoading());
    Settings? settings = await repository.getSettings();

    if (settings == null) {
      settings = const Settings.initial();
      repository.setSettings(settings);
    }

    emit(SettingsLoaded(settings: settings));
  }

  _onSortChanged(SettingsSortChanged event, Emitter<SettingsState> emit) async {
    Settings? settings = await repository.getSettings();

    if (settings != null) {
      settings = settings.copyWith(sortOption: event.sortOption);

      repository.setSettings(settings);
      emit(SettingsLoaded(settings: settings));
    }
  }
}
