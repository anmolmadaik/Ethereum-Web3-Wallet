import 'dart:convert';
import 'package:ethereumweb3wallet/Class/wallet.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Class/token.dart';

class Home extends StatefulWidget {

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var add = TextEditingController();

  var amt = TextEditingController();

  Future<dynamic> generateAddress(String s, String ID) async{
    var w = Provider.of<Wallet>(context, listen: false);
    Map<String, String> header = {
      "Content-Type": "application/json",
      "X-API-Key": "48b8334b7203cbd82e05674e36dca01fb1598ec3"
    };
    final bod = jsonEncode({
      "data": {
        "item": {
          "label": "${s}",
        }
      }
    });
    print("Create Address Service Started");
    final http.Response response = await http.post(Uri.parse("https://rest.cryptoapis.io/wallet-as-a-service/wallets/${ID}/ethereum/goerli/addresses"),headers: header, body: bod);
    print("Create Address Service Ended");
    print(response.body);
    var k = jsonDecode(response.body);
    if(response.statusCode == 200){
      print("Copying Response started");
      setState(() {
        error = false;
      });
      w.setAddress(k["data"]["item"]["address"]);
      print("Copying Response ended");
    }
    else{
      print("Copying Error Started");
      setState(() {
        error = true;
      });
      w.setError("Error: ${k["error"]["code"]}: ${k["error"]["message"]}");
      print("Copying Error Ended");
    }
    return k;
  }

  Future<bool> transaction(String ID, List<bool> SOR, String amount, String Sender, String Receiver) async{
    Map<String, String> header = {
      "Content-Type": "application/json",
      "X-API-Key": "48b8334b7203cbd82e05674e36dca01fb1598ec3"
    };
    if(SOR[0] == true){ //send
      final bod = jsonEncode({
        "data":{
          "item":{
            "amount": "${amount}",
            "feePriority": "standard",
            "recipientAddress": "${Receiver}"
          }
        }
      });
      print("Send Transaction API started");
      final http.Response response = await http.post(Uri.parse("https://rest.cryptoapis.io/wallet-as-a-service/wallets/${ID}/ethereum/goerli/addresses/${Sender}/transaction-requests"), headers: header, body: bod);
      print("Send Transaction API ended");
      print(response.body);
      if(response.statusCode == 201){
        return true;
      }
      else{
        return false;
      }
    }
    else{
      final bod = jsonEncode({
        "data":{
          "item":{
            "amount": "${amount}",
            "feePriority": "standard",
            "recipientAddress": "${Sender}"
          }
        }
      });
      print("Receive Transaction API started");
      final http.Response response = await http.post(Uri.parse("https://rest.cryptoapis.io/wallet-as-a-service/wallets/${ID}/ethereum/goerli/addresses/${Receiver}/transaction-requests"), headers: header, body: bod);
      print("Receive Transaction API ended");
      print(response.body);
      if(response.statusCode == 201){
        return true;
      }
      else{
        return false;
      }
    }
  }

  void listAddress(String id) async{
    var w = Provider.of<Wallet>(context, listen: false);
    Map<String, String> header = {
      "Content-Type": "application/json",
      "X-API-Key": "48b8334b7203cbd82e05674e36dca01fb1598ec3"
    };
    print("Get Addresses Started");
    final http.Response response = await http.get(Uri.parse("https://rest.cryptoapis.io/wallet-as-a-service/wallets/${id}/ethereum/goerli/addresses"),headers: header);
    print("Get Addresses Ended");
    print(response.body);
    var k = jsonDecode(response.body);
    if(response.statusCode == 200){
      print("Response copying started");
      setState(() {
        error = false;
      });
      for(dynamic t in k["data"]["items"]){
        if(t["address"] == w.getAddress()){
          w.setAddressLabel(t["label"]);
          w.setAddressBalance(t["confirmedBalance"]["amount"]);
          w.setAddressUnit(t["confirmedBalance"]["unit"]);
        }
      }
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
  }

  Future<dynamic> getTokens(String Address) async{
    var w = Provider.of<Wallet>(context, listen: false);;
    Map<String, String> header = {
      "Content-Type": "application/json",
      "X-API-Key": "48b8334b7203cbd82e05674e36dca01fb1598ec3"
    };
    print("Get Token Service Started");
    final http.Response response = await http.get(Uri.parse("https://rest.cryptoapis.io/blockchain-data/ethereum/goerli/addresses/${Address}/tokens"),headers: header);
    print("Get Token Service Ended");
    print(response.body);
    var k = jsonDecode(response.body);
    if(response.statusCode == 200){
      print("Response copying started");
      setState(() {
        error = false;
      });
      w.Token.clear();
      for(dynamic t in k["data"]["items"]){
        tokenUnit to = tokenUnit();
        to.setToken(t["name"], t["contractAddress"], t["type"], t["symbol"], t["confirmedBalance"]);
        w.addToken(to);
      }
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
    var w = Provider.of<Wallet>(context,listen: false);
    w.setLoggedin(true);
    if(w.getLogic() == 3){
      generateAddress(w.getAddressLabel(), w.getWalletID());
    }
    listAddress(w.getWalletID());
    data = getTokens(w.getAddress());
  }

  @override
  Widget build(BuildContext context) {
    var w = Provider.of<Wallet>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Ethereum Web3 Wallet", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 10,
        actions: [
          IconButton(onPressed: (){
            Navigator.pushNamed(context, "/history");
          },
              icon: Icon(Icons.history))
        ],
        iconTheme: IconThemeData(
            color: Colors.black
        ),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 13.5, horizontal: 4),
            child: Column(
              children: [
                Row(
                  children: [Text("Wallet Name",textAlign: TextAlign.center,style: TextStyle(fontSize: 15),)],
                ),
                SizedBox(height: 5,),
                Row(
                  children: [Expanded(child: Text("${w.getWalletNameD()}", overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 15)))],
                ),
                SizedBox(height: 5,),
                Divider(thickness: 1, color: Colors.black,),
                SizedBox(height: 5,),
                Row(
                  children: [Text("Wallet ID",textAlign: TextAlign.center,style: TextStyle(fontSize: 15))],
                ),
                SizedBox(height: 5,),
                Row(
                  children: [Expanded(child: Text("${w.getWalletID()}", style: TextStyle(fontSize: 15)))],
                ),
                SizedBox(height: 5,),
                Divider(thickness: 1, color: Colors.black,),
                SizedBox(height: 5,),
                Row(
                  children: [Text("BlockChain",textAlign: TextAlign.center,style: TextStyle(fontSize: 15))],
                ),
                SizedBox(height: 5,),
                Row(
                  children: [Text("${w.getBlockChain()}", overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 15))],
                ),
                SizedBox(height: 5,),
                Divider(thickness: 1, color: Colors.black,),
                SizedBox(height: 5,),
                Row(
                  children: [Text("Wallet Balance",textAlign: TextAlign.center,style: TextStyle(fontSize: 15))],
                ),
                SizedBox(height: 5,),
                Row(
                  children: [Text("${w.getBalance()} ${w.getUnit()}", overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 15))],
                ),
                SizedBox(height: 5,),
                Divider(thickness: 1, color: Colors.black,),
                SizedBox(height: 5,),
                Row(
                  children: [Text("Address Label",textAlign: TextAlign.center,style: TextStyle(fontSize: 15))],
                ),
                SizedBox(height: 5,),
                Row(
                  children: [Expanded(child: Text("${w.getAddressLabel()}", overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 15)))],
                ),
                SizedBox(height: 5,),
                Divider(thickness: 1, color: Colors.black,),
                SizedBox(height: 5,),
                Row(
                  children: [Text("Address",textAlign: TextAlign.center,style: TextStyle(fontSize: 15))],
                ),
                SizedBox(height: 5,),
                Row(
                  children: [Expanded(child: Text("${w.getAddress()}", style: TextStyle(fontSize: 15)))],
                ),
                SizedBox(height: 5,),
                Divider(thickness: 1, color: Colors.black,),
                SizedBox(height: 5,),
                Row(
                  children: [Text("Address Balance",textAlign: TextAlign.center,style: TextStyle(fontSize: 15))],
                ),
                SizedBox(height: 5,),
                Row(
                  children: [Expanded(child: Text("${w.getAddressBalance()} ${w.getAddressUnit()}", overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 15)))],
                ),
                SizedBox(height: 5,),
                Divider(thickness: 1, color: Colors.black,),
                SizedBox(height: 5,),
                TextButton(onPressed: (){generateAddress(w.getAddressLabel(), w.getWalletID());}, child: Text("Generate New Address"))
              ],
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: data,
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done){
              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            child: Column(
                              children: [
                                ToggleButtons(
                                  textStyle: TextStyle(
                                      fontSize: 15
                                  ),
                                  isSelected: w.getsor(),
                                  onPressed: (int index){
                                    w.setsor(index);
                                  },
                                  fillColor: Colors.black,
                                  selectedColor: Colors.white,
                                  color: Colors.grey[400],
                                  borderColor: Colors.grey[400],
                                  selectedBorderColor: Colors.black,
                                  borderWidth: 1.5,
                                  constraints: const BoxConstraints(
                                    minHeight: 30.0,
                                    minWidth: 80.0,
                                  ),
                                  children: [
                                    Text("Send"),
                                    Text("Receive")
                                  ],
                                ),
                                SizedBox(height: 5,),
                                Row(
                                  children: [
                                    Text("Enter Address", style: TextStyle(fontSize: 15),),
                                    SizedBox(width: 10,),
                                    Expanded(child: SizedBox(
                                      height: 35,
                                      child: TextField(
                                        controller: add,
                                        style: TextStyle(
                                            fontSize: 15
                                        ),
                                        decoration: InputDecoration(
                                            hintText: w.getsor()[0] == true ? "Type Recipient Address" : "Type Sender Address",
                                            border: OutlineInputBorder(),
                                            contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10)
                                        ),
                                      ),
                                    )),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Text("Enter Amount", style: TextStyle(fontSize: 15),),
                                    SizedBox(width: 10,),
                                    Expanded(child: SizedBox(
                                      height: 35,
                                      child: TextField(
                                        controller: amt,
                                        style: TextStyle(
                                            fontSize: 15
                                        ),
                                        decoration: InputDecoration(
                                            hintText: "Type Amount to be Transeferred",
                                            border: OutlineInputBorder(),
                                            contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10)
                                        ),
                                      ),
                                    )),
                                  ],
                                ),
                                SizedBox(height: 2.1,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(onPressed: () async{
                                      var k = await transaction(w.getWalletID(),w.getsor(),amt.text,w.getAddress(),add.text);
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text("Transaction Result"),
                                            content: k == true? Text("Transaction request created successfully") : Text("${w.getError()}"),
                                            actions: [
                                              TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text("OK"))
                                            ],
                                          ),
                                      );
                                    },
                                      child: Text("Perform Transaction", style: TextStyle(color: Colors.white),),
                                      style: ButtonStyle(
                                        //    padding: MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(vertical: 13, horizontal: 20)),
                                          side: MaterialStatePropertyAll<BorderSide>(BorderSide(
                                            color: Colors.black,
                                            width: 1.5,
                                          )),
                                          backgroundColor: MaterialStatePropertyAll<Color>(Colors.black),
                                          shape: MaterialStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(
                                              borderRadius: BorderRadius.zero
                                          )),
                                          overlayColor: MaterialStateProperty.resolveWith(
                                                  (Set<MaterialState> states){
                                                if(states.contains(MaterialState.pressed)){
                                                  return Colors.white38;
                                                }
                                                return Colors.transparent;
                                              }
                                          )
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                    ),
                    // Divider(color: Colors.black, thickness: 0.5,),
                    Expanded(
                        flex: 2,
                        child: Card(
                          color: Colors.white,
                          child: error == false?
                            w.getTokenLength() == 0 ?
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
                              itemCount: w.getTokenLength(),
                              itemBuilder: (context,index){
                                return TextButton(
                                  onPressed: (){
                                    // Navigator.pushNamed(context, "/token", arguments: {"Contract": "${tokens["data"]["items"][index]["contractAddress"]}");
                                    Navigator.pushNamed(context, "/token", arguments: {"Contract": "${w.Token[index].getTokenContractAddress()}", "Use": true});
                                  },
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll<Color>(Colors.white),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(5, 7.5, 5, 0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                    flex: 1,
                                                    child: Text("Name: ${w.Token[index].getTokenName()}", style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.normal),)
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child:
                                                  Text("Type: ${w.Token[index].getTokenType()}", style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.normal),),
                                                  //Text("Name: ${token["items"][index]["name"]}");
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child:
                                                  Text("Symbol: ${w.Token[index].getTokenSymbol()}", style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.normal),),
                                                  //Text("Name: ${token["items"][index]["name"]}");
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 5,),
                                            Row(
                                              children: [
                                                Expanded(child: Text("Contract ${w.Token[index].getTokenContractAddress()}", overflow: TextOverflow.fade, style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.normal), ))
                                              ],
                                            ),
                                            SizedBox(height: 5,),
                                            Row(
                                              children: [
                                                Text("Balance: ${w.Token[index].getTokenBalance()}", style: TextStyle(fontSize: 15, color: Colors.black,  fontWeight: FontWeight.normal), )
                                              ],
                                            ),
                                            SizedBox(height: 10,),
                                            Divider(color: Colors.black, thickness: 1.5,),
                                            //SizedBox(height: 10,),
                                          ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }):Column(
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
                        )
                    ),
                  ],
                ),
              );
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
                  Text("Fetching Token Lists",
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


