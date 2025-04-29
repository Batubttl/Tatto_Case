import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'tattoo_state.dart';
import '../../domain/usecases/generate_tattoo.dart';
import '../../domain/repositories/tattoo_repository.dart';

class TattooCubit extends Cubit<TattooState> {
  final String baseUrl;
  final http.Client httpClient;
  final GenerateTattoo generateTattoo;
  final TattooRepository repository;

  TattooCubit({
    required this.baseUrl,
    required this.httpClient,
    required this.generateTattoo,
    required this.repository,
  }) : super(TattooState.initial());

  void setPrompt(String prompt) {
    emit(state.copyWith(prompt: prompt));
  }

  void setStyle(String style) {
    emit(state.copyWith(
      style: style,
      selectedStyle: style,
    ));
  }

  void setAspectRatio(String ratio) {
    emit(state.copyWith(
      aspectRatio: ratio,
      selectedAspectRatio: ratio,
    ));
  }

  void setOutput(String output) {
    emit(state.copyWith(
      output: output,
      selectedOutput: output,
    ));
  }

  String _enhancePrompt(String userPrompt, String output) {
    final outputPrompts = {
      'arm':
          'realistic detailed photograph of a tattoo on human arm, showing $userPrompt, professional tattoo photography, clear skin, detailed tattoo art',
      'leg':
          'realistic detailed photograph of a tattoo on human leg, showing $userPrompt, professional tattoo photography, clear skin, detailed tattoo art',
      'whitepaper':
          'professional tattoo design on white paper, showing $userPrompt, detailed line art, tattoo sketch style',
      'skin paper':
          'tattoo design on skin-textured paper, showing $userPrompt, realistic skin texture, detailed tattoo art',
    };

    return outputPrompts[output.toLowerCase()] ?? userPrompt;
  }

  Future<void> createTattoo() async {
    if (state.prompt == null || state.prompt!.isEmpty) {
      emit(state.copyWith(error: 'Lütfen bir prompt girin'));
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));

    try {
      print('Creating tattoo with prompt: ${state.prompt}');
      final enhancedPrompt =
          _enhancePrompt(state.prompt!, state.selectedOutput ?? 'arm');

      final result = await generateTattoo(GenerateTattooParams(
        prompt: enhancedPrompt,
        style: state.selectedStyle,
        aspectRatio: state.selectedAspectRatio,
        output: state.selectedOutput,
      ));

      print('Generation result: $result');

      result.fold(
        (failure) {
          print('Generation failed: ${failure.message}');
          emit(state.copyWith(
            isLoading: false,
            error: failure.message,
          ));
        },
        (tattoo) {
          print('Generation succeeded: $tattoo');
          emit(state.copyWith(
            isLoading: false,
            tattoo: tattoo,
            error: null,
          ));
        },
      );
    } catch (e) {
      print('Generation error: $e');
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  void recreate() {
    emit(state.copyWith(
      tattoo: null,
      error: null,
      isLoading: true,
    ));
    createTattoo();
  }

  void edit() {
    emit(state.copyWith(
      tattoo: null,
      error: null,
    ));
  }

  Future<void> surpriseMe() async {
    try {
      final result = await repository.getRandomPrompt();
      result.fold(
        (failure) => emit(state.copyWith(error: failure.message)),
        (prompt) => setPrompt(prompt),
      );
    } catch (e) {
      emit(state.copyWith(error: 'Random prompt alınamadı: $e'));
    }
  }

  Future<void> shareTattoo() async {
    if (state.tattoo?.imageUrl == null) return;

    try {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/tattoo_share.png');

      final response = await httpClient.get(Uri.parse(state.tattoo!.imageUrl));
      await file.writeAsBytes(response.bodyBytes);
      await Share.shareXFiles([XFile(file.path)],
          text: 'Check out my AI generated tattoo!');
    } catch (e) {
      emit(state.copyWith(error: 'Failed to share tattoo: $e'));
    }
  }

  Future<void> saveTattoo() async {
    if (state.tattoo?.imageUrl == null) return;

    try {
      final response = await httpClient.get(Uri.parse(state.tattoo!.imageUrl));
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'tattoo_$timestamp.png';

      final result = await ImageGallerySaver.saveImage(
        response.bodyBytes,
        name: fileName,
        quality: 100,
      );

      if (result['isSuccess']) {
        emit(state.copyWith(error: 'Tattoo saved successfully!'));
      } else {
        emit(state.copyWith(error: 'Failed to save tattoo'));
      }
    } catch (e) {
      emit(state.copyWith(error: 'Failed to save tattoo: $e'));
    }
  }
}
