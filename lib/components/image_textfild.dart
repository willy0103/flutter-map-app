import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class MyImage extends StatelessWidget {
  final String imageUrl;
  final bool obscureText;
  final File? imageFile;
  final Function(File?) onImagePicked;

  const MyImage({
    Key? key,
    this.imageUrl = '',
    required this.obscureText,
    required this.imageFile,
    required this.onImagePicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 235, 231, 231),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
          shape: BoxShape.circle,
          border: Border.all(
            color: Color.fromARGB(255, 238, 238, 238).withOpacity(0.9),
            width: 3.0,
          ),
        ),
        child: CircleAvatar(
          backgroundColor: Color.fromARGB(255, 245, 245, 245),
          radius: 90.0,
          backgroundImage: imageFile != null
              ? FileImage(imageFile!)
              : imageUrl.isNotEmpty
                  ? AssetImage(imageUrl) as ImageProvider<Object>?
                  : AssetImage('lib/images/camera1.png')
                      as ImageProvider<Object>?,
        ),
      ),
    );
  }

  _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final File file = File(await _cropImage(File(pickedFile.path)));
      //final String compressedFilePath = await _compressImage(file);
      //final File compressedFile = File(compressedFilePath);
      onImagePicked(file);
    }
  }


  _cropImage(File pickedFile) async {
    final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: "Image Cropper",
              toolbarColor: Color.fromARGB(255, 245, 196, 250),
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: "Image Cropper",
          )
        ]);

    return croppedFile?.path ?? pickedFile.path;
  }
}


  //_pickImage() async {
  //  final ImagePicker _picker = ImagePicker();
  //  final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  //  if (pickedFile != null) {
  //    final File file = File(await _cropImage(File(pickedFile.path)));
  //    onImagePicked(file);
  // }
  // }