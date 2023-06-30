import 'package:flutter/cupertino.dart';

class tokenDetails extends ChangeNotifier{
  String Name = "";
  String Type = "";
  String Symbol = "";
  String Supply = "";
  int auth = 0;
  int authml = 0;
  int unauth = 0;
  String amount = "";
  String balances = "";
  String issuer = "";
  String error = "Error Occured";

  String getError(){
    return error;
  }

  void setError(String e){
    print("Setting Address");
    error = e;
    // await Future.delayed(Duration(milliseconds: 5));
    notifyListeners();
    print("Error set Successfully");
  }

  void setTokenDetails(String n, String t, String sy, String su, int a, int am, int u, String amt, String b, String i){
    print("Setting token detail started");
    Name = n;
    Type = t;
    Symbol = sy;
    Supply = su;
    auth = a;
    authml = am;
    unauth = u;
    amount = amt;
    balances = b;
    issuer = i;
    notifyListeners();
    print("Setting token detail ended");
  }

  String getTokenDetailName(){
    return Name;
  }

  String getTokenDetailType(){
    return Type;
  }

  String getTokenDetailSymbol(){
    return Symbol;
  }

  String getTokenDetailSupply(){
    return Supply;
  }

  int getTokenDetailAuth(){
    return auth;
  }

  int getTokenDetailAuthML(){
    return authml;
  }

  int getTokenDetailUnauth(){
    return unauth;
  }

  String getTokenDetailAmount(){
    return amount;
  }

  String getTokenDetailBalances(){
    return amount;
  }

  String getTokenDetailIssuer(){
    return amount;
  }

}