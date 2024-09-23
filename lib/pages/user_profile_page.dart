import 'package:flutter/material.dart';
import 'package:client_app/api/api_service.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Map<String, dynamic>? userProfile;
  bool isLoading = true;
  final APIService apiService = APIService(); // Instantiate APIService directly

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    userProfile = await apiService.getUserProfile(); // Call your function here
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Account'),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : userProfile != null
              ? SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Profile Image and Company Name Section
                        Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: userProfile!['profileImage'] !=
                                      null
                                  ? NetworkImage(userProfile!['profileImage'])
                                  : AssetImage('assets/images/novation.png')
                                      as ImageProvider, // Placeholder image
                            ),
                            SizedBox(height: 12),
                            Text(
                              userProfile!['companyName'],
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),

                        // Manager Full Name
                        _buildProfileDetailCard(
                          icon: Icons.person,
                          title: 'Manager Full Name',
                          value: userProfile!['fullName'],
                        ),

                        // Email
                        _buildProfileDetailCard(
                          icon: Icons.email,
                          title: 'Email',
                          value: userProfile!['email'],
                        ),

                        // Phone Number
                        _buildProfileDetailCard(
                          icon: Icons.phone,
                          title: 'Phone Number',
                          value: userProfile!['phoneNumber'],
                        ),

                        // Postal Address
                        _buildProfileDetailCard(
                          icon: Icons.location_on,
                          title: 'Postal Address',
                          value: userProfile!['postalAddress'],
                        ),
                      ],
                    ),
                  ),
                )
              : Center(child: Text('Failed to load profile')),
    );
  }

  // Helper function to build individual profile detail card
  Widget _buildProfileDetailCard(
      {required IconData icon, required String title, required String value}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.teal, size: 30),
        title: Text(
          title,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal),
        ),
        subtitle: Text(
          value,
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      ),
    );
  }
}
