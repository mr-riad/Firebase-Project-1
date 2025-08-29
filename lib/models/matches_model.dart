class MatchesModel {
  final String id;
  final String team1;
  final String team2;
  final String runningTime;
  final String totalTime;
  final int score1;
  final int score2;

  MatchesModel({
    required this.id,
    required this.team1,
    required this.team2,
    required this.runningTime,
    required this.totalTime,
    required this.score1,
    required this.score2,
  });

  // Factory constructor to create MatchesModel from Firestore document
  factory MatchesModel.fromFirestore(String id, Map<String, dynamic> data) {
    return MatchesModel(
      id: id,
      team1: data['team1'] ?? '',
      team2: data['team2'] ?? '',
      runningTime: data['runningTime'] ?? '',
      totalTime: data['totalTime'] ?? '',
      score1: data['score1'] ?? 0,
      score2: data['score2'] ?? 0,
    );
  }
}