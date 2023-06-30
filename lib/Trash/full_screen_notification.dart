// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// Future<void> main() async {
//   // Always initialize Awesome Notifications
//   // initializeLocalNotifications()를 호출하여 항상 Awesome Notifications를 초기화
//   await NotificationController.initializeLocalNotifications();
//   runApp(const MyApp());
// }

// ///  *********************************************
// ///     NOTIFICATION CONTROLLER
// ///  *********************************************
// ///
// class NotificationController {
//   //NotificationController 클래스는 알림 컨트롤러를 정의합니다.
//   //initialAction은 초기 알림 액션을 저장하기 위한 변수입니다.
//   static ReceivedAction? initialAction;

//   ///  *********************************************
//   ///     INITIALIZATIONS
//   ///  *********************************************
//   ///
//   ///initializeLocalNotifications()는 로컬 알림을 초기화하는 메서드입니다.
//   static Future<void> initializeLocalNotifications() async {
//     //AwesomeNotifications().initialize()을 호출하여 알림 채널을 설정하고 초기화합니다.
//     await AwesomeNotifications().initialize(
//         null, //'resource://drawable/res_app_icon',//
//         [
//           //여기서는 alerts 채널을 설정하고 기본 설정 값을 사용합니다.
//           NotificationChannel(
//               // 알림 액션을 처리하는 메서드입니다.
//               channelKey: 'alerts',
//               channelName: 'Alerts',
//               channelDescription: 'Notification tests as alerts',
//               //소리 재생 여부(playSound)
//               playSound: true,
//               //소리 재생 여부(playSound)
//               onlyAlertOnce: true,
//               //그룹 알림 동작(groupAlertBehavior)
//               groupAlertBehavior: GroupAlertBehavior.Children,
//               //중요도(importance),
//               importance: NotificationImportance.High,
//               //기본 개인 정보 설정(defaultPrivacy)
//               defaultPrivacy: NotificationPrivacy.Private,
//               //기본 색상(defaultColor)
//               defaultColor: Colors.deepPurple,
//               //기본 색상(defaultColor)
//               ledColor: Colors.deepPurple)
//         ],
//         //debug 매개변수를 true로 설정하여 디버그 모드에서도 알림을 표시할 수 있습니다.
//         debug: true);

//     // Get initial notification action is optional
//     //getInitialNotificationAction()을 호출하여 초기 알림 액션을
//     //가져와 initialAction 변수에 저장합니다.
//     //initialAction 변수는 초기 알림 액션을 저장하기 위한 변수로,
//     //알림을 통해 앱이 실행될 때 사용됩니다. getInitialNotificationAction
//     //메서드를 호출하여 초기 알림 액션을 가져옵니다.
//     initialAction = await AwesomeNotifications()
//         .getInitialNotificationAction(removeFromActionEvents: false);
//   }

//   ///  *********************************************
//   ///     NOTIFICATION EVENTS LISTENER
//   ///  *********************************************
//   ///  Notifications events are only delivered after call this method
//   /// startListeningNotificationEvents()는 알림 이벤트를 수신하기 위해 알림
//   /// 리스너를 설정하는 메서드입니다.
//   /// AwesomeNotifications().setListeners()를 호출하여 알림 액션을 수신할 때
//   /// 호출될 콜백 함수를 등록합니다.
//   ///
//   /// startListeningNotificationEvents 메서드는 알림 이벤트를 수신하기 위해
//   /// 리스너를 등록합니다. setListeners 메서드를 호출하여 onActionReceivedMethod
//   /// 메서드를 알림 액션 수신 메서드로 등록합니다. 이 메서드는 알림 액션이 수신되었을
//   /// 때 실행되는 메서드입니다. ReceivedAction 객체를 매개변수로 받으며, 해당 객체는
//   /// 수신된 알림 액션에 대한 정보를 포함합니다.
//   static Future<void> startListeningNotificationEvents() async {
//     AwesomeNotifications()
//         .setListeners(onActionReceivedMethod: onActionReceivedMethod);
//   }

//   ///  *********************************************
//   ///     NOTIFICATION EVENTS
//   ///  *********************************************
//   ///
//   @pragma('vm:entry-point')
//   // 알림 액션 이벤트를 처리하는 메서드
//   static Future<void> onActionReceivedMethod(
//       ReceivedAction receivedAction) async {
//     // 알림 액션을 처리하는 메서드입니다.
//     if (receivedAction.actionType == ActionType.SilentAction ||
//         receivedAction.actionType == ActionType.SilentBackgroundAction) {
//       // For background actions, you must hold the execution until the end
//       print(
//           'Message sent via notification input: "${receivedAction.buttonKeyInput}"');
//       await executeLongTaskInBackground();
//     } else {
//       MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
//           '/notification-page',
//           (route) =>
//               (route.settings.name != '/notification-page') || route.isFirst,
//           arguments: receivedAction);
//     }
//   }

//   ///  *********************************************
//   ///     REQUESTING NOTIFICATION PERMISSIONS
//   ///  *********************************************
//   ///
//   static Future<bool> displayNotificationRationale() async {
//     // 알림 허용에 대한 권한 설명을 표시하는 메서드
//     bool userAuthorized = false;
//     BuildContext context = MyApp.navigatorKey.currentContext!;
//     await showDialog(
//         context: context,
//         builder: (BuildContext ctx) {
//           return AlertDialog(
//             title: Text('Get Notified!',
//                 style: Theme.of(context).textTheme.titleLarge),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Image.asset(
//                         'assets/animated-bell.gif',
//                         height: MediaQuery.of(context).size.height * 0.3,
//                         fit: BoxFit.fitWidth,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                     'Allow Awesome Notifications to send you beautiful notifications!'),
//               ],
//             ),
//             actions: [
//               TextButton(
//                   onPressed: () {
//                     Navigator.of(ctx).pop();
//                   },
//                   child: Text(
//                     'Deny',
//                     style: Theme.of(context)
//                         .textTheme
//                         .titleLarge
//                         ?.copyWith(color: Colors.red),
//                   )),
//               TextButton(
//                   onPressed: () async {
//                     userAuthorized = true;
//                     Navigator.of(ctx).pop();
//                   },
//                   child: Text(
//                     'Allow',
//                     style: Theme.of(context)
//                         .textTheme
//                         .titleLarge
//                         ?.copyWith(color: Colors.deepPurple),
//                   )),
//             ],
//           );
//         });
//     return userAuthorized &&
//         await AwesomeNotifications().requestPermissionToSendNotifications();
//   }

//   ///  *********************************************
//   ///     BACKGROUND TASKS TEST
//   ///  *********************************************
//   static Future<void> executeLongTaskInBackground() async {
//     print("starting long task");
//     await Future.delayed(const Duration(seconds: 4));
//     final url = Uri.parse("http://google.com");
//     final re = await http.get(url);
//     print(re.body);
//     print("long task done");
//   }

//   ///  *********************************************
//   ///     NOTIFICATION CREATION METHODS
//   ///  *********************************************
//   ///
//   static Future<void> createNewNotification() async {
//     bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
//     if (!isAllowed) isAllowed = await displayNotificationRationale();
//     if (!isAllowed) return;

//     await AwesomeNotifications().createNotification(
//         content: NotificationContent(
//             id: -1, // -1 is replaced by a random number
//             channelKey: 'alerts',
//             title: 'Huston! The eagle has landed!',
//             body:
//                 "A small step for a man, but a giant leap to Flutter's community!",
//             bigPicture: 'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
//             largeIcon: 'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
//             //'asset://assets/images/balloons-in-sky.jpg',
//             notificationLayout: NotificationLayout.BigPicture,
//             payload: {'notificationId': '1234567890'}),
//         actionButtons: [
//           NotificationActionButton(key: 'REDIRECT', label: 'Redirect'),
//           NotificationActionButton(
//               key: 'REPLY',
//               label: 'Reply Message',
//               requireInputText: true,
//               actionType: ActionType.SilentAction),
//           NotificationActionButton(
//               key: 'DISMISS',
//               label: 'Dismiss',
//               actionType: ActionType.DismissAction,
//               isDangerousOption: true)
//         ]);
//   }

//   static Future<void> scheduleNewNotification() async {
//     bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
//     if (!isAllowed) isAllowed = await displayNotificationRationale();
//     if (!isAllowed) return;

//     await AwesomeNotifications().createNotification(
//         content: NotificationContent(
//             id: -1, // -1 is replaced by a random number
//             channelKey: 'alerts',
//             title: "Huston! The eagle has landed!",
//             body:
//                 "A small step for a man, but a giant leap to Flutter's community!",
//             bigPicture: 'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
//             largeIcon: 'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
//             //'asset://assets/images/balloons-in-sky.jpg',
//             notificationLayout: NotificationLayout.BigPicture,
//             payload: {
//               'notificationId': '1234567890'
//             }),
//         actionButtons: [
//           NotificationActionButton(key: 'REDIRECT', label: 'Redirect'),
//           NotificationActionButton(
//               key: 'DISMISS',
//               label: 'Dismiss',
//               actionType: ActionType.DismissAction,
//               isDangerousOption: true)
//         ],
//         schedule: NotificationCalendar.fromDate(
//             date: DateTime.now().add(const Duration(seconds: 10))));
//   }

//   static Future<void> resetBadgeCounter() async {
//     await AwesomeNotifications().resetGlobalBadge();
//   }

//   static Future<void> cancelNotifications() async {
//     await AwesomeNotifications().cancelAll();
//   }
// }

// ///  *********************************************
// ///     MAIN WIDGET
// ///  *********************************************
// ///
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   // The navigator key is necessary to navigate using static methods
//   static final GlobalKey<NavigatorState> navigatorKey =
//       GlobalKey<NavigatorState>();

//   static Color mainColor = const Color(0xFF9D50DD);

//   @override
//   State<MyApp> createState() => _AppState();
// }

// class _AppState extends State<MyApp> {
//   // This widget is the root of your application.

//   static const String routeHome = '/', routeNotification = '/notification-page';

//   @override
//   void initState() {
//     NotificationController.startListeningNotificationEvents();
//     super.initState();
//   }

//   List<Route<dynamic>> onGenerateInitialRoutes(String initialRouteName) {
//     List<Route<dynamic>> pageStack = [];
//     pageStack.add(MaterialPageRoute(
//         builder: (_) =>
//             const MyHomePage(title: 'Awesome Notifications Example App')));
//     if (initialRouteName == routeNotification &&
//         NotificationController.initialAction != null) {
//       pageStack.add(MaterialPageRoute(
//           builder: (_) => NotificationPage(
//               receivedAction: NotificationController.initialAction!)));
//     }
//     return pageStack;
//   }

//   Route<dynamic>? onGenerateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case routeHome:
//         return MaterialPageRoute(
//             builder: (_) =>
//                 const MyHomePage(title: 'Awesome Notifications Example App'));

//       case routeNotification:
//         ReceivedAction receivedAction = settings.arguments as ReceivedAction;
//         return MaterialPageRoute(
//             builder: (_) => NotificationPage(receivedAction: receivedAction));
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Awesome Notifications - Simple Example',
//       navigatorKey: MyApp.navigatorKey,
//       onGenerateInitialRoutes: onGenerateInitialRoutes,
//       onGenerateRoute: onGenerateRoute,
//       theme: ThemeData(
//         primarySwatch: Colors.deepPurple,
//       ),
//     );
//   }
// }

// ///  *********************************************
// ///     HOME PAGE
// ///  *********************************************
// ///
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: const <Widget>[
//             Text(
//               'Push the buttons below to create new notifications',
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const SizedBox(width: 20),
//             FloatingActionButton(
//               heroTag: '1',
//               onPressed: () => NotificationController.createNewNotification(),
//               tooltip: 'Create New notification',
//               child: const Icon(Icons.outgoing_mail),
//             ),
//             const SizedBox(width: 10),
//             FloatingActionButton(
//               heroTag: '2',
//               onPressed: () => NotificationController.scheduleNewNotification(),
//               tooltip: 'Schedule New notification',
//               child: const Icon(Icons.access_time_outlined),
//             ),
//             const SizedBox(width: 10),
//             FloatingActionButton(
//               heroTag: '3',
//               onPressed: () => NotificationController.resetBadgeCounter(),
//               tooltip: 'Reset badge counter',
//               child: const Icon(Icons.exposure_zero),
//             ),
//             const SizedBox(width: 10),
//             FloatingActionButton(
//               heroTag: '4',
//               onPressed: () => NotificationController.cancelNotifications(),
//               tooltip: 'Cancel all notifications',
//               child: const Icon(Icons.delete_forever),
//             ),
//           ],
//         ),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }

// ///  *********************************************
// ///     NOTIFICATION PAGE
// ///  *********************************************
// ///
// class NotificationPage extends StatelessWidget {
//   const NotificationPage({Key? key, required this.receivedAction})
//       : super(key: key);

//   final ReceivedAction receivedAction;

//   @override
//   Widget build(BuildContext context) {
//     bool hasLargeIcon = receivedAction.largeIconImage != null;
//     bool hasBigPicture = receivedAction.bigPictureImage != null;
//     double bigPictureSize = MediaQuery.of(context).size.height * .4;
//     double largeIconSize =
//         MediaQuery.of(context).size.height * (hasBigPicture ? .12 : .2);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(receivedAction.title ?? receivedAction.body ?? ''),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.zero,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//                 height:
//                     hasBigPicture ? bigPictureSize + 40 : largeIconSize + 60,
//                 child: hasBigPicture
//                     ? Stack(
//                         children: [
//                           if (hasBigPicture)
//                             FadeInImage(
//                               placeholder: const NetworkImage(
//                                   'https://cdn.syncfusion.com/content/images/common/placeholder.gif'),
//                               //AssetImage('assets/images/placeholder.gif'),
//                               height: bigPictureSize,
//                               width: MediaQuery.of(context).size.width,
//                               image: receivedAction.bigPictureImage!,
//                               fit: BoxFit.cover,
//                             ),
//                           if (hasLargeIcon)
//                             Positioned(
//                               bottom: 15,
//                               left: 20,
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.all(
//                                     Radius.circular(largeIconSize)),
//                                 child: FadeInImage(
//                                   placeholder: const NetworkImage(
//                                       'https://cdn.syncfusion.com/content/images/common/placeholder.gif'),
//                                   //AssetImage('assets/images/placeholder.gif'),
//                                   height: largeIconSize,
//                                   width: largeIconSize,
//                                   image: receivedAction.largeIconImage!,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             )
//                         ],
//                       )
//                     : Center(
//                         child: ClipRRect(
//                           borderRadius:
//                               BorderRadius.all(Radius.circular(largeIconSize)),
//                           child: FadeInImage(
//                             placeholder: const NetworkImage(
//                                 'https://cdn.syncfusion.com/content/images/common/placeholder.gif'),
//                             //AssetImage('assets/images/placeholder.gif'),
//                             height: largeIconSize,
//                             width: largeIconSize,
//                             image: receivedAction.largeIconImage!,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       )),
//             Padding(
//               padding: const EdgeInsets.only(bottom: 20.0, left: 20, right: 20),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   RichText(
//                       text: TextSpan(children: [
//                     if (receivedAction.title?.isNotEmpty ?? false)
//                       TextSpan(
//                         text: receivedAction.title!,
//                         style: Theme.of(context).textTheme.titleLarge,
//                       ),
//                     if ((receivedAction.title?.isNotEmpty ?? false) &&
//                         (receivedAction.body?.isNotEmpty ?? false))
//                       TextSpan(
//                         text: '\n\n',
//                         style: Theme.of(context).textTheme.bodyMedium,
//                       ),
//                     if (receivedAction.body?.isNotEmpty ?? false)
//                       TextSpan(
//                         text: receivedAction.body!,
//                         style: Theme.of(context).textTheme.bodyMedium,
//                       ),
//                   ]))
//                 ],
//               ),
//             ),
//             Container(
//               color: Colors.black12,
//               padding: const EdgeInsets.all(20),
//               width: MediaQuery.of(context).size.width,
//               child: Text(receivedAction.toString()),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
