bool isEmailValid(String email) {
  final RegExp regex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
  return regex.hasMatch(email.trim());
}
