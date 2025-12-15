import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Documents {
  final int id;
  final String name;
  final dynamic dateOfBirth;
  final dynamic nationality;
  final dynamic photoUrl;
  final dynamic position;
  final Stats stats;
  final History history;
  final List<LastMatch> lastMatches;

  Documents({
    required this.id,
    required this.name,
    required this.dateOfBirth,
    required this.nationality,
    required this.photoUrl,
    required this.position,
    required this.stats,
    required this.history,
    required this.lastMatches,
  });

  factory Documents.fromJson(Map<String, dynamic> json) => Documents(
    id: json["id"],
    name: json["name"],
    dateOfBirth: json["date_of_birth"],
    nationality: json["nationality"],
    photoUrl: json["photo_url"],
    position: json["position"],
    stats: Stats.fromJson(json["stats"]),
    history: History.fromJson(json["history"]),
    lastMatches: List<LastMatch>.from(json["last_matches"].map((x) => LastMatch.fromJson(x))),
  );
}

class Stats {
  final String goalsscored;
  final String yellowcards;
  final String redcards;

  Stats({
    required this.goalsscored,
    required this.yellowcards,
    required this.redcards,
  });

  factory Stats.fromJson(Map<String, dynamic> json) => Stats(
    goalsscored: json["goalsscored"],
    yellowcards: json["yellowcards"],
    redcards: json["redcards"],
  );
}

class History {
  final int teamId;
  final dynamic startDate;
  final dynamic endDate;
  final String teamName;

  History({
    required this.teamId,
    required this.startDate,
    required this.endDate,
    required this.teamName,
  });

  factory History.fromJson(Map<String, dynamic> json) => History(
    teamId: json["teamId"],
    startDate: json["startDate"],
    endDate: json["endDate"],
    teamName: json["teamName"],
  );
}

class LastMatch {
  final int id;
  final DateTime date;
  final int competitionId;
  final int homeTeamId;
  final int awayTeamId;
  final int homeTeamScore;
  final int awayTeamScore;
  final dynamic matchVenue;
  final String homeTeamName;
  final String awayTeamName;
  final List<Event> events;

  LastMatch({
    required this.id,
    required this.date,
    required this.competitionId,
    required this.homeTeamId,
    required this.awayTeamId,
    required this.homeTeamScore,
    required this.awayTeamScore,
    required this.matchVenue,
    required this.homeTeamName,
    required this.awayTeamName,
    required this.events,
  });

  factory LastMatch.fromJson(Map<String, dynamic> json) => LastMatch(
    id: json["id"],
    date: DateTime.parse(json["date"]),
    competitionId: json["competitionId"],
    homeTeamId: json["homeTeamId"],
    awayTeamId: json["awayTeamId"],
    homeTeamScore: json["homeTeamScore"],
    awayTeamScore: json["awayTeamScore"],
    matchVenue: json["matchVenue"],
    homeTeamName: json["homeTeamName"],
    awayTeamName: json["awayTeamName"],
    events: List<Event>.from(json["events"].map((x) => Event.fromJson(x))),
  );
}

class Event {
  final String type;
  final int minute;
  final int playerId;
  final dynamic assistingPlayerId;

  Event({
    required this.type,
    required this.minute,
    required this.playerId,
    required this.assistingPlayerId,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    type: json["type"],
    minute: json["minute"],
    playerId: json["player_id"],
    assistingPlayerId: json["assisting_player_id"],
  );
}

class PlayerDetailsScreen extends StatefulWidget {
  final int playerId;

  const PlayerDetailsScreen({super.key, required this.playerId});

  @override
  State<PlayerDetailsScreen> createState() => _PlayerDetailsScreenState();
}

class _PlayerDetailsScreenState extends State<PlayerDetailsScreen> {
  Documents? playerData;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchPlayerData();
  }

  Future<void> fetchPlayerData() async {
    try {
      final response = await http.get(
        Uri.parse('https://maule-fan-app-server.vercel.app/api/players/${widget.playerId}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          playerData = Documents.fromJson(data);
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Failed to load player data';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Color _getEventColor(String type) {
    switch (type.toLowerCase()) {
      case 'goal':
        return Colors.green;
      case 'yellow card':
        return Colors.yellow;
      case 'red card':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildEventIcon(Event event) {
    final color = _getEventColor(event.type);
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Text(
          '${event.minute}',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getMatchResult(LastMatch match) {
    return '${match.homeTeamScore} - ${match.awayTeamScore}';
  }

  String _getOpponent(LastMatch match) {
    // Assuming the player's team is the home team for now
    // You might need to adjust this logic based on your requirements
    return match.awayTeamName;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            'Player Profile',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (error != null || playerData == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            'Player Profile',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Text(
            error ?? 'No data available',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    final player = playerData!;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Player Profile',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Player Name
            Text(
              player.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            // Position and Nationality
            Row(
              children: [
                Text(
                  '${player.position ?? "Unknown"} - ${player.nationality ?? "Unknown"}',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 24,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: const Center(
                    child: Text('🇲🇼', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Career History
            const Text(
              'CAREER HISTORY',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                player.history.teamName,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
            const SizedBox(height: 24),
            // Key Statistics
            const Text(
              'KEY STATISTICS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatColumn('Goals Scored', player.stats.goalsscored),
                _buildStatColumn('Yellow Cards', player.stats.yellowcards),
                _buildStatColumn('Red Cards', player.stats.redcards),
              ],
            ),
            const SizedBox(height: 24),
            // Last 5 Matches
            const Text(
              'LAST 5 MATCHES',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...player.lastMatches.take(5).map(
              (match) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatDate(match.date),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'vs ${_getOpponent(match)} ${_getMatchResult(match)}',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: match.events
                          .where((event) => event.playerId == player.id)
                          .map((event) => _buildEventIcon(event))
                          .toList(),
                    ),
                    if (match.events.where((event) => event.playerId == player.id).isEmpty)
                      const Text(
                        'No key events',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}