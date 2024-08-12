import 'package:flutter_application_with_clean_arch/features/domain/repositories/productrepository.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([
  ProductRepository,
  SharedPreferences,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient),
])
void main() {}
