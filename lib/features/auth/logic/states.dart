import 'package:equatable/equatable.dart';
import 'package:real_ecommerce/features/auth/data/models/auth_response_model.dart';

enum AuthStatus { initial, loading, success, failure, loggedOut }
class AuthState extends Equatable {
  final AuthStatus status;
  final AuthResponseModel? authData;
  final String? message;

  const AuthState({
    this.status = AuthStatus.initial,
    this.authData,
    this.message,
  });

  bool get isLoading => status == AuthStatus.loading;
  bool get isSuccess => status == AuthStatus.success;

  AuthState copyWith({
    AuthStatus? status,
    AuthResponseModel? authData,
    String? message,
  }) {
    return AuthState(
      status: status ?? this.status,
      authData: authData ?? this.authData,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, authData, message];
}
