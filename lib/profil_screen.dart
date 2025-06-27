import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'admin_login.dart';

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
  bool isLoading = true; // Diubah jadi true agar loading saat pertama kali buka

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  /// Memuat data profil pengguna dari database Supabase
  Future<void> loadUserProfile() async {
    // try-catch ditambahkan untuk menangani error koneksi atau lainnya
    try {
      final user = supabase.auth.currentUser;
      if (user != null) {
        final res =
            await supabase.from('profiles').select().eq('id', user.id).single();

        // Memperbarui state dengan data yang didapat
        if (mounted) {
          setState(() {
            fullName = res['full_name'];
            email = user.email;
            avatarUrl = res['profile_url'];
          });
        }
      }
    } catch (e) {
      // Menampilkan pesan error jika gagal memuat profil
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal memuat profil: $e')));
      }
    } finally {
      // Selalu hentikan loading indicator setelah selesai, baik berhasil maupun gagal
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  /// Memilih gambar dari galeri dan mengunggahnya (kompatibel untuk mobile & web)
  Future<void> pickAndUploadImage() async {
    // Menampilkan loading indicator saat proses dimulai
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
        // 1. Baca data gambar sebagai bytes (aman untuk semua platform)
        final fileBytes = await pickedFile.readAsBytes();

        // 2. Buat nama file yang unik untuk menghindari penimpaan file lain
        final fileName =
            '${supabase.auth.currentUser!.id}_${DateTime.now().millisecondsSinceEpoch}.png';

        // 3. Gunakan .uploadBinary() agar kompatibel dengan Web dan Mobile
        await supabase.storage
            .from('avatars')
            .uploadBinary(
              fileName,
              fileBytes,
              fileOptions: const FileOptions(
                upsert: false, // false agar tidak menimpa jika nama file sama
                contentType: 'image/png',
              ),
            );

        // 4. Dapatkan URL publik dari gambar yang baru diunggah
        final publicURL = supabase.storage
            .from('avatars')
            .getPublicUrl(fileName);

        // 5. Perbarui URL di database profil pengguna
        await supabase
            .from('profiles')
            .update({'profile_url': publicURL})
            .eq('id', supabase.auth.currentUser!.id);

        // 6. Perbarui tampilan avatar di UI
        if (mounted) {
          setState(() {
            avatarUrl = publicURL;
          });
        }
      }
    } catch (e) {
      // Menampilkan pesan error jika terjadi kegagalan
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal mengunggah gambar: $e')));
      }
    } finally {
      // Selalu hentikan loading indicator setelah selesai
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
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
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start, // Agar teks "Business Address" rata kiri
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

                    // FITUR YANG SUDAH ADA TETAP DIPERTAHANKAN
                    const Text(
                      "Business Address Details",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
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
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Get.to(() => AdminLoginScreen());
                      },
                      child: const Text("LOGIN ANDMIN"),
                    ),
                  ],
                ),
              ),
    );
  }
}
