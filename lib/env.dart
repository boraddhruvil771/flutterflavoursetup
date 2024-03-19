import 'package:flutter/material.dart';

enum Environment { dev, prod, staging }

abstract class AppEnvironment {
  static late String baseApiUrl;
  static late String title;
  static late String imageUrl;
  static late Color primaryColors;
  static late Environment _environment;

  static Environment get environment => _environment;

  static setUpEnv(Environment env) {
    _environment = env;
    switch (env) {
      case Environment.dev:
        {
          baseApiUrl = "https://app-dev.com";
          title = "Flavour development";
          primaryColors = Colors.blue;
          imageUrl = "https://www.odishaage.com/wp-content/uploads/2021/11/d56d20b4-1072-48c0-b832-deecf6641d49-696x464.jpg";
          break;
        }
      case Environment.prod:
        {
          baseApiUrl = "https://app-prod.com";
          title = "Flavour production";
          primaryColors = Colors.redAccent;
          imageUrl = "https://www.shutterstock.com/image-illustration/production-word-cloud-business-concept-260nw-357240260.jpg";
          break;
        }
      case Environment.staging:
        {
          baseApiUrl = "https://adevelopmentpp-staging.com";
          title = "Flavour staging";
          primaryColors = Colors.green;
          imageUrl = "https://media.istockphoto.com/id/1368320531/photo/home-staging.webp?b=1&s=170667a&w=0&k=20&c=43TRCDsc2vxOsXBL0a4OSDse8WOuQx5it48rNO6z-SE=";
          break;
        }
    }
  }
}
