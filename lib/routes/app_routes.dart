import 'package:go_router/go_router.dart';
import 'package:store_system/presentation/view/home_view.dart';
import 'package:store_system/routes/names_route.dart';

import '../presentation/view/auth/login_view.dart';

class AppRoute {
  static GoRouter getRouter() {
    return GoRouter(
      initialLocation: NamesRoute.login,
      routes: [
        GoRoute(
          path: NamesRoute.login,
          name: NamesRoute.login,
          builder: (context, state) =>  LoginPage(),
        ),
        GoRoute(
          path: NamesRoute.home,
          name: NamesRoute.home,
          builder: (context, state) => HomeView(),
        ),
      ],
    );
  }
}
