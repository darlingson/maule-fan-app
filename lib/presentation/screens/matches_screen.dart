import 'package:flutter/material.dart';

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

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Match> matches = [
      // Recent matches with events
      const Match(
        home: 'KAM',
        away: 'BUL',
        date: 'Nov 27, 2025',
        score: '0 - 2',
        league: 'TNM Super League',
        highlight: "88' Goal (BUL)",
        isUpcoming: false,
        events: [
          Event(time: 88, type: 'GOAL', player: 'Chawanangwa Gomezgani', team: 'BUL'),
          Event(time: 75, type: 'YC', player: 'Player X', team: 'KAM'),
          Event(time: 62, type: 'GOAL', player: 'Precious Samuel', team: 'BUL'),
          Event(time: 45, type: 'YC', player: 'Player Y', team: 'BUL'),
          Event(time: 30, type: 'RC', player: 'Player Z', team: 'KAM'),
        ],
      ),
      const Match(
        home: 'BUL',
        away: 'CIV',
        date: 'Nov 23, 2025',
        score: '4 - 3',
        league: 'TNM Super League',
        highlight: "75' Red Card (CIV)",
        isUpcoming: false,
        events: [
          Event(time: 89, type: 'GOAL', player: 'Henry Kabuwa', team: 'CIV'),
          Event(time: 82, type: 'YC', player: 'Player A', team: 'BUL'),
          Event(time: 75, type: 'RC', player: 'Player B', team: 'CIV'),
          Event(time: 68, type: 'GOAL', player: 'Limbikani Mphepo', team: 'BUL'),
          Event(time: 55, type: 'GOAL', player: 'Player C', team: 'CIV'),
          Event(time: 42, type: 'GOAL', player: 'Player D', team: 'BUL'),
          Event(time: 28, type: 'YC', player: 'Player E', team: 'CIV'),
          Event(time: 15, type: 'GOAL', player: 'Christopher Kumwembe', team: 'BUL'),
        ],
      ),
      const Match(
        home: 'BLU',
        away: 'BUL',
        date: 'Nov 6, 2025',
        score: '0 - 0',
        league: 'TNM Super League',
        highlight: null,
        isUpcoming: false,
        events: [
          Event(time: 70, type: 'YC', player: 'Player F', team: 'BLU'),
          Event(time: 45, type: 'YC', player: 'Player G', team: 'BUL'),
          Event(time: 20, type: 'YC', player: 'Player H', team: 'BLU'),
        ],
      ),
      // Upcoming matches
      const Match(
        home: 'KAR',
        away: 'BUL',
        date: 'Dec 17, 2025',
        score: null,
        league: 'TNM Super League',
        highlight: null,
        isUpcoming: true,
        events: [],
      ),
      const Match(
        home: 'BUL',
        away: 'SIL',
        date: 'Dec 28, 2025',
        score: null,
        league: 'TNM Super League',
        highlight: null,
        isUpcoming: true,
        events: [],
      ),
      const Match(
        home: 'MZU',
        away: 'BUL',
        date: 'Jan 4, 2026',
        score: null,
        league: 'TNM Super League',
        highlight: null,
        isUpcoming: true,
        events: [],
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            color: Colors.black,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Matches',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white70),
                      ),
                      child: const Text(
                        'Season ▼',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white70),
                      ),
                      child: const Text(
                        'Competition ▼',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: matches.length,
              itemBuilder: (context, index) {
                final match = matches[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MatchDetailsScreen(match: match),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.black,
                    margin: const EdgeInsets.only(bottom: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${match.date} - ${match.league}',
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                match.home,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (match.isUpcoming)
                                const Text(
                                  'vs',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 20,
                                  ),
                                )
                              else
                                Text(
                                  match.score ?? '',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              Text(
                                match.away,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          if (match.highlight != null) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.circle,
                                  color: Colors.red,
                                  size: 8,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  match.highlight!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

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