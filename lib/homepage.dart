import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/login.dart';
import 'package:flutter_application_2/signuppage.dart';
// Define the color constant
const Color accentLime = Color(0xFFCCFF33); // FF = full opacity
class Homepage extends StatelessWidget {
  const Homepage({super.key});
  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: SizedBox.expand(
      child: Container(
        color:const Color.fromARGB(83, 1, 207, 18),
        child: Stack(
          children: [
            
                Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0, 0.1, 1],
                  colors: [
                    Color.fromARGB(0, 255, 255, 255), // 40% opacity
                    Color.fromARGB(137, 255, 255, 255), 
                    Color.fromARGB(255, 255, 255, 255), 
                  ],
                ),
              ),
            ),
          ),
        
            // Content with SafeArea
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Spacer(flex: 1),
                      
                      // Title
                      Text(
                        'Wherever You Are',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0B2545), // Dark blue
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Subtitle
                      Text(
                        'Health Is a Priority',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0B2545), // Dark gray
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Description
                      Text(
                        '"There is no instant way to a healthy life"',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF718096), // Medium gray
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Get Started Button
                      CupertinoButton(
                        borderRadius: BorderRadius.circular(30),
                        color: const Color.fromARGB(255, 1, 207, 18),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 16,
                        ),
                        pressedOpacity: 0.8,
                        onPressed: () {
                         Navigator.push(context, MaterialPageRoute(builder:(context)=>Signuppage()),);
                        },
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                     
                            Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Text(
      'Already have an account? ',
      style: TextStyle(
        color: Colors.grey[600],
      ),
    ),
    TextButton(
      onPressed: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>Login()),);
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        'Log In',
        style: TextStyle(
          color: Color.fromARGB(255, 1, 207, 18),
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ],
),
                      
                      const SizedBox(height: 110),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}}
 