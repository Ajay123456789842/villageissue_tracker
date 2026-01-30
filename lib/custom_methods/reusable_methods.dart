import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ReusableMethods {
  Future<String?> pickAndSaveImage() async {
    try {
      final XFile? image = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1024,
      );

      //  User cancelled camera
      if (image == null) {
        debugPrint("Camera cancelled");
        return null;
      }

      final dir = await getApplicationDocumentsDirectory();
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${basename(image.path)}';

      final savedImage = await File(image.path).copy('${dir.path}/$fileName');

      debugPrint("Image saved locally: ${savedImage.path}");

      return savedImage.path;
    } catch (e, s) {
      debugPrint("Image pick error: $e");
      debugPrintStack(stackTrace: s);
      return null;
    }
  }

  void displaySnackbar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        text,
        style: const TextStyle(fontSize: 12),
      ),
    ));
  }

  void dipalyAlertdialog(BuildContext context, String title, String content) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'))
            ],
          );
        });
  }
}
