import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_1_prm/viewmodels/auth_view_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Consumer<AuthViewModel>(
        builder: (context, viewModel, child) {
          if (!viewModel.isSignedIn) {
            return _SignedOutProfileState(viewModel: viewModel);
          }

          final user = viewModel.user;

          return ListView(
            padding: const EdgeInsets.all(24),
            children: <Widget>[
              Center(
                child: CircleAvatar(
                  radius: 52,
                  backgroundImage: user?.photoURL == null
                      ? null
                      : NetworkImage(user!.photoURL!),
                  child: user?.photoURL == null
                      ? const Icon(Icons.person_rounded, size: 52)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                user?.displayName ?? 'Researcher',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                user?.email ?? 'No email available',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 28),
              _ProfileInfoCard(
                children: <Widget>[
                  _ProfileInfoTile(
                    icon: Icons.verified_user_rounded,
                    label: 'User ID',
                    value: user?.uid ?? 'Unavailable',
                  ),
                  _ProfileInfoTile(
                    icon: Icons.mail_rounded,
                    label: 'Email verified',
                    value: user?.emailVerified == true ? 'Yes' : 'No',
                  ),
                  _ProfileInfoTile(
                    icon: Icons.login_rounded,
                    label: 'Sign-in provider',
                    value:
                        user?.providerData
                            .map((provider) => provider.providerId)
                            .join(', ') ??
                        'Unavailable',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: viewModel.isLoading ? null : viewModel.signOut,
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Sign out'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SignedOutProfileState extends StatelessWidget {
  const _SignedOutProfileState({required this.viewModel});

  final AuthViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.account_circle_outlined,
              size: 88,
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.35),
            ),
            const SizedBox(height: 16),
            Text(
              'Sign in to view your profile',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: viewModel.isLoading
                  ? null
                  : viewModel.signInWithGoogle,
              icon: const Icon(Icons.login_rounded),
              label: const Text('Sign in with Google'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileInfoCard extends StatelessWidget {
  const _ProfileInfoCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  const _ProfileInfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      subtitle: Text(value),
    );
  }
}
