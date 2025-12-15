import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Matches {
  final int page;
  final int limit;
  final List<Datum> data;

  Matches({
    required this.page,
    required this.limit,
    required this.data,
  });

  factory Matches.fromJson(Map<String, dynamic> json) => Matches(
    page: json["page"],
    limit: json["limit"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );
}

class Datum {
  final int id;
  final DateTime date;
  final dynamic venue;
  final String status;
  final Score score;
  final Competition competition;
  final Team homeTeam;
  final Team awayTeam;
  final Events events;

  Datum({
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

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    date: DateTime.parse(json["date"]),
    venue: json["venue"],
    status: json["status"],
    score: Score.fromJson(json["score"]),
    competition: Competition.fromJson(json["competition"]),
    homeTeam: Team.fromJson(json["home_team"]),
    awayTeam: Team.fromJson(json["away_team"]),
    events: Events.fromJson(json["events"]),
  );
}

class Team {
  final String shortName;
  final dynamic logoUrl;

  Team({
    required this.shortName,
    required this.logoUrl,
  });

  factory Team.fromJson(Map<String, dynamic> json) => Team(
    shortName: json["short_name"],
    logoUrl: json["logo_url"],
  );
}

class Competition {
  final String name;
  final String season;

  Competition({
    required this.name,
    required this.season,
  });

  factory Competition.fromJson(Map<String, dynamic> json) => Competition(
    name: json["name"],
    season: json["season"],
  );
}

class Events {
  final List<Goal> goals;
  final List<dynamic> redCards;

  Events({
    required this.goals,
    required this.redCards,
  });

  factory Events.fromJson(Map<String, dynamic> json) => Events(
    goals: List<Goal>.from(json["goals"].map((x) => Goal.fromJson(x))),
    redCards: List<dynamic>.from(json["red_cards"].map((x) => x)),
  );
}

class Goal {
  final int playerId;
  final int minute;
  final dynamic assistingPlayerId;

  Goal({
    required this.playerId,
    required this.minute,
    required this.assistingPlayerId,
  });

  factory Goal.fromJson(Map<String, dynamic> json) => Goal(
    playerId: json["player_id"],
    minute: json["minute"],
    assistingPlayerId: json["assisting_player_id"],
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
    home: json["home"],
    away: json["away"],
  );
}

class MatchesScreen extends StatefulWidget {
  final int teamId;

  const MatchesScreen({super.key, required this.teamId});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  Matches? matchesData;
  bool isLoading = true;
  String? error;
  int currentPage = 1;
  final int limit = 10;

  @override
  void initState() {
    super.initState();
    fetchMatches();
  }

  Future<void> fetchMatches() async {
    try {
      final response = await http.get(
        Uri.parse('https://maule-fan-app-server.vercel.app/api/teams/${widget.teamId}/matches/events?page=$currentPage&limit=$limit'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          matchesData = Matches.fromJson(data);
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Failed to load matches';
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

  String getHighlight(Datum match) {
    if (match.events.goals.isNotEmpty) {
      final latestGoal = match.events.goals.reduce((a, b) => a.minute > b.minute ? a : b);
      return "${latestGoal.minute}' Goal";
    } else if (match.events.redCards.isNotEmpty) {
      final latestRedCard = match.events.redCards.first;
      return "${latestRedCard['minute']}' Red Card";
    }
    return '';
  }

  Color getHighlightColor(Datum match) {
    if (match.events.goals.isNotEmpty) return Colors.green;
    if (match.events.redCards.isNotEmpty) return Colors.red;
    return Colors.white70;
  }

  IconData getHighlightIcon(Datum match) {
    if (match.events.goals.isNotEmpty) return Icons.sports_soccer;
    if (match.events.redCards.isNotEmpty) return Icons.dangerous;
    return Icons.circle;
  }

  bool isUpcoming(Datum match) {
    return match.status == 'UPCOMING';
  }

  void loadNextPage() {
    setState(() {
      currentPage++;
      isLoading = true;
      fetchMatches();
    });
  }

  void loadPreviousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
        isLoading = true;
        fetchMatches();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading && matchesData == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (error != null || matchesData == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            error ?? 'No data available',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }

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
              itemCount: matchesData!.data.length,
              itemBuilder: (context, index) {
                final match = matchesData!.data[index];
                final highlight = getHighlight(match);
                
                return InkWell(
                  onTap: () {
                    // You can navigate to match details here
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (_) => MatchDetailsScreen(match: match),
                    //   ),
                    // );
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
                            '${formatDate(match.date)} - ${match.competition.name}',
                            style: const TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                match.homeTeam.shortName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (isUpcoming(match))
                                const Text(
                                  'vs',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 20,
                                  ),
                                )
                              else
                                Text(
                                  '${match.score.home} - ${match.score.away}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              Text(
                                match.awayTeam.shortName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          if (highlight.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  getHighlightIcon(match),
                                  color: getHighlightColor(match),
                                  size: 12,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  highlight,
                                  style: TextStyle(
                                    color: getHighlightColor(match),
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
          // Pagination controls
          if (matchesData != null) ...[
            Container(
              color: Colors.black,
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: currentPage > 1 ? loadPreviousPage : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white12,
                      disabledBackgroundColor: Colors.white12.withOpacity(0.3),
                    ),
                    child: const Text('Previous', style: TextStyle(color: Colors.white)),
                  ),
                  Text(
                    'Page $currentPage',
                    style: const TextStyle(color: Colors.white),
                  ),
                  ElevatedButton(
                    onPressed: matchesData!.data.length == limit ? loadNextPage : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white12,
                      disabledBackgroundColor: Colors.white12.withOpacity(0.3),
                    ),
                    child: const Text('Next', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}