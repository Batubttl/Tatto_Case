import 'package:equatable/equatable.dart';
import '../../domain/entities/tattoo.dart';

class TattooState extends Equatable {
  final String? prompt;
  final String? style;
  final String? output;
  final String? aspectRatio;
  final Tattoo? tattoo;
  final bool isLoading;
  final String? error;
  final String? selectedStyle;
  final String? selectedAspectRatio;
  final String? selectedOutput;

  const TattooState({
    this.prompt,
    this.style,
    this.output,
    this.aspectRatio,
    this.tattoo,
    this.isLoading = false,
    this.error,
    this.selectedStyle,
    this.selectedAspectRatio = '1:1',
    this.selectedOutput = 'Arm',
  });

  factory TattooState.initial() => const TattooState();

  TattooState copyWith({
    String? prompt,
    String? style,
    String? output,
    String? aspectRatio,
    Tattoo? tattoo,
    bool? isLoading,
    String? error,
    String? selectedStyle,
    String? selectedAspectRatio,
    String? selectedOutput,
  }) {
    return TattooState(
      prompt: prompt ?? this.prompt,
      style: style ?? this.style,
      output: output ?? this.output,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      tattoo: tattoo ?? this.tattoo,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      selectedStyle: selectedStyle ?? this.selectedStyle,
      selectedAspectRatio: selectedAspectRatio ?? this.selectedAspectRatio,
      selectedOutput: selectedOutput ?? this.selectedOutput,
    );
  }

  @override
  List<Object?> get props => [
        prompt,
        style,
        output,
        aspectRatio,
        tattoo,
        isLoading,
        error,
        selectedStyle,
        selectedAspectRatio,
        selectedOutput,
      ];
}

class TattooInitial extends TattooState {
  const TattooInitial();
}

class TattooLoading extends TattooState {
  const TattooLoading();
}

class TattooSuccess extends TattooState {
  final Tattoo tattoo;
  const TattooSuccess(this.tattoo);

  @override
  List<Object?> get props => [tattoo];
}

class TattooError extends TattooState {
  final String message;
  const TattooError(this.message);

  @override
  List<Object?> get props => [message];
}
