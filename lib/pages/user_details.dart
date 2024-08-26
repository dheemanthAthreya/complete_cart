import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';

import 'user_profile_photo_provider.dart'; // Import UserProfilePhotoProvider
import 'cart_page.dart';
import 'categories.dart';
import 'home_page.dart';
import 'package:flash_cart/pages/account_bottom_navigation_bar_item.dart' as AccountItem;

class UserDetails extends StatefulWidget {
  // final String address;
  //
  // UserDetails({required this.address});

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String _phoneNumberErrorText = '';
  late UserProfilePhotoProvider _userProfilePhotoProvider;

  @override
  void initState() {
    super.initState();
    _userProfilePhotoProvider = Provider.of<UserProfilePhotoProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "User Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 20.0,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _userProfilePhotoProvider.selectedImagePath != null
                      ? FileImage(File(_userProfilePhotoProvider.selectedImagePath!)) as ImageProvider<Object>?
                      : null, // Set to null if there's no custom image
                  child: _userProfilePhotoProvider.selectedImagePath == null
                      ? Icon(Icons.person, size: 50, color: Colors.white) // Default Icon
                      : null, // Hide the Icon when a custom image is selected
                ),

                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _selectImage();
                  },
                  child: Text('Choose Photo'),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _phoneNumberController,
                  onChanged: _validatePhoneNumber,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                    errorText: _phoneNumberErrorText.isNotEmpty
                        ? _phoneNumberErrorText
                        : null,
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    saveUserDetails();
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: AccountItem.AccountBottomNavigationBarItem(), // Use AccountBottomNavigationBarItem
            label: 'Account',
          ),
        ],
        selectedItemColor: Color(0xff6c63ff),
        unselectedItemColor: Colors.grey,
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Categories()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
              break;
            case 3:
              break;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _validatePhoneNumber(String value) {
    setState(() {
      if (value.length != 10) {
        _phoneNumberErrorText = 'Phone number must be 10 digits long';
      } else {
        _phoneNumberErrorText = '';
      }
    });
  }

  void _selectImage() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose an option"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                _getImage(ImageSource.gallery); // Open gallery
              },
              child: Text("Gallery"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                _getImage(ImageSource.camera); // Open camera
              },
              child: Text("Camera"),
            ),
          ],
        );
      },
    );
  }

  void _getImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);

    setState(() {
      if (pickedImage != null) {
        // Update selected image path using provider
        context.read<UserProfilePhotoProvider>().setSelectedImagePath(pickedImage.path);
      }
    });
  }

  void saveUserDetails() async {
    await Firebase.initializeApp();

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    Map<String, dynamic> userDetails = {
      'username': _usernameController.text,
      'phoneNumber': _phoneNumberController.text,
      'address': _addressController.text,
    };

    String username = _usernameController.text;

    try {
      String imagePath = await uploadImage();
      userDetails['imagePath'] = imagePath;

      // Set selected image path using provider
      Provider.of<UserProfilePhotoProvider>(context, listen: false).setSelectedImagePath(imagePath);

      await firestore.collection('Users').doc(username).set(userDetails);

      print('User details saved successfully');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(address: _addressController.text),
        ),
      );
    } catch (error) {
      print('Error saving user details: $error');
    }
  }

  Future<String> uploadImage() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference storageReference =
    storage.ref().child('user_images/${_usernameController.text}.jpg');

    UploadTask uploadTask =
    storageReference.putFile(File(_userProfilePhotoProvider.selectedImagePath!));
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

    String downloadURL = await taskSnapshot.ref.getDownloadURL();

    return downloadURL;
  }
}

class AccountBottomNavigationBarItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfilePhotoProvider>(
      builder: (context, userProfilePhotoProvider, _) {
        return userProfilePhotoProvider.selectedImagePath != null
            ? CircleAvatar(
          radius: 14,
          backgroundImage: FileImage(File(userProfilePhotoProvider.selectedImagePath!)),
        )
            : Icon(Icons.account_circle);
      },
    );
  }
}
