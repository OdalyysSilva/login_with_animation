import 'package:flutter/material.dart';
import 'package:login_with_animation/screens/login_screen.dart';

void main() {
  //Para que la aplicación arranque y aparezca en pantalla
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  //Es la raiz de la app
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //Configura el tema y la pantalla inicial (temas, navegación, idioma, etc.).
      title: 'Flutter Demo', //Nombre de la app
      debugShowCheckedModeBanner: false, //Quita la marca roja de la esquina
      theme: ThemeData(
        //Define colores y estilos
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:
          const LoginScreen(), //Es la pantalla inicial de la app, si se quita solo se verá una pantalla blanca
    );
  }
}
