import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_bakery/colors.dart';
import 'package:provider/provider.dart';

import '../backend/auth.dart';

class LoadingOverlay extends ChangeNotifier {
  bool _show = false;
  bool get show => _show;
  set show(bool value) {
    if (_show == value) return;
    _show = value;
    notifyListeners();
  }
}

class AdminSignInPage extends StatefulWidget {
  const AdminSignInPage({super.key});

  @override
  State<AdminSignInPage> createState() => _AdminSignInPageState();
}

class _AdminSignInPageState extends State<AdminSignInPage> {
  final _formKey = GlobalKey<FormState>();
  String? _signinErrorCode;
  late final LoadingOverlay _loadingOverlay;

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _loadingOverlay = LoadingOverlay();
  }

  String? _emailValidator(String? email) {
    if (_signinErrorCode == null) {
      if (email?.isEmpty ?? true) return 'Please enter email id';
    } else {
      switch (_signinErrorCode) {
        case 'user-not-found':
          return 'No admin account found for this email id';
        case 'invalid-email':
          return 'Invalid email format, please check the spelling';
      }
    }
    return null;
  }

  String? _passwordValidator(String? password) {
    if (_signinErrorCode == null) {
      if (password?.isEmpty ?? true) {
        return 'Please enter password';
      } else if (password!.length < 6) {
        return 'Password must contain atleast 6 characters';
      }
    } else if (_signinErrorCode == 'wrong-password') {
      return 'Wrong password';
    }
    return null;
  }

  void _onSignin(BuildContext context) {
    // Validates user inputs only.
    final formState = _formKey.currentState!;
    if (!formState.validate()) return;

    // Showing loading widgtet.
    _loadingOverlay.show = true;

    signInWithEmailAndPassword(
      _emailController.text.trimRight(),
      _passwordController.text,
    ).then((errorCode) {
      _loadingOverlay.show = false;
      if (errorCode == null) {
        Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false);
      } else {
        // Authentication error occurred.
        _signinErrorCode = errorCode;
        formState.validate();
        _signinErrorCode = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const icon = LightColors.main;
    const text = Color(0xFF2F383E);
    bool obscurePassword = true;

    final mainContent = SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8.0, 16.0, 10.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SvgPicture.asset('images/signin.svg', height: 200.0),
            const SizedBox(height: 20.0),
            const Text(
              'Hi there',
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.w500,
                color: text,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(
              width: 255.0,
              child: Text(
                'Log in with provided email & password if you are admin',
                style: TextStyle(color: text),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40.0),
            SignInTextField(
              hint: 'Email Id',
              validator: _emailValidator,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(
                Icons.alternate_email,
                color: icon,
              ),
            ),
            const SizedBox(height: 20.0),
            StatefulBuilder(
              builder: (context, setState) => SignInTextField(
                hint: 'Password',
                validator: _passwordValidator,
                controller: _passwordController,
                obscure: obscurePassword,
                keyboardType: TextInputType.visiblePassword,
                prefixIcon: const Icon(Icons.lock_outline_rounded, color: icon),
                suffixIcon: IconButton(
                  onPressed: () =>
                      setState(() => obscurePassword = !obscurePassword),
                  icon: obscurePassword
                      ? const Icon(Icons.visibility_off_outlined, color: icon)
                      : const Icon(Icons.visibility_outlined, color: icon),
                ),
              ),
            ),
            const SizedBox(height: 80.0),
            MaterialButton(
              height: 52.0,
              onPressed: () => _onSignin(context),
              elevation: 0.0,
              highlightElevation: 0.0,
              minWidth: double.infinity,
              shape: const StadiumBorder(),
              color: LightColors.main,
              textColor: Colors.white,
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );

    return ChangeNotifierProvider.value(
      value: _loadingOverlay,
      child: Scaffold(
        appBar: AppBar(),
        body: Consumer<LoadingOverlay>(
          builder: (_, overlay, __) => overlay.show
              ? Stack(
                  children: [
                    mainContent,
                    Container(
                      color: Colors.black38,
                      alignment: Alignment.center,
                      child: const RepaintBoundary(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ],
                )
              : mainContent,
        ),
      ),
    );
  }
}

class SignInTextField extends StatelessWidget {
  const SignInTextField({
    super.key,
    this.hint,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.obscure = false,
    required this.controller,
  });

  final String? hint;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool obscure;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final outlinedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(9.0),
      borderSide: const BorderSide(color: Color(0xFFA3B2FF)),
    );

    return TextFormField(
      validator: validator,
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: LightColors.main,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        filled: true,
        isDense: false,
        fillColor: const Color(0xFFF9FAFF),
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFF828BB6),
          fontWeight: FontWeight.w400,
        ),
        enabledBorder: outlinedBorder,
        focusedBorder: outlinedBorder,
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
