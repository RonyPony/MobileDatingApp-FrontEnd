import 'package:flutter/material.dart';
import 'package:inlove/services/countriesService.dart';

import '../models/country.dart';

class CountriesProvider with ChangeNotifier {
  CountriesService _service;

  CountriesProvider(this._service);

  Future<Country>findCountryById(String id) async {
    var response = await _service.getCountryById(id);
    return response;
  }

  Future<List<Country>>getAllCountries() async {
    var response = await _service.getAllCountries();
    return response;
  }
}