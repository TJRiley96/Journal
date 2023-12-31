import 'package:flutter/material.dart';
import 'package:journal/account/create_account.dart';
import 'package:journal/account/forgot_password.dart';
import 'package:journal/get/get_post.dart';
import 'package:journal/post/create_post.dart';
import 'login/login_screen.dart';




class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/post/create':
        return MaterialPageRoute(builder: (_) => const CreatePostScreen());
      case '/get/entry':
        return MaterialPageRoute(builder: (_) => const GetFirePost());
      case '/account/create':
        return MaterialPageRoute(builder: (_) => const CreateAccount());
      case '/account/forgot':
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      // case '/settings':
      //   return MaterialPageRoute(builder: (_) => const SettingsScreen());
    // case '/bluetooth':
    //   return MaterialPageRoute(builder: (_) => BluetoothScreen());
    // case '/test':
    //   return MaterialPageRoute(builder: (_) => TestScreen());
    // case '/stream':
    //   return MaterialPageRoute(builder: (_) => StreamScreen());
    // case '/chart':
    //   return MaterialPageRoute(builder: (_) => VeloGraph());
    // case '/chart2':
    //   return MaterialPageRoute(builder: (_) => StreamChartAgain());
    // case '/settings/bat':
    //   return MaterialPageRoute(builder: (_) => BatteryGraph());
    // If args is not of the correct type, return an error page.
    // You can also throw an exception while in development.
      default:
      // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}