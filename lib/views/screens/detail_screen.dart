import 'package:api_task/models/user_model.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final UserModel users;
  const DetailScreen({
    super.key,
    required this.users,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${users.firstName} ${users.lastName}"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: users.id,
              transitionOnUserGestures: true,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      users.avatar,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "${users.firstName} ${users.lastName}",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              users.email,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
