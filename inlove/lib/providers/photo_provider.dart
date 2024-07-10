import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:inlove/models/photo.dart';
import 'package:inlove/models/photoToUpload.dart';

import '../services/photo_service.dart';

class PhotoProvider with ChangeNotifier {
  final PhotoService _service;
  PhotoProvider(this._service);

  Future<Photo> getUserProfilePicture(int UserId) async {
    var response = await _service.getUserProfilePicture(UserId);
    return response;
  }

  Future<List<Photo>> getAllPhotos() async {
    var response = await _service.getAllPhotos();
    return response;
  }

  Future<Photo> getPhoto(int photoId) async {
    var response = await _service.getPhoto(photoId);
    return response;
  }

  Future<bool> deletePhoto(int photoId) async {
    var response = await _service.deletePhoto(photoId);
    return response;
  }

  Future<List<Photo>> getPhotosofAnUser(int userId) async {
    var response = await _service.getPhotosofAnUser(userId);
    return response;
  }

  Future<bool> uploadPhoto(PhotoToUpload photo) async {
    var response = await _service.uploadPhoto(photo);
    return response;
  }

  Future<XFile> compressImage(File image, String targetPath) async {
    var response = await _service.compressImage(image, targetPath);
    return response;
  }
}
