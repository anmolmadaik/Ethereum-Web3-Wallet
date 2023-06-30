import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Class/wallet.dart';

class Login extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Wallet w = Provider.of<Wallet>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Ethereum Web3 Wallet", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 10,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 35,),
                  TextButton(onPressed: (){
                    w.setLogic(1);
                    Navigator.pushNamed(context,'/input');
                  },
                    child: Text("Create a New Wallet",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18
                      ),
                    ),
                    style: ButtonStyle(
                        padding: MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(vertical: 13, horizontal: 20)),
                        side: MaterialStatePropertyAll<BorderSide>(BorderSide(
                          color: Colors.black,
                          width: 1.5,
                        )),
                        backgroundColor: MaterialStatePropertyAll<Color>(Colors.white)
                    ),
                  )
                ],
              ),
              SizedBox(height: 15,),
              Divider(color: Colors.black, thickness: 3,),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: (){
                    w.setLogic(2);
                    Navigator.pushNamed(context,"/input");
                  },
                    child: Text("Use Existing Wallet",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18
                      ),
                    ),
                    style: ButtonStyle(
                        padding: MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(vertical: 13, horizontal: 20)),
                        side: MaterialStatePropertyAll<BorderSide>(BorderSide(
                          color: Colors.black,
                          width: 1.5,
                        )),
                        backgroundColor: MaterialStatePropertyAll<Color>(Colors.white)
                    ),
                  ),
                  SizedBox(width: 35,),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
