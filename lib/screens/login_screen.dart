import 'package:flutter/material.dart'; //widgets y estilos de flutter
import 'package:rive/rive.dart'; //para usar las animaciones Rive
//3.1 importar libreria par timer
import 'dart:async';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
} //Si se quita la pantalla no existe

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  //Para controlar la visiblilidad de la contraseña, si se quita no podrá mostrar u ocultar

  StateMachineController? controller; //controla la animación de Rive

  // Cerebro de la lógica de las animaciones
  //SMI: State Machine Input
  SMIBool? isChecking; //Activa el modo chismoso
  SMIBool? isHandsUp; //se tapa los ojos
  SMITrigger? trigSucess; //se emociona
  SMITrigger? trigFail; //Se pone triste

  //2.1 vaariable para recorrido de la mirada
  SMINumber? numLook; //0..80 en el asset

  //1. crear variables focusNotde
  final emailFocus = FocusNode();
  final passFocus = FocusNode();

  //3.2 timer para detener la mirada al dejar de teclear
  Timer? _typingDebounce;

  //2. listeners (oyentes/chismoso)
  //aqui se crean los focos
  @override
  void initState() {
    super.initState();
    emailFocus.addListener(() {
      if (emailFocus.hasFocus) {
        //Manos abajo en email
        isHandsUp?.change(false);
        //2.2 mirada neutral al enofcar email
        numLook?.value = 50.0;
        isHandsUp?.change(false);
      }
    });
    passFocus.addListener(() {
      //Manos arriba en password
      isHandsUp?.change(passFocus.hasFocus);
    });
  }

  @override
  Widget build(BuildContext context) {
    //Si el build se quita, no muestra nada
    // el MediaQuery para obetener el tamaño de la pantalla del dispositivo
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      //Estructura para pantallas
      // evita nugde o cámaras frontales para móviles
      body: SafeArea(
        //Evita que el contenido se superponga
        child: Padding(
          //agrega márgenes
          // Margen horizontal, eje x horizontal o derecha izquierda, sino todo se pegaría a los bordes
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            //Organización vertical, para poner cosas debajo de otras
            children: [
              SizedBox(
                //Da el espacio para mostrar la animación
                width: size.width,
                height: 200,
                child: RiveAnimation.asset(
                  //Muestra el archivo de animación
                  'assets/animated_login_character.riv',
                  stateMachines: ["Login Machine"], //Al iniciarse
                  //Conecta el Rive con el código
                  onInit: (artboard) {
                    //Enlaza la variables de los gestos
                    controller = StateMachineController.fromArtboard(
                      artboard,
                      "Login Machine",
                    );
                    //Verificar que inició bien
                    if (controller == null) return;
                    artboard.addController(controller!);
                    isChecking = controller!.findSMI('isChecking');
                    isHandsUp = controller!.findSMI('isHandsUp');
                    trigSucess = controller!.findSMI('trigSucess');
                    trigFail = controller!.findSMI('trigFail');
                    //Enlazar variable con la animación
                    numLook = controller!.findSMI('numLook');
                  },
                ),
              ),
              const SizedBox(height: 10),

              TextField(
                //Email
                focusNode:
                    emailFocus, //para llamar a los oyentes, asignar el focusnode al textfield
                onChanged: (value) {
                  if (isHandsUp != null) {
                    //Baja las manos
                    //isHandsUp!.change(false);

                    //2.4 Implementando numlook
                    //estoy escribiendo
                    isChecking!.change(true);
                    //ajuste de limites de 0 a 100
                    //80 es una medida de calibracion
                    final look = (value.length / 80.0 * 100.0).clamp(
                      0.0,
                      100.0,
                    );
                    numLook?.value = look;

                    //3.3 debounce: si vuelve a teclear, reinicia el contador
                    _typingDebounce
                        ?.cancel(); //cancela cualquier timer existente
                    _typingDebounce = Timer(const Duration(seconds: 3), () {
                      if (!mounted) {
                        return; //si la pnatlla se cierra
                      }
                      //Mirada neutra
                      isChecking?.change(false);
                    });
                  }
                  if (isChecking == null) return;
                  //Mueve los ojos
                  isChecking!.change(true);
                },
                //Campo de texto
                //Para que aparezaca el email del usuraio en móviles
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Email",
                  prefixIcon: const Icon(Icons.mail),
                  border: OutlineInputBorder(
                    // Esquinas redondeadas
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              TextField(
                //Password
                focusNode:
                    passFocus, //para llamar a los oyentes, asignar el focusnode al textfield
                onChanged: (value) {
                  if (isChecking != null) {
                    //Deja de mirar
                    //isChecking!.change(false);   //se comenta porque ya no es necesario
                  }
                  if (isHandsUp == null) return;
                  //Se tapa los ojos
                  isHandsUp!.change(true);
                },
                //Para que aparezaca la contraseña del usuraio en móviles
                obscureText:
                    !_isPasswordVisible, // Si es true, oculta y si es false, muestra
                decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    // BorderRadius es para esquinas redondeadas
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    //suffix, para poner un widget al final del Testfield
                    //IconB, Es el botón para hacer click
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons
                                .visibility_off //Para poder ocultar
                          : Icons.visibility, //Para poder mostrarla
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      }); //actualiza si se ve un signo o el otro
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                //Para poner la parte de se te olvidó la contraseña?
                width: size.width,
                child: const Text(
                  "Forgot your password",
                  textAlign: TextAlign.right, //Alinear a la derecha
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),

              const SizedBox(height: 10), //Para el botón de inicio de sesión
              MaterialButton(
                minWidth: size.width,
                height: 50,
                color: Colors.deepPurpleAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(12),
                ),
                onPressed: () {},
                child: Text("Login", style: TextStyle(color: Colors.white70)),
              ),
              const SizedBox(height: 10),
              SizedBox(
                //Muestra la parte de registro
                width: size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Solo dibuja el texto y da la opción de registro
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Register",
                        style: TextStyle(
                          color: Colors.black12,
                          //en negrita
                          fontWeight: FontWeight.bold,
                          //subrayado
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //4. liberacion de recursos/limpieza de focus
  @override
  void dispose() {
    emailFocus.dispose();
    passFocus.dispose();
    _typingDebounce?.cancel();
    super.dispose();
  }
}
