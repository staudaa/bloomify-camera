import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/supabase_service.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController priceController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  XFile? selectedImage;

  bool isLoading = false;

  Future<void> pickFromCamera() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        selectedImage = pickedFile;
      });
    }
  }

  Future<void> pickFromGallery() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        selectedImage = pickedFile;
      });
    }
  }

  Future<void> addProduct() async {
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field dan foto wajib diisi')),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final imageUrl = await SupabaseService.uploadImage(selectedImage!);
      await SupabaseService.supabase.from('products').insert({
        'name': nameController.text,
        'price': int.parse(priceController.text),
        'description': descriptionController.text,
        'image_url': imageUrl,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk berhasil ditambahkan 🌸')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Produk')),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            selectedImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(25),

                    child: Image.network(
                      selectedImage!.path,
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    width: double.infinity,
                    height: 220,

                    decoration: BoxDecoration(
                      color: Colors.pink.shade100,

                      borderRadius: BorderRadius.circular(25),
                    ),

                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Icon(
                          Icons.local_florist,
                          size: 70,
                          color: Colors.white,
                        ),

                        SizedBox(height: 10),

                        Text(
                          'Upload Foto Bunga',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: pickFromCamera,

                    icon: const Icon(Icons.camera_alt),

                    label: const Text('Camera'),
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: pickFromGallery,

                    icon: const Icon(Icons.photo),

                    label: const Text('Gallery'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            TextField(
              controller: nameController,

              decoration: InputDecoration(
                labelText: 'Nama Bunga',

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: priceController,

              keyboardType: TextInputType.number,

              decoration: InputDecoration(
                labelText: 'Harga',

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: descriptionController,

              maxLines: 4,

              decoration: InputDecoration(
                labelText: 'Deskripsi',

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed: isLoading ? null : addProduct,

                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('SIMPAN PRODUK'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
