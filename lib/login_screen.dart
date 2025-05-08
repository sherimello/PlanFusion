import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'client_screen/client_screen.dart';
import 'service_provider/service_provider_main.dart';
import 'admin_screen/admin_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  final String? selectedRole;
  final String? userName;
  final String? email;
  final String? password;

  const LoginScreen({
    super.key,
    this.selectedRole,
    this.userName,
    this.email,
    this.password,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String selectedRole = "Client";
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _errorMessage;
  bool _obscurePassword = true, _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _loginUser() async {
    if (!_formKey.currentState!.validate()) {
      return; // If form is not valid, do nothing
    }

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // User successfully logged in
      User? user = userCredential.user;
      if (user != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Login successful! Welcome ${user.displayName ?? user.email}')),
          );
          // Navigate to your app's home screen or dashboard
          // Example:
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => const HomeScreen()),
          // );
          print("User logged in: ${user.uid}");
          // You might want to navigate based on widget.selectedRole or fetch role from Firestore
        }
      }
    } on FirebaseAuthException catch (e) {
      String message = "Login failed. Please try again.";
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is not valid.';
      } else if (e.code == 'user-disabled') {
        message = 'This user account has been disabled.';
      } else if (e.code == 'invalid-credential') {
        // More generic error for invalid email/password
        message = 'Invalid email or password.';
      }
      // It's good to log the actual error code for debugging
      print('Firebase Auth Error Code: ${e.code}');
      print('Firebase Auth Error Message: ${e.message}');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An unexpected error occurred: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.selectedRole != null) {
      selectedRole = widget.selectedRole!;
    }
    if (widget.email != null) {
      _emailController.text = widget.email!;
    }
    if (widget.password != null) {
      _passwordController.text = widget.password!;
    }
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _errorMessage = null;
      });

      if (selectedRole == "Admin") {
        if (_emailController.text == "admin@example.com" &&
            _passwordController.text == "admin123") {
          _showSuccessPopup("Admin", () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const AdminDashboardScreen()),
            );
          });
        } else {
          setState(() {
            _errorMessage = "Invalid admin credentials.";
          });
        }
      } else if (selectedRole == "Service Provider") {
        _loginUser().whenComplete(() {
          _showSuccessPopup("Service Provider", () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const ServiceProviderMain()),
            );
          });
        });
      } else if (selectedRole == "Client") {
        _loginUser().whenComplete(() {
          _showSuccessPopup("Client", () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ClientScreen()),
            );
          });
        });
      }
    }
  }

  void _showSuccessPopup(String role, VoidCallback onRedirect) {
    String username = _emailController.text.split('@').first;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Stack(
          children: [
            const Opacity(
              opacity: 0.3,
              child: ModalBarrier(dismissible: false, color: Colors.black),
            ),
            Center(
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                backgroundColor: const Color(0xFFEFC8C5),
                contentPadding: const EdgeInsets.all(20),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle,
                        size: 60, color: Colors.black),
                    const SizedBox(height: 10),
                    Text(
                      "Welcome, $username!",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Redirecting to $role Dashboard...",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context);
      onRedirect();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/b8.jpg'),
                fit: BoxFit.cover,
              ),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.7),
                  Colors.white.withOpacity(0.7)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.1),
                    const Text(
                      "PlanFusion",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF5A4B4B),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildRoleOption("Client"),
                        _buildRoleOption("Admin"),
                        _buildRoleOption("Service Provider"),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    ClipOval(
                      child: Image.asset(
                        'assets/logo.jpg',
                        height: screenHeight * 0.15,
                        width: screenHeight * 0.15,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    _buildTextField(
                      "Email",
                      "Enter your email",
                      _emailController,
                      Icons.email,
                      false,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    _buildTextField(
                      "Password",
                      "Enter your password",
                      _passwordController,
                      Icons.lock,
                      true,
                    ),
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          _errorMessage!,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ),
                    SizedBox(height: screenHeight * 0.03),
                    ElevatedButton(
                      onPressed: _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEFC8C5),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02,
                          horizontal: screenWidth * 0.3,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text("LOG IN"),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Don't have an account? SIGN UP",
                        style: TextStyle(
                          color: Color(0xFF5A4B4B),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Visibility(
                visible: _isLoading,
                child: const CircularProgressIndicator(
                  color: Colors.black,
                )),
          )
        ],
      ),
    );
  }

  Widget _buildRoleOption(String title) {
    return Row(
      children: [
        Radio(
          value: title,
          groupValue: selectedRole,
          onChanged: (value) {
            setState(() {
              selectedRole = value.toString();
            });
          },
          activeColor: const Color(0xFFEFC8C5),
        ),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF5A4B4B),
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, String hint,
      TextEditingController controller, IconData icon, bool isPassword) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFF5A4B4B), fontSize: 16),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText: isPassword ? _obscurePassword : false,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "$label is required";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            prefixIcon: Icon(icon, color: const Color(0xFFEFC8C5)),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: const Color(0xFFEFC8C5),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  )
                : null,
          ),
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
      ],
    );
  }
}
