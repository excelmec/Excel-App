import 'dart:async';

import 'package:flutter/material.dart';

class LoginStatus with ChangeNotifier{

 late StreamController userdata;

  StreamController get data => userdata;

  LoginStatus(){
    userdata=StreamController();
  }

  setData(dynamic data){
    userdata.add(data);
    // notifyListeners();
  }

}