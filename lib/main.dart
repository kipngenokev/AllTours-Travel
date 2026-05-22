import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/app_config.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home_screen.dart';
import 'services/auth_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Only initialise Supabase if credentials were supplied via --dart-define.
  // Otherwise the app boots into a setup screen instead of crashing.
  if (AppConfig.isConfigured) {
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
    );
  }

  runApp(const AllToursApp());
}

class AllToursApp extends StatelessWidget {
  const AllToursApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (!AppConfig.isConfigured) {
      return MaterialApp(
        title: 'All-Tours',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const _SetupScreen(),
      );
    }

    // Provide auth state to the whole tree.
    return ChangeNotifierProvider(
      create: (_) => AuthService(),
      child: MaterialApp(
        title: 'All-Tours',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const _AuthGate(),
      ),
    );
  }
}

/// Shows Home when signed in, Login otherwise. Rebuilds on auth changes.
class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    return auth.isLoggedIn ? const HomeScreen() : const LoginScreen();
  }
}

/// Friendly instructions shown until Supabase credentials are configured.
class _SetupScreen extends StatelessWidget {
  const _SetupScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.travel_explore,
                    color: AppColors.primary, size: 48),
                const SizedBox(height: 16),
                Text('Almost there', style: AppTheme.display(size: 30)),
                const SizedBox(height: 10),
                const Text(
                  'All-Tours needs your Supabase project to handle accounts '
                  'and destinations. Add the credentials, then run:',
                  style: TextStyle(color: AppColors.muted, height: 1.5),
                ),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.ink,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const SelectableText(
                    'flutter run \\\n'
                    '  --dart-define=SUPABASE_URL=https://xxxx.supabase.co \\\n'
                    '  --dart-define=SUPABASE_ANON_KEY=eyJhbGciOi...',
                    style: TextStyle(
                      color: Color(0xFFB8E0DC),
                      fontFamily: 'monospace',
                      fontSize: 13,
                      height: 1.6,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  '1. Create a project at supabase.com\n'
                  '2. Run supabase/schema.sql then supabase/seed.sql in the '
                  'SQL Editor\n'
                  '3. Copy your Project URL and anon key from '
                  'Settings → API\n'
                  '4. Re-run with the command above',
                  style: TextStyle(height: 1.7),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
