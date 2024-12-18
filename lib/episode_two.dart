import 'package:arprojesi/colors.dart';
import 'package:arprojesi/episode_three.dart';
import 'package:flutter/material.dart';

class EpisodeTwo extends StatefulWidget {
  const EpisodeTwo({super.key});

  @override
  State<EpisodeTwo> createState() => _EpisodeTwoState();
}

class _EpisodeTwoState extends State<EpisodeTwo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.turq,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EpisodeThree(),
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
            image: AssetImage("assets/images/episode2.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
