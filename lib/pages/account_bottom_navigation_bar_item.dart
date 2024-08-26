import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_profile_photo_provider.dart'; // Import UserProfilePhotoProvider

class AccountBottomNavigationBarItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfilePhotoProvider>(
      builder: (context, userProfilePhotoProvider, _) {
        return Column(
          children: [
            userProfilePhotoProvider.selectedImagePath != null
                ? CircleAvatar(
              radius: 14,
              backgroundImage: NetworkImage(userProfilePhotoProvider.selectedImagePath!),
            )
                : Icon(Icons.account_circle),
            SizedBox(width: 8), // Add some spacing between icon and label
            // Text('Account'),
          ],
        );
      },
    );
  }
}
