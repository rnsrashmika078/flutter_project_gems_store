import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:superbase_auth/main.dart';
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:superbase_auth/models/gem.dart';

Future<void> insertData(
  String? userId,
  String? email,
  String? username,
  String? dp,
) async {
  await supabase.from(dotenv.env['SUPABASE_TABLE']!).upsert({
    'user_id': userId,
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

Future<String?> uploadImageToSupabase(Uint8List imageBytes) async {
  try {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final path = 'public/$fileName.jpg';

    await Supabase.instance.client.storage
        .from('gem_storage')
        .uploadBinary(
          path,
          imageBytes,
          fileOptions: const FileOptions(contentType: 'image/jpeg'),
        );

    final publicUrl = Supabase.instance.client.storage
        .from('gem_storage')
        .getPublicUrl(path);

    return publicUrl;
  } catch (e) {
    print("Upload error: $e");
    return null;
  }
}

Future<void> addItem(Gem gem) async {
  await supabase.from("gems").insert({
    'name': gem.name,
    'type': gem.type,
    'price': gem.price,
    'location': gem.location,
    'imagePath': gem.imagePath,
    'owner': gem.owner,
  });
}

Future<List<Gem>> getGemListing() async {
  final response = await supabase
      .from("gems")
      .select('id, name, type, price, location, owner, imagePath');

  return response
      .map(
        (row) => Gem(
          id: row['id'].toString(),
          name: row['name'] ?? '',
          type: row['type'] ?? '',
          price: (row['price'] as num?)?.toDouble() ?? 0,
          location: row['location'] ?? '',
          owner: row['owner'] ?? '',
          imagePath: row['imagePath'] ?? '',
        ),
      )
      .toList();
}

Future<void> updateItem(Gem gem) async {
  await supabase
      .from("gems")
      .update({
        'name': gem.name,
        'type': gem.type,
        'price': gem.price,
        'location': gem.location,
        'imagePath': gem.imagePath,
        'owner': gem.owner,
      })
      .eq('id', gem.id);
}

Future<void> deleteItem(String id) async {
  await supabase.from("gems").delete().eq('id', id);
}
