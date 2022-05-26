import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:japanese_vocabulary/bloc/settings_bloc.dart';
import 'package:japanese_vocabulary/data/models/settings.dart';
import 'package:japanese_vocabulary/data/repositories/settings_repository.dart';
import 'package:mocktail/mocktail.dart';

import '../utils/mocks.dart';
import '../utils/params.dart';

void main() {
  late SettingsRepository repo;
  late SettingsBloc bloc;

  setUp(() {
    repo = MockSettingsRepository();
    bloc = SettingsBloc(repository: repo);
    registerFallbackValue(FakeSettings());
  });

  tearDown(() {
    bloc.close();
    reset(repo);
  });

  blocTest<SettingsBloc, SettingsState>(
    'emits [SettingsLoading, SettingsLoaded] with default settings values when SettingsRetrieved is added.',
    build: () => bloc,
    setUp: () {
      when(repo.getSettings).thenAnswer((_) async => null);
      when(() => repo.setSettings(any())).thenAnswer((_) async => true);
    },
    act: (bloc) => bloc.add(SettingsRetrieved()),
    expect: () => <SettingsState>[
      const SettingsLoading(),
      const SettingsLoaded(settings: Settings.initial()),
    ],
    verify: (_) {
      verify(() => repo.getSettings()).called(1);
      verify(() => repo.setSettings(any())).called(1);
    },
  );

  blocTest<SettingsBloc, SettingsState>(
    'emits [SettingsLoading, SettingsLoaded] with the cached value when SettingsRetrieved is added.',
    build: () => bloc,
    setUp: () {
      when(repo.getSettings).thenAnswer((_) async => settings1);
    },
    act: (bloc) => bloc.add(SettingsRetrieved()),
    expect: () => <SettingsState>[
      const SettingsLoading(),
      SettingsLoaded(settings: settings1),
    ],
    verify: (_) {
      verify(() => repo.getSettings()).called(1);
      verifyNever(() => repo.setSettings(any()));
    },
  );

  blocTest<SettingsBloc, SettingsState>(
    'emits [SettingsLoaded] when SettingsSortChanged is added.',
    build: () => bloc,
    setUp: () {
      when(repo.getSettings).thenAnswer((_) async => settings1);
      when(() => repo.setSettings(any())).thenAnswer((_) async => true);
    },
    act: (bloc) => bloc.add(SettingsSortChanged(sortOption: sortOption1)),
    expect: () => <SettingsState>[
      SettingsLoaded(settings: settings1.copyWith(sortOption: sortOption1)),
    ],
    verify: (_) {
      verify(() => repo.getSettings()).called(1);
      verify(() => repo.setSettings(any())).called(1);
    },
  );
}
