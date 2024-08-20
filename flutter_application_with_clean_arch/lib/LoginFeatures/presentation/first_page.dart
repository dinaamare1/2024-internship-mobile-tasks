import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Login/login_page.dart/login_page.dart';
class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  void initState() {
    super.initState();
    // Delay for 3 seconds before navigating to LoginPage
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final buttonColor = Color(0xFF3F51F3);
    final containerSize = screenWidth * 0.2;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/smile.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF3F51F3).withOpacity(0.4), // 40% opacity
                    Color(0xFF3F51F3).withOpacity(1.0), // 100% opacity
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: containerSize * 3,
                  height: containerSize * 1.25,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: buttonColor,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  alignment: Alignment.center,
                  child: Transform.scale(
                    scale: 1.5,
                    child: Text(
                      'ECOM',
                      style: GoogleFonts.caveatBrush(
                        fontSize: containerSize * 0.8,
                        fontWeight: FontWeight.w900,
                        color: buttonColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.025),
                Text(
                  'ECOMMERCE APP',
                  style: TextStyle(
                    fontSize: screenWidth * 0.1,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 150,
            left: 0,
            right: 0,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
