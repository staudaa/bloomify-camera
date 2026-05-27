import 'package:flutter/material.dart';

import '../models/product_model.dart';
import '../services/supabase_service.dart';

import '../widgets/product_card.dart';
import 'add_product_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ProductModel> products = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  Future<void> getProducts() async {
    final response = await SupabaseService.supabase.from('products').select();

    products = response
        .map<ProductModel>((e) => ProductModel.fromJson(e))
        .toList();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bloomify 🌸')),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(16),

              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.7,
              ),

              itemCount: products.length,

              itemBuilder: (context, index) {
                return ProductCard(product: products[index]);
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,

            MaterialPageRoute(builder: (context) => const AddProductScreen()),
          );

          if (result == true) {
            getProducts();
          }
        },

        child: const Icon(Icons.add),
      ),
    );
  }
}
