class AuthLoginRequest {
  final String username;
  final String password;

  AuthLoginRequest({required this.username, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}
