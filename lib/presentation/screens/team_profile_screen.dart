import 'package:flutter/material.dart';

class Achievement {
  final String title;
  final String year;
  final String type;

  const Achievement({
    required this.title,
    required this.year,
    required this.type,
  });
}

class TeamProfileScreen extends StatelessWidget {
  const TeamProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const String clubName = 'NYASA BIG BULLETS';
    const String founded = '1976';
    const String league = 'TNM Super League';
    const String homeGround = 'Kamuzu Stadium, Blantyre';
    const String nickname = 'The Peoples\' Team';

    const List<String> historyHighlights = [
      'Founded in 1976 in Blantyre, Malawi, as a community club.',
      'First major title: Malawi State Cup in 1980.',
      'Dominant force in Malawian football, with over 30 league titles.',
      'Known for youth development and community involvement.',
    ];

    const List<Achievement> achievements = [
      Achievement(title: 'TNM Super League', year: '2024/25', type: 'League'),
      Achievement(title: 'TNM Super League', year: '2023/24', type: 'League'),
      Achievement(title: 'FISD Challenge Cup', year: '2024', type: 'Cup'),
      Achievement(title: 'FISD Challenge Cup', year: '2023', type: 'Cup'),
      Achievement(title: 'Carabao Cup', year: '2022', type: 'Cup'),
      Achievement(title: 'Charity Shield', year: '2024', type: 'Shield'),
      Achievement(title: 'CAF Confederations Cup', year: '2019', type: 'International'),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Team Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFDA1A32),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              clubName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.info_outline, nickname),
            _buildInfoRow(Icons.calendar_today, 'Founded: $founded'),
            _buildInfoRow(Icons.stadium, league),
            _buildInfoRow(Icons.location_on, homeGround),
            const SizedBox(height: 24),

            const Text(
              'HISTORY',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...historyHighlights.map(
              (highlight) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.circle,
                      color: Color(0xFFDA1A32),
                      size: 8,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        highlight,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'ACHIEVEMENTS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 1,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: achievements.length,
              itemBuilder: (context, index) {
                final achievement = achievements[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDA1A32).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFDA1A32).withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        achievement.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        achievement.year,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      if (achievement.type.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          achievement.type,
                          style: const TextStyle(
                            color: Color(0xFFDA1A32),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            const Center(
              child: Text(
                'More to come...',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFFDA1A32),
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}