import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:cloud_firestore/cloud_firestore.dart'; // Import FirebaseFirestore
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String selectedRole = "Client";
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false; // To show a loading indicator

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUpUser() async {
    if (!_formKey.currentState!.validate()) {
      return; // If form is not valid, do nothing
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Create user with Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;

      if (user != null) {
        // Optionally, update the user's display name in Firebase Auth
        await user.updateDisplayName(_nameController.text.trim());
        // Reload user to get updated info if needed, though not strictly necessary here
        // await user.reload();
        // user = _auth.currentUser; // Re-fetch current user

        // 2. Save user credentials/info to Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': _nameController.text.trim(),
          'email': user.email, // Use user.email as it's verified by Auth
          'role': selectedRole,
          'createdAt': FieldValue.serverTimestamp(), // Good practice to store creation time
          // Add any other fields you want to store
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sign up successful! Please log in.')),
          );
          // Navigate to LoginScreen or directly to HomeScreen if you auto-login
          Navigator.pushReplacement( // Use pushReplacement so user can't go back to signup
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(
                selectedRole: selectedRole,
                userName: _nameController.text.trim(),
                email: _emailController.text.trim(),
                password: _passwordController.text.trim(),
                // You might want to prefill email on login screen
                // email: _emailController.text.trim(),
              ),
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      String message = "An error occurred. Please try again.";
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is not valid.';
      }
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
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/b8.jpg'), // Ensure this asset exists
            fit: BoxFit.cover,
          ),
          gradient: LinearGradient( // This gradient will overlay the image
            colors: [
              const Color(0xFFFFFFFF).withOpacity(0.8), // Adjust opacity
              const Color(0xFFFFFFFF).withOpacity(0.8), // Adjust opacity
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
                    _buildRoleOption("Service Provider"),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),
                _buildTextField(
                  "Name",
                  "Enter your name",
                  controller: _nameController,
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Name is required";
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                _buildTextField(
                  "Email",
                  "Enter your email",
                  controller: _emailController,
                  icon: Icons.email,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Email is required";
                    }
                    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                        .hasMatch(value.trim())) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                _buildTextField(
                  "Password",
                  "Enter your password",
                  controller: _passwordController,
                  icon: Icons.lock,
                  isPassword: true,
                  obscureText: _obscurePassword,
                  onToggleObscureText: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    }
                    if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                _buildTextField(
                  "Confirm Password",
                  "Confirm your password",
                  controller: _confirmPasswordController,
                  icon: Icons.lock,
                  isPassword: true,
                  obscureText: _obscureConfirmPassword,
                  onToggleObscureText: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Confirm Password is required";
                    }
                    if (value != _passwordController.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.03),
                Center(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _signUpUser, // Call _signUpUser
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
                    child: _isLoading
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.0,
                      ),
                    )
                        : const Text("SIGN UP"),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                TextButton(
                  onPressed: _isLoading ? null : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(selectedRole: "Admin"),
                      ),
                    );
                  },
                  child: const Text(
                    "LOGIN AS ADMIN",
                    style: TextStyle(
                      color: Color(0xFF5A4B4B),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildAuthIcon(FontAwesomeIcons.google),
                    SizedBox(width: screenWidth * 0.05),
                    _buildAuthIcon(FontAwesomeIcons.facebook),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                TextButton(
                  onPressed: _isLoading ? null : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(
                          selectedRole: selectedRole,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "Already have an account? LOG IN",
                    style: TextStyle(
                      color: Color(0xFF5A4B4B),
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05), // Extra padding at bottom
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleOption(String title) {
    return Row(
      children: [
        Radio<String>( // Explicitly type Radio
          value: title,
          groupValue: selectedRole,
          onChanged: (String? value) { // Make value nullable
            if (value != null) {
              setState(() {
                selectedRole = value;
              });
            }
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

  Widget _buildTextField(
      String label,
      String hint, {
        bool isPassword = false,
        required TextEditingController controller,
        required IconData icon,
        bool obscureText = false,
        VoidCallback? onToggleObscureText,
        required String? Function(String?) validator,
      }) {
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
          obscureText: isPassword ? obscureText : false,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.white.withOpacity(0.9), // Slightly transparent white
            contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none, // Remove border if filled
            ),
            enabledBorder: OutlineInputBorder( // Border when enabled but not focused
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder( // Border when focused
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFEFC8C5), width: 1.5),
            ),
            prefixIcon: Icon(icon, color: const Color(0xFFEFC8C5)),
            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: const Color(0xFFEFC8C5),
              ),
              onPressed: onToggleObscureText,
            )
                : null,
          ),
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildAuthIcon(IconData icon) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: const Color(0xFFEFC8C5),
      child: IconButton(
        icon: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
        onPressed: () {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Social login not implemented yet.')),
            );
          }
          // Social login logic here
        },
      ),
    );
  }
}