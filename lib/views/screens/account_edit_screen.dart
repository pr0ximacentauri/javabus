import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:javabus/viewmodels/auth_view_model.dart';
import 'package:javabus/services/cloudinary_service.dart';
import 'package:provider/provider.dart';

class AccountEditScreen extends StatefulWidget {
  const AccountEditScreen({super.key});

  @override
  State<AccountEditScreen> createState() => _AccountEditScreenState();
}

class _AccountEditScreenState extends State<AccountEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _usernameController;
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  final TextEditingController _newPasswordController = TextEditingController();

  File? _selectedImage;
  String? _imageUrl;
  bool _isUploadingImage = false;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthViewModel>(context, listen: false).user!;
    _usernameController = TextEditingController(text: user.username);
    _fullNameController = TextEditingController(text: user.fullName);
    _emailController = TextEditingController(text: user.email);
    _imageUrl = user.imageUrl;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
      await _uploadImage(_selectedImage!);
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    setState(() => _isUploadingImage = true);
    final url = await CloudinaryService.uploadImage(imageFile);
    setState(() {
      _isUploadingImage = false;
      _imageUrl = url;
    });

    if (_imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengunggah gambar'), backgroundColor: Colors.orange.shade600),
      );
    }
  }

  Future<void> _saveProfile() async {
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    if (!_formKey.currentState!.validate()) return;

    final success = await authVM.updateProfile(
      username: _usernameController.text.trim(),
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      newPassword: _newPasswordController.text.isNotEmpty
          ? _newPasswordController.text.trim()
          : null,
      imageUrl: _imageUrl,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Akun berhasil diperbarui'), backgroundColor: Colors.orange.shade600),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui akun'), backgroundColor: Colors.orange.shade600),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);

    return PopScope(
      canPop: !_isUploadingImage,
      // ignore: deprecated_member_use
      onPopInvoked: (didPop) {
        if (!didPop && _isUploadingImage) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tunggu hingga gambar selesai diunggah'),
              backgroundColor: Colors.orange.shade600,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Edit Akun')),
        body: authVM.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      if (_isUploadingImage)
                        const CircularProgressIndicator()
                      else
                        GestureDetector(
                          onTap: () => _showImagePickerOptions(),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: _selectedImage != null
                                ? FileImage(_selectedImage!)
                                : (_imageUrl != null
                                    ? NetworkImage(_imageUrl!) as ImageProvider
                                    : const NetworkImage("https://cdn-icons-png.flaticon.com/512/5987/5987424.png")),
                          ),
                        ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(labelText: 'Username'),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Wajib diisi' : null,
                      ),
                      TextFormField(
                        controller: _fullNameController,
                        decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Wajib diisi' : null,
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Wajib diisi' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _newPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password Baru (opsional)',
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: _isUploadingImage ? null : _saveProfile,
                        child: _isUploadingImage ? const Text('Uploading...') : const Text('Simpan Perubahan'),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );

  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Kamera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Galeri'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }
}
