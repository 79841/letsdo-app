Future<dynamic> fetchWithRetry(Function() fetchData, int retryCount) async {
  for (int i = 0; i < retryCount; i++) {
    try {
      return await fetchData().timeout(const Duration(seconds: 2));
    } catch (e) {
      print("retry fetch data...");
    }
  }
  throw Exception("failed to fetch data");
}
