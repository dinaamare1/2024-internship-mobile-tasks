import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../features/presentation/Home/home_page_widgets/home_page.dart';
import '../../Register/register_page/register_page.dart';
import '../bloc/login_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage; 

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonColor = Color(0xFF3F51F3);
    final textFieldBackgroundColor = buttonColor.withOpacity(0.1);
    final borderRadius = 10.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: SizedBox(
            width: screenWidth,
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.10),
              child: BlocConsumer<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state is LoginSuccess) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeView(name: state.user.name,)),
                    );
                  }
                  if (state is LoginFailure) {
                    setState(() {
                      _errorMessage = 'Login failed: ${state.failure.message}';
                      _emailController.clear();
                      _passwordController.clear();
                    });
                  }
                },
                builder: (context, state) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: screenWidth * 0.2),
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: screenWidth * 0.4,
                              height: screenWidth * 0.03,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10.0,
                                    spreadRadius: 3.0,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: buttonColor,
                                width: screenWidth * 0.0026,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                screenWidth * 0.09,
                                screenWidth * 0.02,
                                screenWidth * 0.09,
                                screenWidth * 0.02,
                              ),
                              child: Text(
                                'ECOM',
                                style: GoogleFonts.caveatBrush(
                                  fontSize: screenWidth * 0.1333,
                                  fontWeight: FontWeight.w400,
                                  color: buttonColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenWidth * 0.1),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sign into your account',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                              fontSize: screenWidth * 0.06778,
                            ),
                          ),
                          SizedBox(height: screenWidth * 0.05),
                          Text(
                            'Email',
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              color: Color(0xFF6F6F6F),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: screenWidth * 0.02),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              hintText: 'ex: jon.smith@email.com',
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(borderRadius),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: buttonColor),
                                borderRadius: BorderRadius.circular(borderRadius),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: textFieldBackgroundColor),
                                borderRadius: BorderRadius.circular(borderRadius),
                              ),
                            ),
                          ),
                          SizedBox(height: screenWidth * 0.05),
                          Text(
                            'Password',
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              color: Color(0xFF6F6F6F),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: screenWidth * 0.02),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: '***********',
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(borderRadius),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: buttonColor),
                                borderRadius: BorderRadius.circular(borderRadius),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: textFieldBackgroundColor),
                                borderRadius: BorderRadius.circular(borderRadius),
                              ),
                            ),
                          ),
                          SizedBox(height: screenWidth * 0.05),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: SizedBox(
                              width: screenWidth * 0.8,
                              child: ElevatedButton(
                                onPressed: () {
                                  context.read<LoginBloc>().add(
                                    LoginUser(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: buttonColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: state is LoginLoading
                                    ? SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.0,
                                        ),
                                      )
                                    : Text(
                                        'SIGN IN',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04478,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          if (_errorMessage != null)
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text(
                                _errorMessage!,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: screenWidth * 0.04,
                                ),
                              ),
                            ),
                          SizedBox(height: screenWidth * 0.3),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Don\'t have an account? ',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.038,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => RegisterPage()),
                                  );
                                },
                                child: Text(
                                  'SIGN UP',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.038,
                                    color: buttonColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        
      ),
    );
  }
}
