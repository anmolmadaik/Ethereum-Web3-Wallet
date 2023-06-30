import 'package:flutter/cupertino.dart';

class transactionUnit extends ChangeNotifier{
  String ID = "";
  DateTime TimeStamp = DateTime.now();
  String Status = "";
  String Direction = "";
  String valueAmount = "";
  String valueConvertedAmount = "";
  String valueExchangeRateUnit = "";
  String valueSymbol = "";
  String feeAmount = "";
  String feeConvertedAmount = "";
  String feeExchangeRateUnit = "";
  String feeSymbol = "";
  String senderAddress = "";
  String senderAmount = "";
  String senderLabel = "";
  String recipientAddress = "";
  String recipientAmount = "";
  String recipientLabel = "";

  void setTransactionDetails(String i, int t, String s, String d){
    print("Setting Transaction Details Starting");
    ID = i;
    TimeStamp = DateTime.fromMillisecondsSinceEpoch(t * 1000);
    Status = s;
    Direction = d;
    notifyListeners();
    print("Setting Transaction Details Ending");
  }

  void setTransactionValue(String a, String ca, String era, String s){
    print("Setting Transaction Value Starting");
    valueAmount = a;
    valueConvertedAmount = ca;
    valueExchangeRateUnit = era;
    valueSymbol = s;
    notifyListeners();
    print("Setting Transaction Value Ending");
  }

  void setTransactionFee(String a, String ca, String era, String s){
    print("Setting Transaction Fee Starting");
    feeAmount = a;
    feeConvertedAmount = ca;
    feeExchangeRateUnit = era;
    feeSymbol = s;
    notifyListeners();
    print("Setting Transaction Fee Ending");
  }

  void setTransactionSender(String ad, String amt, String l){
    print("Setting Transaction Sender Starting");
    senderAddress = ad;
    senderAmount = amt;
    senderLabel = l;
    notifyListeners();
    print("Setting Transaction Sender Ending");
  }

  void setTransactionRecipient(String ad, String amt, String l){
    print("Setting Transaction Recipient Starting");
    recipientAddress = ad;
    recipientAmount = amt;
    recipientLabel = l;
    notifyListeners();
    print("Setting Transaction Recipient Ending");
  }

  String getTransactionID(){
    return ID;
  }

  DateTime getTransactionTimeStamp(){
    return TimeStamp;
  }

  String getTransactionStatus(){
    return Status;
  }

  String getTransactionDirection(){
    return Direction;
  }

  String getTransactionValueAmount(){
    return valueAmount;
  }

  String getTransactionValueConvertedAmount(){
    return valueConvertedAmount;
  }

  String getTransactionValueExchangeRateUnit(){
    return valueExchangeRateUnit;
  }

  String getTransactionValueSymbol(){
    return valueSymbol;
  }

  String getTransactionFeeAmount(){
    return feeAmount;
  }

  String getTransactionFeeConvertedAmount(){
    return feeConvertedAmount;
  }

  String getTransactionFeeExchangeRateUnit(){
    return feeExchangeRateUnit;
  }

  String getTransactionFeeSymbol(){
    return feeSymbol;
  }

  String getTransactionSenderAddress(){
    return senderAddress;
  }

  String getTransactionSenderAmount(){
    return senderAmount;
  }

  String getTransactionSenderLabel(){
    return senderLabel;
  }

  String getTransactionRecipientAddress(){
    return recipientAddress;
  }

  String getTransactionRecipientAmount(){
    return recipientAmount;
  }

  String getTransactionRecipientLabel(){
    return recipientLabel;
  }

}