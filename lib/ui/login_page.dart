import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AdminSignInPage extends StatelessWidget {
  const AdminSignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFFFEED3);
    const icon = Color(0xFFCB9F59);
    bool obscurePassword = true;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        toolbarHeight: 0.0,
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: bg,
          systemNavigationBarColor: bg,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      ),
      body: SingleChildScrollView(
        // reverse: true,
        padding: const EdgeInsets.fromLTRB(16, 8.0, 16.0, 10.0),
        child: Column(
          children: [
            SvgPicture.asset(
              'images/login_vector.svg',
              // width: 182.0,
              height: 198.0,
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Welcome Admin',
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.w500,
                color: Color(0xFF37474F),
              ),
            ),
            const SizedBox(height: 8.0),
            const SizedBox(
              width: 255.0,
              child: Text(
                'Log in with provided email & password if you are admin',
                style: TextStyle(color: Color(0xFF837053)),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30.0),
            const SignInTextField(
              hint: 'Email',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icon(Icons.alternate_email, color: icon),
            ),
            const SizedBox(height: 20.0),
            StatefulBuilder(
              builder: (context, setState) => SignInTextField(
                hint: 'Password',
                obscure: obscurePassword,
                keyboardType: TextInputType.visiblePassword,
                prefixIcon: const Icon(Icons.lock_outline_rounded, color: icon),
                suffixIcon: IconButton(
                  onPressed: () => setState(() {
                    obscurePassword = !obscurePassword;
                  }),
                  icon: obscurePassword
                      ? const Icon(Icons.visibility_off_outlined, color: icon)
                      : const Icon(Icons.visibility_outlined, color: icon),
                ),
              ),
            ),
            const SizedBox(height: 80.0),
            MaterialButton(
              height: 52.0,
              onPressed: () {},
              // disabledColor: const Color(0xFFD8D8D8),
              elevation: 0.0,
              // disabledTextColor: Colors.black,
              highlightElevation: 0.0,
              minWidth: double.infinity,
              shape: const StadiumBorder(),
              color: const Color(0xFFE9A538),
              textColor: Colors.white,
              splashColor: const Color(0xFFA56C0F),
              child: const Text('Sign In'),
            ),
          ],
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
  });

  final String? hint;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    final outlinedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(9.0),
      borderSide: const BorderSide(color: Color(0xFFFFDBA3)),
    );

    return TextFormField(
      validator: validator,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(color: Color(0xFFA96C0A)),
      decoration: InputDecoration(
        filled: true,
        isDense: false,
        fillColor: const Color(0xFFFFE6BE),
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFCB9F59)),
        enabledBorder: outlinedBorder,
        focusedBorder: outlinedBorder,
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
