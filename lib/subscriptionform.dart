import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/controllers/subscriptioncontroller.dart';
import 'package:flutter_application_2/model/subscriptionmodel.dart';
import 'package:flutter_application_2/provider/subscription%20provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SubscriptionForm extends StatefulWidget {
  const SubscriptionForm({super.key});

  @override
  State<SubscriptionForm> createState() => _SubscriptionFormState();
}

class _SubscriptionFormState extends State<SubscriptionForm> {
  final _formKey = GlobalKey<FormState>();
    final _typeController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedType;

  Future<void> _pickDate(bool isStart) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    
    if (date != null) {
      setState(() {
        if (isStart) {
          _startDate = date;
          if (_endDate != null && _endDate!.isBefore(date)) _endDate = null;
        } else {
          _endDate = date;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle:true,
        title:  Text('New Subscription',
        style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B2545),) ,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
               TextFormField(
                controller: _typeController,
                decoration: const InputDecoration(
                  labelText: 'Subscription Type',
                  hintText: 'Enter subscription type (e.g., MMA, CARDIO)'
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a subscription type';
                  }
                  return null;
                },
               ),
              const SizedBox(height: 20),
              TextFormField(
                readOnly: true,
                controller: TextEditingController(
                    text: _startDate != null
                        ? DateFormat('MMM dd, yyyy').format(_startDate!)
                        : ''),
                decoration: const InputDecoration(
                  labelText: 'Start Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => _pickDate(true),
                validator: (v) => _startDate == null ? 'Select start date' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                readOnly: true,
                controller: TextEditingController(
                    text: _endDate != null
                        ? DateFormat('MMM dd, yyyy').format(_endDate!)
                        : ''),
                decoration: const InputDecoration(
                  labelText: 'End Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => _pickDate(false),
                validator: (v) {
                  if (_endDate == null) return 'Select end date';
                  if (_endDate!.isBefore(_startDate!)) {
                    return 'End date must be after start date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF01CF12),
                    foregroundColor: Colors.white,),
                onPressed: () async{
                if (_formKey.currentState!.validate()) {
                  try {
  // Validate all required fields
  if (_typeController.text.isEmpty || _startDate == null || _endDate == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All fields are required')),
    );
    return;
  }

  // Create subscription object
  final newSubscription = Subscriptionmodel(
    type: _typeController.text,
    datedebut: DateTime(_startDate!.year, _startDate!.month, _startDate!.day),
    datefin: DateTime(_endDate!.year, _endDate!.month, _endDate!.day),
  );

  // Send to controller
  final response = await Subscriptioncontroller.instance.createsubscription(newSubscription);
  
  if (response['status'] == true) {
    // Parse response
    final rawBody = response['body'] as String? ?? '{}';
    final json = jsonDecode(rawBody);
    final createdSubscription = Subscriptionmodel.fromJson(json);
    
    // Update provider
       final provider = Provider.of<SubscriptionProvider>(context, listen: false);
    provider.AddSubscription(newSubscription);

    // Clear form
    _typeController.clear();
    setState(() {
      _startDate = null;
      _endDate = null;
    });
       ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Subscription created!')),
    );
    
    Navigator.pop(context);
  } else {
    // Show error from server
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response['error']?.toString() ?? 'Failed to create subscription')),
    );
  }
} catch (e) {
  // Handle exceptions
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Error: ${e.toString()}')),
  );
}
                }
                },
              
  child: const Text('Create Subscription'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
     