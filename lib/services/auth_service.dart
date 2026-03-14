import 'package:store_system/data/models/response_vm_model.dart';
import 'package:store_system/services/api_service.dart';

class AuthService {
  final ApiService _apiService;

  AuthService(this._apiService);

  Future<ResponseVM> login({
    required String phone,
    required String password,
  }) async {
    // نرسل البيانات كـ Map بناءً على ما يطلبه الـ Swagger
    final response = await _apiService.post(
      endpoint: 'auth/login', // تأكد من الـ Path الصحيح من Swagger
      data: {'phone': phone, 'password': password},
    );

    if (response.isSuccess) {
      // هنا نقوم بحفظ التوكنات فور نجاح العملية
      await _apiService.saveTokens(
        accessToken: response.data['token'], // تأكد من اسم المفتاح في الـ JSON
        refreshToken: response.data['refreshToken'],
      );
    }

    return response;
  }
}
