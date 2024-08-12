import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'meal_entry_form.dart';

class HomePage extends StatelessWidget {
  final CollectionReference meals = FirebaseFirestore.instance.collection('meals');
  final CollectionReference foodWaste = FirebaseFirestore.instance.collection('food_waste');
  final TextEditingController foodWasteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Today\'s Meals',
            style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0))),
        backgroundColor: Color.fromARGB(255, 253, 189, 52),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamBuilder<DocumentSnapshot>(
                    stream: meals.doc(DateTime.now().toIso8601String().split('T')[0]).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Failed to fetch meals: ${snapshot.error}'));
                      }
                      var data = snapshot.data?.data() as Map<String, dynamic>? ?? {};
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            color: Colors.white.withOpacity(0.8),
                            child: ListTile(
                              title: Text(
                                'Breakfast',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(data['breakfast'] ?? 'Not Available'),
                            ),
                          ),
                          SizedBox(height: 10),
                          Card(
                            color: Colors.white.withOpacity(0.8),
                            child: ListTile(
                              title: Text(
                                'Lunch',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(data['lunch'] ?? 'Not Available'),
                            ),
                          ),
                          SizedBox(height: 10),
                          Card(
                            color: Colors.white.withOpacity(0.8),
                            child: ListTile(
                              title: Text(
                                'Dinner',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(data['dinner'] ?? 'Not Available'),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MealEntryForm()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 253, 189, 52),
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                      child: Text(
                        'Enter Meal Details',
                        style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Food Waste',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: foodWasteController,
                    decoration: InputDecoration(
                      labelText: 'Food Waste (kg)',
                      hintText: 'Enter the amount of food waste in kg',
                      labelStyle: TextStyle(color: Colors.black),
                      hintStyle: TextStyle(color: Colors.black54),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    style: TextStyle(color: Colors.black),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        String yesterdayDate = DateTime.now()
                            .subtract(Duration(days: 1))
                            .toIso8601String()
                            .split('T')[0];
                        foodWaste.doc(yesterdayDate).set({
                          'food_waste_kg': foodWasteController.text,
                        }).then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Food waste saved successfully')));
                          foodWasteController.clear();
                        }).catchError((error) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Failed to save food waste: $error')));
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 253, 189, 52),
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                      child: Text(
                        'Submit Food Waste',
                        style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}