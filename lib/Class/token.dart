import 'package:flutter/cupertino.dart';

class tokenUnit extends ChangeNotifier{
  String Name = "";
  String ContractAddress = "";
  String Type = "";
  String Symbol = "";
  String Balance = "";

  void setToken(String n, String c, String t, String s, String b){
    print("Setting token started");
    Name = n;
    ContractAddress = c;
    Type = t;
    Symbol = s;
    Balance = b;
    notifyListeners();
    print("Setting token ended");
  }

  String getTokenName(){
    return Name;
  }


  String getTokenContractAddress(){
    return ContractAddress;
  }

  String getTokenType(){
    return Type;
  }

  String getTokenSymbol(){
    return Symbol;
  }

  String getTokenBalance(){
    return Balance;
  }
}


