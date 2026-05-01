import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class FilePickerField extends StatelessWidget {
  final String label;
  final bool isOptional;
  final String? selectedFileName;

  /// Called with the picked file name after user selects a file.
  /// Pass this to your cubit e.g: onFilePicked: cubit.updateNationalIdFront
  final ValueChanged<String?> onFilePicked;

  const FilePickerField({
    super.key,
    required this.label,
    this.isOptional = false,
    this.selectedFileName,
    required this.onFilePicked,
  });

  Future<void> _showPickerOptions(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined, color: Color(0xFF1A3A6B)),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.of(ctx).pop();
                  final ImagePicker picker = ImagePicker();
                  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    onFilePicked(image.path);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.insert_drive_file_outlined, color: Color(0xFF1A3A6B)),
                title: const Text('File'),
                onTap: () async {
                  Navigator.of(ctx).pop();
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
                  );
                  if (result != null && result.files.isNotEmpty) {
                    onFilePicked(result.files.single.path);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Label ────────────────────────────────────────────────────
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E),
            ),
            children: [
              if (!isOptional)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
              if (isOptional)
                const TextSpan(
                  text: ' (Optional)',
                  style: TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // ── Picker Box ────────────────────────────────────────────────
        GestureDetector(
          onTap: () => _showPickerOptions(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: (selectedFileName != null && selectedFileName!.isNotEmpty)
                    ? const Color(0xFF22C55E).withOpacity(0.5)
                    : const Color(0xFFE5E7EB),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    (selectedFileName != null && selectedFileName!.isNotEmpty)
                        ? selectedFileName!.split('/').last
                        : 'Choose file...',
                    style: TextStyle(
                      fontSize: 14,
                      color: (selectedFileName != null && selectedFileName!.isNotEmpty)
                          ? const Color(0xFF1A1A2E)
                          : const Color(0xFF9CA3AF),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (selectedFileName != null && selectedFileName!.isNotEmpty) ...[
                  const Icon(
                    Icons.check_circle_outline,
                    size: 18,
                    color: Color(0xFF22C55E),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      onFilePicked(''); // Clear the file
                    },
                    child: const Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.red,
                    ),
                  ),
                ] else ...[
                  const Icon(
                    Icons.upload_file_outlined,
                    size: 18,
                    color: Color(0xFF9CA3AF),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
