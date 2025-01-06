import 'package:flutter/material.dart';
import 'package:steps_tracker/tabs/home_page_tab.dart';

class LandinPage extends StatelessWidget {
  const LandinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.only(
                bottom: 100,
              ),
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('lib/assets/images/Landing-Image.png'),
                    fit: BoxFit.cover),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(50),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>  HomeScreen()));
              },
              child: const Text('Get Started'),
            ),
          )
        ],
      ),
    );
  }
}
