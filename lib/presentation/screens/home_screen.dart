import 'package:flutter/material.dart';


class LatestMatchData {
  final String homeTeam;
  final String awayTeam;
  final String score;
  final String status;
  final String venue;
  final String goals;
  final String assists;
  final String redCards;

  const LatestMatchData({
    required this.homeTeam,
    required this.awayTeam,
    required this.score,
    required this.status,
    required this.venue,
    required this.goals,
    required this.assists,
    required this.redCards,
  });
}

class NextMatchData {
  final String homeTeam;
  final String awayTeam;
  final String date;
  final String time;
  final String fullDateTime;
  final String venue;
  final String daysToKickoff;

  const NextMatchData({
    required this.homeTeam,
    required this.awayTeam,
    required this.date,
    required this.time,
    required this.fullDateTime,
    required this.venue,
    required this.daysToKickoff,
  });
}

class CompetitionData {
  final String name;

  const CompetitionData({required this.name});
}

const String clubName = 'NYASA BIG BULLETS';
const String season = 'TNM Super League - 2025/26 Season';

const LatestMatchData latestMatch = LatestMatchData(
  homeTeam: 'Kamuzu Barracks',
  awayTeam: 'Nyasa Big Bullets',
  score: '0 - 2',
  status: 'Full Time',
  venue: 'Kamuzu Barracks Ground',
  goals: "Salima (5'), Adepoju (37')",
  assists: "None",
  redCards: "None",
);

const NextMatchData nextMatch = NextMatchData(
  homeTeam: 'Nyasa Big Bullets',
  awayTeam: 'Silver Strikers',
  date: 'Sat, Dec 7',
  time: '15:00',
  fullDateTime: 'Sat, Dec 7 - 15:00',
  venue: 'Kamuzu Stadium',
  daysToKickoff: '7 Days to Kick-off',
);

const List<CompetitionData> competitions = [
  CompetitionData(name: 'TNM Super League'),
  CompetitionData(name: 'FISD Challenge Cup'),
  CompetitionData(name: 'Charity Shield'),
];

class LatestMatchCard extends StatelessWidget {
  final LatestMatchData data;

  const LatestMatchCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'LATEST MATCH',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 3,
                  height: 60,
                  color: Colors.red,
                  margin: const EdgeInsets.only(right: 12),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${data.homeTeam} ${data.score} ${data.awayTeam}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${data.status} - ${data.venue}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Match stats
            _buildStatRow('Goals:', data.goals),
            _buildStatRow('Assists:', data.assists),
            _buildStatRow('Red Cards:', data.redCards),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80, // Aligning the values
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NextMatchCard extends StatelessWidget {
  final NextMatchData data;

  const NextMatchCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'NEXT MATCH',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            // Matchup
            Text(
              '${data.homeTeam} vs ${data.awayTeam}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            // Date and Time
            Text(
              data.fullDateTime,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            // Venue Info
            Text(
              'Venue info: ${data.venue}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.watch_later_outlined,
                  color: Colors.red,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  data.daysToKickoff,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CompetitionsCard extends StatelessWidget {
  final List<CompetitionData> competitionsList;

  const CompetitionsCard({super.key, required this.competitionsList});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'COMPETITIONS',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            // List of Competitions
            ...competitionsList.map((comp) => _buildCompetitionItem(comp.name)),
          ],
        ),
      ),
    );
  }

  Widget _buildCompetitionItem(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          const Icon(
            Icons.circle,
            color: Colors.red,
            size: 8,
          ),
          const SizedBox(width: 8),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: const Text(
          'Home',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  clubName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  season,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const LatestMatchCard(data: latestMatch),
          const NextMatchCard(data: nextMatch),
          const CompetitionsCard(competitionsList: competitions),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}