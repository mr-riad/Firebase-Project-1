import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MatchDetailScreen extends StatelessWidget {
  final String matchId;
  const MatchDetailScreen({super.key, required this.matchId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(matchId)),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection("matches").doc(matchId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var match = snapshot.data!;
          return Center(
            child: Card(
              margin: const EdgeInsets.all(20),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("${match['team1']} vs ${match['team2']}",
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text("${match['score1']} : ${match['score2']}",
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text("Time : ${match['runningTime']}"),
                    Text("Total Time : ${match['totalTime']}"),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
