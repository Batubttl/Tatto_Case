import 'package:equatable/equatable.dart';

class Tattoo extends Equatable {
  final String id;
  final String prompt;
  final String style;
  final String output;
  final String imageUrl;

  const Tattoo({
    required this.id,
    required this.prompt,
    required this.style,
    required this.output,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [id, prompt, style, output, imageUrl];
}
