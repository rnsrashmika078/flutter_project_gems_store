import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:superbase_auth/main.dart';

Future<void> insertData(
  String? user_id,
  String? email,
  String? username,
  String? dp,
) async {
  print("USER ID $user_id");
  await supabase.from(dotenv.env['SUPABASE_TABLE']!).upsert({
    'user_id': user_id,
    'email': email,
    'username': username,
    'dp': dp,
  }, onConflict: 'user_id');
}

Future<Map<String, dynamic>?> getUserData(String userId) async {
  Map<String, dynamic>? user = await supabase
      .from(dotenv.env['SUPABASE_TABLE']!)
      .select('user_id,username, dp,email')
      .eq('user_id', userId)
      .maybeSingle();

  if (user!.isNotEmpty) {
    return user;
  }
  return null;
}

Future<List<Map<String, dynamic>>> getAllUsers() async {
  return await supabase.from(dotenv.env['SUPABASE_TABLE']!).select();
}
