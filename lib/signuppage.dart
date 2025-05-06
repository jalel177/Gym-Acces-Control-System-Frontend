import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/controllers/auth.controller.dart';
import 'package:flutter_application_2/model/usermodel.dart';
import 'package:flutter_application_2/login.dart';
import 'package:form_field_validator/form_field_validator.dart'as form_validator;
import 'package:get/get.dart';

class Signuppage extends StatefulWidget {
  const Signuppage({super.key});

  @override
  State<Signuppage> createState() => _MyWidgetState();
}
@override
class _MyWidgetState extends State<Signuppage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  late TextEditingController firstnameController;
  late TextEditingController lastnameController;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController addressController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  final controller = Get.put(AuthController());

  final emailValidator = form_validator.MultiValidator([
    form_validator.RequiredValidator(errorText: 'Email is required'),
    form_validator.EmailValidator(errorText: 'Enter a valid email address'),
  ]);

  final passwordValidator = form_validator.MultiValidator([
    form_validator.RequiredValidator(errorText: 'Password is required'),
    form_validator.MinLengthValidator(8, 
      errorText: 'Password must be at least 8 characters'),
    form_validator.MaxLengthValidator(15, errorText:'Password must be at max 15 characters'),
      
  ]);


  
  @override
  void initState() {
    super.initState();
    firstnameController=TextEditingController();
    lastnameController=TextEditingController();
    usernameController=TextEditingController();
    emailController = TextEditingController();
    addressController=TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    addressController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
    String? _confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }
    if (value != passwordController.text) {
      return 'Passwords must match';
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
    backgroundColor: Colors.white,
    centerTitle: true,
    title: Text(
      'Create Account',
      style: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF0B2545),
       
      ),
    ),

    
  ),
      body: Form(
        key: _formKey,
        child: SizedBox.expand(
          child: Container(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
        
                   
                    // Name fields (no controllers/validators)
                    Row(
                      children: [
                        Expanded(
                          child: _buildInputField(
                            hint: 'First Name',
                            icon: Icons.person_outline,
                            controller: firstnameController,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildInputField(
                            hint: 'Last Name',
                            icon: Icons.person_outline,
                            controller: lastnameController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Username (no controller/validator)
                    _buildInputField(
                      hint: 'Username',
                      icon: Icons.alternate_email,
                      controller:usernameController,
                    ),

                    // Username (no controller/validator)
               
               
                    const SizedBox(height: 20),
                    // Email field with validation
                    _buildInputField(
                      hint: 'Email',
                      icon: Icons.email_outlined,
                      controller: emailController,
                      validator: emailValidator.call,
                    ),
                                _buildInputField(
                      hint: 'Address',
                      icon: Icons.home_max_outlined,
                      controller: addressController,
                    ),
                    const SizedBox(height: 20),
                    // Password field with validation
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
                    const SizedBox(height: 20),
                    // Confirm Password with validation
                    _buildPasswordField(
                      hint: 'Confirm Password',
                      obscure: _obscureConfirmPassword,
                      controller: confirmPasswordController,
                      validator: _confirmPasswordValidator,
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                             const SizedBox(height: 20),
                    // Username (no controller/validator)
        
                    const SizedBox(height: 30),
                    CupertinoButton(
                      borderRadius: BorderRadius.circular(30),
                      color: const Color.fromARGB(255, 1, 207, 18),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                      pressedOpacity: 0.8,
                      onPressed: () async{
                        if (_formKey.currentState!.validate()) {
                             final user = Usermodel(
                                    userid: '',
                                    firstname:firstnameController.text, 
                                    lastname: lastnameController.text,
                                    username: usernameController.text,
                                    email:emailController.text,
                                    address: addressController.text,
                                    password:passwordController.text, 
                                    
                                  );
                                    var result = await controller
                                      .signupController(user);
                                      
                                  if (result['status'] == true) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(result['success']),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(result['error'])),
                                    );
                                  }
                                  print("success");
                                      Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Login()));
                                } else {
                                  print("failure");}
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    
                               const SizedBox(height: 20),

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
        'assets/icons/google.png', // Add this image to your assets
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String hint,
    required IconData icon,
    TextEditingController? controller,
    FormFieldValidator<String>? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[600]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          prefixIcon: Icon(icon, color: Colors.grey[600]),
          errorStyle: const TextStyle(color: Colors.red),
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