part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class SettingsRetrieved extends SettingsEvent {}

class SettingsSortChanged extends SettingsEvent {
  final SortOption sortOption;

  const SettingsSortChanged({required this.sortOption});

  @override
  List<Object?> get props => [sortOption];
}
