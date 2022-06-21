import '../models/country.dart';

abstract class CountriesContract {
  Future<Country>getCountryById(String id);
  Future<List<Country>>getAllCountries();
}