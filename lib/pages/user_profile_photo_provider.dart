import 'package:flutter/material.dart';

class UserProfilePhotoProvider extends ChangeNotifier {
  String? _selectedImagePath;

  String? get selectedImagePath => _selectedImagePath;

  void setSelectedImagePath(String? imagePath) {
    if (imagePath != null && imagePath.isNotEmpty) {
      _selectedImagePath = imagePath;
      print('Selected image path: $_selectedImagePath');
      notifyListeners();
    } else {
      // Handle invalid image path
      print('Invalid image path');
    }
  }

  void clearSelectedImagePath() {
    _selectedImagePath = null;
    notifyListeners();
  }
}
