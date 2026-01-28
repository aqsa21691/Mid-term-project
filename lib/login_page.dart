import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //getting data from server (Domain)
import 'dart:convert'; //for encoding and decoding of JSON
import 'dart:math'; //for captcha
import 'home_page.dart'; // for later
import 'signup_page.dart'; // for later

class LoginPage extends StatefulWidget {
  final String?
  prefilledEmail; //for automatically filling or email and password after sign up
  final String? prefilledPassword;

  //Key?key manages flutter tree management while in Key:key child class passes the key to its parent class
  const LoginPage({Key? key, this.prefilledEmail, this.prefilledPassword})
    : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
  //logic or each stateful widget is in state
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  // for reading and writing current textfield
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _captchaController;

  bool _isLoading = false; // button will hide while loading
  bool _obscurePassword = true; //for password security
  String _generatedCaptcha = ""; //for captcha generation

  @override
  void initState() {
    super.initState();
    //if the email and passwords are being prefilled by any page then it will display on screen
    _emailController = TextEditingController(text: widget.prefilledEmail ?? '');
    _passwordController = TextEditingController(
      //if email and password are empty it will be null
      text: widget.prefilledPassword ?? '',
    );
    _captchaController =
        TextEditingController(); //input field for entering captcha
    _generateCaptcha();
  }

  //Generating random 6-character captcha
  void _generateCaptcha() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random(); //for creating random one
    setState(() {
      _generatedCaptcha = List.generate(
        6,
        (index) => chars[random.nextInt(chars.length)],
      ).join();
    });
  }

  //Background working of sign in button
  Future<void> _loginUser() async {
    if (!_formKey.currentState!.validate()) return;

    // verify captcha with user's entered one
    if (_captchaController.text.trim() != _generatedCaptcha) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incorrect captcha, please try again!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      _generateCaptcha(); // refresh captcha
      return;
    }

    setState(() => _isLoading = true); // shows the loading
    // backend verification
    try {
      final uri = Uri.parse('https://devntec.com/E10_API/login_page.php');
      final response = await http.post(
        uri,
        body: {
          'email': _emailController.text.trim(),
          'password': _passwordController.text.trim(),
        },
      );

      final res = jsonDecode(response.body);
      // if email and password along with captcha are correct

      if (response.statusCode == 200 && res['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              fullName: res['full_name'] ?? '',
              email: _emailController.text.trim(),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res['message'] ?? 'Invalid credentials!'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connection Error: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffaf7f8), //App bar backgroung color
      appBar: AppBar(
        title: const Text(
          // Fixed app bar name
          'E10_AQSA',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Color(0xff0a1a3d), // app bar text's color
          ),
        ),
        backgroundColor: Colors.white, //background color
        elevation: 1,
        iconTheme: const IconThemeData(color: Color(0xff0a1a3d)), //icon color
      ),
      body: Center(
        child: SingleChildScrollView(
          //screen can scroll
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 20,
          ), // for clean UI and centered one
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 450,
            ), //Box constraints are of 450px it means it can run on any screen
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 110,
                  ), //logo of BGNU is taken from images folder in assets folder
                  const SizedBox(height: 30),
                  const Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0a1a3d),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // 📧 Email
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined),
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        v!.contains('@') ? null : 'Enter a valid email',
                  ),
                  const SizedBox(height: 18),

                  // 🔒 Password
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline),
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                    ),
                    validator: (v) => v!.isEmpty ? 'Enter your password' : null,
                  ),
                  const SizedBox(height: 20),

                  // 🔤 CAPTCHA Box
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: Text(
                          _generatedCaptcha,
                          style: const TextStyle(
                            fontSize: 20,
                            letterSpacing: 3,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff0a1a3d),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.refresh,
                          color: Color.fromARGB(255, 7, 12, 87),
                        ),
                        onPressed: _generateCaptcha,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _captchaController,
                    decoration: const InputDecoration(
                      labelText: 'Enter CAPTCHA',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        v!.isEmpty ? 'Please enter CAPTCHA' : null,
                  ),

                  const SizedBox(height: 30),

                  // 🔘 Sign In
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff0a1a3d),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _isLoading ? null : _loginUser,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Sign In',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🪪 Sign Up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Color.fromARGB(255, 70, 127, 252),
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
    );
  }
}
