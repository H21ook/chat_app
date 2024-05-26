import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/widgets/shared/custom_text_form_input.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  final db = FirebaseFirestore.instance;
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _username = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - kToolbarHeight,
        child: Form(
          key: _formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Register",
                    style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: 16),
                CustomTextFormInput(
                    controller: _username,
                    labelText: 'Username',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter username';
                      }
                      if (value.length < 6) {
                        return "Username length must be greater than 6 characters";
                      }
                      return null;
                    }),
                const SizedBox(height: 16),
                CustomTextFormInput(
                    labelText: 'Password',
                    obscureText: true,
                    controller: _pass,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      if (value.length < 4) {
                        return "Password length must be greater than 4 characters";
                      }
                      return null;
                    }),
                const SizedBox(height: 16),
                CustomTextFormInput(
                    labelText: 'Confirm Password',
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter confirm password';
                      }
                      if (value != _pass.text) {
                        return 'Confirm password not match';
                      }
                      return null;
                    }),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      authProvider
                          .registerUser(
                              _username.text.toLowerCase(), _pass.text)
                          .then((res) {
                        if (res.code == 500) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(res.errorText ?? "Error...")),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Register success")),
                          );
                          _formKey.currentState!.reset();
                          context.go("/login");
                        }
                      });
                    }
                  },
                  style: FilledButton.styleFrom(
                      fixedSize: const Size.fromWidth(double.maxFinite)),
                  child: const Text("Register"),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.go("/login");
                  },
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size.fromWidth(double.maxFinite)),
                  child: const Text("Login"),
                ),
              ]),
        ),
      ),
    );
  }
}
