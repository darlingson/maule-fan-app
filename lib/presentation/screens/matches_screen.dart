import 'package:flutter/material.dart';

class Match {
  final String home;
  final String away;
  final String date;
  final String? score;
  final String league;
  final String? highlight;
  final bool isUpcoming;

  const Match({
    required this.home,
    required this.away,
    required this.date,
    this.score,
    required this.league,
    this.highlight,
    required this.isUpcoming,
  });
}

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Match> matches = [
      // Recent matches
      const Match(
        home: 'KAM',
        away: 'BUL',
        date: 'Nov 27, 2025',
        score: '0 - 2',
        league: 'TNM Super League',
        highlight: "88' Goal (BUL)",
        isUpcoming: false,
      ),
      const Match(
        home: 'BUL',
        away: 'CIV',
        date: 'Nov 23, 2025',
        score: '4 - 3',
        league: 'TNM Super League',
        highlight: "75' Red Card (CIV)",
        isUpcoming: false,
      ),
      const Match(
        home: 'BLU',
        away: 'BUL',
        date: 'Nov 6, 2025',
        score: '0 - 0',
        league: 'TNM Super League',
        highlight: null,
        isUpcoming: false,
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
      ),
      const Match(
        home: 'BUL',
        away: 'SIL',
        date: 'Dec 28, 2025',
        score: null,
        league: 'TNM Super League',
        highlight: null,
        isUpcoming: true,
      ),
      const Match(
        home: 'MZU',
        away: 'BUL',
        date: 'Jan 4, 2026',
        score: null,
        league: 'TNM Super League',
        highlight: null,
        isUpcoming: true,
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
                return Card(
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
