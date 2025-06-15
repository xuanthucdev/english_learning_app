import 'package:english_app/core/services/ranked_service.dart';
import 'package:english_app/models/ranked_model.dart';
import 'package:flutter/material.dart';

class RankScreen extends StatefulWidget {
  @override
  _RankScreenState createState() => _RankScreenState();
}

class _RankScreenState extends State<RankScreen> {
  late Future<List<RankedUser>> _rankingFuture;

  @override
  void initState() {
    super.initState();
    _rankingFuture = RankService.fetchRanking();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: Colors.purple.shade800,
        centerTitle: true,
      ),
      body: FutureBuilder<List<RankedUser>>(
        future: _rankingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final rankedUsers = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: const [
                      Text(
                        'Top Performers',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Celebrating the best in skill tests!',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildPodium(context, rankedUsers),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        (rankedUsers.length > 3) ? rankedUsers.length - 3 : 0,
                    itemBuilder: (context, index) {
                      final user = rankedUsers[index + 3];
                      return _buildRankCard(user);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPodium(BuildContext context, List<RankedUser> users) {
    // Đảm bảo có ít nhất 1 người
    if (users.isEmpty) return const SizedBox();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (users.length > 1) _buildPodiumItem(users[1], 0.6), // Hạng 2
        _buildPodiumItem(users[0], 0.8), // Hạng 1
        if (users.length > 2) _buildPodiumItem(users[2], 0.5), // Hạng 3
      ],
    );
  }

  Widget _buildPodiumItem(RankedUser user, double heightFactor) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.purple.shade700,
          child: const Icon(Icons.person, color: Colors.white, size: 32),
        ),
        const SizedBox(height: 8),
        Text(
          user.userName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text('${user.score} pts'),
        const SizedBox(height: 6),
        Container(
          height: 80 * heightFactor,
          width: 60,
          decoration: BoxDecoration(
            color: Colors.purple.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              '${user.rank}',
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRankCard(RankedUser user) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.purple.shade700,
          child: const Icon(Icons.person, color: Colors.white),
        ),
        title: Text(user.userName),
        subtitle: Text('Score: ${user.score}'),
        trailing: CircleAvatar(
          backgroundColor: Colors.purple.shade300,
          child:
              Text('${user.rank}', style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
