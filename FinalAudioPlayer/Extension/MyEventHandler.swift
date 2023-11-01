//
//  MyEventHandler.swift
//  FinalAudioPlayer
//
//  Created by Taha Hussein on 01/11/2023.
//

//import Flutter
//import UIKit
//
//public class MyEventPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
//    private var eventSink: FlutterEventSink?
//
//    public static func register(with registrar: FlutterPluginRegistrar) {
//        let channel = FlutterEventChannel(name: "my_event_channel", binaryMessenger: registrar.messenger())
//        let instance = MyEventPlugin()
//        channel.setStreamHandler(instance)
//    }
//
//    public func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
//        self.eventSink = eventSink
//        // Add code here to start listening for events on the iOS side.
//        // When an event occurs, call self.eventSink?(eventData) to send data to Flutter.
//        return nil
//    }
//
//    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
//        eventSink = nil
//        // Add code here to stop listening for events on the iOS side.
//        return nil
//    }
//}

/// in iOS
//Emit Events in iOS:
//
//When the event occurs in your iOS code, use eventSink to send data to the Flutter side. For example, you can emit an event when a button is tapped:
//swift
//Copy code
//// Inside your iOS code when an event occurs:
//let eventData = ["message": "Event data from iOS"]
//eventSink?(eventData)



/// in Flutter
/// import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//
//void main() {
//  runApp(MyApp());
//}
//
//class MyApp extends StatefulWidget {
//  @override
//  _MyAppState createState() => _MyAppState();
//}
//
//class _MyAppState extends State<MyApp> {
//  static const eventChannel = EventChannel('my_event_channel');
//  String eventData = "No event yet";
//
//  @override
//  void initState() {
//    super.initState();
//    eventChannel.receiveBroadcastStream().listen((data) {
//      setState(() {
//        eventData = data['message'];
//      });
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      home: Scaffold(
//        appBar: AppBar(
//          title: Text('Flutter Event Handling'),
//        ),
//        body: Center(
//          child: Text(eventData),
//        ),
//      ),
//    );
//  }
//}
//Now, when an event occurs on the iOS side, it will be sent to the Flutter app and displayed on the screen. Make sure you replace "my_event_channel" with the actual name of your event channel.
//
//
//
//
//
//
