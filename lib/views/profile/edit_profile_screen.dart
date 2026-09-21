import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  bool isLoading = true;
  bool isSaving = false;

  User? get user => FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    if (user == null) return;

    final document = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    nameController.text =
        document.data()?['name'] as String? ??
        user!.displayName ??
        '';

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  Future<void> saveProfile() async {
    if (!formKey.currentState!.validate() || user == null) {
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      final name = nameController.text.trim();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        'name': name,
      });

      await user!.updateDisplayName(name);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
        ),
      );

      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Update failed: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Form(
                  key: formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      const CircleAvatar(
                        radius: 45,
                        child: Icon(
                          Icons.person,
                          size: 50,
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return 'Enter your name';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: user?.email ?? '',
                        enabled: false,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ),
                      const SizedBox(height: 25),
                      ElevatedButton(
                        onPressed: isSaving ? null : saveProfile,
                        child: isSaving
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Save Changes'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}