import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

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
  String? userRole; // Variabel baru untuk menyimpan role pengguna
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  /// Memuat data profil pengguna dari database Supabase, termasuk role
  Future<void> loadUserProfile() async {
    try {
      final user = supabase.auth.currentUser;
      if (user != null) {
        // Mengambil semua kolom, termasuk 'role'
        final res =
            await supabase.from('profiles').select().eq('id', user.id).single();

        setState(() {
          fullName = res['full_name'];
          email = user.email;
          avatarUrl = res['profile_url'];
          userRole = res['role']; // Menyimpan role dari database
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal memuat profil: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  /// Memilih gambar dari galeri dan mengunggahnya ke Supabase Storage
  Future<void> pickAndUploadImage() async {
    setState(() {
      isLoading = true;
    });

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        final fileBytes = await pickedFile.readAsBytes();
        final fileName =
            '${supabase.auth.currentUser!.id}_${DateTime.now().millisecondsSinceEpoch}.png';

        await supabase.storage
            .from('avatars')
            .uploadBinary(
              fileName,
              fileBytes,
              fileOptions: const FileOptions(
                upsert: false,
                contentType: 'image/png',
              ),
            );

        final publicURL = supabase.storage
            .from('avatars')
            .getPublicUrl(fileName);

        await supabase
            .from('profiles')
            .update({'profile_url': publicURL})
            .eq('id', supabase.auth.currentUser!.id);

        setState(() {
          avatarUrl = publicURL;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal mengunggah gambar: $e')));
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// Fungsi untuk logout pengguna
  Future<void> _signOut() async {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      // Menangani error jika logout gagal
    } finally {
      // Kembali ke halaman login dan hapus semua halaman sebelumnya
      if (mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/login', (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Saya"),
        actions: [
          // Tombol Logout di AppBar
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
            tooltip: 'Logout',
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                avatarUrl != null && avatarUrl!.isNotEmpty
                                    ? NetworkImage(avatarUrl!)
                                    : const AssetImage('assets/avatar.png')
                                        as ImageProvider,
                            backgroundColor: Colors.grey[200],
                          ),
                          GestureDetector(
                            onTap: pickAndUploadImage,
                            child: const CircleAvatar(
                              radius: 15,
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
                      initialValue: fullName ?? 'Nama tidak tersedia',
                      decoration: const InputDecoration(labelText: 'Full Name'),
                      readOnly: true,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      initialValue: email ?? 'Email tidak tersedia',
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                      ),
                      readOnly: true,
                    ),
                    const SizedBox(height: 30),

                    // === TOMBOL BARU DITAMBAHKAN DI SINI ===

                    // 1. Tombol Edit Profil (selalu muncul)
                    ElevatedButton.icon(
                      icon: const Icon(Icons.person_outline),
                      label: const Text('Edit Profil'),
                      onPressed: () {
                        // TODO: Navigasi ke halaman untuk mengedit profil
                        // Contoh: Navigator.pushNamed(context, '/edit_profile');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Halaman Edit Profil belum dibuat!'),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),

                    // 2. Tombol Panel Admin (hanya muncul jika role adalah 'admin')
                    if (userRole == 'admin')
                      ElevatedButton.icon(
                        icon: const Icon(Icons.admin_panel_settings_outlined),
                        label: const Text('Masuk ke Panel Admin'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.teal, // Warna berbeda untuk admin
                        ),
                        onPressed: () {
                          // TODO: Navigasi ke halaman dashboard admin
                          // Contoh: Navigator.pushNamed(context, '/admin_dashboard');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Halaman Panel Admin belum dibuat!',
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
    );
  }
}
