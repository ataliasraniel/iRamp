import 'package:bot_toast/bot_toast.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:thunderapp/screens/add%20new%20ramp/add_new_ramp_screen.dart';
import 'package:thunderapp/screens/add%20new%20ramp/finished_addition_screen.dart';
import 'package:thunderapp/screens/carrousel/carrousel_screen.dart';
import 'package:thunderapp/screens/screens_index.dart';
import 'package:thunderapp/screens/sign%20up/sign_up_screen.dart';
import 'package:thunderapp/screens/start/start_screen.dart';
import 'package:thunderapp/shared/constants/app_theme.dart';
import 'package:thunderapp/shared/core/db/firestore_db_manager.dart';
import 'package:thunderapp/shared/core/navigator.dart';

import 'screens/home/home_screen.dart';
import 'screens/signin/sign_in_screen.dart';
import 'screens/splash/splash_screen.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final botToastBuilder = BotToastInit();
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      navigatorObservers: [BotToastNavigatorObserver()],
      builder: (context, child) {
        child = botToastBuilder(context, child);
        child = DevicePreview.appBuilder(
            context,
            ResponsiveWrapper.builder(child,
                minWidth: 640,
                maxWidth: 1980,
                defaultScale: true,
                breakpoints: const [
                  ResponsiveBreakpoint.resize(480,
                      name: MOBILE),
                  ResponsiveBreakpoint.resize(768,
                      name: TABLET),
                  ResponsiveBreakpoint.resize(1024,
                      name: DESKTOP),
                ]));
        return child;
      },
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: AppTheme().getCurrentTheme(context),
      routes: {
        Screens.splash: (BuildContext context) =>
            const SplashScreen(),
        Screens.carrousel: (BuildContext context) =>
            const CarrouselScreen(),
        Screens.addNewRamp: (context) =>
            const AddNewRampScreen(),
        Screens.start: (context) => const StartScreen(),
        Screens.signUp: (context) => const SignUpScreen(),
        Screens.home: (BuildContext context) =>
            const HomeScreen(),
        Screens.signin: (BuildContext context) =>
            const SignInScreen(),
        Screens.finished: (context) =>
            const FinishAdditionScreen()
      },
    );
  }
}
