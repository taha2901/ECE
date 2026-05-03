class AuthTokensModel {
  final String access;
  final String refresh;

  AuthTokensModel({required this.access, required this.refresh});

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) {
    return AuthTokensModel(
      access: json['access'] as String,
      refresh: json['refresh'] as String,
    );
  }
}
