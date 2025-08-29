import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_project1/models/matches_model.dart';
import 'package:flutter/material.dart';
import 'match_details_screen.dart';

class MatchListScreen extends StatefulWidget {
  const MatchListScreen({super.key});

  @override
  State<MatchListScreen> createState() => _MatchListScreenState();
}

class _MatchListScreenState extends State<MatchListScreen> {
  List<MatchesModel> _listOfMatches = [];
  bool _isLoading = true;

  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _getLiveScoreData();
  }

  Future<void> _getLiveScoreData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final QuerySnapshot<Map<String, dynamic>> snapshot =
      await db.collection('matches').get();

      List<MatchesModel> matches = [];
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
        MatchesModel matchesModel = MatchesModel.fromFirestore(
          doc.id,
          doc.data(),
        );
        matches.add(matchesModel);
      }

      setState(() {
        _listOfMatches = matches;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching matches: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Match List", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _listOfMatches.isEmpty
          ? const Center(child: Text("No matches found"))
          : ListView.builder(
        itemCount: _listOfMatches.length,
        itemBuilder: (context, index) {
          final match = _listOfMatches[index];
          return Card(
            margin: const EdgeInsets.all(6),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
                top: 6,
                bottom: 6,
              ),
              child: ListTile(
                title: Text(
                  "${match.team1} vs ${match.team2}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Match ID: ${match.id}"),
                    Text("Score: ${match.score1} - ${match.score2}"),
                    Text("Running Time: ${match.runningTime}"),
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MatchDetailScreen(matchId: match.id),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getLiveScoreData,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
