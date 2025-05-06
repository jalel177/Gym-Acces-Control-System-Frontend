import 'package:flutter/material.dart';
import 'package:flutter_application_2/Componnents/sessioncard.dart';
import 'package:flutter_application_2/provider/sessionprovider.dart';
import 'package:flutter_application_2/subscriptionform.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key, required token});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();



  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(vertical:30.0),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Good Morning',
                      style: TextStyle(fontSize: 24, color: Colors.grey[600],fontWeight:FontWeight.bold)),
              
                ],
              ),
            ),
            // Search Bar
            _buildSearchBar(),
            const SizedBox(height: 20),
            
               _buildSubscriptionField(),
                     const SizedBox(height: 30),

            // Popular Workouts
            Text('Popular Workouts',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0B2545))),
            const SizedBox(height: 15),
            _buildWorkoutCard('Lower Body Training', '700 Kcal', '50 Min'),
            const SizedBox(height: 10),
            _buildWorkoutCard('Upper Body Train', '600 Kcal', '40 Min'),
            const SizedBox(height: 30),
            
            // Trending Combat Sports
            Text('Trending Combat Sessions',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0B2545))),
                    SizedBox(height: 10,),
                    Consumer<SessionProvider>(
  builder: (context, provider, _) {
    final sessions = provider.sessions.take(2).toList(); // Get newest 2
    return Column(
       children: sessions.map((session) => SessionCard(
               session: session, // Pass session object
                    index: sessions.indexOf(session),
                  )).toList()
    );
  },
),
            
            
            // Today's Plan
            Text("Today's Plan",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0B2545))),
            const SizedBox(height: 15),
            _buildPlanItem('Push Up', '100 Push up a day', '48%'),
            _buildPlanItem('Sit Up', '20 Sit up a day', '75%'),
          ],
        ),
      ),
     
    );
  }
  Widget _buildSubscriptionField() {
    return InkWell(
      onTap: () {  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SubscriptionForm()),
  );   // Add your subscription logic here
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text.rich(
              TextSpan(
                text: 'You have no subscription. ',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                children: [
                  TextSpan(
                    text: 'Join now',
                    style: TextStyle(
                      color: const Color(0xFF01CF12),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, 
                size: 16, 
                color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }

Widget _buildSearchBar() {
  return Container(
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(10),
    ), // Added closing parenthesis for BoxDecoration
    child: TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search',
        border: InputBorder.none,
        prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
      ),
    ),
  );
}
  Widget _buildWorkoutCard(String title, String calories, String duration) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column( 
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(calories, style: const TextStyle(color: Color(0xFF01CF12))),
              ],
            ),
            Chip(
              label: Text(duration),
              backgroundColor: Color(0xFF0B2545).withOpacity(0.1),
            )
          ],
        ),
      ),
    );
  }



  Widget _buildPlanItem(String exercise, String goal, String progress) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(exercise, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(progress, style: const TextStyle(color: Color(0xFF01CF12))),
              ],
            ),
            const SizedBox(height: 10),
            Text(goal, style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: double.parse(progress.replaceAll('%', '')) / 100,
              backgroundColor: Colors.grey[200],
              color: const Color(0xFF01CF12),
            ),
            const SizedBox(height: 5),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF0B2545).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20)
                ),
                child: const Text('Beginner', 
                    style: TextStyle(color: Color(0xFF0B2545), fontSize: 12)),
              ),
            )
          ],
        ),
      ),
    );
  }
}