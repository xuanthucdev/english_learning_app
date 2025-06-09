import 'package:flutter/material.dart';

class RankScreen extends StatelessWidget {
  // Sample ranking data
  final List<RankedUser> rankedUsers = [
    RankedUser(
      rank: 1,
      name: 'Emma Wilson',
      score: 950,
      avatar: Icons.person,
    ),
    RankedUser(
      rank: 2,
      name: 'Liam Brown',
      score: 920,
      avatar: Icons.person,
    ),
    RankedUser(
      rank: 3,
      name: 'Sophia Nguyen',
      score: 890,
      avatar: Icons.person,
    ),
    RankedUser(
      rank: 4,
      name: 'James Lee',
      score: 850,
      avatar: Icons.person,
    ),
    RankedUser(
      rank: 5,
      name: 'Olivia Smith',
      score: 820,
      avatar: Icons.person,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Leaderboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.purple.shade800,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple.shade800, Colors.purple.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple.shade100, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Top Performers',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple.shade900,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Celebrating the best in skill tests!',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              // Podium section with constrained height
              SizedBox(
                height: MediaQuery.of(context).size.height *
                    0.3, // 30% of screen height
                child: _buildPodium(context),
              ),
              // Leaderboard list
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: rankedUsers.length - 3, // Start from 4th place
                  itemBuilder: (context, index) {
                    final user = rankedUsers[index + 3];
                    return _buildRankCard(context, user, index + 3);
                  },
                ),
              ),
              const SizedBox(height: 20), // Extra padding at the bottom
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPodium(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (rankedUsers.length > 1)
          _buildPodiumItem(context, rankedUsers[1], 2, 0.6), // 2nd place
        if (rankedUsers.isNotEmpty)
          _buildPodiumItem(context, rankedUsers[0], 1, 0.8), // 1st place
        if (rankedUsers.length > 2)
          _buildPodiumItem(context, rankedUsers[2], 3, 0.5), // 3rd place
      ],
    );
  }

  Widget _buildPodiumItem(
      BuildContext context, RankedUser user, int rank, double heightFactor) {
    Color rankColor = rank == 1
        ? Colors.purple.shade900
        : rank == 2
            ? Colors.purple.shade700
            : Colors.purple.shade500;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: 100,
      height: MediaQuery.of(context).size.height *
          0.3 *
          heightFactor, // Dynamic height
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.purple.shade700,
            child: Icon(
              user.avatar,
              size: 32,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            user.name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.purple.shade900,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '${user.score} pts',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [rankColor, rankColor.withOpacity(0.7)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: Center(
                child: Text(
                  '$rank',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankCard(BuildContext context, RankedUser user, int index) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 500),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
        color: Colors.purple.shade50,
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.purple.shade700,
            child: Icon(
              user.avatar,
              color: Colors.white,
              size: 28,
            ),
          ),
          title: Text(
            user.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            'Score: ${user.score}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          trailing: CircleAvatar(
            radius: 18,
            backgroundColor: Colors.purple.shade300,
            child: Text(
              '${user.rank}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          onTap: () {
            // Navigate to user profile or details (optional)
          },
        ),
      ),
    );
  }
}

class RankedUser {
  final int rank;
  final String name;
  final int score;
  final IconData avatar;

  RankedUser({
    required this.rank,
    required this.name,
    required this.score,
    required this.avatar,
  });
}
