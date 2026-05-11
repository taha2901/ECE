import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:real_ecommerce/features/auth/data/models/auth_login_request.dart';
import 'package:real_ecommerce/features/auth/data/models/auth_register_request.dart';
import 'package:real_ecommerce/features/auth/data/models/auth_response_model.dart';
import 'package:real_ecommerce/features/auth/data/models/auth_tokens_model.dart';
import 'package:real_ecommerce/features/auth/data/models/auth_user_model.dart';
import 'package:real_ecommerce/features/auth/data/repositories/auth_repository.dart';
import 'package:real_ecommerce/features/auth/logic/states.dart';
import 'package:real_ecommerce/core/helpers/constants.dart';
import 'package:real_ecommerce/core/helpers/shared_pref_helper.dart';
import 'package:real_ecommerce/core/network/dio_factory.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(const AuthState());

  Future<void> checkAuthStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final refreshToken = prefs.getString('auth_refresh_token');

      if (token != null && token.isNotEmpty && refreshToken != null && refreshToken.isNotEmpty) {
        final authData = _restoreAuthDataFromPrefs(prefs, token, refreshToken);

        // Rehydrate Dio headers and secure storage for auto-login.
        await SharedPrefHelper.setSecuredString(SharedPrefKeys.userToken, token);
        await SharedPrefHelper.setSecuredString(SharedPrefKeys.refreshToken, refreshToken);
        DioFactory.setTokenIntoHeaderAfterLogin(token);

        emit(
          state.copyWith(
            status: AuthStatus.success,
            authData: authData,
            message: 'Auto-logged in',
          ),
        );
        await _refreshUserProfile();
        return;
      }

      emit(state.copyWith(status: AuthStatus.initial, message: null));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.initial, message: null));
    }
  }

  AuthResponseModel? _restoreAuthDataFromPrefs(
    SharedPreferences prefs,
    String token,
    String refreshToken,
  ) {
    final userId = prefs.getString('user_id');
    final username = prefs.getString('username');
    final email = prefs.getString('email');
    final firstName = prefs.getString('first_name');
    final lastName = prefs.getString('last_name');
    final phone = prefs.getString('phone') ?? '';
    final address = prefs.getString('address') ?? '';
    final city = prefs.getString('city') ?? '';
    final country = prefs.getString('country') ?? '';
    final isAdmin = prefs.getBool('is_admin') ?? false;
    final isStaff = prefs.getBool('is_staff') ?? false;

    final tokens = AuthTokensModel(access: token, refresh: refreshToken);
    if (userId == null || username == null || email == null || firstName == null || lastName == null) {
      return AuthResponseModel(user: null, tokens: tokens);
    }

    final parsedUserId = int.tryParse(userId) ?? 0;
    final user = AuthUserModel(
      id: parsedUserId,
      username: username,
      email: email,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      address: address,
      city: city,
      country: country,
      isAdmin: isAdmin,
      isStaff: isStaff,
    );

    return AuthResponseModel(user: user, tokens: tokens);
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
        await _refreshUserProfile();
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
        await _refreshUserProfile();
      },
      failure: (errorHandler) => emit(
        state.copyWith(
          status: AuthStatus.failure,
          message: errorHandler.apiErrorModel.readableMessage,
        ),
      ),
    );
  }

  /// ✅ تحديث بيانات الملف الشخصي من الـ API — يمكن استدعاؤه من أي مكان
  Future<void> refreshUserProfile() async {
    await _refreshUserProfile();
  }

  Future<void> _refreshUserProfile() async {
    final profileResult = await _repository.getProfile();
    profileResult.when(
      success: (user) async {
        final tokens = state.authData?.tokens;
        if (tokens != null) {
          final updatedAuthData = AuthResponseModel(user: user, tokens: tokens);
          await _saveAuthData(updatedAuthData);
          emit(state.copyWith(authData: updatedAuthData));
        }
      },
      failure: (_) {},
    );
  }

  /// ✅ Logout — بيكلم الـ API وبيمسح البيانات المحلية
  Future<void> logout() async {
    emit(state.copyWith(status: AuthStatus.loading));
    await _repository.logout();
    await _clearAuthData();
    emit(state.copyWith(
      status: AuthStatus.loggedOut,
      authData: null,
      message: 'Logged out successfully',
    ));
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
      await prefs.remove('phone');
      await prefs.remove('address');
      await prefs.remove('city');
      await prefs.remove('country');
      await prefs.remove('is_admin');
      await prefs.remove('is_staff');
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
