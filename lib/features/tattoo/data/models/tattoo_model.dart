import '../../domain/entities/tattoo.dart';

class TattooModel extends Tattoo {
  const TattooModel({
    required String id,
    required String prompt,
    required String style,
    required String output,
    required String imageUrl,
  }) : super(
          id: id,
          prompt: prompt,
          style: style,
          output: output,
          imageUrl: imageUrl,
        );

  factory TattooModel.fromJson(Map<String, dynamic> json) {
    return TattooModel(
      id: json['id'] as String,
      prompt: json['prompt'] as String,
      style: json['style'] as String,
      output: json['output'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prompt': prompt,
      'style': style,
      'output': output,
      'imageUrl': imageUrl,
    };
  }
}
