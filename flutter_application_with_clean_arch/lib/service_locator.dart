import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginFeatures/data/data_sources/local_contracts.dart';
import 'LoginFeatures/data/data_sources/local_data_sources.dart';
import 'LoginFeatures/data/data_sources/remote_contrats.dart';
import 'LoginFeatures/data/data_sources/remote_data_sources.dart';
import 'LoginFeatures/data/repository/data_repository.dart';
import 'LoginFeatures/domain/use_cases/login_usecase.dart';
import 'LoginFeatures/domain/use_cases/register_usecase.dart';
import 'core/network/network_info.dart';
import 'features/data/data_sources/local_contracts.dart';
import 'features/data/data_sources/local_data_source.dart';
import 'features/data/data_sources/remote_contracts.dart';
import 'features/data/data_sources/remote_data_source.dart';
import 'features/data/repositories/data_repository.dart';
import 'features/domain/repositories/productrepository.dart';
import 'features/domain/usecases/add_product.dart';
import 'features/domain/usecases/delete_product.dart';
import 'features/domain/usecases/get_all_product.dart';
import 'features/domain/usecases/get_single_product.dart';
import 'features/domain/usecases/update_product.dart';

var locator = GetIt.instance;

Future<void> setUp() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton(() => sharedPreferences);

  locator.registerLazySingleton<http.Client>(() => http.Client());

  locator.registerLazySingleton<ProductLocalDataSource>(
    () => LocalDataSourceImp(sharedPreferences: locator<SharedPreferences>()),
  );


  locator.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(client: locator<http.Client>()),
  );


 locator.registerSingleton<Connectivity>(Connectivity());
  locator.registerSingleton<NetworkInfo>(
    NetworkInfoImpl(connectivity: locator<Connectivity>()),
  );

  locator.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      localDataSource: locator<ProductLocalDataSource>(),
      networkInfo: locator<NetworkInfo>(),
      remoteDataSource: locator<ProductRemoteDataSource>(),
    ),
  );

  locator.registerLazySingleton<AddProductUseCase>(
    () => AddProductUseCase(productRepository: locator<ProductRepository>()),
  );
  locator.registerLazySingleton<GetAllProductUseCase>(
    () => GetAllProductUseCase(productRepository: locator<ProductRepository>()),
  );
  locator.registerLazySingleton<GetSingleProductUseCase>(
    () => GetSingleProductUseCase(productRepository: locator<ProductRepository>()),
  );
  locator.registerLazySingleton<DeleteProductUseCase>(
    () => DeleteProductUseCase(productRepository: locator<ProductRepository>()),
  );
  locator.registerLazySingleton<UpdateProductUseCase>(
    () => UpdateProductUseCase(productRepository: locator<ProductRepository>()),
  );
  locator.registerLazySingleton<UserProductRepository>(
    ()=>UserProductRepository(remoteContrats: locator<RemoteContrats>(), 
    localContrats: locator<LocalContracts>(), 
    networkInfo: locator<NetworkInfo>()));
  locator.registerLazySingleton<LoginUsecase>(()=>LoginUsecase(useRepository: locator<UserProductRepository>()));

  locator.registerLazySingleton<RemoteContrats>(
    () => RemoteDataSourcesImp(client: locator<http.Client>()),
  );
  locator.registerLazySingleton<LocalContracts>(
    () => LocalDataSourcesImp(locator<SharedPreferences>()),
  );
  locator.registerLazySingleton<RegisterUsecase>(()=>RegisterUsecase(userRepository: locator<UserProductRepository>()));

}
