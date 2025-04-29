import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_button.dart';
import '../cubit/tattoo_cubit.dart';

class TattooForm extends StatelessWidget {
  final TextEditingController promptController;
  final VoidCallback onSurpriseMe;
  final bool showClear;
  final VoidCallback onClear;

  const TattooForm({
    required this.promptController,
    required this.onSurpriseMe,
    required this.showClear,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TattooCubit>();
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                AppStrings.enterPrompt,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Stack(
                children: [
                  TextField(
                    controller: promptController,
                    onChanged: cubit.setPrompt,
                    decoration: InputDecoration(
                      hintText: AppStrings.promptHint,
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: promptController.text.isEmpty
                            ? AppColors.secondaryText
                            : AppColors.text,
                      ),
                      filled: true,
                      fillColor: AppColors.card,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(12, 12, 40, 12),
                    ),
                    maxLines: 4,
                  ),
                  if (promptController.text.isEmpty)
                    Positioned(
                      left: 8,
                      bottom: 8,
                      child: GestureDetector(
                        onTap: onSurpriseMe,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.secondaryText,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.auto_awesome,
                                color: AppColors.text,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                AppStrings.surpriseMe,
                                style: TextStyle(
                                  color: AppColors.text,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (promptController.text.isNotEmpty)
                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: IconButton(
                        icon: const Icon(
                          Icons.clear,
                          size: 20,
                          color: AppColors.secondaryText,
                        ),
                        onPressed: onClear,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                AppStrings.aspectRatio,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _MockHorizontalSelector(
                items: ['1:1', '3:2', '2:3', '3:4'],
                onSelect: cubit.setAspectRatio,
              ),
              const SizedBox(height: 16),
              const Text(
                AppStrings.styles,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _MockHorizontalSelector(
                items: ['blackwork', 'geometric', 'minimalist', 'Halloween'],
                onSelect: cubit.setStyle,
              ),
              const SizedBox(height: 16),
              const Text(
                AppStrings.outputs,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _MockHorizontalSelector(
                items: ['Arm', 'Whitepaper', 'Leg', 'Skin Paper'],
                onSelect: cubit.setOutput,
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0),
                  Colors.black.withOpacity(0.8),
                  Colors.black,
                ],
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: SizedBox(
                height: 60,
                child: AppButton(
                  onPressed: () {
                    if (cubit.state.prompt == null ||
                        cubit.state.prompt!.trim().isEmpty) {
                      Future.microtask(() {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.amber[700],
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.only(
                              top: 16,
                              left: 16,
                              right: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            duration: const Duration(seconds: 2),
                            content: const Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.warning,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Warning',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Please enter a prompt to generate a tattoo',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                      return;
                    }
                    cubit.createTattoo();
                  },
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.create,
                          style: TextStyle(
                            color: AppColors.text,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 1),
                        Text(
                          AppStrings.watchAd,
                          style: TextStyle(
                            color: AppColors.text,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MockHorizontalSelector extends StatelessWidget {
  final List<String> items;
  final void Function(String) onSelect;

  const _MockHorizontalSelector({
    required this.items,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items.map((item) {
          // Aspect Ratio için özel görünüm
          if (items.contains('1:1') && items.contains('3:2')) {
            return _buildAspectRatioOption(item, context);
          }
          // Diğer seçenekler için mevcut görünüm
          return _buildOption(item, context);
        }).toList(),
      ),
    );
  }

  Widget _buildAspectRatioOption(String item, BuildContext context) {
    final cubit = context.read<TattooCubit>();
    final state = cubit.state;
    final isSelected = item == '1:1'; // İlk kare her zaman seçili

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => onSelect(item),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.grey[800],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Text(
                item,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isSelected) ...[
                const SizedBox(width: 4),
                const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 16,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(String item, BuildContext context) {
    final cubit = context.read<TattooCubit>();
    final state = cubit.state;
    final isSelected =
        state.selectedStyle == item || state.selectedOutput == item;

    // Her item için farklı image path belirliyoruz
    String imagePath = '';
    switch (item) {
      case 'geometric':
        imagePath = 'assets/images/leg.png';
        break;
      case 'Halloween':
        imagePath = 'assets/images/halo.jpg';
        break;
      case 'blackwork':
        imagePath = 'assets/images/blackwork.jpeg';
        break;
      case 'minimalist':
        imagePath = 'assets/images/minimalist.png';
        break;
      case 'Arm':
        imagePath = 'assets/images/arm.jpeg';
        break;
      case 'Whitepaper':
        imagePath = 'assets/images/whitepaper.jpeg';
        break;
      case 'Leg':
        imagePath = 'assets/images/leg.png';
        break;
      case 'Skin Paper':
        imagePath = 'assets/images/skinnypaper.jpeg';
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () => onSelect(item),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[800],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.text,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
