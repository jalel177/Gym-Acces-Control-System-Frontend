
import 'package:flutter/material.dart';
import 'package:flutter_application_2/controllers/sessioncontroller.dart';
import 'package:flutter_application_2/model/sessionmodel.dart';
import 'package:flutter_application_2/provider/sessionprovider.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Details extends StatefulWidget {
  final int index;
  final Sessionmodel session;


  const Details({super.key,  required this.index, required this.session,});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  final TextEditingController _commentController = TextEditingController();
  final List<String> _comments = [];
  final TextEditingController _editTitleController = TextEditingController();
    final TextEditingController _editCoachController = TextEditingController();
  final TextEditingController _editDateController = TextEditingController();
  final TextEditingController _editDurationController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final Sessioncontroller _sessioncontroller = Get.put(Sessioncontroller());

  @override
  void initState() {
    super.initState();
      final session = Provider.of<SessionProvider>(context, listen: false)
        .sessions[widget.index];
    _editTitleController.text = session.sportname;
     _editCoachController.text =session.entraineur!;
    _editDateController.text =session.date != null 
        ? DateFormat('MMM dd, yyyy - hh:mm a').format(session.date!)
        : '';
    _editDurationController.text = session.duration ?? '';
  }

  @override
  void dispose() {
    _commentController.dispose();
    _editTitleController.dispose();
    _editCoachController.dispose;
    _editDateController.dispose();
    _editDurationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addComment() {
    if (_commentController.text.isNotEmpty) {
      setState(() {
        _comments.add(_commentController.text);
        _commentController.clear();
      });
      // Scroll to the bottom after adding a comment
      Future.delayed(Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
  final currentSession = Provider.of<SessionProvider>(context)
        .sessions[widget.index];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF0B2545)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Details',
          style: TextStyle(
            color: const Color(0xFF0B2545),
            fontWeight: FontWeight.w600,
            fontSize: 36,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Color(0xFF0B2545)),
            onPressed: () => _showEditDialog(context),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.red[400]),
            onPressed: () => _deleteSession(context),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey[50]!, Colors.grey[100]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSessionCard(currentSession),
                      const SizedBox(height: 24),
                      Text(
                        'Comments',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0B2545),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _comments.isEmpty
                          ? _buildEmptyCommentsPlaceholder()
                          : _buildCommentsList(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: _buildCommentInput(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSessionCard(Sessionmodel session) {
    return Card(
      elevation: 3,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFF01CF12).withOpacity(0.85),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                session.sportname ?? 'Unnamed Session',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 20),
              _buildInfoRow(Icons.person_outline, session.entraineur ?? 'Unknown Coach'),
              const SizedBox(height: 16),
              _buildInfoRow(
                Icons.calendar_today,
                session.date != null
                    ? DateFormat('MMM dd, yyyy - hh:mm a').format(session.date!)
                    : 'No date set',
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.timer_outlined, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      session.duration ?? 'No duration',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.9), size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyCommentsPlaceholder() {
    return SizedBox(
      height: 150,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No comments yet',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add a comment to get started',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentsList() {
    return ListView.builder(
      controller: _scrollController,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _comments.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Card(
          elevation: 1,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: const Color(0xFF01CF12).withOpacity(0.1),
                      child: const Icon(
                        Icons.person,
                        size: 18,
                        color: Color(0xFF01CF12),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'You',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0B2545),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Just now',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _comments[index],
                  style: TextStyle(
                    color: const Color(0xFF0B2545).withOpacity(0.8),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCommentInput() {
    return Card(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: TextField(
          controller: _commentController,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: 'Add a comment...',
            hintStyle: TextStyle(color: Colors.grey[500]),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.send_rounded,
                color: Color(0xFF01CF12),
              ),
              onPressed: _addComment,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          onSubmitted: (_) => _addComment(),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Edit Session',
          style: TextStyle(
            color: Color(0xFF0B2545),
            fontWeight: FontWeight.bold,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildEditTextField(
                controller: _editTitleController,
                label: 'Session Title',
                icon: Icons.sports,
              ),
              const SizedBox(height: 16),
              _buildEditTextField(
                controller: _editCoachController,
                label: 'Coach',
                icon: Icons.person,
              ),
              const SizedBox(height: 16),
              _buildEditTextField(
                controller: _editDateController,
                label: 'Date & Time',
                icon: Icons.calendar_today,
                hint: 'MMM dd, yyyy - hh:mm a',
              ),
              const SizedBox(height: 16),
              _buildEditTextField(
                controller: _editDurationController,
                label: 'Duration',
                icon: Icons.timer_outlined,
                hint: 'e.g. 60 minutes',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF01CF12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            onPressed: () async {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              );

              try {
                final parsedDate = DateFormat('MMM dd, yyyy - hh:mm a')
                    .parse(_editDateController.text);

                final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
                final currentSession = sessionProvider.sessions[widget.index];

                final updatedSession = Sessionmodel(
                  coursid: currentSession.coursid,
                  sportname: _editTitleController.text,
                  entraineur: _editCoachController.text,
                  date: parsedDate,
                  duration: _editDurationController.text,
                );

                final success = await _sessioncontroller.updateSession(
                  updatedSession.toJson(),
                  updatedSession.coursid!,
                );

                if (success) {
                  sessionProvider.updateSession(widget.index, updatedSession);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Session updated successfully'),
                      backgroundColor: Colors.green,
                    )
                  );
                } else {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Server rejected update'),
                      backgroundColor: Colors.orange,
                    )
                  );
                }
              } on FormatException catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Invalid date: ${e.message}'),
                    backgroundColor: Colors.red,
                  )
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Update failed: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  )
                );
              }
            },
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildEditTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Color(0xFF01CF12)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFF01CF12), width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
    );
  }

  void _deleteSession(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Session',
          style: TextStyle(
            color: Color(0xFF0B2545),
            fontWeight: FontWeight.bold,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Text(
          'Are you sure you want to delete this session? This action cannot be undone.',
          style: TextStyle(
            color: Colors.grey[800],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            onPressed: () async {
   try {
                final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
                final currentSession = sessionProvider.sessions[widget.index];
                final courseid = currentSession.coursid;

                if (courseid == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('❌ Cannot delete - Session ID missing'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 3),
                    )
                  );
                  return;
                }

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );

                final success = await _sessioncontroller.deletesession(courseid);
                Navigator.of(context).pop();

                if (success) {
                  sessionProvider.deleteSession(widget.index);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ Session deleted successfully'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    )
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('⚠️ Failed to delete session'),
                      backgroundColor: Colors.orange,
                      duration: Duration(seconds: 3),
                    )
                  );
                }
              } catch (e) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('🔥 Critical error: ${e.toString()}'),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 5),
                  )
                );
              }
            },
   
       child: Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}