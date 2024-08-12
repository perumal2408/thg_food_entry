import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MealEntryForm extends StatefulWidget {
  @override
  _MealEntryFormState createState() => _MealEntryFormState();
}

class _MealEntryFormState extends State<MealEntryForm> {
  final TextEditingController breakfastController = TextEditingController();
  final TextEditingController lunchController = TextEditingController();
  final TextEditingController dinnerController = TextEditingController();
  final CollectionReference meals = FirebaseFirestore.instance.collection('meals');

  final _formKey = GlobalKey<FormState>();

  void saveMeal() {
    if (_formKey.currentState?.validate() ?? false) {
      meals.doc(DateTime.now().toIso8601String().split('T')[0]).set({
        'breakfast': breakfastController.text,
        'lunch': lunchController.text,
        'dinner': dinnerController.text,
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Meal saved successfully')));
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save meal: $error')));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Entry'),
         backgroundColor: const Color.fromARGB(255, 255, 185, 34),
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter your meals for today',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 37, 37, 37),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: breakfastController,
                    decoration: InputDecoration(
                      labelText: 'Breakfast',
                      hintText: 'Enter your breakfast details',
                      labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                      hintStyle: TextStyle(color: const Color.fromARGB(179, 0, 0, 0)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    style: TextStyle(color: Colors.black),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter breakfast details';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: lunchController,
                    decoration: InputDecoration(
                      labelText: 'Lunch',
                      hintText: 'Enter your lunch details',
                      labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                      hintStyle: TextStyle(color: const Color.fromARGB(179, 0, 0, 0)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    style: TextStyle(color: Colors.black),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter lunch details';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: dinnerController,
                    decoration: InputDecoration(
                      labelText: 'Dinner',
                      hintText: 'Enter your dinner details',
                      labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                      hintStyle: TextStyle(color: const Color.fromARGB(179, 0, 0, 0)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    style: TextStyle(color: Colors.black),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter dinner details';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: saveMeal,
                      style: ElevatedButton.styleFrom(
                         backgroundColor: const Color.fromARGB(255, 255, 185, 34),
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                      child: Text('Save Meal', style: TextStyle(color: Colors.white)),
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