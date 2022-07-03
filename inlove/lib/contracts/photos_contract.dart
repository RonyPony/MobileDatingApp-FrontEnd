import 'dart:io';

import 'package:inlove/models/photo.dart';
import 'package:inlove/models/photoToUpload.dart';

abstract class PhotosContract {
  Future<Photo>getUserProfilePicture(int userId);
  Future<List<Photo>> getAllPhotos();
  Future<Photo> getPhoto(int photoId);
  Future<bool> deletePhoto(int photoId);
  Future<List<Photo>> getPhotosofAnUser(int userId);
  Future<bool> uploadPhoto(PhotoToUpload photo);
  Future<File> compressImage(File image, String targetPath);
}