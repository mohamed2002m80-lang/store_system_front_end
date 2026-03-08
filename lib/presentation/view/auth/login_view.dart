import 'package:flutter/material.dart';
import 'package:store_system/presentation/widget/get_input_from_user_widget.dart';
import 'package:store_system/helper/size_app.dart';
import 'package:store_system/helper/constant_app.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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

    return Scaffold(
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Card(
          elevation: 0,
          color: Colors.white,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
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
                        controller: passwordController,
                        size: size,
                        hintText: "........",
                        isPassword: true,
                        isRequired: true,
                        suffixIcon: const Icon(
                          Icons.lock_outline,
                          color: Colors.blueGrey,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: rememberMe,
                                activeColor: const Color(0xFF0D1724),
                                onChanged: (val) =>
                                    setState(() => rememberMe = val!),
                              ),
                              const Text("تذكرني"),
                            ],
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              "نسيت كلمة المرور؟",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

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
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {}
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "دخول للنظام",
                                style: TextStyle(
                                  fontFamily: ConstantApp.fontFamily,
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
    );
  }
}
