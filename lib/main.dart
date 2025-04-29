import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'features/tattoo/presentation/pages/home_page.dart';
import 'features/tattoo/presentation/cubit/tattoo_cubit.dart';
import 'features/tattoo/domain/usecases/generate_tattoo.dart';
import 'features/tattoo/data/repositories/tattoo_repository_impl.dart';
import 'features/tattoo/data/datasources/tattoo_remote_data_source.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Burada repository ve usecase'i gerçek implementasyonla bağlayabilirsin
    final remoteDataSource = TattooRemoteDataSourceImpl(
      baseUrl: 'http://localhost:3000', // veya kendi backend adresin
      client: http.Client(),
    );
    final repository = TattooRepositoryImpl(remoteDataSource: remoteDataSource);
    final usecase = GenerateTattoo(repository);

    return MaterialApp(
      title: 'Tattoo AI',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => TattooCubit(
          baseUrl: 'http://localhost:3000',
          httpClient: http.Client(),
          generateTattoo: usecase,
          repository: repository,
        ),
        child: const HomePage(),
      ),
    );
  }
}
