import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../features/presentation/Home/home_page_widgets/home_page.dart';
import '../../Login/login_page.dart/login_page.dart';
import '../bloc/register_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth * 0.10;
    final buttonWidth = screenWidth * 0.8;
    final borderRadius = 10.0;
    final buttonColor = Color(0xFF3F51F3);
    final textFieldBackgroundColor = buttonColor.withOpacity(0.1);

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Registration Successful', style: TextStyle(color: Colors.black,)),
                            backgroundColor: Colors.white,),
            );Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeView(name: state.user.name,)),
              );
          } else if (state is RegisterFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Registration failed: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          color: buttonColor,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Spacer(),
                        Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              bottom: 5,
                              child: Container(
                                width: screenWidth * 0.2,
                                height: screenWidth * 0.05,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 15.0,
                                      spreadRadius: 3.0,
                                      offset: Offset(0, 10),
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
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Text(
                                  'ECOM',
                                  style: GoogleFonts.caveatBrush(
                                    fontSize: screenWidth * 0.08,
                                    fontWeight: FontWeight.w900,
                                    color: buttonColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: padding),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create your account',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          fontSize: screenWidth * 0.07778,
                        ),
                      ),
                      SizedBox(height: padding / 1.5),
                      Text(
                        'Name',
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          color: Color(0xFF6F6F6F),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: screenWidth * 0.015),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'ex: jon smith',
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
                      SizedBox(height: padding / 3),
                      Text(
                        'Email',
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          color: Color(0xFF6F6F6F),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: screenWidth * 0.015),
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
                      SizedBox(height: padding / 3),
                      Text(
                        'Password',
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          color: Color(0xFF6F6F6F),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: screenWidth * 0.015),
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
                      SizedBox(height: padding / 3),
                      Text(
                        'Confirm Password',
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          color: Color(0xFF6F6F6F),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: screenWidth * 0.015),
                      TextFormField(
                        controller: _confirmPasswordController,
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
                      SizedBox(height: padding / 3),
                      Row(
                        children: [
                          Checkbox(
                            value: _agreedToTerms,
                            onChanged: (bool? value) {
                              setState(() {
                                _agreedToTerms = value ?? false;
                              });
                            },
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'I understood the ',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.045,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'terms & policy',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.045,
                                      color: buttonColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: padding / 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: SizedBox(
                          width: buttonWidth,
                          child: ElevatedButton(
                            onPressed: _agreedToTerms ? () {
                              context.read<RegisterBloc>().add(
                                RegisterUser(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                  name: _nameController.text,
                                ),
                              );
                            } : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: state is RegisterLoading
                                  ? CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      'SIGN UP',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04478,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: padding/1.5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: TextStyle(
                              fontSize: screenWidth * 0.044,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                            );                            
                            },
                            child: Text(
                              'SIGN IN',
                              style: TextStyle(
                                fontSize: screenWidth * 0.044,
                                color: buttonColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
