import 'package:flutter/material.dart';
import 'package:newsapp/provider/auth_provider.dart';
import 'package:newsapp/provider/comments_provider.dart';
import 'package:provider/provider.dart';
import 'comments_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLogin = false;

  Future<void> _signup(BuildContext context) async {
    try {
      if (_emailController.text.trim().isEmpty ||
          _passwordController.text.trim().isEmpty ||
          _nameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill in all fields'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      bool value =
          await Provider.of<AuthenticationProvider>(context, listen: false)
              .signup(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _nameController.text.trim(),
      );
      if (value) {
        if (context.mounted) {
          Provider.of<CommentsProvider>(context, listen: false);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const CommentsScreen()),
          );
        }
      } else {
        if (context.mounted) {
          final error =
              Provider.of<AuthenticationProvider>(context, listen: false)
                  .errorMessage;
          if (error.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error),
                backgroundColor: Colors.red,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to sign up'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Failed to sign up: $e');
    }
  }

  Future<void> _signin(BuildContext context) async {
    try {
      if (_emailController.text.trim().isEmpty ||
          _passwordController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill in all fields'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      bool value =
          await Provider.of<AuthenticationProvider>(context, listen: false)
              .signin(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (value) {
        if (context.mounted) {
          Provider.of<CommentsProvider>(context, listen: false);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const CommentsScreen()),
          );
        }
      } else {
        if (context.mounted) {
          final error =
              Provider.of<AuthenticationProvider>(context, listen: false)
                  .errorMessage;
          if (error.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error),
                backgroundColor: Colors.red,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to sign in'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Failed to sign up: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(
      builder: (context, authProvider, state) {
        return authProvider.isLoading
            ? const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              )
            : Scaffold(
                appBar: AppBar(
                  title: Text(
                    'Comments',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                bottomNavigationBar: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            isLogin ? _signin(context) : _signup(context);
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.height * 0.06,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              isLogin ? 'Login' : 'Signup',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isLogin)
                            Text(
                              "New Here? ",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          if (!isLogin)
                            Text(
                              "Already have an account? ",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isLogin = !isLogin;
                                _passwordController.clear();
                                _emailController.clear();
                                _nameController.clear();
                              });
                            },
                            child: Text(
                              isLogin ? 'Signup' : 'Login',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        !isLogin
                            ? TextFormField(
                                key: const ValueKey('name'),
                                controller: _nameController,
                                decoration:
                                    inputDecorationCustom(context, 'Name'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  } else {
                                    return null;
                                  }
                                },
                              )
                            : Container(),
                        const SizedBox(height: 12),
                        TextFormField(
                          key: const ValueKey('email'),
                          controller: _emailController,
                          decoration: inputDecorationCustom(context, 'Email'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            if (!value.contains('@')) {
                              return 'Invalid email';
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          key: const ValueKey('password'),
                          controller: _passwordController,
                          decoration:
                              inputDecorationCustom(context, 'Password'),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }

  InputDecoration inputDecorationCustom(BuildContext context, String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: Theme.of(context).textTheme.bodyMedium,
      fillColor: Colors.white,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}