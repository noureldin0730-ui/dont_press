import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const DontPressApp());
}

class DontPressApp extends StatelessWidget {
  const DontPressApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const DontPressPage(),
    );
  }
}

class DontPressPage extends StatefulWidget {
  const DontPressPage({super.key});

  @override
  State<DontPressPage> createState() => _DontPressPageState();
}

class _DontPressPageState extends State<DontPressPage> {
  int presses = 0;

  String message = "مهما حصل... متضغطش.";

  final Random random = Random();

  final List<String> messages = [
    "قلتلك متضغطش!",
    "ليه ضغطت؟",
    "بجد؟",
    "وقف ضغط.",
    "إنت مش قادر تقاوم، صح؟",
    "في حاجة بتراقبك...",
    "حاسس إن دي كانت فكرة وحشة.",
    "كمّل... لو تقدر.",
  ];

  void pressButton() {
    setState(() {
      presses++;
      message = messages[random.nextInt(messages.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff070707),
      body: