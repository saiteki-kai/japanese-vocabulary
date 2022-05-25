import 'dart:convert';
import 'package:equatable/equatable.dart';

enum SortField { text, date, accuracy, streak }

class SortOption extends Equatable {
  const SortOption({
    this.field = SortField.text,
    this.descending = false,
  });

  const SortOption.initial()
      : field = SortField.text,
        descending = false;

  final SortField field;
  final bool descending;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'field': field.name,
      'descending': descending,
    };
  }

  factory SortOption.fromMap(Map<String, dynamic> map) {
    final field = SortField.values.where((e) => e.name == map['field']).first;

    return SortOption(
      field: field,
      descending: map['descending'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory SortOption.fromJson(String source) =>
      SortOption.fromMap(json.decode(source) as Map<String, dynamic>);

  SortOption copyWith({SortField? field, bool? descending}) {
    return SortOption(
      field: field ?? this.field,
      descending: descending ?? this.descending,
    );
  }

  @override
  List<Object?> get props => [field, descending];
}
