import 'package:flutter/material.dart';
import 'package:flutter_application_2/provider/subscription%20provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Header
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF0B2545).withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 1,
                  )
                ],
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xFF0B2545).withOpacity(0.05),
                child: Icon(Icons.person,
                    size: 50,
                    color: Color(0xFF0B2545)),
              ),
            ),
            SizedBox(height: 20),
            Text('Muhammad Ali',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0B2545))),
            SizedBox(height: 8),
            Text('m.ali@fitnessapp.com',
                style: TextStyle(color: Colors.grey[600])),
                
            // Stats Cards
            SizedBox(height: 30),
            Row(
              children: [
                _buildStatCard('10', 'Sessions'),
                SizedBox(width: 10),
                _buildStatCard('98%', 'Consistency'),
              ],
            ),
            
            // Subscription Card
            SizedBox(height: 20),
            _buildSubscriptionCard(),
            
            // Account Section
            SizedBox(height: 30),
            _buildSectionHeader('Account:'),
            _buildProfileItem(Icons.edit, 'Edit Profile'),
            _buildProfileItem(Icons.notifications, 'Notifications'),

            
            // Settings Section
            SizedBox(height: 20),
            _buildProfileItem(Icons.help_outline, 'Help & Support'),
            _buildProfileItem(Icons.privacy_tip_outlined, 'Privacy Policy'),
            
            // Logout Button
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0B2545),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Log Out',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Column(
            children: [
              Text(value,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF01CF12))),
              SizedBox(height: 5),
              Text(label,
                  style: TextStyle(
                      color: Colors.grey[600])),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildSubscriptionCard() {
  return Consumer<SubscriptionProvider>(
    builder: (context, provider, _){
       final subscription = provider.currentSubscription;
      return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Color(0xFF0B2545).withOpacity(0.1),
          width: 1,
        ),
      ),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Subscription',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0B2545))),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Color(0xFF01CF12).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    subscription?.type ?? 'No subscription',
                    style: TextStyle(
                      color: Color(0xFF01CF12),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSubscriptionDetail(
                  'Start Date',
                  subscription?.datedebut != null 
                    ? DateFormat('dd MMM yyyy').format(subscription!.datedebut) 
                    : 'N/A',
                  Icons.calendar_today_outlined,
                ),
                _buildSubscriptionDetail(
                  'End Date',
                  subscription?.datefin != null
                    ? DateFormat('dd MMM yyyy').format(subscription!.datefin) 
                    : 'N/A',
                  Icons.event_available,
                ),
              ],
            ),
          ],
        ),
      ),
      );
    }

  );
}





  Widget _buildSubscriptionDetail(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: Color(0xFF0B2545).withOpacity(0.7),
        ),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF0B2545),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Text(text,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B2545))),
          SizedBox(width: 10),
          Expanded(
            child: Divider(
              color: Color(0xFF0B2545).withOpacity(0.2),
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String text) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFF0B2545).withOpacity(0.05),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Color(0xFF0B2545)),
        ),
        title: Text(text,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF0B2545))),
        trailing: Icon(Icons.chevron_right,
            color: Colors.grey[500]),
      ),
    );
  }
}
  
