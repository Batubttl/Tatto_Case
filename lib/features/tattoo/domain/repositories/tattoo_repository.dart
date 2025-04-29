import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/tattoo.dart';
import '../usecases/generate_tattoo.dart';

abstract class TattooRepository {
  Future<Either<Failure, Tattoo>> generateTattoo(GenerateTattooParams params);
  Future<Either<Failure, void>> saveTattoo(String imageUrl);
  Future<Either<Failure, void>> shareTattoo(String imageUrl);
  Future<Either<Failure, String>> getRandomPrompt();
} 