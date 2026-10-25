// -----------------------------------------------------------------------------
// take_progress_photo_screen.dart
//
// "Take Photo" screen � lets the user capture or select a progress photo.
// This is a UI prototype; no real camera/gallery is used.
// Shows:
//  - Body silhouette / fitness illustration
//  - Close (X), Camera, Gallery buttons
//  - Leads to the photo preview screen
// -----------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'progress_photo_preview_screen.dart';

class TakeProgressPhotoScreen extends StatefulWidget {
  const TakeProgressPhotoScreen({super.key});

  @override
  State<TakeProgressPhotoScreen> createState() =>
      _TakeProgressPhotoScreenState();
}

class _TakeProgressPhotoScreenState extends State<TakeProgressPhotoScreen> {
  // App colour palette
  static const Color _primary = Color(0xFF92A3FD);

  // Demo state: show a loading/capturing animation when camera is pressed
  bool _isCapturing = false;

  // Dummy gallery images to pick from
  final List<Map<String, String>> _galleryItems = [
    {
      'path': 'assets/images/Rectangle 5909.png',
      'label': '02 June',
    },
    {
      'path': 'assets/images/Rectangle 5910.png',
      'label': '05 July',
    },
    {
      'path': 'assets/images/Rectangle 5911.png',
      'label': '03 August',
    },
    {
      'path': 'assets/images/Rectangle 5912.png',
      'label': '03 September',
    },
    {
      'path': 'assets/images/Rectangle 5913.png',
      'label': 'Recent',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // -- Background: dark viewfinder area ---------------------
            Positioned.fill(
              child: Container(
                color: const Color(0xFF1A1A2E),
              ),
            ),

            // -- Body silhouette / illustration ------------------------
            Positioned.fill(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Viewfinder guide overlay
                    Container(
                      width: 220,
                      height: 320,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _primary.withValues(alpha: 0.6),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(
                          'assets/images/onboarding1.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.accessibility_new,
                                size: 80,
                                color: _primary.withValues(alpha: 0.6),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Stand in the frame',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Position yourself in the frame',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // -- Header -----------------------------------------------
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildHeader(),
            ),

            // -- Bottom controls ---------------------------------------
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomControls(),
            ),

            // -- Capturing overlay -------------------------------------
            if (_isCapturing)
              Positioned.fill(
                child: Container(
                  color: Colors.white.withValues(alpha: 0.6),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF92A3FD)),
                    ),
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
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.arrow_back_ios_new,
                  size: 14, color: Colors.white),
            ),
          ),
          const Text(
            'Take Photo',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.more_horiz, size: 20, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: const EdgeInsets.fromLTRB(40, 24, 40, 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Close (X) button
          _buildControlButton(
            icon: Icons.close,
            label: 'Cancel',
            onTap: () => Navigator.pop(context),
          ),

          // Camera / Capture button (main)
          GestureDetector(
            onTap: _onCameraPressed,
            child: Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF92A3FD).withValues(alpha: 0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),

          // Gallery button
          _buildControlButton(
            icon: Icons.photo_library_outlined,
            label: 'Gallery',
            onTap: _onGalleryPressed,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // -- Actions -----------------------------------------------------------------

  /// Simulates taking a photo with the camera.
  void _onCameraPressed() async {
    setState(() => _isCapturing = true);
    // Simulate a short shutter delay
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() => _isCapturing = false);

    if (!mounted) return;
    // Use the first dummy image as the "captured" photo
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProgressPhotoPreviewScreen(
          imagePath: 'assets/images/Rectangle 5913.png',
          suggestedDate: _getCurrentDateLabel(),
        ),
      ),
    );
  }

  /// Shows a bottom-sheet gallery picker.
  void _onGalleryPressed() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _GalleryPickerSheet(
        items: _galleryItems,
        onSelected: (path, label) {
          Navigator.pop(context); // Close sheet
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProgressPhotoPreviewScreen(
                imagePath: path,
                suggestedDate: label,
              ),
            ),
          );
        },
      ),
    );
  }

  /// Returns a simple date label for the "captured" photo.
  String _getCurrentDateLabel() {
    final now = DateTime.now();
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${now.day.toString().padLeft(2, '0')} ${months[now.month - 1]}';
  }
}

// -----------------------------------------------------------------------------
// Gallery Picker Sheet (bottom sheet used by the Gallery button)
// -----------------------------------------------------------------------------

class _GalleryPickerSheet extends StatelessWidget {
  final List<Map<String, String>> items;
  final void Function(String path, String label) onSelected;

  const _GalleryPickerSheet({
    required this.items,
    required this.onSelected,
  });

  static const Color _primary = Color(0xFF92A3FD);
  static const Color _textDark = Color(0xFF1D1617);
  static const Color _textGrey = Color(0xFF7B6F72);

  @override
  Widget build(BuildContext context) {
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
            'Select Photo',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (_, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final item = items[index];
                return GestureDetector(
                  onTap: () =>
                      onSelected(item['path']!, item['label']!),
                  child: Column(
                    children: [
                      Container(
                        width: 110,
                        height: 130,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _primary.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(13),
                          child: Image.asset(
                            item['path']!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: const Color(0xFFE8F0FE),
                              child: const Icon(
                                Icons.person_outline,
                                size: 40,
                                color: _primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item['label']!,
                        style: const TextStyle(
                          fontSize: 11,
                          color: _textGrey,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
