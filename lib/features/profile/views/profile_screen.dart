import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fatcherappv2/providers/auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            onTap: () {
              // Navigate to notifications screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Date profil'),
            onTap: () {
              // Navigate to profile details screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.pets),
            title: const Text('Date animal(e)'),
            onTap: () {
              // Navigate to animal details screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Login security'),
            onTap: () {
              // Navigate to login security screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Payments History'),
            onTap: () {
              // Navigate to payments history screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              await auth.logout(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Customer problems'),
            onTap: () {
              // Navigate to customer problems screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy & sharing'),
            onTap: () {
              // Navigate to privacy & sharing screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.gavel),
            title: const Text('Legal'),
            onTap: () {
              // Navigate to legal information screen
            },
          ),
        ],
      ),
    );
  }
}
