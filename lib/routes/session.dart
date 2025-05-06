
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/Componnents/sessioncard.dart';
import 'package:flutter_application_2/config/config.dart';
import 'package:flutter_application_2/controllers/sessioncontroller.dart';
import 'package:flutter_application_2/model/sessionmodel.dart';
import 'package:flutter_application_2/provider/sessionprovider.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
class Session extends StatefulWidget {
  const Session({super.key});

  @override
  State<Session> createState() => _SessionState();
}

class _SessionState extends State<Session> {


  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
   final TextEditingController _coachController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  DateTime? _selectedDateTime;
  final Sessioncontroller _sessioncontroller = Get.put(Sessioncontroller());
  bool _isLoading = false;


  
  Future<void> _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      
      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            
          );
        });
      }
    }
  }
  @override
  void initState() {
    super.initState();
       WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshSessions();
    });
  }

  Future<void> _refreshSessions() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      await Provider.of<SessionProvider>(context, listen: false).getallsessions();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading sessions: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
    // No need to manually call getallsessions() since we're now doing it 
    // automatically in the SessionProvider constructor
  



  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor:Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: _isLoading 
          ? Center(child: CircularProgressIndicator())
          : Consumer<SessionProvider>(
          builder: (context, provider, _) {
               if (provider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (provider.sessions.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('No sessions found', style: TextStyle(fontSize: 18)),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _refreshSessions,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF01CF12),
                          ),
                          child: Text('Refresh'),
                        ),
                      ],
                    ),
                  );
                }
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: provider.sessions.length,
              itemBuilder: (context, index) => SessionCard(   session: provider.sessions[index],index: index), // Only pass index
            );
          },
        ),
      ),
      // ... floating action button remains same ...
     
      floatingActionButton: FloatingActionButton(
        
        backgroundColor: Color(0xFF01CF12),
        child: Icon(Icons.add),
        onPressed: () => _showAddSessionDialog(context),
        
        
      ),

    );
        
    
  }

  void _showAddSessionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('New Session',
            style: TextStyle(color: Color(0xFF0B2545))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Session Name',
                labelStyle: TextStyle(color: Color(0xFF0B2545)))),
                 TextField(
              controller: _coachController,
              decoration: InputDecoration(
                labelText: 'Coach',
                labelStyle: TextStyle(color: Color(0xFF0B2545)))),
                 ListTile(
              title: Text(_selectedDateTime != null
                  ? DateFormat('MMM dd, yyyy - hh:mm a').format(_selectedDateTime!)
                  : 'Select Date & Time'),
              trailing: Icon(Icons.calendar_today),
              onTap: _selectDateTime,
            ),
            TextField(
              controller: _durationController,
              decoration: InputDecoration(
                labelText: 'Duration',
                labelStyle: TextStyle(color: Color(0xFF0B2545)))),
          
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: TextStyle(color: Colors.grey[600]))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF01CF12)),
            onPressed: () async{
               try {
    if (_titleController.text.isEmpty ||
        _coachController.text.isEmpty ||
        _selectedDateTime == null ||
        _durationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required')),
      );
      return;
    }

    final newSession = Sessionmodel(
      sportname: _titleController.text,
      entraineur: _coachController.text,
      date: _selectedDateTime!,
      duration: _durationController.text,
    );

    final response = await _sessioncontroller.createsession(newSession);
    if (response['status'] == true) {
      final rawBody = response['body'] as String? ?? '{}'; // Handle null body
      final json = jsonDecode(rawBody);
      final createdSession = Sessionmodel.fromJson(json);
      
      Provider.of<SessionProvider>(context, listen: false)
          .addSession(createdSession);

      // Clear fields and close dialog
      _titleController.clear();
      _coachController.clear();
      _durationController.clear();
      setState(() => _selectedDateTime = null);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['error'].toString())),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}')),
    );
  }
            },
    
            

           child: Text('Create',
                style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }         
}

