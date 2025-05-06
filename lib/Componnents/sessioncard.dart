import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/details.dart';
import 'package:flutter_application_2/model/sessionmodel.dart';
import 'package:flutter_application_2/provider/sessionprovider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SessionCard extends StatelessWidget {
final Sessionmodel session;
  final int index;



  const SessionCard({
    super.key,required this.index, required this.session,
  });

  @override
  Widget build(BuildContext context) {
     return Consumer<SessionProvider>( // Add Consumer to get updates
      builder: (context, provider, _) {
        final session = provider.sessions[index]; 
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => Details(session:session,index:index,)
          ),
        );
      },
      child: SizedBox(
        height: 182,
        child: Hero(
          tag: 'session-$index-${session.sportname ?? "unknown"}', // Handle null sportname
          child: Material(
            type: MaterialType.transparency,
            child: Card(
              margin: const EdgeInsets.only(bottom: 5),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            session.sportname ?? 'Unnamed Session',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                              const SizedBox(width: 5),
                              Text(
                                session.entraineur ?? 'Unknown Coach',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                                  const SizedBox(width: 5),
                                  Text(
                                    session.date != null 
                                      ? DateFormat('MMM dd, yyyy - hh:mm a').format(session.date!)
                                      : 'No date set',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Chip(
                                    label: Text(session.duration ?? 'No duration'),
                                    backgroundColor: const Color(0xFF0B2545).withOpacity(0.1)),
                                ],
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF01CF12),
                                  foregroundColor: Colors.white
                                ),
                                onPressed: () {},
                                child: const Text('Join'),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
      }
     );
  }
}    
  
