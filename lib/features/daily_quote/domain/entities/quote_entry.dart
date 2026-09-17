import 'package:equatable/equatable.dart';

class QuoteEntry extends Equatable {
  final String japanese;
  final String english;

  const QuoteEntry({required this.japanese, required this.english});

  factory QuoteEntry.fromJson(Map<String, dynamic> json) {
    return QuoteEntry(
      japanese: json['japanese'] as String,
      english: json['english'] as String,
    );
  }

  @override
  List<Object?> get props => [japanese, english];
}
