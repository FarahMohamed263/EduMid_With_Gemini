import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_screen.dart'; // خلي عندك صفحة HomeScreen جاهزة

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool passwordVisible = false;
  bool confirmPasswordVisible = false;

  bool isLoading = false; // علشان Loading state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xfff3f4f6), Color(0xffe0e7ff), Color(0xfffdf2f8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    "Create Account",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(blurRadius: 20, color: Colors.black12),
                      ],
                    ),
                    child: Column(
                      children: [
                        /// FULL NAME
                        TextFormField(
                          controller: nameController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            hintText: "Full Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Full name is required";
                            }

                            final parts = value.trim().split(RegExp(r'\s+'));
                            if (parts.length < 2) {
                              return "Enter first and last name";
                            }

                            for (var part in parts) {
                              if (part.length < 3) {
                                return "Each name must be at least 3 characters";
                              }

                              if (!RegExp(r'^[a-zA-Z]+$').hasMatch(part)) {
                                return "Name must contain letters only";
                              }
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        /// EMAIL
                        TextFormField(
                          controller: emailController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.email),
                            hintText: "Email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email is required";
                            }

                            if (!RegExp(
                              r'^[^@]+@(gmail\.com|yahoo\.com|sci\.asu\.edu\.eg)$',
                            ).hasMatch(value)) {
                              return "Enter a valid email";
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        /// PASSWORD
                        TextFormField(
                          controller: passwordController,
                          obscureText: !passwordVisible,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock),
                            hintText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password is required";
                            }

                            if (value.contains(' ')) {
                              return "Password cannot contain spaces";
                            }

                            if (value.length < 8) {
                              return "Password must be at least 8 characters";
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        /// CONFIRM PASSWORD
                        TextFormField(
                          controller: confirmPasswordController,
                          obscureText: !confirmPasswordVisible,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock),
                            hintText: "Confirm Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                confirmPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  confirmPasswordVisible =
                                      !confirmPasswordVisible;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Confirm your password";
                            }

                            if (value.contains(' ')) {
                              return "Password cannot contain spaces";
                            }

                            if (value != passwordController.text) {
                              return "Passwords do not match";
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        /// CREATE ACCOUNT BUTTON
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        isLoading = true;
                                      });

                                      try {
                                        // 1️⃣ Sign up in Firebase Auth
                                        UserCredential userCredential =
                                            await FirebaseAuth.instance
                                                .createUserWithEmailAndPassword(
                                                  email: emailController.text
                                                      .trim(),
                                                  password: passwordController
                                                      .text
                                                      .trim(),
                                                );

                                        // 2️⃣ Store extra data in Firestore
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(userCredential.user!.uid)
                                            .set({
                                              'name': nameController.text
                                                  .trim(),
                                              'email': emailController.text
                                                  .trim(),
                                              'createdAt': Timestamp.now(),
                                            });

                                        // 3️⃣ Navigate to Home
                                        if (context.mounted) {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => const HomePage(),
                                            ),
                                          );
                                        }
                                      } on FirebaseAuthException catch (e) {
                                        String message = '';
                                        if (e.code == 'email-already-in-use') {
                                          message =
                                              'This email is already registered';
                                        } else if (e.code == 'weak-password') {
                                          message = 'Password is too weak';
                                        } else {
                                          message =
                                              e.message ?? 'An error occurred';
                                        }

                                        if (context.mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(content: Text(message)),
                                          );
                                        }
                                      } finally {
                                        if (mounted) {
                                          setState(() {
                                            isLoading = false;
                                          });
                                        }
                                      }
                                    }
                                  },
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text("Create Account"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// BACK TO LOGIN
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Sign In"),
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
