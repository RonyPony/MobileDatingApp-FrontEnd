import 'package:flutter/material.dart';
import 'package:inlove/models/user.dart';

import '../services/setting_service.dart';

class SettingsProvider with ChangeNotifier {
 final SettingService _service;
 SettingsProvider(this._service);
  
  Future<bool> activateGhostMode(int userId) async {
    var response = await _service.activateGhostMode(userId);
    return response;
  }
  Future<bool> deactivateGhostMode(int userId) async {
    var response = await _service.deactivateGhostMode(userId);
    return response;
  }
  Future<bool> activateInstagram(int userId) async {
    var response = await _service.activateInstagram(userId);
    return response;
  }
  Future<bool> deactivateInstagram(int userId) async {
    var response = await _service.deactivateInstagram(userId);
    return response;
  }
  Future<bool> activateWhatsapp(int userId) async {
    var response = await _service.activateWhatsapp(userId);
    return response;
  }
  Future<bool> deactivateWhatsapp(int userId) async {
    var response = await _service.deactivateWhatsapp(userId);
    return response;
  }
  Future<bool> setInstagram(int userId, String instagramUser) async {
    var response = await _service.setInstagram(userId,instagramUser);
    return response;
  }
  Future<bool> setWhatsapp(int userId, String whatsappNumber) async {
    var response = await _service.setWhatsapp(userId,whatsappNumber);
    return response;
  }

  Future<bool>setFiltersPreferences(int userId,User userWithChanges)async{
    var response = await _service.setFiltersPreferences(userId, userWithChanges);
    return response;
  }

  Future<bool>showMySexuality(bool showMySexuality)async{
    var response = await _service.updateSexuality(showMySexuality);
    return response;
  }
}