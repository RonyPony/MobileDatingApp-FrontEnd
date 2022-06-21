// ignore_for_file: file_names

import '../models/country.dart';

abstract class CountriesContract {
  Future<Country>getCountryById(String id);
  Future<List<Country>>getAllCountries();
  Future<Country>getCountryByName(String name);
}