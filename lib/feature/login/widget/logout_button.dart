import 'package:arcane/feature/login/login_service.dart';
import 'package:flutter/material.dart';
import 'package:serviced/serviced.dart';

enum LogoutButtonType { tile, button }

class LogoutButton extends StatelessWidget {
  final LogoutButtonType type;

  const LogoutButton({super.key, required this.type});

  void _logout() => svc<LoginService>().signOutDialog();

  @override
  Widget build(BuildContext context) => type == LogoutButtonType.tile
      ? ListTile(
          leading: const Icon(Icons.logout_rounded),
          title: const Text("Log Out"),
          subtitle: const Text("Log Out of your account"),
          onTap: _logout,
        )
      : IconButton(onPressed: _logout, icon: const Icon(Icons.logout_rounded));
}
