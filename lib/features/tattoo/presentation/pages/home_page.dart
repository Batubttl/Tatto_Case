import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatto_case/features/tattoo/presentation/cubit/tattoo_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../cubit/tattoo_cubit.dart';
import '../widgets/tattoo_form.dart';
import '../widgets/generating_view.dart';
import '../widgets/result_view.dart';
import '../../domain/usecases/generate_tattoo.dart';
import '../../data/repositories/tattoo_repository_impl.dart';
import '../../data/datasources/tattoo_remote_data_source.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final client = http.Client();
    final baseUrl = 'http://localhost:3000';
    final remoteDataSource = TattooRemoteDataSourceImpl(
      baseUrl: baseUrl,
      client: client,
    );
    final repository = TattooRepositoryImpl(remoteDataSource: remoteDataSource);
    final usecase = GenerateTattoo(repository);

    return BlocProvider(
      create: (context) => TattooCubit(
        baseUrl: baseUrl,
        httpClient: client,
        generateTattoo: usecase,
        repository: repository,
      ),
      child: const _HomePageBody(),
    );
  }
}

class _HomePageBody extends StatefulWidget {
  const _HomePageBody();

  @override
  State<_HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<_HomePageBody> {
  late final TextEditingController _promptController;

  @override
  void initState() {
    super.initState();
    _promptController = TextEditingController();
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TattooCubit, TattooState>(
      builder: (context, state) {
        final isGenerating = state.isLoading;
        return Scaffold(
          appBar: isGenerating || state.tattoo != null
              ? null
              : AppBar(
                  title: const Text(AppStrings.appName),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 8,
                      ),
                      child: GestureDetector(
                        onTap: () => _showProDialog(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.diamond,
                                color: AppColors.diamond,
                                size: 20,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'PRO',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () {},
                    ),
                  ],
                ),
          body: isGenerating
              ? const GeneratingView()
              : (state.tattoo != null
                  ? Container(
                      color: Colors.black,
                      child: ResultView(
                        imageUrl: state.tattoo!.imageUrl,
                        onShare: context.read<TattooCubit>().shareTattoo,
                        onSave: context.read<TattooCubit>().saveTattoo,
                        onRecreate: context.read<TattooCubit>().recreate,
                        onEdit: context.read<TattooCubit>().edit,
                      ),
                    )
                  : TattooForm(
                      promptController: _promptController,
                      onSurpriseMe: () async {
                        await context.read<TattooCubit>().surpriseMe();
                        _promptController.text =
                            context.read<TattooCubit>().state.prompt ?? '';
                      },
                      showClear: (state.prompt?.isNotEmpty ?? false),
                      onClear: () {
                        _promptController.clear();
                        context.read<TattooCubit>().setPrompt('');
                      },
                    )),
          bottomNavigationBar: isGenerating
              ? null
              : BottomNavigationBar(
                  backgroundColor: AppColors.background,
                  selectedItemColor: AppColors.text,
                  unselectedItemColor: Colors.grey,
                  currentIndex: 0,
                  onTap: (_) {},
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.brush),
                      label: 'AI Create',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.view_in_ar),
                      label: 'AR Preview',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.grid_view),
                      label: 'Discover',
                    ),
                  ],
                ),
        );
      },
    );
  }
}

void _showProDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.card,
      title: const Row(
        children: [
          Icon(Icons.diamond, color: AppColors.diamond),
          SizedBox(width: 8),
          Text('PRO', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      content: const Text(
        'Upgrade to PRO and reduce your waiting time while pushing boundaries of your creativity.',
      ),
      actions: [
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            onPressed: () {
              /* Satın alma işlemi */
            },
            child: const Text(
              'Buy Now',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
