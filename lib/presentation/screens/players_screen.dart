import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maule_fan_app/presentation/screens/player_details_screen.dart';

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
                        builder: (_) =>
                            PlayerDetailsScreen(playerId: player['id']),
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
