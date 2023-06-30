import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../Class/wallet.dart';
import '../Class/transaction.dart';

class History extends StatefulWidget {
  
  
  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  Future<dynamic> getHistory(String ID) async{
    var w = Provider.of<Wallet>(context, listen: false);
    Map<String, String> header = {
      "Content-Type": "application/json",
      "X-API-Key": "48b8334b7203cbd82e05674e36dca01fb1598ec3"
    };
    print("Get Transaction History Service Started");
    final http.Response response = await http.get(Uri.parse("https://rest.cryptoapis.io/wallet-as-a-service/wallets/${ID}/ethereum/goerli/transactions"), headers: header);
    print("Get Transaction History Service Ended");
    print(response.body);
    var k = jsonDecode(response.body);
    if(response.statusCode == 200){
      print("Response copying started");
      setState(() {
        error = false;
      });
      w.Transaction.clear();
      for(dynamic t in k["data"]["items"]){
        transactionUnit tr = transactionUnit();
        tr.setTransactionDetails(t["transactionId"], t["timestamp"], t["status"], t["direction"]);
        tr.setTransactionValue(t["value"]["amount"], t["value"]["convertedAmount"], t["value"]["exchangeRateUnit"], t["value"]["symbol"]);
        tr.setTransactionFee(t["fee"]["amount"], t["fee"]["convertedAmount"], t["fee"]["exchangeRateUnit"], t["fee"]["symbol"]);
        if(t["senders"][0]["amount"] != "0"){
          tr.setTransactionSender(t["senders"][0]["address"], t["senders"][0]["amount"], t["senders"][0]["label"]);
          tr.setTransactionRecipient(t["recipients"][0]["address"], t["recipients"][0]["amount"], t["recipients"][0]["label"]);
        }
        else{
          tr.setTransactionSender(t["senders"][0]["address"], t["senders"][0]["amount"], '-');
          tr.setTransactionRecipient(t["recipients"][0]["address"], t["recipients"][0]["amount"], '-');
        }
        w.addTransaction(tr);
      }
      w.Transaction.sort((a,b) => a.TimeStamp.compareTo(b.TimeStamp));
      print("Response copying ended");
    }
    else{
      print("Error copying started");
      setState(() {
        error = true;
      });
      w.setError("Error: ${k["error"]["code"]}: ${k["error"]["message"]}");
      print("Error copying ended");
    }
    return k;
  }

  late bool error;
  late Future<dynamic> data;

  @override
  void initState() {
    super.initState();
    var w = Provider.of<Wallet>(context, listen: false);
    data = getHistory(w.getWalletID());
  }

  @override
  Widget build(BuildContext context) {
    var w = Provider.of<Wallet>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Transactions History", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 10,
        iconTheme: IconThemeData(
            color: Colors.black
        ),
      ),
      body: FutureBuilder(
        future: data,
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            if(error == false){
              return Container(
                child: w.getTransactionLength() == 0 ?
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("No tokens associated with this address",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 18
                      ),)
                  ],
                ):
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: w.getTransactionLength(),
                    itemBuilder: (context,index){
                      return Padding(
                          padding: const EdgeInsets.fromLTRB(7.5, 10, 7.5, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ExpansionTile(
                                backgroundColor: Colors.white,
                                childrenPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                                title: Text("Transaction No: ${index+1},\n\nID: ${w.Transaction[index].getTransactionID()}",
                                    style: TextStyle(
                                      fontSize: 17.5,
                                    ),
                                ),
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(height: 15,),
                                      Row(
                                        children: [
                                          Expanded(flex:1, child:Text("Timestamp", style: TextStyle(fontSize: 16),)),
                                          Expanded(flex:1, child: Text("${w.Transaction[index].getTransactionTimeStamp()}", style: TextStyle(fontSize: 16)))
                                        ],
                                      ),
                                      SizedBox(height: 15,),
                                      Row(
                                        children: [
                                          Expanded(flex:1, child:Text("Direction", style: TextStyle(fontSize: 16),)),
                                          Expanded(flex:1, child: Text("${w.Transaction[index].getTransactionDirection()}", style: TextStyle(fontSize: 16)))
                                        ],
                                      ),
                                      SizedBox(height: 15,),
                                      Row(
                                        children: [
                                          Expanded(flex:1, child:Text("Status", style: TextStyle(fontSize: 16),)),
                                          Expanded(flex:1, child: Text("${w.Transaction[index].getTransactionStatus()}", style: TextStyle(fontSize: 16)))
                                        ],
                                      ),
                                      SizedBox(height: 7,),
                                      Divider(thickness: 1.5,color: Colors.black,),
                                      SizedBox(height: 7,),
                                      Row(
                                        children: [
                                          Expanded(flex:1, child:Text("Value Details", style: TextStyle(fontSize: 18), textAlign: TextAlign.center,)),
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Row(
                                        children: [
                                          Expanded(flex:1, child:Text("Amount", style: TextStyle(fontSize: 16))),
                                          Expanded(flex:1, child: Text("${w.Transaction[index].getTransactionValueAmount()}", style: TextStyle(fontSize: 16)))
                                        ],
                                      ),
                                      SizedBox(height: 15,),
                                      Row(
                                        children: [
                                          Expanded(flex:1, child:Text("Converted Amount", style: TextStyle(fontSize: 16))),
                                          Expanded(flex:1, child: Text("${w.Transaction[index].getTransactionValueConvertedAmount()}", style: TextStyle(fontSize: 16)))
                                        ],
                                      ),
                                      SizedBox(height: 15,),
                                      Row(
                                        children: [
                                          Expanded(flex:1, child:Text("Exchange Rate Unit", style: TextStyle(fontSize: 16))),
                                          Expanded(flex:1, child: Text("${w.Transaction[index].getTransactionValueExchangeRateUnit()}", style: TextStyle(fontSize: 16)))
                                        ],
                                      ),
                                      SizedBox(height: 15,),
                                      Row(
                                        children: [
                                          Expanded(flex:1, child:Text("Symbol", style: TextStyle(fontSize: 16))),
                                          Expanded(flex:1, child: Text("${w.Transaction[index].getTransactionValueSymbol()}", style: TextStyle(fontSize: 16)))
                                        ],
                                      ),
                                      SizedBox(height: 7,),
                                      Divider(thickness: 1.5,color: Colors.black,),
                                      SizedBox(height: 7,),
                                      Row(
                                        children: [
                                          Expanded(flex:1, child:Text("Fee Details", style: TextStyle(fontSize: 18), textAlign: TextAlign.center)),
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Row(
                                        children: [
                                          Expanded(flex:1, child:Text("Amount", style: TextStyle(fontSize: 16))),
                                          Expanded(flex:1, child: Text("${w.Transaction[index].getTransactionFeeAmount()}", style: TextStyle(fontSize: 16)))
                                        ],
                                      ),
                                      SizedBox(height: 15,),
                                      Row(
                                        children: [
                                          Expanded(flex:1, child:Text("Converted Amount", style: TextStyle(fontSize: 16))),
                                          Expanded(flex:1, child: Text("${w.Transaction[index].getTransactionFeeConvertedAmount()}", style: TextStyle(fontSize: 16)))
                                        ],
                                      ),
                                      SizedBox(height: 15,),
                                      Row(
                                        children: [
                                          Expanded(flex:1, child:Text("Exchange Rate Unit", style: TextStyle(fontSize: 16))),
                                          Expanded(flex:1, child: Text("${w.Transaction[index].getTransactionFeeExchangeRateUnit()}", style: TextStyle(fontSize: 16)))
                                        ],
                                      ),
                                      SizedBox(height: 15,),
                                      Row(
                                        children: [
                                          Expanded(flex:1, child:Text("Symbol", style: TextStyle(fontSize: 16))),
                                          Expanded(flex:1, child: Text("${w.Transaction[index].getTransactionFeeSymbol()}", style: TextStyle(fontSize: 16)))
                                        ],
                                      ),
                                      SizedBox(height: 7,),
                                      Divider(thickness: 1.5,color: Colors.black,),
                                      SizedBox(height: 7,),
                                      Row(
                                        children: [
                                          Expanded(flex:1, child:Text("Sender Details", style: TextStyle(fontSize: 18), textAlign: TextAlign.center)),
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Row(
                                        children: [
                                          Expanded(flex:1, child:Text("Address", style: TextStyle(fontSize: 16))),
                                          Expanded(flex:1, child: Text("${w.Transaction[index].getTransactionSenderAddress()}", style: TextStyle(fontSize: 16)))
                                        ],
                                      ),
                                      SizedBox(height: 15,),
                                      Row(
                                        children: [
                                          Expanded(flex:1, child:Text("Amount", style: TextStyle(fontSize: 16))),
                                          Expanded(flex:1, child: Text("${w.Transaction[index].getTransactionSenderAmount()}", style: TextStyle(fontSize: 16)))
                                        ],
                                      ),
                                      SizedBox(height: 15,),
                                      Row(
                                        children: [
                                          Expanded(flex:1, child:Text("Label", style: TextStyle(fontSize: 16))),
                                          Expanded(flex:1, child: Text("${w.Transaction[index].getTransactionSenderLabel()}", style: TextStyle(fontSize: 16)))
                                        ],
                                      ),
                                      SizedBox(height: 7,),
                                      Divider(thickness: 1.5,color: Colors.black,),
                                      SizedBox(height: 7,),
                                      Row(
                                        children: [
                                          Expanded(flex:1, child:Text("Recipient Details", style: TextStyle(fontSize: 18), textAlign: TextAlign.center)),
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Row(
                                        children: [
                                          Expanded(flex:1, child:Text("Address", style: TextStyle(fontSize: 16))),
                                          Expanded(flex:1, child: Text("${w.Transaction[index].getTransactionRecipientAddress()}", style: TextStyle(fontSize: 16)))
                                        ],
                                      ),
                                      SizedBox(height: 15,),
                                      Row(
                                        children: [
                                          Expanded(flex:1, child:Text("Amount", style: TextStyle(fontSize: 16))),
                                          Expanded(flex:1, child: Text("${w.Transaction[index].getTransactionRecipientAmount()}", style: TextStyle(fontSize: 16)))
                                        ],
                                      ),
                                      SizedBox(height: 15,),
                                      Row(
                                        children: [
                                          Expanded(flex:1, child:Text("Label", style: TextStyle(fontSize: 16))),
                                          Expanded(flex:1, child: Text("${w.Transaction[index].getTransactionRecipientLabel()}", style: TextStyle(fontSize: 16)))
                                        ],
                                      ),
                                      SizedBox(height: 15,),
                                    ],
                                  )
                                ],
                              ),
                              Divider(thickness: 2,),
                            ],
                          )
                      );
                    }),
              );
            }
            else{
              return Center(
                child: Padding(
                  padding:  EdgeInsets.symmetric(
                      vertical: 12, horizontal: 7.5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("${w.getError()}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 18
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
          }
          return Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitRing(
                    size: 50,
                    color: Colors.black45,
                  ),
                  SizedBox(height: 15),
                  Text("Fetching Transaction History",
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18
                    ),
                  )
                ],
              ),
            ),
          );
        }
      )

    );
  }
}
