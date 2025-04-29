import 'package:dartz/dartz.dart';
import '../entities/tattoo.dart';
import '../repositories/tattoo_repository.dart';
import '../../../../core/error/failures.dart';

class GenerateTattooParams {
  final String prompt;
  final String? style;
  final String? aspectRatio;
  final String? output;

  GenerateTattooParams({
    required this.prompt,
    this.style,
    this.aspectRatio,
    this.output,
  });

  Map<String, dynamic> toJson() => {
    'prompt': prompt,
    if (style != null) 'style': style,
    if (aspectRatio != null) 'aspect_ratio': aspectRatio,
    if (output != null) 'output': output,
  };
}

class GenerateTattoo {
  final TattooRepository repository;

  GenerateTattoo(this.repository);

  Future<Either<Failure, Tattoo>> call(GenerateTattooParams params) async {
    return await repository.generateTattoo(params);
  }
} 