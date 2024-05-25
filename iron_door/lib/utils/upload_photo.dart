import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'dart:async';
import 'dart:developer';
import 'package:iron_door/backend/post_images.dart';

String userName = '';
bool uploadPressed = false;

class PhotosData {
  String name;
  List<String> images;

  PhotosData({required this.name, required this.images});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'images': images,
    };
  }
}

void setName(String? name) {
  if (name != null) {
    userName = name;
  }
}

Future<void> sendDataToDatabase(String name, List<String> photos) async {
  PhotosData photosData = PhotosData(name: name, images: photos);
  Map<String, dynamic> photosMapped = photosData.toJson();

  String dataJSON = jsonEncode(photosMapped);
  try {
    await sendImages(dataJSON);
  } catch (e) {
    log('Error posting data: $e');
  }
}

Future<List<String>> encodeToBase64(List<PlatformFile> files) async {
  List<String> base64photos = [];
  String start = 'data:image/jpeg;base64,';

  if (files == []) {
    throw Exception("Pictures upload error");
  }

  for (var file in files) {
    List<int> bytes = await file.bytes!.toList();
    String photoBase64 = base64Encode(bytes);
    photoBase64 = start + photoBase64;
    base64photos.add(photoBase64);
  }

  return base64photos;
}

Future<List<PlatformFile>> getPhotos() async {
  List<PlatformFile> files = [];
  var picked = await FilePicker.platform.pickFiles(allowMultiple: true);

  if (picked != null && picked.files.isNotEmpty) {
    if (picked.files.length > 10) {
      throw Exception("Only upload 10 photos");
    }

    for (var file in picked.files) {
      files.add(file);
    }
  } else {
    throw Exception("No pictures selected");
  }

  log('PHOTO LENGTH: ${files.length}');

  return files;
}

Future<void> uploadPhotosToDatabase() async {
  List<PlatformFile> photos = await getPhotos();
  List<String> photosBase64 = await encodeToBase64(photos);

  if (userName != "") {
    sendDataToDatabase(userName, photosBase64);
    uploadPressed = true;
  } else {
    throw Exception("Need to enter name");
  }
}
