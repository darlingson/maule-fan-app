import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PlayerEvent {
  final String type;
  final int minute;

  const PlayerEvent({required this.type, required this.minute});
}

class LastMatch {
  final String date;
  final String opponent;
  final String result;
  final List<PlayerEvent> events;

  const LastMatch({
    required this.date,
    required this.opponent,
    required this.result,
    required this.events,
  });
}

class Player {
  final String name;
  final String position;
  final String nationality;
  final List<String> careerHistory;
  final int matchesPlayed;
  final int goalsScored;
  final int yellowCards;
  final int redCards;
  final List<LastMatch> lastMatches;

  const Player({
    required this.name,
    required this.position,
    required this.nationality,
    required this.careerHistory,
    required this.matchesPlayed,
    required this.goalsScored,
    required this.yellowCards,
    required this.redCards,
    required this.lastMatches,
  });
}

const List<Player> players = [
  const Player(
    name: 'Hassan Kajoke',
    position: 'FW',
    nationality: 'Malawi',
    careerHistory: [
      'Nyasa Big Bullets (2018-Present)',
      'Malawi National Team (2019-Present)',
    ],
    matchesPlayed: 250,
    goalsScored: 120,
    yellowCards: 15,
    redCards: 1,
    lastMatches: [
      LastMatch(
        date: 'Nov 27, 2025',
        opponent: 'KAM',
        result: '0-2',
        events: [
          PlayerEvent(type: 'Goal', minute: 88),
          PlayerEvent(type: 'Goal', minute: 62),
        ],
      ),
      LastMatch(
        date: 'Nov 23, 2025',
        opponent: 'CIV',
        result: '4-3',
        events: [PlayerEvent(type: 'Goal', minute: 68)],
      ),
      LastMatch(
        date: 'Nov 6, 2025',
        opponent: 'BLU',
        result: '0-0',
        events: [PlayerEvent(type: 'Yellow Card', minute: 45)],
      ),
      LastMatch(
        date: 'Oct 30, 2025',
        opponent: 'SIL',
        result: '2-1',
        events: [],
      ),
      LastMatch(
        date: 'Oct 20, 2025',
        opponent: 'KAR',
        result: '3-0',
        events: [PlayerEvent(type: 'Goal', minute: 15)],
      ),
    ],
  ),
  const Player(
    name: 'Babatunde Adepoju',
    position: 'FW',
    nationality: 'Nigeria',
    careerHistory: [
      'Nyasa Big Bullets (2022-Present)',
      'Nigeria National Team (2023-Present)',
    ],
    matchesPlayed: 120,
    goalsScored: 65,
    yellowCards: 8,
    redCards: 0,
    lastMatches: [
      LastMatch(
        date: 'Nov 27, 2025',
        opponent: 'KAM',
        result: '0-2',
        events: [],
      ),
      LastMatch(
        date: 'Nov 23, 2025',
        opponent: 'CIV',
        result: '4-3',
        events: [PlayerEvent(type: 'Goal', minute: 89)],
      ),
      LastMatch(
        date: 'Nov 6, 2025',
        opponent: 'BLU',
        result: '0-0',
        events: [],
      ),
      LastMatch(
        date: 'Oct 30, 2025',
        opponent: 'SIL',
        result: '2-1',
        events: [PlayerEvent(type: 'Yellow Card', minute: 20)],
      ),
      LastMatch(
        date: 'Oct 20, 2025',
        opponent: 'KAR',
        result: '3-0',
        events: [],
      ),
    ],
  ),
  const Player(
    name: 'Yankho Singo',
    position: 'MF',
    nationality: 'Malawi',
    careerHistory: [
      'Nyasa Big Bullets (2020-Present)',
      'Malawi National Team (2021-Present)',
    ],
    matchesPlayed: 180,
    goalsScored: 25,
    yellowCards: 22,
    redCards: 2,
    lastMatches: [
      LastMatch(
        date: 'Nov 27, 2025',
        opponent: 'KAM',
        result: '0-2',
        events: [PlayerEvent(type: 'Yellow Card', minute: 75)],
      ),
      LastMatch(
        date: 'Nov 23, 2025',
        opponent: 'CIV',
        result: '4-3',
        events: [],
      ),
      LastMatch(
        date: 'Nov 6, 2025',
        opponent: 'BLU',
        result: '0-0',
        events: [],
      ),
      LastMatch(
        date: 'Oct 30, 2025',
        opponent: 'SIL',
        result: '2-1',
        events: [PlayerEvent(type: 'Yellow Card', minute: 42)],
      ),
      LastMatch(
        date: 'Oct 20, 2025',
        opponent: 'KAR',
        result: '3-0',
        events: [],
      ),
    ],
  ),
  const Player(
    name: 'Wongani Lungu',
    position: 'MF',
    nationality: 'Malawi',
    careerHistory: ['Nyasa Big Bullets (2019-Present)'],
    matchesPlayed: 200,
    goalsScored: 30,
    yellowCards: 18,
    redCards: 1,
    lastMatches: [
      LastMatch(
        date: 'Nov 27, 2025',
        opponent: 'KAM',
        result: '0-2',
        events: [],
      ),
      LastMatch(
        date: 'Nov 23, 2025',
        opponent: 'CIV',
        result: '4-3',
        events: [PlayerEvent(type: 'Yellow Card', minute: 82)],
      ),
      LastMatch(
        date: 'Nov 6, 2025',
        opponent: 'BLU',
        result: '0-0',
        events: [PlayerEvent(type: 'Yellow Card', minute: 70)],
      ),
      LastMatch(
        date: 'Oct 30, 2025',
        opponent: 'SIL',
        result: '2-1',
        events: [],
      ),
      LastMatch(
        date: 'Oct 20, 2025',
        opponent: 'KAR',
        result: '3-0',
        events: [PlayerEvent(type: 'Goal', minute: 55)],
      ),
    ],
  ),
  const Player(
    name: 'Clyde Senaji',
    position: 'DF',
    nationality: 'Malawi',
    careerHistory: [
      'Nyasa Big Bullets (2021-Present)',
      'Malawi National Team (2022-Present)',
    ],
    matchesPlayed: 140,
    goalsScored: 5,
    yellowCards: 12,
    redCards: 0,
    lastMatches: [
      LastMatch(
        date: 'Nov 27, 2025',
        opponent: 'KAM',
        result: '0-2',
        events: [],
      ),
      LastMatch(
        date: 'Nov 23, 2025',
        opponent: 'CIV',
        result: '4-3',
        events: [],
      ),
      LastMatch(
        date: 'Nov 6, 2025',
        opponent: 'BLU',
        result: '0-0',
        events: [],
      ),
      LastMatch(
        date: 'Oct 30, 2025',
        opponent: 'SIL',
        result: '2-1',
        events: [PlayerEvent(type: 'Yellow Card', minute: 28)],
      ),
      LastMatch(
        date: 'Oct 20, 2025',
        opponent: 'KAR',
        result: '3-0',
        events: [],
      ),
    ],
  ),
  const Player(
    name: 'Blessings Mpokera',
    position: 'DF',
    nationality: 'Malawi',
    careerHistory: ['Nyasa Big Bullets (2017-Present)'],
    matchesPlayed: 220,
    goalsScored: 8,
    yellowCards: 25,
    redCards: 1,
    lastMatches: [
      LastMatch(
        date: 'Nov 27, 2025',
        opponent: 'KAM',
        result: '0-2',
        events: [],
      ),
      LastMatch(
        date: 'Nov 23, 2025',
        opponent: 'CIV',
        result: '4-3',
        events: [PlayerEvent(type: 'Red Card', minute: 75)],
      ),
      LastMatch(
        date: 'Nov 6, 2025',
        opponent: 'BLU',
        result: '0-0',
        events: [],
      ),
      LastMatch(
        date: 'Oct 30, 2025',
        opponent: 'SIL',
        result: '2-1',
        events: [],
      ),
      LastMatch(
        date: 'Oct 20, 2025',
        opponent: 'KAR',
        result: '3-0',
        events: [PlayerEvent(type: 'Yellow Card', minute: 13)],
      ),
    ],
  ),
  const Player(
    name: 'Richard Chimbamba',
    position: 'GK',
    nationality: 'Malawi',
    careerHistory: ['Nyasa Big Bullets (2020-Present)'],
    matchesPlayed: 160,
    goalsScored: 0,
    yellowCards: 5,
    redCards: 0,
    lastMatches: [
      LastMatch(
        date: 'Nov 27, 2025',
        opponent: 'KAM',
        result: '0-2',
        events: [],
      ),
      LastMatch(
        date: 'Nov 23, 2025',
        opponent: 'CIV',
        result: '4-3',
        events: [],
      ),
      LastMatch(
        date: 'Nov 6, 2025',
        opponent: 'BLU',
        result: '0-0',
        events: [],
      ),
      LastMatch(
        date: 'Oct 30, 2025',
        opponent: 'SIL',
        result: '2-1',
        events: [],
      ),
      LastMatch(
        date: 'Oct 20, 2025',
        opponent: 'KAR',
        result: '3-0',
        events: [],
      ),
    ],
  ),
  const Player(
    name: 'Peter Banda',
    position: 'MF',
    nationality: 'Malawi',
    careerHistory: [
      'Nyasa Big Bullets (2023-Present)',
      'Malawi National Team (2024-Present)',
    ],
    matchesPlayed: 80,
    goalsScored: 15,
    yellowCards: 10,
    redCards: 0,
    lastMatches: [
      LastMatch(
        date: 'Nov 27, 2025',
        opponent: 'KAM',
        result: '0-2',
        events: [PlayerEvent(type: 'Goal', minute: 37)],
      ),
      LastMatch(
        date: 'Nov 23, 2025',
        opponent: 'CIV',
        result: '4-3',
        events: [],
      ),
      LastMatch(
        date: 'Nov 6, 2025',
        opponent: 'BLU',
        result: '0-0',
        events: [PlayerEvent(type: 'Yellow Card', minute: 20)],
      ),
      LastMatch(
        date: 'Oct 30, 2025',
        opponent: 'SIL',
        result: '2-1',
        events: [],
      ),
      LastMatch(
        date: 'Oct 20, 2025',
        opponent: 'KAR',
        result: '3-0',
        events: [],
      ),
    ],
  ),
];



class PlayersScreen extends StatefulWidget {
  const PlayersScreen({super.key});

  @override
  State<PlayersScreen> createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  late Future<Map<String, dynamic>> _playersFuture;

  @override
  void initState() {
    super.initState();
    _playersFuture = fetchPlayers();
  }

  Color _getPositionColor(String? position) {
    switch (position) {
      case 'FW':
        return Colors.green;
      case 'MF':
        return Colors.yellow;
      case 'DF':
        return Colors.blue;
      case 'GK':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Future<Map<String, dynamic>> fetchPlayers() async {
    final response = await http.get(
      Uri.parse('https://maule-fan-app-server.vercel.app/api/teams/1/players'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load players');
    }
  }

  Future<void> _refreshPlayers() async {
    setState(() {
      _playersFuture = fetchPlayers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Players', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPlayers,
        color: Colors.white,
        backgroundColor: Colors.black,
        child: FutureBuilder<Map<String, dynamic>>(
          future: _playersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _refreshPlayers,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!['data'] == null) {
              return const Center(
                child: Text(
                  'No players found',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            final players = snapshot.data!['data'] as List<dynamic>;

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: players.length,
              itemBuilder: (context, index) {
                final player = players[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PlayerDetailsScreen(player: player),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 60,
                          color: _getPositionColor(player['position']),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                player['name'] ?? 'Unknown Player',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${player['position'] ?? 'Unknown'} | ${player['nationality'] ?? 'Unknown'}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class PlayerDetailsScreen extends StatelessWidget {
  final Player player;

  const PlayerDetailsScreen({super.key, required this.player});

  Color _getEventColor(String type) {
    switch (type) {
      case 'Goal':
        return Colors.red;
      case 'Yellow Card':
        return Colors.yellow;
      case 'Red Card':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildEventIcon(PlayerEvent event) {
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

  @override
  Widget build(BuildContext context) {
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
                  '${player.position} - ${player.nationality}',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                // Flag placeholder - could use Image.asset if available
                const SizedBox(width: 8),
                Container(
                  width: 24,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.blue, // Placeholder for flag
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
            ...player.careerHistory.map(
              (hist) => Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  hist,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
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
                _buildStatColumn('Matches Played', '${player.matchesPlayed}'),
                _buildStatColumn('Goals Scored', '${player.goalsScored}'),
                _buildStatColumn('Yellow Cards', '${player.yellowCards}'),
                _buildStatColumn('Red Cards', '${player.redCards}'),
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
            ...player.lastMatches.map(
              (match) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      match.date,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'vs ${match.opponent} ${match.result}',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: match.events
                          .map((event) => _buildEventIcon(event))
                          .toList(),
                    ),
                    if (match.events.isEmpty)
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
