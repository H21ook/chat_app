import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final db = FirebaseFirestore.instance;

  Future<List<QueryDocumentSnapshot<User>>> getUsersList() async {
    var event = await db
        .collection("users")
        .withConverter(
            fromFirestore: User.fromFirestore,
            toFirestore: (User user, options) => user.toFirestore())
        .get();
    return event.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            "Home",
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  context.go("/account");
                },
                icon: const Icon(
                  Icons.account_circle_outlined,
                  color: Colors.white,
                ))
          ],
        ),
        body: FutureBuilder(
            future: getUsersList(),
            builder: (BuildContext context,
                AsyncSnapshot<List<QueryDocumentSnapshot<User>>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (_, index) {
                      final user = snapshot.data![index].data();
                      return ListTile(
                        onTap: () {
                          context.go("/videocall");
                        },
                        title: Text(user.username),
                        subtitle: const Text("Some text"),
                      );
                    });
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text("No items"),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
