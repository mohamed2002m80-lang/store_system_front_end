import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:store_system/logic/auth/cubit/cubit/auth_cubit.dart';
import 'package:store_system/services/api_service.dart';
import 'helper/constant_app.dart';
import 'helper/size_app.dart';
import 'routes/app_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const StoreSystem());
}

class StoreSystem extends StatefulWidget {
  const StoreSystem({super.key});

  @override
  State<StoreSystem> createState() => _StoreSystemState();
}

class _StoreSystemState extends State<StoreSystem> {
  late final GoRouter router;

  @override
  void initState() {
    super.initState();
    router = AppRoute.getRouter();
  }

  @override
  Widget build(BuildContext context) {
    // نستخدم MultiRepositoryProvider لتوفير الـ ApiService أولاً
    return MultiRepositoryProvider(
      providers: [RepositoryProvider(create: (context) => ApiService())],
      child: MultiBlocProvider(
        providers: [
          // ثم نوفر الـ AuthCubit الذي يعتمد على الـ ApiService
          BlocProvider(
            create: (context) => AuthCubit(context.read<ApiService>()),
          ),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          debugShowCheckedModeBanner: false,
          locale: const Locale('ar'),
          supportedLocales: const [Locale('ar')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: ThemeData(
            fontFamily: ConstantApp.fontFamily,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
          ),
          builder: (context, child) {
            SizeApp size = SizeApp(
              widthScreen: MediaQuery.of(context).size.width,
              heightScreen: MediaQuery.of(context).size.height,
            );
            return OfflineBuilder(
              connectivityBuilder: (context, connectivity, child) {
                final connected = !connectivity.contains(
                  ConnectivityResult.none,
                );
                return Scaffold(
                  body: connected
                      ? child
                      : Center(
                          child: Text(
                            '...تأكد من الإتصال بالإنترنت',
                            style: TextStyle(
                              fontSize: size.width * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                );
              },
              child: child!,
            );
          },
        ),
      ),
    );
  }
}
