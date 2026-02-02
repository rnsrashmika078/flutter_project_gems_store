import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:superbase_auth/provider/auth_provider.dart';
import 'package:superbase_auth/screens/home_screen.dart';
import 'package:superbase_auth/services/supabase_services.dart';
import 'package:superbase_auth/widgets/custom_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  runApp(ProviderScope(child: MyApp()));
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: AuthApp());
  }
}

class AuthApp extends ConsumerStatefulWidget {
  const AuthApp({super.key});

  @override
  ConsumerState<AuthApp> createState() => _AuthApp();
}

class _AuthApp extends ConsumerState<AuthApp> {
  Map<String, dynamic>? _authUserData;
  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    supabase.auth.onAuthStateChange.listen((data) async {
      final user = data.session?.user;
      final newUserData = data.session?.user.userMetadata;
      setState(() {
        _authUserData = newUserData;
      });

      if (data.event == AuthChangeEvent.signedIn && user != null) {
        final localUsername = ref.read(userNameProvider);
        await insertData(
          user.id,
          newUserData?['email'],
          newUserData?['name'] ?? localUsername,
          newUserData?['dp'],
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Gem Store"),
      body: Center(child: HomeScreen(authUserData: _authUserData)),
    );
  }
}
