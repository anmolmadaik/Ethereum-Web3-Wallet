import 'package:flutter/cupertino.dart';
import 'dart:core';
import 'token.dart';
import 'transaction.dart';

class Wallet extends ChangeNotifier{
  String WalletID = "";
  String WalletName = "";
  String Address = "";
  String AddressLabel = "";
  String AddressBal = "0";
  String AddressUnit = "";
  String Unit = "";
  String Balance = "0";
  String BlockChain = "";
  List<tokenUnit> Token = [];
  List<transactionUnit> Transaction = [];
  int logic = 0;
  bool loggedin = false;
  String error = "Error Occured";
  String amt =  "";
  var add = TextEditingController();
  var cor = TextEditingController();
  List<bool> sendorReceive = [
    true, false
  ];


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

  String getWalletID() {
    return WalletID;
  }

  void setWalletID(String s){
    print("Setting Wallet ID");
    WalletID = s;
    //await Future.delayed(Duration(milliseconds: 5));
    notifyListeners();
    print("Wallet ID set successfully");
  }

  String getWalletNameD(){
    return WalletName;
  }

  void setWalletName(String s) async{
    print("Setting Wallet Name");
    WalletName = s;
    await Future.delayed(Duration(milliseconds: 5));
    notifyListeners();
    print("Wallet set successfully");
  }

  String getAddress(){
    return Address;
  }

  void setAddress(String s){
    print("Setting Address");
    Address = s;
    //await Future.delayed(Duration(milliseconds: 5));
    notifyListeners();
    print("Address set successfully");
  }

  String getAddressLabel(){
    return AddressLabel;
  }

  void setAddressLabel(String s){
    print("Setting Address Label");
    AddressLabel = s;
    //await Future.delayed(Duration(milliseconds: 5));
    notifyListeners();
    print("Address Label set successfully");
  }

  String getAddressBalance(){
    return AddressBal;
  }

  void setAddressBalance(String s){
    print("Setting Address Balance");
    AddressBal = s;
    //await Future.delayed(Duration(milliseconds: 5));
    notifyListeners();
    print("Address Balance set Successfully");
  }

  String getAddressUnit(){
    return AddressUnit;
  }

  void setAddressUnit(String s){
    print("Setting Address Unit");
    AddressUnit = s;
    //await Future.delayed(Duration(milliseconds: 5));
    notifyListeners();
    print("Address Unit set successfully");
  }

  String getBalance(){
    return Balance;
  }

  void setBalance(String s){
    print("Setting Balance");
    Balance = s;
    notifyListeners();
    print("Balance set successfully");
  }

  String getUnit(){
    return Unit;
  }

  void setUnit(String s){
    print("Setting Unit");
    Unit = s;
    notifyListeners();
    print("Unit set successfully");
  }

  String getBlockChain(){
    return BlockChain;
  }

  void setBlockChain(String s){
    print("Setting BlockChain");
    BlockChain = s;
    notifyListeners();
    print("BlockChain set Successfully");
  }

  int getLogic(){
    return logic;
  }

  void setLogic(int i){
    print("Setting Logic");
    logic = i;
    //await Future.delayed(Duration(milliseconds: 5));
    notifyListeners();
    print("Logic Set Successfully");
  }

  bool getLoggedIn(){
    return loggedin;
  }

  void setLoggedin(bool b){
    print("Setting Logged in");
    loggedin = b;
    //await Future.delayed(Duration(milliseconds: 5));
    notifyListeners();
    print("Logged in set Successfully");
  }

  List<bool> getsor(){
    return sendorReceive;
  }

  void setsor(int i){
    print("Setting sor");
    sendorReceive[i] = true;
    sendorReceive[1-i] = false;
    //await Future.delayed(Duration(milliseconds: 5));
    notifyListeners();
    print("sor set successfully");
  }

  void addTransaction(transactionUnit t){
    print("Adding Transaction");
    Transaction.add(t);
    notifyListeners();
    print("Transaction Added");
  }

  void addToken(tokenUnit t){
    print("Adding Token");
    Token.add(t);
    notifyListeners();
    print("Token Added");
  }

  int getTokenLength(){
    return Token.length;
  }

  int getTransactionLength(){
    return Transaction.length;
  }


}