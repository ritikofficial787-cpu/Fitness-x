// -----------------------------------------------------------------------------
// progress_comparison_screen.dart
//
// Comparison screen � lets the user select two photos and compare them.
// Shows:
//  - Select Month 1 and Select Month 2 fields
//  - Compare button (disabled until both photos are selected)
// -----------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'progress_photo_screen.dart'; // for dummyProgressPhotos & ProgressPhoto
import 'progress_result_screen.dart';

class ProgressComparisonScreen extends StatefulWidget {
  const ProgressComparisonScreen({super.key});

  @override
  State<ProgressComparisonScreen> createState() =>
      _ProgressComparisonScreenState();
}

class _ProgressComparisonScreenState
    extends State<ProgressComparisonScreen> {
  // App colour palette
  static const Color _primary = Color(0xFF92A3FD);
  static const Color _textDark = Color(0xFF1D1617);
  static const Color _textGrey = Color(0xFF7B6F72);
  static const Color _bgLight = Color(0xFFF7F8F8);
  static const Color _cardBg = Color(0xFFE8F0FE);

  // Selected photos (null = not yet selected)
  ProgressPhoto? _photo1;
  ProgressPhoto? _photo2;

  @override
  Widget build(BuildContext context) {
    final bothSelected = _photo1 != null && _photo2 != null;

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
                    const SizedBox(height: 24),

                    // -- Illustration / top area ----------------------
                    _buildTopIllustration(),
                    const SizedBox(height: 30),

                    // -- Select Month 1 -------------------------------
                    _buildSelectLabel('Select Month 1'),
                    const SizedBox(height: 10),
                    _buildSelectField(
                      photo: _photo1,
                      placeholder: 'Select photo / date',
                      onTap: () => _openPhotoPicker(slot: 1),
                    ),
                    const SizedBox(height: 20),

                    // -- Select Month 2 -------------------------------
                    _buildSelectLabel('Select Month 2'),
                    const SizedBox(height: 10),
                    _buildSelectField(
                      photo: _photo2,
                      placeholder: 'Select photo / date',
                      onTap: () => _openPhotoPicker(slot: 2),
                    ),
                    const SizedBox(height: 36),

                    // -- Validation message ---------------------------
                    if (!bothSelected)
                      Center(
                        child: Text(
                          'Please select two photos to compare.',
                          style: TextStyle(
                            fontSize: 12,
                            color: _textGrey.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),

                    // -- Compare button -------------------------------
                    _buildCompareButton(enabled: bothSelected),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
            'Comparison',
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

  Widget _buildTopIllustration() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE8F0FE), Color(0xFFDDE8FF)],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Photo 1 placeholder
          _buildPhotoPlaceholder(_photo1, 'Before'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'VS',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Photo 2 placeholder
          _buildPhotoPlaceholder(_photo2, 'After'),
        ],
      ),
    );
  }

  Widget _buildPhotoPlaceholder(ProgressPhoto? photo, String label) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFF92A3FD).withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: photo == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 32,
                      color: const Color(0xFF92A3FD).withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        color: _textGrey.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: Image.asset(
                    photo.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: _cardBg,
                      child: const Icon(
                        Icons.person_outline,
                        size: 40,
                        color: _primary,
                      ),
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 8),
        Text(
          photo?.date ?? label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: _textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: _textDark,
      ),
    );
  }

  Widget _buildSelectField({
    required ProgressPhoto? photo,
    required String placeholder,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(14),
          border: photo != null
              ? Border.all(color: _primary.withValues(alpha: 0.5), width: 1.5)
              : null,
        ),
        child: Row(
          children: [
            // Thumbnail if selected
            if (photo != null) ...[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    photo.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: _primary.withValues(alpha: 0.2),
                      child: const Icon(Icons.person_outline,
                          size: 22, color: _primary),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                photo != null ? photo.date : placeholder,
                style: TextStyle(
                  fontSize: 14,
                  color: photo != null ? _textDark : _textGrey,
                  fontWeight: photo != null ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: _textGrey.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompareButton({required bool enabled}) {
    return GestureDetector(
      onTap: enabled ? _onCompare : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: enabled
              ? const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
                )
              : null,
          color: enabled ? null : const Color(0xFFDDDADA),
          borderRadius: BorderRadius.circular(99),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: const Color(0xFF92A3FD).withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            'Compare',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: enabled ? Colors.white : _textGrey,
            ),
          ),
        ),
      ),
    );
  }

  // -- Actions -----------------------------------------------------------------

  void _openPhotoPicker({required int slot}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _PhotoPickerSheet(
        onSelected: (photo) {
          setState(() {
            if (slot == 1) {
              _photo1 = photo;
            } else {
              _photo2 = photo;
            }
          });
        },
      ),
    );
  }

  void _onCompare() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProgressResultScreen(
          photo1: _photo1!,
          photo2: _photo2!,
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Photo Picker Sheet
// -----------------------------------------------------------------------------

class _PhotoPickerSheet extends StatelessWidget {
  final void Function(ProgressPhoto) onSelected;

  const _PhotoPickerSheet({required this.onSelected});

  static const Color _primary = Color(0xFF92A3FD);
  static const Color _textDark = Color(0xFF1D1617);
  static const Color _textGrey = Color(0xFF7B6F72);
  static const Color _cardBg = Color(0xFFE8F0FE);

  @override
  Widget build(BuildContext context) {
    final photos = dummyProgressPhotos;

    return Container(
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 50,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFDDDADA),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Select a Photo',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 18),
          // List of available progress photos
          ...photos.map((photo) {
            return GestureDetector(
              onTap: () {
                Navigator.pop(context);
                onSelected(photo);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _cardBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    // Thumbnail
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          photo.imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: _primary.withValues(alpha: 0.2),
                            child: const Icon(Icons.person_outline,
                                size: 24, color: _primary),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            photo.date,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _textDark,
                            ),
                          ),
                          if (photo.weight.isNotEmpty)
                            Text(
                              photo.weight,
                              style: const TextStyle(
                                fontSize: 12,
                                color: _textGrey,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: _textGrey,
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
