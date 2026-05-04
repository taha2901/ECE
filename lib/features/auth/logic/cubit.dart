import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:real_ecommerce/features/auth/data/models/auth_login_request.dart';
import 'package:real_ecommerce/features/auth/data/models/auth_register_request.dart';
import 'package:real_ecommerce/features/auth/data/repositories/auth_repository.dart';
import 'package:real_ecommerce/features/auth/logic/states.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(const AuthState());

  Future<void> checkAuthStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final refreshToken = prefs.getString('auth_refresh_token');

      if (token != null && refreshToken != null) {
        emit(
          state.copyWith(status: AuthStatus.success, message: 'Auto-logged in'),
        );
      }
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.initial, message: null));
    }
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading, message: null));

    final result = await _repository.login(
      AuthLoginRequest(username: username, password: password),
    );

    result.when(
      success: (data) async {
        await _saveAuthData(data);
        emit(
          state.copyWith(
            status: AuthStatus.success,
            authData: data,
            message: 'Signed in successfully',
          ),
        );
      },
      failure: (errorHandler) => emit(
        state.copyWith(
          status: AuthStatus.failure,
          message: errorHandler.apiErrorModel.readableMessage,
        ),
      ),
    );
  }

  Future<void> register({
    required String username,
    required String email,
    required String firstName,
    required String lastName,
    required String phone,
    required String password,
    required String password2,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading, message: null));

    final result = await _repository.register(
      AuthRegisterRequest(
        username: username,
        email: email,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        password: password,
        password2: password2,
      ),
    );

    result.when(
      success: (data) async {
        await _saveAuthData(data);
        emit(
          state.copyWith(
            status: AuthStatus.success,
            authData: data,
            message: 'Registration completed',
          ),
        );
      },
      failure: (errorHandler) => emit(
        state.copyWith(
          status: AuthStatus.failure,
          message: errorHandler.apiErrorModel.readableMessage,
        ),
      ),
    );
  }

  /// ✅ Logout — بيكلم الـ API وبيمسح البيانات المحلية
  Future<void> logout() async {
    emit(state.copyWith(status: AuthStatus.loading));
    await _repository.logout();
    await _clearAuthData();
    emit(state.copyWith(status: AuthStatus.loggedOut));
  }

  Future<void> _clearAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('auth_refresh_token');
      await prefs.remove('user_id');
      await prefs.remove('username');
      await prefs.remove('email');
      await prefs.remove('first_name');
      await prefs.remove('last_name');
    } catch (e) {
      // ignore
    }
  }

  Future<void> _saveAuthData(dynamic data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (data.tokens != null) {
        await prefs.setString('auth_token', data.tokens.access ?? '');
        await prefs.setString('auth_refresh_token', data.tokens.refresh ?? '');
      }
      if (data.user != null) {
        await prefs.setString('user_id', (data.user.id ?? '').toString());
        await prefs.setString('username', data.user.username ?? '');
        await prefs.setString('email', data.user.email ?? '');
        await prefs.setString('first_name', data.user.firstName ?? '');
        await prefs.setString('last_name', data.user.lastName ?? '');
      }
    } catch (e) {
      // ignore
    }
  }
}
