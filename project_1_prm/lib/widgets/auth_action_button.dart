import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_1_prm/screens/profile_screen.dart';
import 'package:project_1_prm/viewmodels/auth_view_model.dart';

class AuthActionButton extends StatelessWidget {
  const AuthActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.errorMessage != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final message = viewModel.errorMessage;
            if (message == null || !context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                behavior: SnackBarBehavior.floating,
              ),
            );
            viewModel.clearError();
          });
        }

        if (viewModel.isLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
          );
        }

        if (!viewModel.isSignedIn) {
          return TextButton.icon(
            onPressed: viewModel.signInWithGoogle,
            icon: const Icon(Icons.login_rounded, color: Colors.white),
            label: const Text('Sign in', style: TextStyle(color: Colors.white)),
          );
        }

        final user = viewModel.user;
        return PopupMenuButton<String>(
          tooltip: 'Account',
          onSelected: (value) {
            if (value == 'profile') {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const ProfileScreen()),
              );
            }
            if (value == 'sign_out') {
              viewModel.signOut();
            }
          },
          itemBuilder: (context) {
            return <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                enabled: false,
                child: Text(user?.email ?? 'Signed in'),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('Profile'),
              ),
              const PopupMenuItem<String>(
                value: 'sign_out',
                child: Text('Sign out'),
              ),
            ];
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: user?.photoURL == null
                  ? null
                  : NetworkImage(user!.photoURL!),
              child: user?.photoURL == null
                  ? const Icon(Icons.person_rounded, size: 18)
                  : null,
            ),
          ),
        );
      },
    );
  }
}
