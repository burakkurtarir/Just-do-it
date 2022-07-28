import 'package:flutter/material.dart';

part '../widgets/add_button.dart';
part '../widgets/header_text.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        children: const [
          Center(
            child: Text('Hello, world!'),
          ),
        ],
      ),
    );
  }
}
