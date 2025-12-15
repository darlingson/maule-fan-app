import 'package:flutter/material.dart';

class MatchDetailsScreen extends StatelessWidget {
  final Match match;

  const MatchDetailsScreen({super.key, required this.match});

  Color _getEventColor(String type) {
    switch (type) {
      case 'RC':
        return Colors.red;
      case 'GOAL':
        return Colors.green;
      case 'YC':
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }

  IconData _getEventIcon(String type) {
    switch (type) {
      case 'RC':
        return Icons.flag; // Red card
      case 'GOAL':
        return Icons.sports_soccer;
      case 'YC':
        return Icons.warning; // Yellow card
      default:
        return Icons.circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = match.isUpcoming ? 'TBD' : 'Full Time';
    final scoreDisplay = match.isUpcoming ? 'vs' : '${match.home} ${match.score} ${match.away}';
    final events = match.events.reversed.toList(); // Show latest first

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
            // Header
            Text(
              '${match.league} - ${match.date}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            // Score
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Events Section
            const Text(
              'Match Events',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '- $status',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            if (events.isNotEmpty)
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: events.length,
                separatorBuilder: (context, index) => const SizedBox(height: 4),
                itemBuilder: (context, index) {
                  final event = events[index];
                  final color = _getEventColor(event.type);
                  final icon = _getEventIcon(event.type);
                  final description = '${event.type} - ${event.player} (${event.team})';
                  return Row(
                    children: [
                      Text(
                        '${event.time}\'',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        icon,
                        color: color,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        description,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  );
                },
              )
            else
              const Text(
                'No events available yet.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
class Event {
  final int time;
  final String type;
  final String player;
  final String team;

  const Event({
    required this.time,
    required this.type,
    required this.player,
    required this.team,
  });
}

class Match {
  final String home;
  final String away;
  final String date;
  final String? score;
  final String league;
  final String? highlight;
  final bool isUpcoming;
  final List<Event> events;

  const Match({
    required this.home,
    required this.away,
    required this.date,
    this.score,
    required this.league,
    this.highlight,
    required this.isUpcoming,
    this.events = const [],
  });
}
