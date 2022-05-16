import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:zarnooshe/splash.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      // navigation bar color
      statusBarColor: Color(0xfffe6405),
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool connected;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: OfflineBuilder(
          connectivityBuilder: (
            BuildContext context,
            ConnectivityResult connectivity,
            Widget child,
          ) {
            connected = connectivity != ConnectivityResult.none;
            if (connected == false) {
              Future.delayed(Duration.zero, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RouterOfflineScreen()),
                );
              });
            }
            return const SecondClass();
          },
          builder: (BuildContext context) {
            return const SecondClass();
          },
        )));
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = true;

  late WebViewController webView;

  Future<bool> _onBack() async {
    var value = await webView.canGoBack();

    if (value) {
      await webView.goBack();
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBack(),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              WebView(
                initialUrl: 'https://zarnooshe.com/',
                javascriptMode: JavascriptMode.unrestricted,
                onPageStarted: (url) {
                  setState(() {
                    isLoading = true;
                  });
                },
                onPageFinished: (status) {
                  setState(() {
                    isLoading = false;
                  });
                },
                onWebViewCreated: (WebViewController controller) {
                  webView = controller;
                },
              ),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Color(0xfffe6405),
                        color: Color(0xff00c3ff),
                      ),
                    )
                  : Stack(),
            ],
          ),
        ),
      ),
    );
  }
}

class RouterOfflineScreen extends StatefulWidget {
  const RouterOfflineScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RouterOfflineScreenState createState() => _RouterOfflineScreenState();
}

class _RouterOfflineScreenState extends State<RouterOfflineScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset('assets/Offline.png', fit: BoxFit.cover),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'شما آفلاین هستید',
                  style: TextStyle(
                      fontWeight: FontWeight.w100,
                      fontSize: 40,
                      fontFamily: 'av'),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyApp()));
                    },
                    child: const Text(
                      'تلاش دوباره',
                      style: TextStyle(fontSize: 18, fontFamily: 'ir'),
                    )),
                const SizedBox(
                  height: 30.0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
