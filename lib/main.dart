import 'package:cashbook/ChangeNotifires/LinkedAccountInfo.dart';
import 'package:cashbook/ChangeNotifires/NavigationState.dart';
import 'package:cashbook/ChangeNotifires/ProfileState.dart';
import 'package:cashbook/ChangeNotifires/TransPopupNotifier.dart';
import 'package:cashbook/Components/CustomBottomBar.dart';
import 'package:cashbook/Components/SearchBar.dart';
import 'package:cashbook/Screens/HomePage.dart';
import 'package:cashbook/Screens/LoginPage.dart';
import 'package:cashbook/Screens/Profile.dart';
import 'package:cashbook/Screens/StartupInfopage.dart';
import 'package:cashbook/Screens/TransactionMonthlyPage.dart';
import 'package:cashbook/Services/Database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Components/TransactionPopUp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => TransPopupNotifier()),
    ChangeNotifierProvider(create: (context) => NavigationState()),
    ChangeNotifierProvider(create: (context) => LinkedAccountInfo()),
    ChangeNotifierProvider(create: (context) => ProfileState()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Colors.white,

          backgroundColor: Color.fromARGB(255, 255, 246, 162),
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(
          title: "CashBook",
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const List<Widget> NavigationPages = <Widget>[
    Icon(Icons.home),
    Icon(Icons.list),
  ];

  int SelectedIndex = 0;
  NavigationState navstate = NavigationState();
  void onItemTap(int index) {
    setState(() {
      SelectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    Start();
    super.initState();
  }

  bool whetherInitialSetupDone = false;
  void Start() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var info = Provider.of<LinkedAccountInfo>(this.context, listen: false);
    //Here Variable name is colab beacuse if  the account have data of collobartion account so for that. otherwise the
    //particular user email only
    info.SetLinkedAccountEmail(pref.getString('Colab').toString());
    Database.email = pref.getString('Colab').toString();
    print("database email 1" + Database.email);

    if (pref.getString('Name') != null) {
      var profileinfo = Provider.of<ProfileState>(this.context, listen: false);
      profileinfo.SetName(true);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LinkedAccountInfo>(builder: (context, colab, child) {
      return Consumer<ProfileState>(builder: (context, data, child) {
        return data.WhetherInitialSetupDone == true
            ? Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).colorScheme.background
                    ])),
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.black,
                    actions: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (Context) => Profile()));
                          },
                          child: CircleAvatar(
                            radius: 20,
                            child: Icon(
                              Icons.person,
                              color: Colors.amber[100],
                            ),
                            backgroundColor: Colors.amber[300],
                          ),
                        ),
                      )
                    ],
                  ),
                  bottomNavigationBar: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor),
                      child: CustomBottomBar()),
                  body: SingleChildScrollView(
                    child: Stack(
                      children: [
                        Consumer<NavigationState>(
                            builder: (context, cart, child) {
                          return cart.getSelectedPage() == 0
                              ? Homepage()
                              : TransactionMonthlyPage();
                        }),
                        Consumer<TransPopupNotifier>(
                            builder: (context, cart, child) {
                          return cart.getPopUpFlag() == 1
                              ? Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: TransactionPopUp())
                              : Container();
                        })
                      ],
                    ),
                  ),
                ),
              )
            : LoginPage();
      });
    });
  }
}
