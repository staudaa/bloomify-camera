import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://wziqpglpbuktgtuqgzoh.supabase.co',
    anonKey: 'sb_publishable_TBQppAU2wbOeir4mV8cuPg_0Xk-KFsJ',
  );

  runApp(const BloomifyApp());
}

class BloomifyApp extends StatelessWidget {
  const BloomifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bloomify',
      theme: ThemeData(primarySwatch: Colors.pink),
      home: const HomeScreen(),
    );
  }
}
