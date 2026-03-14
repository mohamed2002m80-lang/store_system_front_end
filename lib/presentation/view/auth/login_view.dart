import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:store_system/logic/auth/cubit/cubit/auth_cubit.dart';
import 'package:store_system/presentation/widget/get_input_from_user_widget.dart';
import 'package:store_system/helper/size_app.dart';
import 'package:store_system/helper/constant_app.dart';
import 'package:store_system/routes/names_route.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    final size = SizeApp(
      heightScreen: MediaQuery.of(context).size.height,
      widthScreen: MediaQuery.of(context).size.width,
    );

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          // الانتقال للصفحة التالية بعد نجاح الدخول
          context.goNamed(NamesRoute.home);
        } else if (state is AuthFailure) {
          // إظهار رسالة خطأ
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: ConstantApp.backgroundColor,
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Card(
                    elevation: 4, // يفضل إضافة ظل خفيف ليظهر الكارد
                    margin: const EdgeInsets.all(
                      12,
                    ), // هام جداً للشاشات الصغيرة
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 40,
                      ), // محتوى الكارد
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "تسجيل الدخول",
                              style: TextStyle(
                                fontFamily: ConstantApp.fontFamily,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: ConstantApp.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "مرحباً بك مجدداً، أدخل بياناتك للبدء",
                              style: TextStyle(
                                fontFamily: ConstantApp.fontFamily,
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 40),
                            const Text(
                              "رقم الهاتف",
                              style: TextStyle(
                                fontFamily: ConstantApp.fontFamily,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            GetInputFromUserWidget(
                              controller: phoneController,
                              requiredText: 'رقم الهاتف مطلوب',
                              errorText: 'رقم الهاتف غير صحيح',
                              size: size,
                              hintText: "9X XXXXXXX",
                              keyboardType: TextInputType.phone,
                              isRequired: true,
                              suffixIcon: const Icon(
                                Icons.phone_outlined,
                                color: Colors.blueGrey,
                              ),
                            ),

                            const SizedBox(height: 20),

                            const Text(
                              "كلمة المرور",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            GetInputFromUserWidget(
                              requiredText: ' ادخل كلمة المرور',
                              errorText: 'كلمة المرور غير صحيحة',
                              controller: passwordController,
                              size: size,
                              hintText: "........",
                              isPassword: true,
                              isRequired: true,
                              suffixIcon: const Icon(
                                Icons.lock_outline,
                                color: ConstantApp.iconColor,
                              ),
                            ),

                            const SizedBox(height: 15),

                            const SizedBox(height: 30),

                            SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ConstantApp.primaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: state is AuthLoading
                                    ? null
                                    : () {
                                        if (_formKey.currentState!.validate()) {
                                          context.read<AuthCubit>().login(
                                            phone: phoneController.text,
                                            password: passwordController.text,
                                          );
                                        }
                                      },
                                child: state is AuthLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "دخول للنظام",
                                            style: TextStyle(
                                              fontFamily:
                                                  ConstantApp.fontFamily,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Icon(Icons.arrow_forward, size: 20),
                                        ],
                                      ),
                              ),
                            ),

                            const SizedBox(height: 40),

                            Center(
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: const TextSpan(
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontFamily: ConstantApp.fontFamily,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "بإستخدامك للنظام، أنت توافق على ",
                                    ),
                                    TextSpan(
                                      text: "شروط الاستخدام ",
                                      style: TextStyle(
                                        fontFamily: ConstantApp.fontFamily,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(text: "و "),
                                    TextSpan(
                                      text: "سياسة الخصوصية",
                                      style: TextStyle(
                                        fontFamily: ConstantApp.fontFamily,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
