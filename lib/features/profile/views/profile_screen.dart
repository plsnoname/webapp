import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fatcherappv2/providers/auth.dart';
import 'package:go_router/go_router.dart';

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
              GoRouter.of(context).push('/settings/notificationSettings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Date profil'),
            onTap: () {
              GoRouter.of(context).push('/settings/accountSettings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.pets),
            title: const Text('Date animal(e)'),
            onTap: () {
              GoRouter.of(context).push('/settings/accountSettings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Login security'),
            onTap: () {
              GoRouter.of(context).push('/settings/accountSettings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Payments History'),
            onTap: () {
              GoRouter.of(context).push('/settings/accountSettings');
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
              GoRouter.of(context).push('/settings/helpSupport');
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy & sharing'),
            onTap: () {
              GoRouter.of(context).push('/settings/privacySettings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.gavel),
            title: const Text('Legal'),
            onTap: () {
              GoRouter.of(context).push('/settings/accountSettings');
            },
          ),
        ],
      ),
    );
  }
}
