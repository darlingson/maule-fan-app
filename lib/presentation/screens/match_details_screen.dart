import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Match matchFromJson(String str) => Match.fromJson(json.decode(str));

class Match {
  final int id;
  final DateTime date;
  final String? venue;
  final String status;
  final Score score;
  final Competition competition;
  final Team homeTeam;
  final Team awayTeam;
  final Events events;

  Match({
    required this.id,
    required this.date,
    required this.venue,
    required this.status,
    required this.score,
    required this.competition,
    required this.homeTeam,
    required this.awayTeam,
    required this.events,
  });

  factory Match.fromJson(Map<String, dynamic> json) => Match(
    id: json["id"] ?? 0,
    date: DateTime.parse(json["date"] ?? DateTime.now().toIso8601String()),
    venue: json["venue"],
    status: json["status"] ?? 'unknown',
    score: Score.fromJson(json["score"] ?? {'home': 0, 'away': 0}),
    competition: Competition.fromJson(json["competition"] ?? {'id': 0, 'name': 'Unknown', 'season': 'Unknown'}),
    homeTeam: Team.fromJson(json["home_team"] ?? {'id': 0, 'name': 'Unknown', 'short_name': 'UNK', 'logo_url': null}),
    awayTeam: Team.fromJson(json["away_team"] ?? {'id': 0, 'name': 'Unknown', 'short_name': 'UNK', 'logo_url': null}),
    events: Events.fromJson(json["events"] ?? {'goals': [], 'yellow_cards': [], 'red_cards': []}),
  );
}

class Team {
  final int id;
  final String name;
  final String shortName;
  final String? logoUrl;

  Team({
    required this.id,
    required this.name,
    required this.shortName,
    required this.logoUrl,
  });

  factory Team.fromJson(Map<String, dynamic> json) => Team(
    id: json["id"] ?? 0,
    name: json["name"] ?? 'Unknown',
    shortName: json["short_name"] ?? 'UNK',
    logoUrl: json["logo_url"],
  );
}

class Competition {
  final int id;
  final String name;
  final String season;

  Competition({
    required this.id,
    required this.name,
    required this.season,
  });

  factory Competition.fromJson(Map<String, dynamic> json) => Competition(
    id: json["id"] ?? 0,
    name: json["name"] ?? 'Unknown',
    season: json["season"] ?? 'Unknown',
  );
}

class Events {
  final List<Goal> goals;
  final List<dynamic> yellowCards;
  final List<dynamic> redCards;

  Events({
    required this.goals,
    required this.yellowCards,
    required this.redCards,
  });

  factory Events.fromJson(Map<String, dynamic> json) => Events(
    goals: List<Goal>.from(json["goals"]?.map((x) => Goal.fromJson(x)) ?? []),
    yellowCards: List<dynamic>.from(json["yellow_cards"] ?? []),
    redCards: List<dynamic>.from(json["red_cards"] ?? []),
  );
}

class Goal {
  final int id;
  final int minute;
  final Player player;
  final dynamic assistingPlayer;

  Goal({
    required this.id,
    required this.minute,
    required this.player,
    required this.assistingPlayer,
  });

  factory Goal.fromJson(Map<String, dynamic> json) => Goal(
    id: json["id"] ?? 0,
    minute: json["minute"] ?? 0,
    player: Player.fromJson(json["player"] ?? {'id': 0, 'name': 'Unknown', 'position': null}),
    assistingPlayer: json["assisting_player"],
  );
}

class Player {
  final int id;
  final String name;
  final dynamic position;

  Player({
    required this.id,
    required this.name,
    required this.position,
  });

  factory Player.fromJson(Map<String, dynamic> json) => Player(
    id: json["id"] ?? 0,
    name: json["name"] ?? 'Unknown',
    position: json["position"],
  );
}

class Score {
  final int home;
  final int away;

  Score({
    required this.home,
    required this.away,
  });

  factory Score.fromJson(Map<String, dynamic> json) => Score(
    home: json["home"] ?? 0,
    away: json["away"] ?? 0,
  );
}

class MatchDetailsScreen extends StatefulWidget {
  final int matchId;

  const MatchDetailsScreen({super.key, required this.matchId});

  @override
  State<MatchDetailsScreen> createState() => _MatchDetailsScreenState();
}

class _MatchDetailsScreenState extends State<MatchDetailsScreen> {
  Match? match;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchMatchDetails();
  }

  Future<void> fetchMatchDetails() async {
    try {
      final response = await http.get(
        Uri.parse('https://maule-fan-app-server.vercel.app/api/matches/${widget.matchId}/details'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          match = Match.fromJson(data);
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Failed to load match details: ${response.statusCode}';
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

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Color _getEventColor(String type) {
    switch (type) {
      case 'goal':
        return Colors.green;
      case 'yellow_card':
        return Colors.yellow;
      case 'red_card':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getEventIcon(String type) {
    switch (type) {
      case 'goal':
        return Icons.sports_soccer;
      case 'yellow_card':
        return Icons.warning;
      case 'red_card':
        return Icons.flag;
      default:
        return Icons.circle;
    }
  }

  Widget _buildGoalEvent(Goal goal) {
    final color = _getEventColor('goal');
    final icon = _getEventIcon('goal');
    String description = goal.player.name;
    if (goal.assistingPlayer != null) {
      description += ' (assisted by ${goal.assistingPlayer['name']})';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(
            '${goal.minute}\'',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 12),
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              description,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardEvent(dynamic card, String type) {
    final color = _getEventColor(type);
    final icon = _getEventIcon(type);
    final playerName = card['player']?['name'] ?? 'Unknown Player';
    final minute = card['minute'] ?? 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(
            '$minute\'',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 12),
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              playerName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Match Details', style: TextStyle(color: Colors.white)),
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

    if (error != null || match == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Match Details', style: TextStyle(color: Colors.white)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Text(
            error ?? 'No match data available',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    final isUpcoming = match!.status == 'UPCOMING';
    final status = isUpcoming ? 'TBD' : match!.status;
    final scoreDisplay = isUpcoming 
        ? 'vs' 
        : '${match!.score.home} - ${match!.score.away}';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Match Details',
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
            // Competition and Date
            Text(
              '${match!.competition.name} - ${formatDate(match!.date)}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      match!.homeTeam.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      match!.homeTeam.shortName,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      scoreDisplay,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      status,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      match!.awayTeam.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      match!.awayTeam.shortName,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            if (match!.venue != null && match!.venue!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Venue: ${match!.venue}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],

            const SizedBox(height: 24),
            
            const Text(
              'Match Events',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            if (match!.events.goals.isNotEmpty) ...[
              const Text(
                'Goals',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...match!.events.goals.map((goal) => _buildGoalEvent(goal)),
              const SizedBox(height: 16),
            ],

            if (match!.events.yellowCards.isNotEmpty) ...[
              const Text(
                'Yellow Cards',
                style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...match!.events.yellowCards.map((card) => _buildCardEvent(card, 'yellow_card')),
              const SizedBox(height: 16),
            ],

            if (match!.events.redCards.isNotEmpty) ...[
              const Text(
                'Red Cards',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...match!.events.redCards.map((card) => _buildCardEvent(card, 'red_card')),
            ],

            if (match!.events.goals.isEmpty && 
                match!.events.yellowCards.isEmpty && 
                match!.events.redCards.isEmpty) ...[
              const Text(
                'No events available yet.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}