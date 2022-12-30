import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:path/path.dart';
import 'package:pendaftaran_siswa_smktag/api/firebase_api.dart';
import 'package:pendaftaran_siswa_smktag/services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UploadTask? task;
  File? file;
  PlatformFile? pickedFile;
  String? urlDownload =
      "https://i0.wp.com/norrismgmt.com/wp-content/uploads/2020/05/24-248253_user-profile-default-image-png-clipart-png-download.png?ssl=1";

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : "No file selected";

    return Scaffold(
      body: Center(
          child: Column(
        children: [
          Text(
            FirebaseAuth.instance.currentUser!.displayName != null
                ? FirebaseAuth.instance.currentUser!.displayName!
                : "",
            style: TextStyle(fontSize: 20),
          ),
          Text(
            FirebaseAuth.instance.currentUser!.email! != null
                ? FirebaseAuth.instance.currentUser!.email!
                : "",
            style: TextStyle(fontSize: 20),
          ),
          GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.red.shade400,
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(20)),
              width: 140,
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "LOGOUT",
                    style: TextStyle(fontSize: 14),
                  )
                ],
              ),
            ),
            onTap: () {
              AuthService().signOut();
            },
          )
        ],
      )),
    );
  }
}
