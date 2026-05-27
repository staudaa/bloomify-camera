import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final supabase = Supabase.instance.client;

  static Future<String> uploadImage(XFile imageFile) async {
    final bytes = await imageFile.readAsBytes();

    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

    await supabase.storage.from('product-images').uploadBinary(fileName, bytes);

    final imageUrl = supabase.storage
        .from('product-images')
        .getPublicUrl(fileName);

    return imageUrl;
  }
}
