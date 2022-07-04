import 'dart:convert';
import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:inlove/constant.dart';
import 'package:inlove/contracts/photos_contract.dart';
import 'package:inlove/models/photo.dart';
import 'package:inlove/models/photoToUpload.dart';

class PhotoService implements PhotosContract {
  @override
  Future<bool> deletePhoto(int photoId) {
    // TODO: implement deletePhoto
    throw UnimplementedError();
  }

  @override
  Future<List<Photo>> getAllPhotos() {
    // TODO: implement getAllPhotos
    throw UnimplementedError();
  }

  @override
  Future<Photo> getPhoto(int photoId) async {
    Photo _photo = Photo();
    try {
      var resp = await Dio().get(
          serverurl+'api/photos/$photoId');
      
      if(resp.statusCode == 200){
        var lista = resp.data;
        if (lista.length>0) {
          _photo.userId = photoId;
          // String jsoned = jsonDecode(lista);
          _photo = Photo.fromJson(lista);
        }else{
          _photo.userId = photoId;
        }
        return _photo;
      }

      if(resp.statusCode=="404"){
        print("Photo Not Found");
      }
      return _photo;
    } 
    on DioError catch (e) {
      //http error(statusCode not 20x) will be catched here.
      print(e.response!.statusCode.toString());
      print(
          'Failed Load Data with status code ${e.response!.statusCode}');
          return _photo;
    }catch(ex){
      print("error "+ex.toString());
      return _photo;
    }
  }

  @override
  Future<List<Photo>> getPhotosofAnUser(int userId) async {
    // TODO: implement getUserProfilePicture
    throw UnimplementedError();
  }

  @override
  Future<Photo> getUserProfilePicture(int UserId) async {
    Photo _photo = Photo();
    try {
      var resp = await Dio().get(
          serverurl+'api/photos/profilePicture/$UserId');
      
      if(resp.statusCode == 200){
        var lista = resp.data;
        if (lista.length>0) {
          _photo.userId = UserId;
          // String jsoned = jsonDecode(lista);
          _photo = Photo.fromJson(lista);
        }else{
          _photo.userId = UserId;
        }
        return _photo;
      }

      if(resp.statusCode=="404"){
        print("Photo Not Found");
      }
      return _photo;
    } 
    on DioError catch (e) {
      //http error(statusCode not 20x) will be catched here.
      print(e.response!.statusCode.toString());
      print(
          'Failed Load Data with status code ${e.response!.statusCode}');
          return _photo;
    }catch(ex){
      print("error "+ex.toString());
      return _photo;
    }
  }

  @override
  Future<bool> uploadPhoto(PhotoToUpload photo) async {
    // throw UnimplementedError();
     Future<bool> nullx;
      try {
        var dio = Dio();
        // String body = json.encode(element);
        final FormData datax = FormData.fromMap({
          'image': await MultipartFile.fromFile(photo.image!),
          'userId': photo.userId
        });
        // datax.files.add(MapEntry(
        //     'files', await MultipartFile.fromFile(element.photo.path)));
        // ImageRequestData lastData = ImageRequestData();
        // lastData.data = datax;
        // lastData.reportId = element.reportId;
        Response response = await dio.post(serverurl+'api/photos/new',
            options: Options(headers: {
              HttpHeaders.contentTypeHeader: "multipart/form-data",
            }),
            data: datax // lastData.toJson(),
            );
            print(response.statusCode);
            if (response.statusCode == 200 || response.statusCode ==201) {
              return true;
            }

            return false;
        
      } catch (e){
        print(e.toString());
        return false;
      }
  }
  
  @override
  Future<File> compressImage(File image, String targetPath) async {
      var result = await FlutterImageCompress.compressAndGetFile(
        image.absolute.path,
        targetPath,
        quality: 88,
        rotate: 180,
      );

      print(image.lengthSync());
      print(result!.lengthSync());

      return result;
    
  }
  }
  
