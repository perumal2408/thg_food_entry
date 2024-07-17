// lib/meal_entry_form.dart
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
      appBar: AppBar(title: Text('Food Entry')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: breakfastController,
                decoration: InputDecoration(labelText: 'Breakfast'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter breakfast details';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: lunchController,
                decoration: InputDecoration(labelText: 'Lunch'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter lunch details';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: dinnerController,
                decoration: InputDecoration(labelText: 'Dinner'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter dinner details';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveMeal,
                child: Text('Save Meal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
