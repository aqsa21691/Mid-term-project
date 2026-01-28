import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'login_page.dart';
import 'home_page.dart';
import 'gallery_page.dart';
import 'gallery_picker_page.dart';
import 'map_page.dart';

class CameraPage extends StatefulWidget {
  final String fullName;
  final String email;

  const CameraPage({super.key, required this.fullName, required this.email});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File? _image;

  Future<void> _takePhoto() async {
    var status = await Permission.camera.status;

    if (status.isDenied || status.isRestricted) {
      status = await Permission.camera.request();
    }

    if (status.isGranted) {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
      );
      if (pickedFile != null) {
        setState(() => _image = File(pickedFile.path));
      }
    } else if (status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Camera permission permanently denied. Enable from settings.",
          ),
          backgroundColor: Colors.red,
        ),
      );
      await openAppSettings();
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
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      HomePage(fullName: widget.fullName, email: widget.email),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Gallery"),
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => GalleryPage(
                    fullName: widget.fullName,
                    email: widget.email,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xff0a1a3d)),
              title: const Text(
                "Camera",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              tileColor: Colors.grey.shade200,
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text("Picker"),
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => GalleryPickerPage(
                    fullName: widget.fullName,
                    email: widget.email,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text("Map"),
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      MapPage(fullName: widget.fullName, email: widget.email),
                ),
              ),
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

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _image!,
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Column(
                      children: const [
                        Icon(
                          Icons.camera_alt,
                          size: 100,
                          color: Color.fromARGB(255, 1, 10, 56),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "No photo captured yet",
                          style: TextStyle(
                            color: Color.fromARGB(255, 5, 8, 80),
                          ),
                        ),
                      ],
                    ),
              const SizedBox(height: 28),
              ElevatedButton.icon(
                onPressed: _takePhoto,
                icon: const Icon(Icons.camera_alt),
                label: const Text("Capture Photo"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0a1a3d),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
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
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    GalleryPage(fullName: widget.fullName, email: widget.email),
              ),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => GalleryPickerPage(
                  fullName: widget.fullName,
                  email: widget.email,
                ),
              ),
            );
          } else if (index == 4) {
            Navigator.pushReplacement(
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
