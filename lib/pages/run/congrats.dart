import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:interval_timer/pages/home.dart';
import 'package:interval_timer/pages/jump_in/jump_in.dart';

class Congrats extends StatefulWidget {
  const Congrats({super.key});

  @override
  State<Congrats> createState() => _CongratsState();
}

class _CongratsState extends State<Congrats> {
  ConfettiController controller =
      ConfettiController(duration: const Duration(seconds: 10));

  @override
  void initState() {
    super.initState();
    controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: ConfettiWidget(
                confettiController: controller,
                blastDirectionality: BlastDirectionality.explosive,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const Home(screenIndex: 1)));
              },
              child: const Text('Finish'),
            ),
          ],
        ),
      ),
    );
  }
}
