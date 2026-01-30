class UserRepository {
  Future<String> fetchUserName() async {
    await Future.delayed(Duration(seconds: 2));
    return 'Jesen';
  }
}
