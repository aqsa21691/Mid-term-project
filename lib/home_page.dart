import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'login_page.dart';
import 'gallery_page.dart';
import 'camera_page.dart';
import 'map_page.dart';
import 'gallery_picker_page.dart';

class HomePage extends StatefulWidget {
  final String fullName;
  final String email;

  const HomePage({super.key, required this.fullName, required this.email});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _users = []; // saves user data who've just loged in
  bool _isLoading = true; // data is loading

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() => _isLoading = true);
    try {
      final uri = Uri.parse(
        'https://devntec.com/E10_API/get_users.php?email=${widget.email}',
      );
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        //correct output
        final resBody = jsonDecode(response.body);
        if (resBody['status'] == 'success') {
          setState(() => _users = resBody['users'] ?? []);
        }
      }
    } catch (e) {
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffaf7f8),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'E10_AQSA',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Color(0xff0a1a3d),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xff0a1a3d)),
            onPressed: _logout,
          ),
        ],
      ),

      //drawer
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(widget.fullName),
              accountEmail: Text(widget.email),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Color(0xff0a1a3d)),
              ),
              decoration: const BoxDecoration(color: Color(0xff0a1a3d)),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Color(0xff0a1a3d)),
              title: const Text(
                "Home",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              tileColor: Colors.grey.shade200,
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Gallery"),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GalleryPage(
                      fullName: widget.fullName,
                      email: widget.email,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Camera"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CameraPage(
                      fullName: widget.fullName,
                      email: widget.email,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text("Picker"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GalleryPickerPage(
                      fullName: widget.fullName,
                      email: widget.email,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text("Map"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        MapPage(fullName: widget.fullName, email: widget.email),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Signout", style: TextStyle(color: Colors.red)),
              onTap: _logout,
            ),
          ],
        ),
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchUsers,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome, ${widget.fullName}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text('Email: ${widget.email}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'All Users',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0a1a3d),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ..._users.map(
                    (u) => Card(
                      elevation: 1,
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xff0a1a3d),
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text(u['full_name']),
                        subtitle: Text(u['email']),
                      ),
                    ),
                  ),
                ],
              ),
            ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: const Color(0xff0a1a3d),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    GalleryPage(fullName: widget.fullName, email: widget.email),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    CameraPage(fullName: widget.fullName, email: widget.email),
              ),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => GalleryPickerPage(
                  fullName: widget.fullName,
                  email: widget.email,
                ),
              ),
            );
          } else if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    MapPage(fullName: widget.fullName, email: widget.email),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library),
            label: 'Gallery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Camera',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.image), label: 'Picker'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
        ],
      ),
    );
  }
}
