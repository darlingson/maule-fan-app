import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Models for the new competitions endpoint
Competitions competitionsFromJson(String str) =>
    Competitions.fromJson(json.decode(str));
String competitionsToJson(Competitions data) => json.encode(data.toJson());

class Competitions {
  final List<Datum> data;
  Competitions({required this.data});
  factory Competitions.fromJson(Map<String, dynamic> json) => Competitions(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );
  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  final int id;
  final String name;
  final String type;
  final String season;
  Datum({
    required this.id,
    required this.name,
    required this.type,
    required this.season,
  });
  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    type: json["type"],
    season: json["season"],
  );
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "type": type,
    "season": season,
  };
}

// Existing matches models
class Matches {
  final int page;
  final int limit;
  final List<MatchDatum> data;
  Matches({required this.page, required this.limit, required this.data});
  factory Matches.fromJson(Map<String, dynamic> json) => Matches(
    page: json["page"],
    limit: json["limit"],
    data: List<MatchDatum>.from(
      json["data"].map((x) => MatchDatum.fromJson(x)),
    ),
  );
  Map<String, dynamic> toJson() => {
    "page": page,
    "limit": limit,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class MatchDatum {
  final int id;
  final DateTime date;
  final dynamic venue;
  final String status;
  final Score score;
  final Competition competition;
  final Team homeTeam;
  final Team awayTeam;
  final Events events;
  MatchDatum({
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
  factory MatchDatum.fromJson(Map<String, dynamic> json) => MatchDatum(
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
  Map<String, dynamic> toJson() => {
    "id": id,
    "date": date.toIso8601String(),
    "venue": venue,
    "status": status,
    "score": score.toJson(),
    "competition": competition.toJson(),
    "home_team": homeTeam.toJson(),
    "away_team": awayTeam.toJson(),
    "events": events.toJson(),
  };
}

class Team {
  final String shortName;
  final dynamic logoUrl;
  Team({required this.shortName, required this.logoUrl});
  factory Team.fromJson(Map<String, dynamic> json) =>
      Team(shortName: json["short_name"], logoUrl: json["logo_url"]);
  Map<String, dynamic> toJson() => {
    "short_name": shortName,
    "logo_url": logoUrl,
  };
}

class Competition {
  final String name;
  final String season;
  Competition({required this.name, required this.season});
  factory Competition.fromJson(Map<String, dynamic> json) =>
      Competition(name: json["name"], season: json["season"]);
  Map<String, dynamic> toJson() => {"name": name, "season": season};
}

class Events {
  final List<Goal> goals;
  final List<dynamic> redCards;
  Events({required this.goals, required this.redCards});
  factory Events.fromJson(Map<String, dynamic> json) => Events(
    goals: List<Goal>.from(json["goals"].map((x) => Goal.fromJson(x))),
    redCards: List<dynamic>.from(json["red_cards"].map((x) => x)),
  );
  Map<String, dynamic> toJson() => {
    "goals": List<dynamic>.from(goals.map((x) => x.toJson())),
    "red_cards": List<dynamic>.from(redCards.map((x) => x)),
  };
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
  Map<String, dynamic> toJson() => {
    "player_id": playerId,
    "minute": minute,
    "assisting_player_id": assistingPlayerId,
  };
}

class Score {
  final int home;
  final int away;
  Score({required this.home, required this.away});
  factory Score.fromJson(Map<String, dynamic> json) =>
      Score(home: json["home"], away: json["away"]);
  Map<String, dynamic> toJson() => {"home": home, "away": away};
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

  // Available competitions from API
  List<Datum> availableCompetitions = [];
  int? selectedCompetitionId;
  String? selectedSeason;

  bool filtersLoaded = false;

  @override
  void initState() {
    super.initState();
    fetchCompetitions();
  }

  Future<void> fetchCompetitions() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://maule-fan-app-server.vercel.app/api/teams/${widget.teamId}/competitions',
        ),
      );
      if (response.statusCode == 200) {
        final data = competitionsFromJson(response.body);
        setState(() {
          availableCompetitions = data.data;
          filtersLoaded = true;
          if (availableCompetitions.isNotEmpty) {
            selectedCompetitionId = availableCompetitions.first.id;
            selectedSeason = availableCompetitions.first.season;
            fetchMatches();
          } else {
            setState(() => isLoading = false);
          }
        });
      } else {
        setState(() {
          error = 'Failed to load competitions';
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

  Future<void> fetchMatches() async {
    if (!filtersLoaded) return;
    try {
      final queryParams = {
        'page': currentPage.toString(),
        'limit': limit.toString(),
      };
      if (selectedCompetitionId != null) {
        queryParams['competition_id'] = selectedCompetitionId.toString();
      }
      if (selectedSeason != null && selectedSeason!.isNotEmpty) {
        queryParams['season'] = selectedSeason!;
      }

      final uri = Uri.parse(
        'https://maule-fan-app-server.vercel.app/api/teams/${widget.teamId}/matches/events',
      ).replace(queryParameters: queryParams);

      final response = await http.get(uri);
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

  String formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';

  List<Widget> buildAllEvents(MatchDatum match) {
    List<Widget> eventWidgets = [];
    for (final goal in match.events.goals) {
      eventWidgets.add(
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.sports_soccer, color: Colors.green, size: 12),
              const SizedBox(width: 2),
              Text(
                "${goal.minute}' Goal",
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }
    for (final redCard in match.events.redCards) {
      eventWidgets.add(
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.dangerous, color: Colors.red, size: 12),
              const SizedBox(width: 2),
              Text(
                "${redCard['minute']}' Red Card",
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return eventWidgets;
  }

  bool isUpcoming(MatchDatum match) => match.status == 'UPCOMING';

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

  void updateCompetitionFilter(Datum? competition) {
    if (competition != null) {
      setState(() {
        selectedCompetitionId = competition.id;
        selectedSeason = competition.season;
        currentPage = 1;
        isLoading = true;
        fetchMatches();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading && !filtersLoaded) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (error != null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(error!, style: const TextStyle(color: Colors.white)),
        ),
      );
    }

    if (!filtersLoaded || availableCompetitions.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: const Center(
          child: Text(
            'No competitions available',
            style: TextStyle(color: Colors.white),
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white70),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Datum>(
                          value: availableCompetitions.firstWhere(
                            (c) => c.id == selectedCompetitionId,
                          ),
                          dropdownColor: Colors.grey[900],
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white70,
                            size: 16,
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          items: availableCompetitions.map((comp) {
                            return DropdownMenuItem<Datum>(
                              value: comp,
                              child: SizedBox(
                                width: 120,
                                child: Text(
                                  '${comp.name} ${comp.season}',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: updateCompetitionFilter,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: matchesData?.data.length ?? 0,
                    itemBuilder: (context, index) {
                      final match = matchesData!.data[index];
                      return InkWell(
                        onTap: () {},
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
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                if (match.events.goals.isNotEmpty ||
                                    match.events.redCards.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 4,
                                    children: buildAllEvents(match),
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
          if (matchesData != null && !isLoading) ...[
            Container(
              color: Colors.black,
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: currentPage > 1 ? loadPreviousPage : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: currentPage > 1
                            ? Colors.white12
                            : Colors.white12.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_back_ios,
                            size: 14,
                            color: currentPage > 1
                                ? Colors.white
                                : Colors.white54,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Previous',
                            style: TextStyle(
                              color: currentPage > 1
                                  ? Colors.white
                                  : Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Page $currentPage',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: matchesData!.data.length == limit
                        ? loadNextPage
                        : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: matchesData!.data.length == limit
                            ? Colors.white12
                            : Colors.white12.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Next',
                            style: TextStyle(
                              color: matchesData!.data.length == limit
                                  ? Colors.white
                                  : Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: matchesData!.data.length == limit
                                ? Colors.white
                                : Colors.white54,
                          ),
                        ],
                      ),
                    ),
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
