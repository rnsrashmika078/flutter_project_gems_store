import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authProvider = StateProvider<User?>((ref) => null);
final userNameProvider = StateProvider<String?>((ref) => null);
