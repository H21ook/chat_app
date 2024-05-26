import 'package:chat_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          backgroundColor: Theme.of(context).colorScheme.primary,
          actions: [
            IconButton(
                onPressed: () {
                  authProvider.logout();
                },
                icon: const Icon(Icons.logout_outlined))
          ],
          title: Text(
            "Account",
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          )),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Email"),
              Text(authProvider.loggedUser?.email ?? ""),
            ],
          ),
        ),
      ),
    );
  }
}
