
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

Future<File?> base64ToFile(String base64Image, String fileName) async {
  try {
    // Decode the Base64 string to bytes
    final bytes = base64Decode(base64Image);

    // Get a temporary directory to store the file
    final directory = await getTemporaryDirectory();

    // Create the file in the directory
    final file = File('${directory.path}/$fileName');

    // Write the bytes to the file
    await file.writeAsBytes(bytes);

    return file; // Return the created file
  } catch (e) {
    print('Error converting Base64 to file: $e');
    return null;
  }
}


   void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }
