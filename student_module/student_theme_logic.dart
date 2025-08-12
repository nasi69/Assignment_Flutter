import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final FlutterSecureStorage _storage=FlutterSecureStorage();
const _key ="StudentThemeLogic";

class StudentThemeLogic extends ChangeNotifier{

  int _themeIndex=0;
    int get themeIndex=>_themeIndex;


  Future readTheme() async{
    await Future.delayed(Duration(seconds: 1));
    String value =await _storage.read(key: _key)??"0";
    _themeIndex=int.parse(value);
    notifyListeners();
  }
    void setTheme(int index){
      _themeIndex=index;
      _storage.write(key: _key, value: _themeIndex.toString());
      notifyListeners();
    }
    void changeToSystem(){
      _themeIndex=0;
      _storage.write(key: _key, value: _themeIndex.toString());
      notifyListeners();
    }
    void changeToDark(){
      _themeIndex=1;
      _storage.write(key: _key, value: _themeIndex.toString());
      notifyListeners();
    }
    void changetoLight(){
      _themeIndex=2;
      _storage.write(key: _key, value: _themeIndex.toString());
      notifyListeners();
    }
}