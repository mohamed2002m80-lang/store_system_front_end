import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_system/logic/auth/cubit/cubit/auth_cubit.dart';
import 'package:store_system/presentation/widget/get_input_from_user_widget.dart';
import 'package:store_system/helper/size_app.dart';
import 'package:store_system/helper/constant_app.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = SizeApp(
      heightScreen: MediaQuery.of(context).size.height,
      widthScreen: MediaQuery.of(context).size.width,
    );

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("تم إنشاء الحساب بنجاح!")),
          );
          Navigator.pop(context); // العودة لصفحة الدخول
        } else if (state is AuthFailure) {
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
                    ), // هام جداً للشاشات الصغيرةa
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Form(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // جعل النصوص تبدأ من اليمين
                          children: [
                            const Text(
                              "إنشاء حساب جديد",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: ConstantApp.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 30),

                            // --- حقل الاسم ---
                            const Text(
                              "الاسم الكامل",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            GetInputFromUserWidget(
                              requiredText: 'الاسم مطلوب',
                              suffixIcon: const Icon(
                                Icons.person_outline,
                                color: ConstantApp.iconColor,
                              ),
                              controller: nameController,
                              hintText: "أدخل اسمك هنا",
                              size: size,
                              isRequired: true,
                            ),
                            const SizedBox(
                              height: 16,
                            ), // مسافة موحدة بين الحقول
                            // --- حقل الهاتف ---
                            const Text(
                              "رقم الهاتف",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            GetInputFromUserWidget(
                              requiredText: 'رقم الهاتف مطلوب',
                              errorText: 'رقم الهاتف غير صحيح',
                              suffixIcon: const Icon(
                                Icons.phone_outlined,
                                color: ConstantApp.iconColor,
                              ),
                              controller: phoneController,
                              hintText: "9X XXXXXXX",
                              size: size,
                              isRequired: true,
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 16),

                            // --- حقل المدينة ---
                            const Text(
                              "المدينة",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: ConstantApp.fontFamily,
                              ),
                            ),
                            const SizedBox(height: 8),
                            GetInputFromUserWidget(
                              requiredText: 'المدينة مطلوبة',
                              errorText: 'المدينة غير صحيحة',
                              suffixIcon: const Icon(
                                Icons.location_city_outlined,
                                color: ConstantApp.iconColor,
                              ),
                              controller: cityController,
                              hintText: " طرابلس",
                              size: size,
                              isRequired: true,
                            ),
                            const SizedBox(height: 16),

                            // --- حقل كلمة المرور ---
                            const Text(
                              "كلمة المرور",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: ConstantApp.fontFamily,
                              ),
                            ),
                            const SizedBox(height: 8),
                            GetInputFromUserWidget(
                              requiredText: 'كلمة المرور مطلوبة',
                              errorText:
                                  'كلمة المرور يجب أن تكون 8 أحرف على الأقل',
                              suffixIcon: const Icon(
                                Icons.lock_outline,
                                color: ConstantApp.iconColor,
                              ),
                              controller: passwordController,
                              hintText: "........",
                              size: size,
                              isRequired: true,
                              isPassword: true,
                            ),
                            const SizedBox(height: 40),

                            // زر الإنشاء
                            SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ConstantApp.primaryColor,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: state is AuthLoading
                                    ? null
                                    : () {
                                        if (_formKey.currentState!.validate()) {
                                          context.read<AuthCubit>().register(
                                            registerData: {
                                              "name": nameController.text,
                                              "phone": phoneController.text,
                                              "password":
                                                  passwordController.text,
                                              "city": cityController.text,
                                              "storeId": 1,
                                              "roleId": 2,
                                              "warehouseId": 1,
                                            },
                                          );
                                        }
                                      },
                                child: state is AuthLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Text(
                                        "إنشاء الحساب",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
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
