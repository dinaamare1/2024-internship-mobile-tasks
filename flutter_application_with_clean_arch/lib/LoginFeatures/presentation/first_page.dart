import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as prefix;
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/error/failure.dart';
import '../../features/presentation/Home/home_page_widgets/home_page.dart';
import '../data/data_sources/local_data_sources.dart';
import '../data/models/user_model.dart';
import 'Login/login_page.dart/login_page.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends prefix.State<FirstPage> {
  late LocalDataSourcesImp localDataSource;

  @override
  void initState() {
    super.initState();
    _initializeAndCheckUser();  
  }

  void _initializeAndCheckUser() async {
    await _initLocalDataSource();
    await _checkUserLoggedIn();
  }

  Future<void> _initLocalDataSource() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    localDataSource = LocalDataSourcesImp(prefs);
  }

  Future<void> _checkUserLoggedIn() async {
    Either<Failure, UserModel> userOrFailure = await localDataSource.GetUser();

    Future.delayed(Duration(seconds: 3), () {
      userOrFailure.fold(
        (failure) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        },
        (user) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeView(name:user.name)),
          );
        },
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
                    Color(0xFF3F51F3).withOpacity(0.4), 
                    Color(0xFF3F51F3).withOpacity(1.0),
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
