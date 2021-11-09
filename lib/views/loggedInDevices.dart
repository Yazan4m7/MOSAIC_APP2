// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:mosaic_doctors/models/mobileDevice.dart';
// import 'package:mosaic_doctors/services/security.dart';
//
// import 'home.dart';
//
//
// class LoggedInDevices extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//       title: 'Logged In Devices',
//       theme: new ThemeData(
//           primaryColor: Color.fromRGBO(58, 66, 86, 1.0), fontFamily: 'Raleway'),
//       home: new ListPage(title: 'Logged In Devices'),
//       // home: DetailPage(),
//     );
//   }
// }
//
// class ListPage extends StatefulWidget {
//   ListPage({Key? key, this.title}) : super(key: key);
//
//   final String? title;
//
//   @override
//   _ListPageState createState() => _ListPageState();
// }
//
// class _ListPageState extends State<ListPage> {
//   List? devices;
//   Future? loggedInDevices;
//   String? myDeviceUUID;
//   @override
//   void initState() {
//     getDeviceID();
//     loggedInDevices = Security.getLoggedInDevices();
//     super.initState();
//   }
//   refresh(){
//     loggedInDevices = Security.getLoggedInDevices();
//   }
//   getDeviceID() async{
//     myDeviceUUID = await Security.getDeviceUUID();
//   }
//   @override
//   Widget build(BuildContext context) {
//
//     ListTile makeListTile(Device device) => ListTile(
//       contentPadding:
//       EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//       leading: Container(
//         padding: EdgeInsets.only(right: 12.0),
//         decoration: new BoxDecoration(
//             border: new Border(
//                 right: new BorderSide(width: 1.0, color: Colors.white24))),
//         child: Icon( device.platform=="Android" ? Icons.android : Icons.phone_iphone, color: Colors.white),
//       ),
//       title: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8.0),
//         child: Text(
//           myDeviceUUID == device.deviceUID ? "${device.name} (This Device)" : device.name!  ,
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//       ),
//       // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
//
//       subtitle: Column(
//         children: [
//           Row(
//             children: <Widget>[
//
//               Expanded(
//                 flex: 10,
//                 child: Padding(
//                     padding: EdgeInsets.only(left: 0.0),
//                     child: Text("IP : " + device.ip!,
//                         style: TextStyle(color: Colors.white))),
//               )
//             ],
//           ),
//           Row(
//             children: <Widget>[
//
//               Expanded(
//                 flex: 5,
//                 child: Padding(
//                     padding: EdgeInsets.only(left: 0.0),
//                     child: Text("Platform : " + device.platform! +' '+ device.os!,
//                         style: TextStyle(color: Colors.white))),
//               )
//             ],
//           ), Row(
//             children: <Widget>[
//
//               Expanded(
//                 flex: 4,
//                 child: Padding(
//                     padding: EdgeInsets.only(left: 0.0),
//                     child: Text("First log in : " + device.dateCreated!.substring(0,10),
//                         style: TextStyle(color: Colors.white))),
//               )
//             ],
//           ),
//           Row(
//             children: <Widget>[
//
//               Expanded(
//                 flex: 4,
//                 child: Padding(
//                     padding: EdgeInsets.only(left: 0.0),
//                     child: Text("Logged in ? " + (device.isAllowed == '1' ? "YES" : "NO"),
//                         style: TextStyle(color: Colors.white))),
//               )
//             ],
//           ),
//         ],
//       ),
//       trailing:
//       myDeviceUUID != device.deviceUID ? IconButton(icon: Icon(Icons.logout, color: Colors.white, size: 30.0),
//         onPressed: () async{
//
//           await Security.logoutDevice(device.deviceUID);
//           refresh();
//           setState(() {
//
//           });
//
//         },) : IconButton(icon: Icon(Icons.logout, color: Colors.grey, size: 30.0),
//         onPressed: (){
//
//         },) ,
//
//     );
//
//     Card makeCard(Device device) => Card(
//       elevation: 8.0,
//       margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
//       child: Container(
//         decoration: BoxDecoration(color: device.isAllowed=='1' ? Color(0xff333333) : Color(0xff565656)),
//         child: makeListTile(device),
//       ),
//     );
//
//     final makeBody = Container(
//       // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//               begin: Alignment.bottomLeft,
//               end: Alignment.topRight,
//               colors: [Color(0xffc3c3c3), Colors.white70]),
//         ),
//         child: FutureBuilder(
//         future: loggedInDevices,
//         builder: (context, list) {
//           if (list.connectionState ==
//               ConnectionState.waiting) {
//             return Center(
//               child: Container(
//
//                 child: SpinKitWanderingCubes(
//                   color: Colors.black,
//                 ),
//               ),
//             );
//           }if (list.data ==
//     null) {
//             return Center(child: Text("No Devices"));
//           }
//       return ListView.builder: (
//           scrollDirection: Axis.vertical,
//           itemCount: list
//               .data.length,
//           itemBuilder: (context, index) {
//             Device device =
//             list.data[index];
//             return makeCard(device);};
//
//
//         }));
//
//
//
//     final topAppBar = AppBar(
//       elevation: 0.5,
//       backgroundColor: Color(0xff333333),
//       title: Text(widget.title!),
//     actions: [
//       IconButton(icon: Icon(Icons.clear),onPressed: (){
//         Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
//             HomeView()), (Route<dynamic> route) => false);}
//         )
//     ],
//     );
//
//     return Scaffold(
//
//       appBar: topAppBar,
//       body: makeBody,
//
//     );
//   }
// }
//
