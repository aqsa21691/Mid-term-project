import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login_page.dart';
import 'home_page.dart';
import 'camera_page.dart';
import 'map_page.dart';
import 'gallery_picker_page.dart';

class GalleryPage extends StatefulWidget {
  final String fullName;
  final String email;

  const GalleryPage({super.key, required this.fullName, required this.email});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  List<String> onlineImages = [];
  bool isLoading = true;

  Future<void> fetchImages() async {
    const apiKey = 'P2mfN5mjpWT0Eh4XJYHrd5nJyCBJmeI9iSDql4dSpFWVvvJIQ1wRxw2u';
    const url = 'https://api.pexels.com/v1/search?query=quran&per_page=3';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': apiKey},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List photos = data['photos'];

        setState(() {
          onlineImages = photos
              .map((photo) => photo['src']['medium'].toString())
              .toList();
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> localImages = [
      'assets/images/pic1.png',
      'assets/images/pic2.png',
      'assets/images/pic3.png',
    ];

    return Scaffold(
      backgroundColor: const Color(0xfffaf7f8),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'E10_AQSA',
          style: TextStyle(
            color: Color(0xff0a1a3d),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xff0a1a3d)),
            onPressed: _logout,
          ),
        ],
      ),

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
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HomePage(
                      fullName: widget.fullName,
                      email: widget.email,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: Color(0xff0a1a3d),
              ),
              title: const Text(
                "Gallery",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              tileColor: Colors.grey.shade200,
              onTap: () => Navigator.pop(context),
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

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome, ${widget.fullName}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text("Email: ${widget.email}"),
            const SizedBox(height: 20),

            const Text(
              'Online Images (Quran)',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff0a1a3d),
              ),
            ),
            const SizedBox(height: 10),

            isLoading
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: onlineImages.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                    itemBuilder: (_, index) => ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        onlineImages[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

            const SizedBox(height: 25),

            const Text(
              'Local Images',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff0a1a3d),
              ),
            ),
            const SizedBox(height: 10),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: localImages.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (_, index) => ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(localImages[index], fit: BoxFit.cover),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: const Color(0xff0a1a3d),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    HomePage(fullName: widget.fullName, email: widget.email),
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
