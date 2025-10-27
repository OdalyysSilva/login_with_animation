import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
// 3.1 importar librería timer
import 'dart:async';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Declaramos las variables necesarias
  late TextEditingController _userPasswordController;
  //6.1 Para controlar el estado de carga del botón
  bool _isLoading = false;
  bool _passwordVisible = false;
  //Para controlar la visiblilidad de la contraseña, si se quita no podrá mostrar u ocultar

  StateMachineController?
  controller; // Cerebro de la lógica de las animaciones, controla la animación de Rive
  // SMI State Machine Input
  SMIBool? isCheking;
  SMIBool? isHandsUp;
  SMITrigger? trigFail;
  SMITrigger? trigSuccess;
  // 2.1 Variable de recorrido de la mirada
  SMINumber? numLook; //0...80 en el asset

  // Focos email y password FocusNode paso 1.1
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();
  // 3.2 Crear timer para detener la animación al dejar de teclear email
  Timer? _typingDebouncer;

  //4.1 Declarar controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  //4.2 Errores para mostrar en la UI
  String? emailError;
  String? passwordError;
  //4.3 Validadores
  bool isValidEmail(String email) {
    // Expresiones regulares
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return emailRegex.hasMatch(email);
  }

  bool isValidPassword(String password) {
    // mínimo 8, una mayúscula, una minúscula, un dígito y un especial
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$',
    );
    return passwordRegex.hasMatch(password);
  }

  // 4.4 accion al boton login
  void _onlogin() async {
    //6.2 evita doble tap
    if (_isLoading) return;
    setState(() => _isLoading = true);

    final email = emailController.text.trim();
    final password = passwordController.text;

    // Recalcular errores
    final eError = isValidEmail(email) ? null : 'Email no válido';
    final pError = isValidPassword(password)
        ? null
        : 'Mínimo 8 caracteres, una mayúscula, una minúscula, un número y un especial';
    // para avisar que hubo un cambio
    setState(() {
      emailError = eError;
      passwordError = pError;
    });
    // 4.5 Cerrar el teclado y bajas
    FocusScope.of(context).unfocus();
    _typingDebouncer?.cancel();
    isCheking?.change(false);
    isHandsUp?.change(false);
    numLook?.value = 50.0; // Mirada neutral

    //6.3 spera para que la animación procece antes los cambios
    await Future.delayed(const Duration(milliseconds: 100));
    // 4.7 Activar Triggers
    if (eError == null && pError == null) {
      trigSuccess?.fire();
    } else {
      trigFail?.fire();
    }
    //6.4 Mantiene el spinner visible un segundo
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() => _isLoading = false);
  }

  // Listeners oyentes
  //Aquí se ran los focos
  @override
  void initState() {
    super.initState();
    _userPasswordController = TextEditingController();
    _passwordVisible = false;
    emailFocus.addListener(() {
      if (emailFocus.hasFocus) {
        isHandsUp?.change(false); //manos abajo email
        //2.2 Mirada neutral al enfocar email
        numLook?.value = 50.0;
        isHandsUp?.change(false); //manos abajo email
      }
    });
    passwordFocus.addListener(() {
      isHandsUp?.change(passwordFocus.hasFocus); //manos arriba password
    });
  }

  @override
  Widget build(BuildContext context) {
    // Consulta el tamaño de la pantalla
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              SizedBox(
                width: size.width,
                height: 200,
                child: RiveAnimation.asset(
                  'assets/animated_login_character.riv',
                  stateMachines: ["Login Machine"],
                  onInit: (artboard) {
                    controller = StateMachineController.fromArtboard(
                      artboard,
                      "Login Machine",
                    );
                    // Verificar que inició bien
                    if (controller == null) return;
                    artboard.addController(controller!);
                    isCheking = controller!.findSMI('isChecking');
                    isHandsUp = controller!.findSMI('isHandsUp');
                    trigSuccess = controller!.findSMI('trigSuccess');
                    trigFail = controller!.findSMI('trigFail');
                    //2.3 enlazar la variable con la animación
                    numLook = controller!.findSMI('numLook');
                  }, // Qué es clamp?? en programación y en la vida
                  // clamp: abrazadera retiene el valor dentro de un rango
                ),
              ),
              const SizedBox(height: 10),
              // Campo de texto email
              TextField(
                // llamado a los oyentes
                focusNode: emailFocus,
                // 4.8 enlazar controldores al texfield
                controller: emailController,
                onChanged: (value) {
                  //6.6 Para actualizar el error en vivo
                  setState(() {
                    emailError = isValidEmail(value) ? null : 'Email no válido';
                  });
                  //2.4 Implementando Numlook
                  // estoy escribiendo
                  isCheking!.change(true);
                  // ajuste de limite 0 a 100
                  // 80 es medida de calibración
                  final look = (value.length / 80.0 * 100.0)
                      .clamp(0.0, 100.0)
                      .toDouble();
                  numLook?.value = look;
                  //3.3 Debounce: si vuelve a teclear, reinicia el timer o contador
                  _typingDebouncer?.cancel(); // cancela un timer existente
                  _typingDebouncer = Timer(const Duration(seconds: 4), () {
                    if (!mounted) {
                      return; // si la pantalla se cierra
                    }

                    // Mirada neutral al dejar de teclear email
                    isCheking?.change(false);
                  });

                  if (isCheking == null) return;
                  // Activa el modo chismoso

                  isCheking!.change(true);
                },
                textInputAction: TextInputAction.next,

                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  //4.9 mostrar el texto de error
                  errorText: emailError,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Email',
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.mail),
                ),
              ),
              const SizedBox(height: 10),
              // Campo de texto password
              TextField(
                focusNode: passwordFocus,
                controller: passwordController,
                onChanged: (value) {
                  setState(
                    () {},
                  ); // <- Esto actualiza la lista de requisitos visualmente

                  passwordError = isValidPassword(value)
                      ? null
                      : 'Mínimo 8 caracteres, una mayúscula, una minúscula, un número y un especial';

                  if (isHandsUp != null) {
                    isHandsUp!.change(true);
                  }
                },
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  // 6.6 errorText: passwordError,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Password',
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.password),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
              ),

              // 6.6 Barra visual que muestra qué le falta a la contraseña
              const SizedBox(height: 10),
              PasswordStrengthChecklist(password: passwordController.text),
              SizedBox(height: 10),
              // Texto forgot password
              SizedBox(
                width: size.width,
                child: Text(
                  'Forgot password?',
                  textAlign: TextAlign.right,
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
              // Botón login
              SizedBox(height: 10),
              // Botón estilo andriod, onPressed todos los botnones
              MaterialButton(
                minWidth: size.width,
                height: 50,
                color: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onPressed: _onlogin,
                child:
                    _isLoading //6.5 sustituir
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : const Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("No tienes cuenta?"),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Regístrate',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
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

  @override
  void dispose() {
    // 4.11 limpiar controladores
    emailController.dispose();
    passwordController.dispose();
    _userPasswordController.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    _typingDebouncer?.cancel(); //3.4
    super.dispose();
  }
}

//6.7 Correción de errores de la contraseña
class PasswordStrengthChecklist extends StatelessWidget {
  final String password;
  const PasswordStrengthChecklist({super.key, required this.password});

  bool get hasUppercase => password.contains(RegExp(r'[A-Z]'));
  bool get hasLowercase => password.contains(RegExp(r'[a-z]'));
  bool get hasNumber => password.contains(RegExp(r'\d'));
  bool get hasSpecial => password.contains(RegExp(r'[^A-Za-z0-9]'));
  bool get hasMinLength => password.length >= 8;

  Widget _buildItem(String text, bool condition) {
    return Row(
      children: [
        Icon(
          condition ? Icons.check_circle : Icons.cancel,
          color: condition ? Colors.green : Colors.red,
          size: 18,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: condition ? Colors.green : Colors.red,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) {
      return const SizedBox();
    } // Oculta mientras no escriba nada
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildItem("Al menos 8 caracteres", hasMinLength),
        _buildItem("Una letra mayúscula", hasUppercase),
        _buildItem("Una letra minúscula", hasLowercase),
        _buildItem("Un número", hasNumber),
        _buildItem("Un símbolo o carácter especial", hasSpecial),
      ],
    );
  }
}
