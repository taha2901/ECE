class AuthRegisterRequest {
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String password;
  final String password2;

  AuthRegisterRequest({
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.password,
    required this.password2,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'password': password,
      'password2': password2,
    };
  }
}
