import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Class/wallet.dart';

class Input extends StatelessWidget {

  var cor = TextEditingController();

  @override
  Widget build(BuildContext context) {
   var w = Provider.of<Wallet>(context);
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
            padding: EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                   w.getLogic()<3  ?
                  w.getLogic()== 1 ?
                  "Enter Wallet Name:"
                      : "Enter Wallet ID"
                      :
                  w.getLogic() == 3?
                  "Enter Address Label:"
                      : "Enter Address ",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18
                  ),
                ),
                SizedBox(height: 15,),
                TextField(
                  controller: cor,
                  decoration: InputDecoration(
                    hintText: w.getLogic() < 3 ?
                    w.getLogic() == 1 ?
                    "Type Wallet Name:"
                        : "Type Wallet ID"
                        :
                    w.getLogic() == 3?
                    "Type Address Label:"
                        : "Type Address ",
                    contentPadding: EdgeInsets.symmetric(vertical: 2.5,horizontal: 15),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10,),
                TextButton(onPressed: (){
                  if(w.getLogic() == 1){
                    w.setWalletName(cor.text);
                    Navigator.pushNamed(context, "/address");
                  }
                  else if(w.getLogic() == 2){
                    w.setWalletID(cor.text);
                    print(w.getWalletID());
                    Navigator.pushNamed(context, "/address");
                  }
                  else if(w.getLogic() == 3){
                    w.setAddressLabel(cor.text);
                    Navigator.pushNamed(context, "/homeScreen");
                  }
                  else if(w.getLogic() == 4){
                    w.setAddress(cor.text);
                    Navigator.pushNamed(context, "/homeScreen");
                  }
                },
                  child: Text("Submit",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16
                    ),
                  ),
                  style: ButtonStyle(
                      padding: MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(vertical: 10, horizontal: 15)),
                      side: MaterialStatePropertyAll<BorderSide>(BorderSide(
                        color: Colors.black,
                        width: 1,
                      )),
                      backgroundColor: MaterialStatePropertyAll<Color>(Colors.white)
                  ),
                )
              ],
            )
        ),
      ),
    );
  }
}
