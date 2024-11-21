import 'package:arprojesi/colors.dart';
import 'package:arprojesi/episode_two.dart';
import 'package:flutter/material.dart';

class EpisodeOne extends StatefulWidget {
  const EpisodeOne({super.key});

  @override
  State<EpisodeOne> createState() => _EpisodeOneState();
}

class _EpisodeOneState extends State<EpisodeOne> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.turq,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EpisodeTwo(),
            ),
          );
        },
        child: const Icon(
          Icons.arrow_forward,
          color: AppColors.gray,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/episode1.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
