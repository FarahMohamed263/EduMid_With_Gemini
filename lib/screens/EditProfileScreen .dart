import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with TickerProviderStateMixin {
  final _fullNameController = TextEditingController(text: 'Alex Morgan');
  final _usernameController = TextEditingController(text: 'alexm_ai');
  final _emailController = TextEditingController(
    text: 'alex.morgan@edumind.ai',
  );
  final _phoneController = TextEditingController(text: '+1 (555) 123-4567');
  final _aboutController = TextEditingController(
    text:
        'AI enthusiast and lifelong learner exploring the future of education.',
  );
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _defaultImageUrl =
      'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde';
  final _imagePicker = ImagePicker();

  bool _showPasswordFields = false;
  bool _isSaving = false;
  String? _pickedImagePath;

  late final AnimationController _particleController;

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _particleController.dispose();
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _aboutController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _goBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _saveChanges() async {
    setState(() => _isSaving = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (!mounted || image == null) return;

    setState(() {
      _pickedImagePath = image.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0B0F2A), Color(0xFF050816)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          const Particles(),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBackButton(),
                  const SizedBox(height: 10),
                  const Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Manage your personal information',
                    style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                  ),
                  const SizedBox(height: 28),
                  Center(child: _buildProfileImage()),
                  const SizedBox(height: 22),
                  _buildFormCard(),
                  const SizedBox(height: 20),
                  _buildButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: _goBack,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.06),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    final ImageProvider imageProvider = _pickedImagePath == null
        ? NetworkImage(_defaultImageUrl)
        : FileImage(File(_pickedImagePath!));

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 142,
          height: 142,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3B82F6).withOpacity(0.55),
                blurRadius: 28,
                spreadRadius: 5,
              ),
            ],
          ),
        ),
        CircleAvatar(
          key: ValueKey(_pickedImagePath ?? _defaultImageUrl),
          radius: 60,
          backgroundColor: const Color(0xFF1F2937),
          backgroundImage: imageProvider,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: PopupMenuButton<String>(
            tooltip: 'Change profile photo',
            color: const Color(0xFF111827),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.white.withOpacity(0.08)),
            ),
            offset: const Offset(0, 44),
            onSelected: (value) {
              if (value == 'Upload') {
                _pickImageFromGallery();
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem<String>(
                value: 'Upload',
                child: Row(
                  children: [
                    Icon(Icons.upload, color: Color(0xFF4DA3FF), size: 18),
                    SizedBox(width: 10),
                    Text('Upload', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
            child: Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF2563EB),
              ),
              child: const Icon(
                Icons.camera_alt,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
      decoration: BoxDecoration(
        color: const Color(0xFF111827).withOpacity(0.85),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _field(
            label: 'Full Name',
            icon: Icons.person_outline,
            controller: _fullNameController,
          ),
          const SizedBox(height: 14),
          _field(
            label: 'Username',
            icon: Icons.alternate_email,
            controller: _usernameController,
          ),
          const SizedBox(height: 14),
          _field(
            label: 'Email Address',
            icon: Icons.email_outlined,
            controller: _emailController,
          ),
          const SizedBox(height: 14),
          _field(
            label: 'Phone Number',
            icon: Icons.phone_outlined,
            controller: _phoneController,
          ),
          const SizedBox(height: 14),
          _passwordSection(),
          const SizedBox(height: 14),
          _field(
            label: 'About Me',
            icon: Icons.info_outline,
            controller: _aboutController,
            maxLines: 3,
            alignTop: true,
          ),
        ],
      ),
    );
  }

  Widget _passwordSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () =>
              setState(() => _showPasswordFields = !_showPasswordFields),
          borderRadius: BorderRadius.circular(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Change Password',
                style: TextStyle(
                  color: Color(0xFF4DA3FF),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Icon(
                _showPasswordFields ? Icons.expand_less : Icons.expand_more,
                color: const Color(0xFF4DA3FF),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        if (_showPasswordFields) ...[
          _passwordField(
            label: 'Enter new password',
            controller: _newPasswordController,
          ),
          const SizedBox(height: 14),
          _passwordField(
            label: 'Confirm password',
            controller: _confirmPasswordController,
          ),
        ],
      ],
    );
  }

  Widget _field({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    int maxLines = 1,
    bool alignTop = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF9CA3AF),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white, fontSize: 15),
          textAlignVertical: alignTop
              ? TextAlignVertical.top
              : TextAlignVertical.center,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF4DA3FF), size: 20),
            filled: true,
            fillColor: const Color(0xFF1F2538),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines > 1 ? 16 : 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              borderSide: BorderSide(color: Color(0xFF3B82F6), width: 1.2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _passwordField({
    required String label,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: true,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.lock_outline,
          color: Color(0xFF4DA3FF),
          size: 20,
        ),
        hintText: label,
        hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
        filled: true,
        fillColor: const Color(0xFF1F2538),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: Color(0xFF3B82F6), width: 1.2),
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: _isSaving ? null : _saveChanges,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 0,
            ),
            child: Text(
              _isSaving ? 'Saving...' : 'Save Changes',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 54,
          child: OutlinedButton(
            onPressed: _goBack,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF2563EB), width: 1.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Color(0xFF4DA3FF),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () {},
          child: const Text(
            'Delete Account',
            style: TextStyle(
              color: Color(0xFFFF5B5B),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class Particles extends StatefulWidget {
  const Particles({super.key});

  @override
  State<Particles> createState() => _ParticlesState();
}

class _ParticlesState extends State<Particles>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return CustomPaint(
          painter: ParticlePainter(controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class ParticlePainter extends CustomPainter {
  final double progress;

  ParticlePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF4DA3FF).withOpacity(0.45);
    final rand = Random(7);

    for (int i = 0; i < 28; i++) {
      final x = rand.nextDouble() * size.width;
      final y =
          ((rand.nextDouble() * size.height) + (progress * 20)) % size.height;
      canvas.drawCircle(Offset(x, y), 1.8, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
