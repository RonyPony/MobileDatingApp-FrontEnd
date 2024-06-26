
// ignore_for_file: unrelated_type_equality_checks, avoid_print

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:inlove/constant.dart';
import 'package:inlove/contracts/countries_contrac.dart';
import 'package:inlove/models/country.dart';

class CountriesService implements CountriesContract {
  @override
  Future<Country> getCountryById(String id) async {
    Country foundCountry = Country();
    try {
      var resp = await Dio().get(
          serverurl+'api/countries/'+id);
      if(resp.statusCode == 200){
        foundCountry = Country.fromJson(resp.data);
        return foundCountry;
      }

      if(resp.statusCode=="404"){
        print("Country Not Found");
      }
      return foundCountry;
    } 
    on DioError catch (e) {
      //http error(statusCode not 20x) will be catched here.
      print(e.response!.statusCode.toString());
      print(
          'Failed Load Data with status code ${e.response!.statusCode}');
          return foundCountry;
    }
  }
  
  @override
  Future<List<Country>> getAllCountries() async {
    List<Country> foundCountry = <Country>[];
    try {
      var resp = await Dio().get(
          serverurl+'api/countries');
      if(resp.statusCode == 200){
        
        var list  = resp.data;
        foundCountry = list.map<Country>((sample) => Country(
          id: sample["id"],
          code: sample["code"],
          createdOn: sample["createdOn"],
          enabled: sample["enabled"],
          name: sample["name"],
          updatedOn: sample["updatedOn"])).toList();
        // foundCountry;
        return foundCountry;
      }

      if(resp.statusCode=="404"){
        print("Country Not Found");
      }
      return foundCountry;
    } 
    on DioError catch (e) {
      //http error(statusCode not 20x) will be catched here.
      print(e.response!.statusCode.toString());
      print(
          'Failed Load Data with status code ${e.response!.statusCode}');
          return foundCountry;
    }
    catch(e){
      print(e);
      return foundCountry;
    }
  }
  
  @override
  Future<Country> getCountryByName(String name) async {
    Country foundCountry = Country();
    try {
      var resp = await Dio().get(
          serverurl+'api/countries/byName/'+name);
      if(resp.statusCode == 200){
        var json;
        if (resp.data.length >0) {
          json= resp.data[0];
        }
        foundCountry = Country.fromJson(resp.data[0]);
        return foundCountry;
      }

      if(resp.statusCode=="404"){
        print("Country Not Found");
      }
      return foundCountry;
    } 
    on DioError catch (e) {
      //http error(statusCode not 20x) will be catched here.
      print(e.response!.statusCode.toString());
      print(
          'Failed Load Data with status code ${e.response!.statusCode}');
          return foundCountry;
    }catch(ex){
      print("error "+ex.toString());
      return foundCountry;
    }
  }
  
}