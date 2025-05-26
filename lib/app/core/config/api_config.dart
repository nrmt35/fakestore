class ApiConfig {
  static String BASE_API_URL = String.fromEnvironment(
    defaultValue: 'https://fakestoreapi.com/',
    'BASE_API_URL',
  );
}
