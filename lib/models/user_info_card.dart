import 'package:flutter/material.dart';

class UserInfoCard extends StatelessWidget {
  final String userName;
  final String profilePicture;
  final int steps;

  UserInfoCard({
    required this.userName,
    required this.profilePicture,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 20,
          width: 20,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: NetworkImage(profilePicture), fit: BoxFit.cover)
          ),
        ),
        SizedBox(
          width: 3,
        ),
        Container(
          child: Text(userName),
        ),
        Spacer(),
        Container(
          child: Text(steps.toString()),
        )
      ],
    );
  }
}
