import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/admin/admindashboard.dart';
import 'package:flutter_application_2/controllers/auth.controller.dart';
import 'package:flutter_application_2/model/usermodel.dart';
import 'package:flutter_application_2/routes.dart';
import 'package:flutter_application_2/signuppage.dart';
import 'package:form_field_validator/form_field_validator.dart' as form_validator;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
    late TextEditingController usernameController;
  late TextEditingController passwordController;
    final controller = Get.put(AuthController());
  late SharedPreferences prefs;



    final passwordValidator = form_validator.MultiValidator([
    form_validator.RequiredValidator(errorText: 'Password is required'),
    form_validator.MinLengthValidator(8, 
      errorText: 'Password must be at least 8 characters'),
    form_validator.MaxLengthValidator(15, errorText:'Password must be at max 15 characters'),
    
      
  ]);
    void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }
   @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
     initSharedPref();

  }
  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.white,
          title: Text(
          'Welcome Back',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0B2545), 
      ),
          ),
           centerTitle:true,
      ),
      body: SizedBox.expand(
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Form(
               key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),

                  // Email/Username Field
                  _buildInputField(
                    hint: 'Username',
                    icon: Icons.alternate_email,
                     controller: usernameController,
                    
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Mot de pass field
                         _buildPasswordField(
                      hint: 'Password',
                      obscure: _obscurePassword,
                      controller: passwordController,
                      validator: passwordValidator.call,
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  const SizedBox(height: 30),
                  // Login Button
                  CupertinoButton(
                    borderRadius: BorderRadius.circular(30),
                    color: const Color.fromARGB(255, 1, 207, 18),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                    pressedOpacity: 0.8,
                  onPressed: () async {
  try {
    if ((_formKey.currentState?.validate() ?? false)) {
      final user = Usermodel(
        username: usernameController.text,
        password: passwordController.text,
      );
      
      final result = await controller.signinController(user);
      
      if (result['status'] == true) {
        final mytoken = result['token'] ?? result['access_token'];
         final roles = result['roles'] as List<String>? ?? [];
        if (mytoken != null && mytoken.isNotEmpty) {
          await prefs.setString('token', mytoken);
          Navigator.pushAndRemoveUntil(
            context,
              MaterialPageRoute(
            builder: (context) => roles.contains('ADMIN') 
                ? AdminDashboard() 
                : Routes(token: mytoken)
          ),
          (route) => false,
        );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login successful but no token received")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['error']?.toString() ?? "Unknown login error")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Login failed: ${e.toString()}")),
    );
  }
},

                    child: const Text(
                      'Log In',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Divider
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey[400])),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'OR',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey[400])),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Google Login Button
                  CupertinoButton(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    pressedOpacity: 0.8,
                    onPressed: () {},
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/icons/google.png',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Continue with Google',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Signup Prompt
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account? ',
                        style: TextStyle(
                          color: Colors.grey[600]),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>Signuppage()),);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Color.fromARGB(255, 1, 207, 18),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
    );
        
      
    
  }

  Widget _buildInputField({required String hint, required IconData icon,
    TextEditingController? controller,
    }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
       child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[600]),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
          prefixIcon: Icon(icon, color: Colors.grey[600]),
        ),
      ),
    );
  }
  Widget _buildPasswordField({
  required String hint,
  required bool obscure,
  required TextEditingController controller,
  required FormFieldValidator<String>? validator,
  required VoidCallback onPressed,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey[300]!),
    ),
    child: TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[600]),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.all(16),
        prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[600]),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey[600],
          ),
          onPressed: onPressed,
        ),
        errorStyle: const TextStyle(color: Colors.red),
      ),
    ),
  );
}
}