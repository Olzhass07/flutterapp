import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VocabScreen extends StatefulWidget {
  const VocabScreen({super.key});

  @override
  State<VocabScreen> createState() => _VocabScreenState();
}

class _VocabScreenState extends State<VocabScreen> {
  @override
  
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Vocab ')));
  }
}
