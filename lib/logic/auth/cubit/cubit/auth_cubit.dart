import 'package:bloc/bloc.dart';
import 'package:store_system/services/api_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final ApiService _apiService;

  AuthCubit(this._apiService) : super(AuthInitial());

  Future<void> login({required String phone, required String password}) async {
    emit(AuthLoading());

    try {
      final response = await _apiService.post(
        endpoint: 'auth/login',
        data: {'phone': phone, 'password': password},
      );

      if (response.isSuccess) {
        await _apiService.saveTokens(
          accessToken: response.data['token'] ?? '',
          refreshToken: response.data['refreshToken'] ?? '',
        );

        emit(AuthSuccess(message: "تم تسجيل الدخول بنجاح"));
      } else {
        emit(AuthFailure(errMessage: response.message ?? "فشل تسجيل الدخول"));
      }
    } catch (e) {
      if (e is ApiException) {
        emit(AuthFailure(errMessage: e.message!));
      } else {
        emit(AuthFailure(errMessage: "حدث خطأ غير متوقع"));
      }
    }
  }

  Future<void> register({required Map<String, dynamic> registerData}) async {
    emit(AuthLoading());
    try {
      final response = await _apiService.post(
        endpoint: 'auth/register',
        data: registerData,
      );

      if (response.isSuccess) {
        emit(AuthSuccess(message: "تم إنشاء الحساب بنجاح"));
      } else {
        emit(AuthFailure(errMessage: response.message ?? "فشل إنشاء الحساب"));
      }
    } catch (e) {
      emit(AuthFailure(errMessage: e.toString()));
    }
  }
}
