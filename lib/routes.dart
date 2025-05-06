import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/routes/Chat.dart';
import 'package:flutter_application_2/routes/home.dart';
import 'package:flutter_application_2/routes/profile.dart';
import 'package:flutter_application_2/routes/session.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Routes extends StatefulWidget {
  const Routes({super.key, required token});
  

  @override
  State<Routes> createState() => _RoutesState();
}
 


class _RoutesState extends State<Routes> {
    late String? token;
    final _bottomNavigationKey = GlobalKey<CurvedNavigationBarState>();
    final int _completedSessions = 12; 
    
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _initializeScreens();
  }

  Future<void> _initializeScreens() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      // Update screens with actual token
      _screens = [
        Home(token: token),
        Chat(),
        Session(),
        Profile(),
      ];
    });
  }

    final List<String> _titles = ["Home", "Chat", "Sessions", "Profile"];
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Color(0xFF0B2545)),
       title: Text(_titles[_selectedIndex],
         style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B2545),) // Drawer icon color
    ),
    centerTitle:true,
       ),
       drawer: Drawer(
        
        width: MediaQuery.of(context).size.width * 0.6,
        backgroundColor:  Color.fromARGB(255, 8, 26, 49),
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                "Muhammad Ali",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color:  Colors.white,
                ),
              ),
              accountEmail: Text(
                "m.ali@fitnessapp.com",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  color: Color(0xFF0B2545),
                  size: 36,
                ),
              ),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 8, 26, 49),
              ),
            ),
            ListTile(
              leading: Icon(Icons.check_circle, color: Color(0xFF01CF12)),
              title: Text('Completed Sessions',
                    style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,)),
              subtitle: Text(
                '$_completedSessions sessions',
                style: TextStyle(
                  color:  Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
           
            ListTile(
              leading: Icon(Icons.help_outline, color:  Colors.white,),
              title: Text('FAQ',
                    style: TextStyle(
                  color:  Colors.white,
                  fontWeight: FontWeight.bold,)),
              onTap: () {
               
                // Add FAQ screen navigation
              },
            ),
           
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text(
                'Log Out',
                style: TextStyle(color: Colors.red,
                fontWeight:FontWeight.bold)
              ),
              onTap: () {
                // Add logout logic
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),

   
      body:_screens[_selectedIndex],
       bottomNavigationBar: CurvedNavigationBar(
        
        key: _bottomNavigationKey,
        items: const [
          CurvedNavigationBarItem(
            child: Icon(Icons.home_outlined),
            label: 'Home',
          ),
         
          CurvedNavigationBarItem(
            child: Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.newspaper),
            label: 'Sessions',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.perm_identity),
            label: 'Profile',
          ),
           CurvedNavigationBarItem(
            child: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor:  Color(0xFF01CF12),
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: _onItemTapped,
        index: _selectedIndex,
       
  
       ),
    );  
    
  }
}