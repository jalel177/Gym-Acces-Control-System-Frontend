import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/controllers/auth.controller.dart';
import 'package:flutter_application_2/controllers/sessioncontroller.dart';
import 'package:flutter_application_2/controllers/subscriptioncontroller.dart';
import 'package:flutter_application_2/details.dart';
import 'package:flutter_application_2/login.dart';
import 'package:flutter_application_2/model/sessionmodel.dart';
import 'package:flutter_application_2/model/subscriptionmodel.dart';
import 'package:flutter_application_2/model/usermodel.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Admin Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF01CF12),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF01CF12),
          primary: const Color(0xFF01CF12),
          secondary: const Color(0xFF0B2545),
          tertiary: const Color(0xFF01CF12),
        ),
        fontFamily: 'Poppins',
        cardTheme: CardTheme(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF01CF12),
        ),
      ),
      home: const AdminDashboard(),
    );
  }
}

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            'Admin Dashboard',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: const Color(0xFF01CF12), // Explicitly set to green
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.notifications_outlined, color: Colors.white),
              onPressed: () {},
            ),
     
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              color: const Color(0xFF01CF12), // Explicitly set to green
              child: TabBar(
                indicatorColor: Colors.white,
                indicatorWeight: 3,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                tabs: const [
                  Tab(icon: Icon(Icons.fitness_center), text: 'Sessions'),
                  Tab(icon: Icon(Icons.subscriptions), text: 'Subscriptions'),
                  Tab(icon: Icon(Icons.people), text: 'Users'),
                ],
              ),
            ),
          ),
        ),
        
        drawer: _buildDrawer(context),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.grey[50]!,
                Colors.grey[100]!,
              ],
            ),
          ),
          child: const TabBarView(
            children: [
              SessionsList(),
              SubscriptionsList(),
              UsersList(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF01CF12),
          onPressed: () {},
          elevation: 4,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
Future<Map<String, String?>> _getUserInfo() async {
  final prefs = await SharedPreferences.getInstance();
  return {
    'email': prefs.getString('email'),
    'username': prefs.getString('username'),
  };
}
  Widget _buildDrawer(BuildContext context) {
  return Drawer(
    child: FutureBuilder<Map<String, String?>>(
      future: _getUserInfo(),
      builder: (context, snapshot) {
        final userEmail = snapshot.data?['email'] ?? 'admin@fitnessapp.com';
        final userName = snapshot.data?['username'] ?? 'Admin User';

        return ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color(0xFF01CF12),
                image: const DecorationImage(
                  image: NetworkImage("https://source.unsplash.com/random/800x600/?fitness"),
                  fit: BoxFit.cover,
                  opacity: 0.2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, color: Colors.white, size: 30),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    userEmail,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          _buildDrawerItem(context, Icons.dashboard, 'Dashboard', true),
          _buildDrawerItem(context, Icons.settings, 'Settings', false),
          const Divider(),
          ListTile(
  leading: Icon(Icons.logout, color: Colors.grey[700]),
  title: Text(
    'Logout',
    style: TextStyle(
      color: Colors.grey[800],
      fontWeight: FontWeight.w500,
    ),
  ),
    onTap: () async {
    // 1) clear everything you saved at signin
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('username');
    await prefs.remove('email');
    // 2) navigate to your login screen and prevent back
    Navigator.of(context).pushReplacement(
  MaterialPageRoute(builder: (_) => Login())
);
  },
),
          
        ],
      );
      },
    )
    );
  }

  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, bool isActive) {
    return Container(
      color: isActive ? const Color(0xFF01CF12).withOpacity(0.1) : Colors.transparent,
      child: ListTile(
        leading: Icon(icon, color: isActive ? const Color(0xFF01CF12) : Colors.grey[700]),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? const Color(0xFF01CF12) : Colors.grey[800],
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        trailing: isActive 
            ? Container(
                width: 4,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF01CF12),
                  borderRadius: BorderRadius.circular(4),
                ),
              )
            : null,
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }


class SessionsList extends StatefulWidget {
  const SessionsList({super.key});
   @override
  State<SessionsList> createState() => _SessionsListState();
}

class _SessionsListState extends State<SessionsList> {
  late Future<List<Sessionmodel>> _sessionsFuture;
  final Sessioncontroller _sessionController = Sessioncontroller();
  
    @override
  void initState() {
    super.initState();
    _sessionsFuture = _sessionController.getallsessions();
  }

  @override
  Widget build(BuildContext context) {
      return FutureBuilder<List<Sessionmodel>>(
      future: _sessionsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: Color(0xFF01CF12)));
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error loading sessions', style: TextStyle(color: Colors.red)));
        }

        final sessions = snapshot.data ?? [];

        if (sessions.isEmpty) {
          return Center(child: Text('No sessions found', style: TextStyle(color: Color(0xFF0B2545))));
        }

        return RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _sessionsFuture = _sessionController.getallsessions();
            });
          },
            child: CustomScrollView(
    slivers: [
      // Header Section
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildHeader(context, 'Upcoming Sessions', 'View All'),
        ),
      ),
      
      // Sessions List
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _SessionCard(session: sessions[index], index:index,),
          ),
          childCount: sessions.length,
           ),
      ),
    ],
  ),
);
      }
      );
  }
}   
class _SessionCard extends StatelessWidget {
   final Sessionmodel session;
  const _SessionCard({required this.session, required this.index});
final int index;
  @override
  Widget build(BuildContext context) {
       return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Details(session:session,index:index),
          ),
        );
      },
      splashColor: Color(0xFF01CF12).withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
        child:Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF01CF12).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.fitness_center, color: Color(0xFF0B2545)),
        ),
        title: Text(session.sportname,  // Use model properties directly
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0B2545))),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Coach: ${session.entraineur}'),
            Text('Date: ${DateFormat('MMM dd, yyyy – HH:mm').format(session.date!)}'),
            Text('Duration: ${session.duration}'),
          ],
        ),
      ),
    ),
       );
  }
}
      



class SubscriptionsList extends StatefulWidget {
  const SubscriptionsList({super.key});

  @override
  State<SubscriptionsList> createState() => _SubscriptionsListState();
}

class _SubscriptionsListState extends State<SubscriptionsList> {
  late Future<List<Subscriptionmodel>> _subscriptionFuture;
  final Subscriptioncontroller _subscriptioncontroller = Subscriptioncontroller();

  @override
  void initState() {
    super.initState();
    _loadSubscriptions();
  }

  Future<void> _loadSubscriptions() async {
    _subscriptionFuture = _subscriptioncontroller.getallsubscriptions();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Subscriptionmodel>>(
      future: _subscriptionFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF01CF12)),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Error loading subscriptions',
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        final subscriptions = snapshot.data ?? [];

        if (subscriptions.isEmpty) {
          return const Center(
            child: Text(
              'No subscriptions found',
              style: TextStyle(color: Color(0xFF0B2545)),
            ),
          );
        }

        return RefreshIndicator(
          color: Color(0xFF01CF12),
          onRefresh: () async {
            setState(() {
              _loadSubscriptions();
            });
          },
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverToBoxAdapter(
                  child: _buildSectionHeader(
                    title: 'Active Subscriptions',
                    action: 'View All',
                    onActionPressed: () {
                      // Add your view all action here
                    },
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => SubscriptionCard(
                      subscription: subscriptions[index],
                      index: index,
                    ),
                    childCount: subscriptions.length,
                  ),
                ),
              ),
              // Add some padding at the bottom for better scrolling
              const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String action,
    VoidCallback? onActionPressed,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0B2545),
          ),
        ),
        TextButton(
          onPressed: onActionPressed,
          style: TextButton.styleFrom(
            foregroundColor: Color(0xFF01CF12),
          ),
          child: Text(action),
        ),
      ],
    );
  }
}

class SubscriptionCard extends StatelessWidget {
  final Subscriptionmodel subscription;
  final int index;

  const SubscriptionCard({
    Key? key,
    required this.subscription,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final daysRemaining = subscription.datefin.difference(DateTime.now()).inDays;
    final bool isExpiringSoon = daysRemaining <= 7 && daysRemaining > 0;
    final bool isExpired = daysRemaining <= 0;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Leading icon in a container
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF01CF12).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.subscriptions,
                color: Color(0xFF0B2545),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subscription.type,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0B2545),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.calendar_today,
                    'Start: ${DateFormat('MMM dd, yyyy').format(subscription.datedebut)}',
                  ),
                  const SizedBox(height: 4),
                  _buildInfoRow(
                    Icons.event,
                    'End: ${DateFormat('MMM dd, yyyy').format(subscription.datefin)}',
                  ),
                  const SizedBox(height: 8),
                  _buildDaysRemainingIndicator(daysRemaining, isExpiringSoon, isExpired),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: Color(0xFF0B2545).withOpacity(0.6),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: Color(0xFF0B2545).withOpacity(0.8),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildDaysRemainingIndicator(int days, bool isExpiringSoon, bool isExpired) {
    Color textColor = Color(0xFF01CF12);
    String text = '$days days left';
    
    if (isExpired) {
      textColor = Colors.red;
      text = 'Expired';
    } else if (isExpiringSoon) {
      textColor = Colors.orange;
      text = '$days days left - Expiring soon';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: textColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
class UsersList extends StatefulWidget {
  const UsersList({super.key});

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  late Future<List<Usermodel>> _usersFuture;
  final AuthController _userController = AuthController();

  @override
  void initState() {
    super.initState();
    _usersFuture = _userController.getallusers();
  }

  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          TextButton(
            onPressed: () {},
            child: const Text('View All', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Usermodel>>(
      future: _usersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.green));
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error loading users', style: TextStyle(color: Colors.red)));
        }

        final users = snapshot.data ?? [];

        return Column(
          children: [
            _buildHeader('Registered Users'),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => setState(() => _usersFuture = _userController.getallusers()),
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) => UserItem(
                    user: users[index],
                    onDelete: () async {
                      final userId = users[index].userid;
                      if (userId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Cannot delete - User ID missing'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const Center(child: CircularProgressIndicator()),
                      );

                      try {
                        final success = await _userController.deleteuser(userId);
                        Navigator.pop(context);

                        if (success) {
                          setState(() {
                            _usersFuture = _usersFuture.then((list) {
      // remove the just‑deleted user
      return list.where((u) => u.userid != userId).toList();
    });
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('User deleted successfully'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Delete failed'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } catch (e) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: ${e.toString()}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class UserItem extends StatefulWidget {
  final Usermodel user;
  final VoidCallback onDelete;

  const UserItem({
    super.key,
    required this.user,
    required this.onDelete,
  });

  @override
  State<UserItem> createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  bool _showDelete = false;

  Widget _buildStatusIndicator() {
    final isActive = Random().nextBool();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? Colors.green[100] : Colors.orange[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: TextStyle(color: isActive ? Colors.green : Colors.orange),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_showDelete) {
          setState(() => _showDelete = false);
        }
      },
      child: Stack(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green[100],
              child: Text(
                widget.user.displayName.characters.first.toUpperCase(),
              ),
            ),
            title: Text(
              widget.user.displayName, 
              style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(widget.user.email ?? 'no email'),
            trailing: _buildStatusIndicator(),
            onLongPress: () => setState(() => _showDelete = true),
          ),
          if (_showDelete) ...[
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(color: Colors.black.withOpacity(0.2)),),
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      widget.onDelete();
                      setState(() => _showDelete = false);
                    },
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
  Widget _buildStatusIndicator() {
    final isActive = Random().nextBool();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? Colors.green[100] : Colors.orange[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive', 
        style: TextStyle(color: isActive ? Colors.green : Colors.orange)
      ),
    );
  }


Widget _buildHeader(BuildContext context, String title, String actionText) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0B2545),
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            actionText,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}