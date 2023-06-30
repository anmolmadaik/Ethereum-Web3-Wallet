import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../Class/tokendetail.dart';

class Token extends StatefulWidget {
  
  @override
  State<Token> createState() => _TokenState();
}

class _TokenState extends State<Token> {

  Future<dynamic> getTokenDetails(String contract) async{
    var t = Provider.of<tokenDetails>(context, listen: false);
    Map<String, String> header = {
      "Content-Type": "application/json",
      "X-API-Key": "48b8334b7203cbd82e05674e36dca01fb1598ec3"
    };
    print("Get Token Detail Service Started");
    final http.Response response = await http.get(Uri.parse("https://rest.cryptoapis.io/blockchain-data/ethereum/goerli/addresses/${contract}/contract"),headers: header);
    print("Get Token Detail Service Ended");
    print(response.body);
    var k = jsonDecode(response.body);
    if(response.statusCode == 200){
      print("Response copying started");
      setState(() {
        error = false;
      });
      // tokenDetails t = tokenDetails();
      print(k["data"]["item"].length);
      if(k["data"]["item"].length > 5){
        t.setTokenDetails(k["data"]["item"]["tokenName"], k["data"]["item"]["tokenType"],
            k["data"]["item"]["tokenSymbol"], k["data"]["item"]["totalSupply"],
            k["data"]["item"]["blockchainSpecific"]["accounts"]["authorized"],
            k["data"]["item"]["blockchainSpecific"]["accounts"]["authorizedToMaintainLiabilities"],
            k["data"]["item"]["blockchainSpecific"]["accounts"]["unauthorized"],
            k["data"]["item"]["blockchainSpecific"]["amount"], k["data"]["item"]["blockchainSpecific"]["claimableBalances"],
            k["data"]["item"]["blockchainSpecific"]["issuer"]);
      }
      else{
        t.setTokenDetails(k["data"]["item"]["tokenName"], k["data"]["item"]["tokenType"],
            k["data"]["item"]["tokenSymbol"], k["data"]["item"]["totalSupply"],
            0, 0, 0, '-', '-', '-');
      }
      print("Response copying ended");
    }
    else{
      setState(() {
        error = true;
      });
      t.setError("Error: ${k["error"]["code"]}: ${k["error"]["message"]}");
    }
    return k;
  }

  late bool error;
  bool start = true;
  late Future<dynamic> data;

  @override
  void initState() {
    super.initState();
    // var w = Provider.of<tokenDetails>(context,listen: false);
  }

  @override
  Widget build(BuildContext context) {
    var arguments = (ModalRoute.of(context)?.settings.arguments?? <String,dynamic>{}) as Map;
    if(start == true){
      data = getTokenDetails(arguments["Contract"]);
      start = false;
    }
    var t = Provider.of<tokenDetails>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Token Details", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 10,
        iconTheme: IconThemeData(
            color: Colors.black
        ),
      ),
      body: FutureBuilder(
        future: data,
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            if(error == false){
                return Container(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(flex: 1, child: Text("Token Name")),
                            Expanded(
                                flex: 1,
                                child: Text("${t.getTokenDetailName()}"))
                          ],
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Divider(
                          color: Colors.black,
                          thickness: 1,
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: [
                            Expanded(flex: 1, child: Text("Token Type")),
                            Expanded(
                                flex: 1,
                                child: Text("${t.getTokenDetailType()}"))
                          ],
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Divider(
                          color: Colors.black,
                          thickness: 1,
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: [
                            Expanded(flex: 1, child: Text("Token Symbol")),
                            Expanded(
                                flex: 1,
                                child: Text("${t.getTokenDetailSymbol()}"))
                          ],
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Divider(
                          color: Colors.black,
                          thickness: 1,
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: [
                            Expanded(flex: 1, child: Text("Total Supply")),
                            Expanded(
                                flex: 1,
                                child: Text("${t.getTokenDetailSupply()}"))
                          ],
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Divider(
                          color: Colors.black,
                          thickness: 1,
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 1, child: Text("Accounts Authorized")),
                            Expanded(
                                flex: 1,
                                child: Text(
                                    "${t.getTokenDetailAuth().toString()}"))
                          ],
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Divider(
                          color: Colors.black,
                          thickness: 1,
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child:
                                    Text("Authorized to Maintain Liabilities")),
                            Expanded(
                                flex: 1,
                                child: Text(
                                    "${t.getTokenDetailAuthML().toString()}"))
                          ],
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Divider(
                          color: Colors.black,
                          thickness: 1,
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: [
                            Expanded(flex: 1, child: Text("Unauthorized")),
                            Expanded(
                                flex: 1,
                                child: Text("${t.getTokenDetailUnauth()}"))
                          ],
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Divider(
                          color: Colors.black,
                          thickness: 1,
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: [
                            Expanded(flex: 1, child: Text("Amount")),
                            Expanded(
                                flex: 1,
                                child: Text("${t.getTokenDetailAmount()}"))
                          ],
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Divider(
                          color: Colors.black,
                          thickness: 1,
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 1, child: Text("Claimable Balances")),
                            Expanded(
                                flex: 1,
                                child: Text("${t.getTokenDetailBalances()}"))
                          ],
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Divider(
                          color: Colors.black,
                          thickness: 1,
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: [
                            Expanded(flex: 1, child: Text("Issuer")),
                            Expanded(
                                flex: 1,
                                child: Text("${t.getTokenDetailIssuer()}"))
                          ],
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Divider(
                          color: Colors.black,
                          thickness: 1,
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
                        Text("${t.getError()}",
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
                  Text("Fetching Token Details",
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18
                    ),
                  )
                ],
              ),
            ),
          );

        },
      )

    );
  }
}
