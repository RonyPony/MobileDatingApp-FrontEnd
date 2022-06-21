// ignore_for_file: file_names

import 'package:inlove/models/user.dart';

abstract class SettingsContract {
  Future<bool>activateGhostMode(int userId);
  Future<bool> deactivateGhostMode(int userId);
  Future<bool> activateInstagram(int userId);
  Future<bool> deactivateInstagram(int userId);
  Future<bool> activateWhatsapp(int userId);
  Future<bool> deactivateWhatsapp(int userId);
  Future<bool> setInstagram(int userId,String instagramUser);
  Future<bool> setWhatsapp(int userId,String whatsappNumber);
  Future<bool>setFiltersPreferences(int userId,User userWithChanges);
}