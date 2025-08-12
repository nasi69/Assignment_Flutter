import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final FlutterSecureStorage _storage = FlutterSecureStorage();
const _key = "StudentFontLogic";

class StudentFontLogic extends ChangeNotifier{
  double _size = 17; //default
  double get size => _size;

  Future readFontSize() async {
    await Future.delayed(Duration(seconds: 1));
    String value = await _storage.read(key: _key) ?? "17";
    _size = double.parse(value); // default to 17
    notifyListeners();
  }

  void increase(){
    if(_size < 30) _size += 3; // size cannot be more than 30
    notifyListeners();
  }

  void decrease(){
    if(_size > 12) _size -= 3; // size cannot be less than 12
    notifyListeners();
  }
}