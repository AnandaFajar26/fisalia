import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  final supabase = Supabase.instance.client;
  String? fullName;
  String? email;
  String? avatarUrl;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      final res =
          await supabase.from('profiles').select().eq('id', user.id).single();

      setState(() {
        fullName = res['full_name'];
        email = user.email;
        avatarUrl = res['profile_url'];
      });
    }
  }

  Future<void> pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final fileName = '${supabase.auth.currentUser!.id}.png';

      final storageResponse = await supabase.storage
          .from('avatars')
          .upload(fileName, file, fileOptions: const FileOptions(upsert: true));

      final publicURL = supabase.storage.from('avatars').getPublicUrl(fileName);

      await supabase
          .from('profiles')
          .update({'profile_url': publicURL})
          .eq('id', supabase.auth.currentUser!.id);
      setState(() => avatarUrl = publicURL);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profil Saya")),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                avatarUrl != null
                                    ? NetworkImage(avatarUrl!)
                                    : const AssetImage('assets/avatar.png')
                                        as ImageProvider,
                          ),
                          GestureDetector(
                            onTap: pickAndUploadImage,
                            child: const CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.edit,
                                size: 18,
                                color: Colors.indigo,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      initialValue: fullName ?? '',
                      decoration: const InputDecoration(labelText: 'Full Name'),
                      readOnly: true,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      initialValue: email ?? '',
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                      ),
                      readOnly: true,
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "Business Address Details",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Pincode'),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Address'),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'City'),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'State'),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Country'),
                    ),
                  ],
                ),
              ),
    );
  }
}
