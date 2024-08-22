import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'LoginFeatures/domain/use_cases/login_usecase.dart';
import 'LoginFeatures/domain/use_cases/logout_usecase.dart';
import 'LoginFeatures/domain/use_cases/register_usecase.dart';
import 'LoginFeatures/presentation/Login/bloc/login_bloc.dart';
import 'LoginFeatures/presentation/Register/bloc/register_bloc.dart';
import 'LoginFeatures/presentation/first_page.dart';
import 'features/domain/usecases/add_product.dart';
import 'features/domain/usecases/delete_product.dart';
import 'features/domain/usecases/get_all_product.dart';
import 'features/domain/usecases/get_single_product.dart';
import 'features/domain/usecases/update_product.dart';
import 'features/presentation/Add/bloc/add_bloc.dart';
import 'features/presentation/Details/bloc/details_bloc.dart';
import 'features/presentation/Home/bloc/home_bloc.dart';
import 'features/presentation/Search/bloc/search_bloc.dart';
import 'features/presentation/Update/bloc/update_bloc.dart';
import 'service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final String homeRoute = '/';
  final String addProductRoute = '/add';
  final String updateProductRoute = '/update';
  final String detailsProductRoute = '/details';

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeBloc(
            getAllProductUseCase: locator<GetAllProductUseCase>(),
            logoutUsecase: locator<LogoutUsecase>(),
          )..add(const FetchProductsEvent()),
        ),
        BlocProvider(create: (context) => RegisterBloc(registerUsecase: locator<RegisterUsecase>())),
        BlocProvider(create: (context) => AddBloc(addProductUseCase: locator<AddProductUseCase>())),
        BlocProvider(create: (context) => UpdateBloc(updateProductUseCase: locator<UpdateProductUseCase>())),
        BlocProvider(create: (context) => DetailsBloc(
            getSingleProductUseCase: locator<GetSingleProductUseCase>(),
            deleteProductUseCase: locator<DeleteProductUseCase>())),
        BlocProvider(
          create: (context) {
            final products = context.read<HomeBloc>().state.products!;
            return SearchBloc(allProducts: products);
          },
        ),
        BlocProvider(create: (context) => LoginBloc(loginUsecase: locator<LoginUsecase>())),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FirstPage(),
      ),
    );
  }
}
