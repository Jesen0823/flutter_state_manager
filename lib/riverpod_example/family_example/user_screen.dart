
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_provider.dart';

class FamilyExampleScreen extends ConsumerWidget {
  const FamilyExampleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Provider Example'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue[50]!, Colors.purple[50]!],
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'User Profiles',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            // User 1 Card
            _buildUserCard(ref, '1'),
            const SizedBox(height: 16),
            
            // User 2 Card
            _buildUserCard(ref, '-1'),
            const SizedBox(height: 16),
            
            // User 3 Card
            _buildUserCard(ref, '3'),
            const SizedBox(height: 16),
            
            // Unknown User Card
            _buildUserCard(ref, '999'),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(WidgetRef ref, String userId) {
    final userAsync = ref.watch(userProvider(userId));
    
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: userAsync.when(
          data: (user) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'User ID: ${user.id}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user.email,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
          error: (error, stackTrace) => Center(
            child: Text(
              'Error: $error',
              style: const TextStyle(
                color: Colors.red,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
