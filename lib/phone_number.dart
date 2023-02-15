import 'dart:developer';

import 'countries.dart';

class NumberTooLongException implements Exception{}
class NumberTooShortException implements Exception{}
class InvalidCharactersException implements Exception{}

class PhoneNumber {
  String countryISOCode;
  String countryCode;
  String number;

  PhoneNumber({
    required this.countryISOCode,
    required this.countryCode,
    required this.number,
  });

  factory PhoneNumber.fromCompleteNumber({required String completeNumber}){
    if(completeNumber == "") {
      return PhoneNumber(countryISOCode: "",
          countryCode: "",
          number: "");
    }

    try{
      Country country = getCountry(completeNumber);
      String number;
      if (completeNumber.startsWith('+')) {
        number = completeNumber.substring(1+country.dialCode.length);
      } else {
        number = completeNumber.substring(country.dialCode.length);
      }
      return PhoneNumber(countryISOCode: country.code,
          countryCode: country.dialCode,
          number: number);
    } on InvalidCharactersException{
      rethrow;
    } on Exception catch(e){
      return PhoneNumber(countryISOCode: "",
          countryCode: "",
          number: "");
    }

  }

  bool isValidNumber(){
      Country country = getCountry(completeNumber);
      if( number.length < country.minLength){
        throw NumberTooShortException();
      }

      if( number.length > country.maxLength){
        throw NumberTooLongException();
      }
      return true;
  }

  String get completeNumber {
    log("completeNumber $countryCode $number");

    switch (countryCode) {
      case "+66":
        if(number.startsWith('0')){
          return countryCode + number.substring(1);
        }
        break;
      default:
    }

    return countryCode + number;
  }

  static Country getCountry(String phoneNumber) {
    if(phoneNumber == ""){
      throw NumberTooShortException();
    }

    final _validPhoneNumber = RegExp(r'^[+0-9]*[0-9]*$');

    if(!_validPhoneNumber.hasMatch(phoneNumber)){
      throw InvalidCharactersException();
    }

    if (phoneNumber.startsWith('+')) {
      return countries.firstWhere((country) =>
          phoneNumber
              .substring(1)
              .startsWith(country.dialCode));
    }
    return countries.firstWhere((country) =>
        phoneNumber.startsWith(country.dialCode));
  }

  String toString() =>
      'PhoneNumber(countryISOCode: $countryISOCode, countryCode: $countryCode, number: $number)';
}