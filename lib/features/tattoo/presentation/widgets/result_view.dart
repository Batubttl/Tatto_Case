import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class ResultView extends StatefulWidget {
  final String imageUrl;
  final VoidCallback onShare;
  final VoidCallback onSave;
  final VoidCallback onRecreate;
  final VoidCallback onEdit;

  const ResultView({
    super.key,
    required this.imageUrl,
    required this.onShare,
    required this.onSave,
    required this.onRecreate,
    required this.onEdit,
  });

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  bool _watermarkEnabled = true;

  // Fotoğrafı kaydetme fonksiyonu
  Future<void> saveImageToGallery() async {
    // Depolama izni kontrolü
    var status = await Permission.storage.request();
    if (status.isGranted) {
      try {
        final result = await ImageGallerySaver.saveFile(widget.imageUrl);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image saved to gallery')),
        );
      } catch (e) {
        print("Error saving image: $e");
      }
    } else {
      print("Storage permission denied");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Storage permission denied')),
      );
    }
  }

  // Fotoğrafı paylaşma fonksiyonu
  Future<void> shareImage() async {
    try {
      await Share.shareFiles([widget.imageUrl], text: 'Check out this image!');
    } catch (e) {
      print("Error sharing image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error sharing image')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Watermark',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              Switch(
                value: _watermarkEnabled,
                onChanged: (value) {
                  setState(() {
                    _watermarkEnabled = value;
                  });
                },
                activeColor: Colors.green,
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Image Container
          Expanded(
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    Image.network(
                      widget.imageUrl,
                      fit: BoxFit.contain,
                    ),
                    if (_watermarkEnabled)
                      Positioned(
                        right: 16,
                        bottom: 16,
                        child: Text(
                          'Tattoo AI',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          // Action Buttons
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Circular Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _CircularButton(
                      icon: Icons.refresh,
                      label: 'Recreate',
                      onTap: widget.onRecreate,
                    ),
                    const SizedBox(width: 48),
                    _CircularButton(
                      icon: Icons.edit,
                      label: 'Edit',
                      onTap: widget.onEdit,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Save and Share Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.download, color: Colors.white),
                        label: const Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: saveImageToGallery,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.share, color: Colors.white),
                        label: const Text(
                          'Share',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: shareImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Colors.white24),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CircularButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _CircularButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white24,
              width: 1,
            ),
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.white),
            onPressed: onTap,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
