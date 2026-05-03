import 'auth_tokens_model.dart';
import 'auth_user_model.dart';

class AuthResponseModel {
  final AuthUserModel? user;
  final AuthTokensModel tokens;

  AuthResponseModel({this.user, required this.tokens});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    // Check if the response has 'user' and 'tokens' structure (register response)
    if (json.containsKey('user') && json.containsKey('tokens')) {
      return AuthResponseModel(
        user: AuthUserModel.fromJson(Map<String, dynamic>.from(json['user'] as Map)),
        tokens: AuthTokensModel.fromJson(Map<String, dynamic>.from(json['tokens'] as Map)),
      );
    } else {
      // Assume the response is directly the tokens (login response)
      return AuthResponseModel(
        user: null,
        tokens: AuthTokensModel.fromJson(json),
      );
    }
  }
}
