import 'package:ethereumweb3wallet/Class/tokendetail.dart';
import 'package:ethereumweb3wallet/Class/wallet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Screens/WalletScreen.dart';
import 'Screens/InputScreen.dart';
import 'Screens/AddressScreen.dart';
import 'Screens/HomeScreen.dart';
import 'Screens/TokenScreen.dart';
import 'Screens/HistoryScreen.dart';

void main() {
  runApp(
    MultiProvider(providers: [
        ChangeNotifierProvider<Wallet>(create: (_) => Wallet(),),
        ChangeNotifierProvider<tokenDetails>(create: (_) => tokenDetails(),),
      ],
        child: MyApp(),
    )
  );
}


class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    var w = Provider.of<Wallet>(context, listen: false);
    return MaterialApp(
      routes: {
        "/" : (context)  => w.getLoggedIn() == false ? Login() :Home(),
        "/input" : (context) => Input(),
        "/address" : (context) => Address(),
        "/homeScreen" : (context) => Home(),
        "/token" : (context) => Token(),
        "/history": (context) => History(),
      },
    );
  }
}


