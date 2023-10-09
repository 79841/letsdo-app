Future<dynamic> fetchWithRetry(Function() fetchData) async {
  int tryCount = 2;
  for (int i = 0; i < tryCount; i++) {
    try {
      return await fetchData().timeout(const Duration(seconds: 2));
    } catch (e) {
      if (i == tryCount - 1) {
        throw Exception("failed to fetch data");
      }
      print("retry fetch data...");
    }
  }
}
