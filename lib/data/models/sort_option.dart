import 'dart:convert';
import 'package:equatable/equatable.dart';

/// The fields on which to sort
enum SortField { text, date, accuracy, streak }

/// An object that contains the [field] on which to sort and the order mode by
/// the parameter [descending].
class SortOption extends Equatable {
  /// Creates a [SortOption] with a [field] and [descending] order.
  const SortOption({
    this.field = SortField.text,
    this.descending = false,
  });

  /// Creates a [SortOption] with default values.
  const SortOption.initial()
      : field = SortField.text,
        descending = false;

  /// A [SortField] indicating the field to use for sorting.
  final SortField field;

  /// A boolean value to use descending order.
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
