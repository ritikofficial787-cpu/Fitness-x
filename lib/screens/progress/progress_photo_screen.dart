// -----------------------------------------------------------------------------
// progress_photo_screen.dart
//
// Progress Photo screen � the main entry point for the Progress Tracker.
// Shows:
//  - Info card ("Keep Your Progress")
//  - Compare My Photo button
//  - Photo gallery grid (local dummy data)
//  - FAB (+) to add a new progress photo
// -----------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'take_progress_photo_screen.dart';
import 'progress_comparison_screen.dart';

// -- Local data model ---------------------------------------------------------

/// Simple model to hold a single progress photo entry.
class ProgressPhoto {
  final String imagePath; // asset path
  final String date; // display date string
  final String weight; // optional weight string

  const ProgressPhoto({
    required this.imagePath,
    required this.date,
    this.weight = '',
  });
}

// -- Shared dummy progress photos ---------------------------------------------
// These Rectangle images are used as stand-in progress photos.
List<ProgressPhoto> dummyProgressPhotos = [
  const ProgressPhoto(
    imagePath: 'assets/images/Rectangle 5909.png',
    date: '02 June',
    weight: '72 kg',
  ),
  const ProgressPhoto(
    imagePath: 'assets/images/Rectangle 5910.png',
    date: '05 July',
    weight: '70 kg',
  ),
  const ProgressPhoto(
    imagePath: 'assets/images/Rectangle 5911.png',
    date: '03 August',
    weight: '69 kg',
  ),
  const ProgressPhoto(
    imagePath: 'assets/images/Rectangle 5912.png',
    date: '03 September',
    weight: '68 kg',
  ),
];

// -----------------------------------------------------------------------------

class ProgressPhotoScreen extends StatefulWidget {
  const ProgressPhotoScreen({super.key});

  @override
  State<ProgressPhotoScreen> createState() => _ProgressPhotoScreenState();
}

class _ProgressPhotoScreenState extends State<ProgressPhotoScreen> {
  // App colour palette
  static const Color _primary = Color(0xFF92A3FD);
  static const Color _textDark = Color(0xFF1D1617);
  static const Color _textGrey = Color(0xFF7B6F72);
  static const Color _bgLight = Color(0xFFF7F8F8);
  static const Color _cardBg = Color(0xFFE8F0FE);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildInfoCard(),
                    const SizedBox(height: 25),
                    _buildSectionTitle('Compare My Photo'),
                    const SizedBox(height: 12),
                    _buildCompareButton(),
                    const SizedBox(height: 25),
                    _buildSectionTitle('Gallery'),
                    const SizedBox(height: 12),
                    _buildPhotoGrid(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildAddFab(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _bgLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.arrow_back_ios_new,
                  size: 14, color: _textDark),
            ),
          ),
          const Text(
            'Progress Photo',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _textDark,
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _bgLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.more_horiz, size: 20, color: _textDark),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF92A3FD).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.photo_camera_outlined,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Keep Your Progress',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Take progress photos regularly to track your fitness journey.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: _textDark,
      ),
    );
  }

  Widget _buildCompareButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ProgressComparisonScreen(),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
          ),
          borderRadius: BorderRadius.circular(99),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF92A3FD).withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'Compare',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoGrid() {
    final photos = dummyProgressPhotos;

    if (photos.isEmpty) {
      return Container(
        height: 150,
        alignment: Alignment.center,
        child: const Text(
          'No photos yet. Tap + to add your first progress photo.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: _textGrey),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.85,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return _buildPhotoCard(photos[index]);
      },
    );
  }

  Widget _buildPhotoCard(ProgressPhoto photo) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.asset(
                photo.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: _cardBg,
                  child: const Icon(
                    Icons.person_outline,
                    size: 48,
                    color: _primary,
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    photo.date,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _textDark,
                    ),
                  ),
                  if (photo.weight.isNotEmpty)
                    Text(
                      photo.weight,
                      style: const TextStyle(
                        fontSize: 11,
                        color: _textGrey,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddFab() {
    return FloatingActionButton(
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const TakeProgressPhotoScreen(),
          ),
        );
        // Refresh state after returning from Take Photo
        setState(() {});
      },
      backgroundColor: _primary,
      elevation: 6,
      child: const Icon(Icons.add, color: Colors.white, size: 28),
    );
  }
}
