import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../Class/wallet.dart';

class Address extends StatefulWidget {

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  Future<dynamic> walletDetails(String id) async {
    var w = Provider.of<Wallet>(context, listen: false);
    Map<String, String> header = {
      "Content-Type": "application/json",
      "X-API-Key": "48b8334b7203cbd82e05674e36dca01fb1598ec3"
    };
    print("Get Wallet Service Started");
    final http.Response response = await http.get(Uri.parse(
        "https://rest.cryptoapis.io/wallet-as-a-service/wallets/${id}/assets"),
        headers: header);
    print("Get Wallet Service Ended");
    var k = jsonDecode(response.body);
    print(response.body);
    if(response.statusCode == 200){
      setState(() {
        error = false;
      });
      print("Copying response started");
      w.setWalletName(k["data"]["item"]["walletName"]);
      w.setBlockChain(k["data"]["item"]["coins"][0]["blockchain"]);
      w.setBalance(k["data"]["item"]["coins"][0]["confirmedBalance"]);
      w.setUnit(k["data"]["item"]["coins"][0]["unit"]);
      print("Copying response ended");
    }
    else{
      print("Copying error started");
      setState(() {
        error = true;
      });
      w.setError("Error: ${k["error"]["code"]}: ${k["error"]["message"]}");
      print("Copying error ended");
    }
    return k;
  }

  Future<dynamic> createWallet(String name) async{
    var w = Provider.of<Wallet>(context, listen: false);
    Map<String, String> header = {
      "Content-Type": "application/json",
      "X-API-Key": "48b8334b7203cbd82e05674e36dca01fb1598ec3"
    };
    final bod = jsonEncode({
      "data": {
        "item": {
          "walletName": "${name}",
          "walletType": "test"
        }
      }
    });
    print("Create Wallet Service Started");
    final http.Response response = await http.post(Uri.parse("https://rest.cryptoapis.io/wallet-as-a-service/wallets/generate"),headers: header, body: bod);
    print("Create Wallet Service Ended");
    var k = jsonDecode(response.body);
    print(response.body);
    if(response.statusCode == 200){
      print("Copying response started");
      w.setWalletID(k["data"]["item"]["walletId"]);
      w.setBlockChain(k["data"]["item"]["coins"][0]["blockchain"]);
      w.setBalance(k["data"]["item"]["coins"][0]["confirmedBalance"]);
      w.setUnit(k["data"]["item"]["coins"][0]["confirmedUnit"]);
      setState(() {
        error = false;
      });
      print("Copying response ended");
    }
    else{
      print("Copying error started");
      setState(() {
        error = true;
      });
      w.setError("Error: ${k["error"]["code"]}: ${k["error"]["message"]}");
      print("Copying error ended");
    }
    return k;
  }

  late Future<dynamic> data;
  late bool error;

  @override
  void initState(){
    super.initState();
    var w = Provider.of<Wallet>(context, listen: false);
    if(w.getLogic() == 1){
      data = createWallet(w.getWalletNameD());
    }
    else{
      data = walletDetails(w.getWalletID());
    }
  }

  @override
  Widget build(BuildContext context) {
    var w = Provider.of<Wallet>(context);
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: Colors.black
          ),
          title: Text(
            "Ethereum Web3 Wallet", style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 10,
        ),
        backgroundColor: Colors.white,
        body: FutureBuilder(
             future: data,
            builder: (context, snapshot){
              if (snapshot.connectionState == ConnectionState.done) {
                if(error == false){
                  return Center(
                    child:
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 12, horizontal: 7.5),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 8),
                            child: Column(
                              children: [
                                Text(
                                    "Wallet Details",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 21,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.bold
                                    )
                                ),
                                SizedBox(height: 5,),
                                Divider(color: Colors.black, thickness: 1.5,),
                                SizedBox(height: 7.9,),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text("Wallet Name",
                                        style: TextStyle(
                                            fontSize: 18
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    // Text("${this.wallet["data"]["item"]["walletName"]}"),
                                    Expanded(
                                      flex: 3,
                                      child: Text("${w.getWalletNameD()}",
                                        style: TextStyle(
                                            fontSize: 18
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 7,),
                                Divider(color: Colors.black, thickness: 1.5,),
                                SizedBox(height: 7,),
                                Row(
                                  children: [
                                    Expanded(flex: 1, child: Text("Wallet ID",
                                      style: TextStyle(
                                          fontSize: 18
                                      ),)),
                                    // Text("${this.wallet["data"]["item"]["walletId"]}"),
                                    Expanded(flex: 3, child: Text("${w.getWalletID()}", style: TextStyle(
                                      fontSize: 18,
                                    ),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                    )
                                  ],
                                ),
                                SizedBox(height: 7.5,),
                                Divider(thickness: 1.5, color: Colors.black,),
                                SizedBox(height: 7.5,),
                                Row(
                                  children: [
                                    Expanded(flex: 1, child: Text("BlockChain",
                                      style: TextStyle(
                                          fontSize: 18
                                      ),)),
                                    //Text("${this.wallet["data"]["item"]["coins"][0]}"),
                                    Expanded(flex: 3, child: Text(
                                      "${w.getBlockChain()}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18
                                    ),)),
                                  ],
                                ),
                                SizedBox(height: 7,),
                                Divider(color: Colors.black, thickness: 1.5,),
                                SizedBox(height: 7,),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text("Balance", style: TextStyle(
                                          fontSize: 18
                                      ),),
                                    ),
                                    //Text("${this.wallet["data"]["item"]["coins"][0]["confirmedBalance"]} ${this.wallet["data"]["items"]["coins"][0]["unit"]}"),
                                    Expanded(
                                      flex: 3,
                                      child: Text("${w.getBalance()} ${w.getUnit()}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 18
                                        ),),
                                    )
                                  ],
                                ),
                                SizedBox(height: 7,),
                                Divider(color: Colors.black, thickness: 1.5,),
                                SizedBox(height: 7,),
                              ],
                            ),
                          ),
                          SizedBox(height: 35,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(onPressed: () {
                                w.setLogic(3);
                                Navigator.pushNamed(context, '/input');
                              },
                                child: Text("Generate a New Address",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18
                                  ),
                                ),
                                style: ButtonStyle(
                                  padding: MaterialStatePropertyAll<EdgeInsets>(
                                      EdgeInsets.symmetric(
                                          vertical: 13, horizontal: 20)),
                                  side: MaterialStatePropertyAll<BorderSide>(
                                      BorderSide(
                                        color: Colors.black,
                                        width: 1.5,
                                      )),
                                  backgroundColor: MaterialStatePropertyAll<
                                      Color>(
                                      Colors.white),
                                  fixedSize: MaterialStatePropertyAll<Size>(
                                      Size(250, 55)),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 15,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(onPressed: () {
                                w.setLogic(4);
                                Navigator.pushNamed(context, "/input");
                              },
                                child: Text("Use Existing Address",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18
                                  ),
                                ),
                                style: ButtonStyle(
                                    padding: MaterialStatePropertyAll<EdgeInsets>(
                                        EdgeInsets.symmetric(
                                            vertical: 13, horizontal: 20)),
                                    side: MaterialStatePropertyAll<BorderSide>(
                                        BorderSide(
                                          color: Colors.black,
                                          width: 1.5,

                                        )),
                                    fixedSize: MaterialStatePropertyAll<Size>(
                                        Size(250, 55)),
                                    backgroundColor: MaterialStatePropertyAll<
                                        Color>(Colors.white)
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
                      Text("Fetching Wallet Details",
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

