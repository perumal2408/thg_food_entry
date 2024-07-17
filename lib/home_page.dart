// lib/home_page.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'meal_entry_form.dart';

class HomePage extends StatelessWidget {
  final CollectionReference meals = FirebaseFirestore.instance.collection('meals');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Today\'s Meals'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: meals.doc(DateTime.now().toIso8601String().split('T')[0]).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Failed to fetch meals: ${snapshot.error}'));
          }
          var data = snapshot.data?.data() as Map<String, dynamic>? ?? {};
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Breakfast: ${data['breakfast'] ?? 'Not Available'}'),
                Text('Lunch: ${data['lunch'] ?? 'Not Available'}'),
                Text('Dinner: ${data['dinner'] ?? 'Not Available'}'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MealEntryForm()),
                    );
                  },
                  child: Text('Enter Meal Details'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
