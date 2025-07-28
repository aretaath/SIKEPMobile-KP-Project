import 'package:flutter/material.dart';
import 'package:sikep/widgets/logout.dart';
import 'package:sikep/models/user.dart';

class UserInfo extends StatelessWidget {
  final UserModel user;
  const UserInfo({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.nama,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(
                user.nip,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        ),
        LogoutButton(),
      ],
    );
  }
}
