import 'package:api_task/models/user_model.dart';
import 'package:api_task/views/screens/detail_screen.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final UserModel user;
  const UserCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailScreen(users: user),
        ),
      ),
      child: Hero(
        transitionOnUserGestures: true,
        tag: "user_avatar_${user.id}",
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 1,
                  )
                ]),
            child: Material(
              borderRadius: BorderRadius.circular(20),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.avatar),
                ),
                title: Text("${user.firstName} ${user.lastName}"),
                subtitle: Text(user.email),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
