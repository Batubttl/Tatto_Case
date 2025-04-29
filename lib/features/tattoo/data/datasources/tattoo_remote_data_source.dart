import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/tattoo.dart';
import '../../domain/usecases/generate_tattoo.dart';
import '../models/tattoo_model.dart';

abstract class TattooRemoteDataSource {
  Future<Tattoo> generateTattoo(GenerateTattooParams params);
  Future<void> saveTattoo(String imageUrl);
  Future<void> shareTattoo(String imageUrl);
  Future<String> getRandomPrompt();
}

class TattooRemoteDataSourceImpl implements TattooRemoteDataSource {
  final String baseUrl;
  final http.Client client;

  TattooRemoteDataSourceImpl({
    required this.baseUrl,
    required this.client,
  });

  @override
  Future<Tattoo> generateTattoo(GenerateTattooParams params) async {
    try {
      print('Generating tattoo with params: ${params.toJson()}');
      final response = await client.post(
        Uri.parse('$baseUrl/generate'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(params.toJson()),
      );

      print('Generate response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final predictionId = data['id'] as String?;
        final status = data['status'] as String?;

        if (predictionId == null) {
          throw Exception('Prediction ID alınamadı');
        }

        // İşlem devam ediyorsa periyodik olarak kontrol et
        for (int i = 0; i < 10; i++) {
          await Future.delayed(const Duration(seconds: 5));

          print('Checking prediction status: $predictionId');
          final checkResponse = await client.get(
            Uri.parse('$baseUrl/generate/$predictionId'),
            headers: {
              'Content-Type': 'application/json',
            },
          );

          print('Check response: ${checkResponse.body}');

          if (checkResponse.statusCode == 200) {
            final checkData = json.decode(checkResponse.body);
            final checkStatus = checkData['status'] as String?;
            final imageUrl = checkData['imageUrl'] as String?;

            if (checkStatus == 'succeeded' &&
                imageUrl != null &&
                imageUrl.isNotEmpty) {
              return TattooModel(
                id: predictionId,
                prompt: params.prompt,
                style: params.style ?? '',
                output: params.output ?? '',
                imageUrl: imageUrl,
              );
            } else if (checkStatus == 'failed') {
              throw Exception(
                  'Dövme oluşturma başarısız: ${checkData['error']}');
            }
          }
        }

        throw Exception('Dövme oluşturma zaman aşımına uğradı');
      } else if (response.statusCode == 429) {
        throw Exception(
            'Çok fazla istek gönderildi. Lütfen biraz bekleyin ve tekrar deneyin.');
      } else {
        throw Exception(
            'Dövme oluşturulamadı: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Generate error: $e');
      throw Exception('Dövme oluşturma hatası: $e');
    }
  }

  @override
  Future<String> getRandomPrompt() async {
    try {
      print('Getting random prompt');
      final response = await client.get(
        Uri.parse('$baseUrl/random-prompt'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('Random prompt response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['prompt'] as String;
      } else {
        throw Exception(
            'Random prompt alınamadı: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Random prompt error: $e');
      throw Exception('Random prompt alma hatası: $e');
    }
  }

  @override
  Future<void> saveTattoo(String imageUrl) async {
    // Implement save functionality
    throw UnimplementedError();
  }

  @override
  Future<void> shareTattoo(String imageUrl) async {
    // Implement share functionality
    throw UnimplementedError();
  }
}
