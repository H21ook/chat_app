import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String username;
  // final String? state;
  // final String? country;
  // final bool? capital;
  // final int? population;
  // final List<String>? regions;

  User({
    required this.username,
    // this.state,
    // this.country,
    // this.capital,
    // this.population,
    // this.regions,
  });

  factory User.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return User(
      username: data!['username'],
      // state: data?['state'],
      // country: data?['country'],
      // capital: data?['capital'],
      // population: data?['population'],
      // regions:
      //     data?['regions'] is Iterable ? List.from(data?['regions']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "username": username,
      // if (state != null) "state": state,
      // if (country != null) "country": country,
      // if (capital != null) "capital": capital,
      // if (population != null) "population": population,
      // if (regions != null) "regions": regions,
    };
  }
}
