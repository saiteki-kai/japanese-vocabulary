import 'dart:convert';
import 'package:equatable/equatable.dart';

import 'sort.dart';

class Settings extends Equatable {
  const Settings({required this.sortOption});

  const Settings.initial() : sortOption = const SortOption.initial();

  final SortOption sortOption;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sortOption': sortOption.toMap(),
    };
  }

  factory Settings.fromMap(Map<String, dynamic> map) {
    return Settings(
      sortOption: SortOption.fromMap(map['sortOption'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Settings.fromJson(String source) =>
      Settings.fromMap(json.decode(source) as Map<String, dynamic>);

  Settings copyWith({
    SortOption? sortOption,
  }) {
    return Settings(
      sortOption: sortOption ?? this.sortOption,
    );
  }

  @override
  List<Object?> get props => [sortOption];
}
