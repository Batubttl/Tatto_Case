import 'dart:convert';
import 'package:http/http.dart' as http;

class TattooService {
  final String baseUrl = 'http://localhost:3000';

  Future<String?> checkGenerationStatus(String predictionId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/generate/$predictionId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Eğer işlem tamamlandıysa ve output varsa
        if (data['status'] == 'succeeded' && 
            data['output'] != null && 
            data['output'].isNotEmpty) {
          return data['output'][0];
        }
        
        // Eğer hata varsa
        if (data['error'] != null) {
          print('Hata: ${data['error']}');
          return null;
        }
        
        // İşlem devam ediyorsa
        print('İşlem durumu: ${data['status']}');
        return null;
      }
      
      print('HTTP Hatası: ${response.statusCode}');
      return null;
    } catch (e) {
      print('Bağlantı Hatası: $e');
      return null;
    }
  }
} 