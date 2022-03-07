// import 'dart:ui';
// import 'package:flutter/foundation.dart';
// import 'package:image/image.dart' as imm;
// import 'package:barcode_image/barcode_image.dart';
// import 'package:blue_thermal_printer/blue_thermal_printer.dart';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:flutter/services.dart';
// import 'package:path_provider/path_provider.dart';

// class Home extends StatefulWidget {
//   const Home({
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

//   List<BluetoothDevice> _devices = [];
//   BluetoothDevice? _device;
//   bool _connected = false;
//   bool _pressed = false;
//   String? pathImage;
//   String? eVoucherPath;

//   @override
//   void initState() {
//     super.initState();
//     initPlatformState();
//     initSavetoPath();
//   }

//   initSavetoPath() async {
//     //read and write
//     //image max 300px X 300px
//     const filename = 'yourlogo.png';
//     var bytes = await rootBundle.load("assets/images/logo.png");
//     String dir = (await getApplicationDocumentsDirectory()).path;
//     writeToFile(bytes, '$dir/$filename');
//     setState(() {
//       pathImage = '$dir/$filename';
//     });
//   }

//   Future<void> initPlatformState() async {
//     List<BluetoothDevice> devices = [];

//     try {
//       devices = await bluetooth.getBondedDevices();
//     } on PlatformException {
//       if (kDebugMode) {
//         print("object");
//       }
//     }

//     bluetooth.onStateChanged().listen((state) {
//       switch (state) {
//         case BlueThermalPrinter.CONNECTED:
//           setState(() {
//             _connected = true;
//             _pressed = false;
//           });
//           break;
//         case BlueThermalPrinter.DISCONNECTED:
//           setState(() {
//             _connected = false;
//             _pressed = false;
//           });
//           break;
//         default:
//           if (kDebugMode) {
//             print(state);
//           }
//           break;
//       }
//     });

//     if (!mounted) return;
//     setState(() {
//       _devices = devices;
//     });
//   }

//   Map<String, dynamic> myMap = {
//     "id": "356",
//     "categoryParentId": "0",
//     "categoryName": "Shahid VIP",
//     "amazonImage":
//         "https://likecard-space.fra1.digitaloceanspaces.com/categories/2899b-.png",
//     "childs": [
//       {
//         "id": "361",
//         "categoryParentId": "356",
//         "categoryName": "Shahid vip KSA",
//         "amazonImage":
//             "https://likecard-space.fra1.digitaloceanspaces.com/categories/1bf32-shahedksa.png",
//         "childs": [
//           {
//             "id": "676",
//             "categoryParentId": "361",
//             "categoryName": "Shahid vip",
//             "amazonImage":
//                 "https://likecard-space.fra1.digitaloceanspaces.com/categories/b4ff8-f2d10-subcategory-vip.png",
//             "childs": []
//           },
//           {
//             "id": "677",
//             "categoryParentId": "361",
//             "categoryName": "KSA Shahid vip + sport",
//             "amazonImage":
//                 "https://likecard-space.fra1.digitaloceanspaces.com/categories/03694-subcategory-sport.png",
//             "childs": []
//           },
//           {
//             "id": "718",
//             "categoryParentId": "361",
//             "categoryName": "Shahid vip \"Imagine\"",
//             "amazonImage":
//                 "https://likecard-space.fra1.digitaloceanspaces.com/categories/c55bd-shaed.png",
//             "childs": []
//           }
//         ]
//       }
//     ]
//   };

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Blue Thermal Printer'),
//       ),
//       body: ListView(
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 const Text(
//                   'Device:',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 DropdownButton<BluetoothDevice>(
//                   items: _getDeviceItems(),
//                   onChanged: (value) => setState(() => _device = value!),
//                   value: _device,
//                 ),
//                 ElevatedButton(
//                   onPressed: _pressed
//                       ? null
//                       : _connected
//                           ? _disconnect
//                           : _connect,
//                   child: SizedBox(
//                     width: 50,
//                     child: Text(
//                       _connected ? 'Disconnect' : 'Connect',
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 50),
//             child: ElevatedButton(
//               onPressed: _connected ? _tesPrint : null,
//               child: const Text('TesPrint'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
//     List<DropdownMenuItem<BluetoothDevice>> items = [];
//     if (_devices.isEmpty) {
//       items.add(const DropdownMenuItem(
//         child: Text('NONE'),
//       ));
//     } else {
//       for (var device in _devices) {
//         items.add(DropdownMenuItem(
//           child: Text(device.name!),
//           value: device,
//         ));
//       }
//     }
//     return items;
//   }

//   void _connect() {
//     if (_device == null) {
//       show('No device selected.');
//     } else {
//       bluetooth.isConnected.then((isConnected) {
//         if (!isConnected!) {
//           bluetooth.connect(_device!).catchError((error) {
//             setState(() => _pressed = false);
//           });
//           setState(() => _pressed = true);
//         }
//       });
//     }
//   }

//   void _disconnect() {
//     bluetooth.disconnect();
//     setState(() => _pressed = true);
//   }

// //write to app path
//   Future<void> writeToFile(ByteData data, String path) {
//     final buffer = data.buffer;
//     return File(path).writeAsBytes(
//         buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
//   }

//   void _tesPrint() async {
//     //SIZE
//     // 0- normal size text
//     // 1- only bold text
//     // 2- bold with medium text
//     // 3- bold with large text
//     //ALIGN
//     // 0- ESC_ALIGN_LEFT
//     // 1- ESC_ALIGN_CENTER
//     // 2- ESC_ALIGN_RIGHT

//     bluetooth.isConnected.then((isConnected) async {
//       if (isConnected!) {
//         await printReciept();
//       }
//     });
//   }

//   Future<void> printReciept() async {
//     String cutLine = "✄-------------------";
//     String divider = "-------------------";
//     bluetooth.printImage(pathImage!); //path of your image/logo
//     bluetooth.printCustom("مؤسسة سلة البساتين", 0, 1);
//     bluetooth.printNewLine();
//     bluetooth.printCustom("Zain 20 SAR", 0, 1);
//     bluetooth.printCustom("Evoucher No.", 0, 1);
//     await createSerialBox('01156631969');
//     bluetooth.printNewLine();
//     bluetooth.printQRcode("Insert Your Own Text to Generate", 200, 200, 1);
//     bluetooth.printNewLine();
//     bluetooth.printLeftRight("SerialNo.", "103440434217", 0);
//     bluetooth.printLeftRight("ReferenceNo.", "4545685", 1,
//         format: "%-15s %15s %n");
//     bluetooth.printLeftRight(
//         "Date", DateTime.now().toString().split(' ').first, 0,
//         format: "%-10s %25s %n");
//     bluetooth.printLeftRight(
//         "Voucher Validity", DateTime.now().toString().split(' ').first, 0,
//         format: "%-10s %13s %n");
//     bluetooth.printNewLine();
//     bluetooth.printCustom(divider, 2, 1);
//     bluetooth.printNewLine();
//     String data =
//         "The Mystc application or site or send 2220 to 900 \n شامل ضريبة القيمة المضافة 15% \n 15% VAT Included";
//     bluetooth.printCustom(data, 0, 1);
//     bluetooth.printNewLine();
//     String atc = "<<ATC>>";
//     bluetooth.printCustom(atc, 0, 1);
//     bluetooth.printNewLine();
//     String atcUrl = "شركة عقد الثريا للتجارة \n WWW.AqedAlthuraya.com";
//     bluetooth.printCustom(atcUrl, 0, 1);
//     bluetooth.printNewLine();
//     await printBarCode("01156631969");
//     bluetooth.printNewLine();
//     bluetooth.printNewLine();
//     bluetooth.printCustom(cutLine, 2, 1);
//     bluetooth.paperCut();
//   }

//   createSerialBox(String serial) async {
//     TextPainter textPainter;
//     textPainter = TextPainter(
//       textAlign: TextAlign.center,
//       textDirection: TextDirection.ltr,
//     );
//     textPainter.text = TextSpan(
//       text: serial,
//       style: const TextStyle(
//         color: Colors.black,
//         fontSize: 28.0,
//         fontWeight: FontWeight.bold,
//       ),
//     );
//     Offset position = const Offset(0, 10);

//     PictureRecorder recorder = PictureRecorder();
//     Canvas c = Canvas(recorder);

//     Paint painter = Paint()
//       ..color = Colors.white
//       ..strokeWidth = 400
//       ..style = PaintingStyle.stroke;

//     c.drawPaint(painter); // etc

//     painter = Paint()
//       ..color = Colors.black
//       ..strokeWidth = 4
//       ..style = PaintingStyle.stroke;

//     c.drawRRect(
//         RRect.fromRectAndRadius(
//             const Rect.fromLTWH(0, 0, 380, 80), const Radius.circular(0)),
//         painter); // etc

//     textPainter.layout(maxWidth: 380, minWidth: 380);
//     textPainter.paint(c, position);

//     Picture p = recorder.endRecording();
//     var sImage = await p.toImage(450, 80);
//     var ddata = await sImage.toByteData(format: ImageByteFormat.png);
//     String dir = (await getApplicationDocumentsDirectory()).path;
//     String filename = 'serial.png';
//     writeToFile(ddata!, '$dir/$filename');
//     setState(() {
//       eVoucherPath = '$dir/$filename';
//     });
//     bluetooth.printImage(eVoucherPath!);
//     bluetooth.printNewLine();
//     bluetooth.printNewLine();
//   }

//   Future printBarCode(String data) async {
//     final image = imm.Image(250, 80);

//     // Fill it with a solid color (white)
//     imm.fill(image, imm.getColor(255, 255, 255));
//     // Draw the barcode
//     drawBarcode(image, Barcode.code128(), data);
//     Directory appDocDir = await getApplicationDocumentsDirectory();
//     String appDocPath = appDocDir.path;
//     // Save the image
//     File(appDocPath + 'barcode.png')
//         .writeAsBytes(imm.encodePng(image))
//         .then((value) async {
//       final imgData = value.readAsBytesSync();
//       bluetooth.printImageBytes(imgData);
//     });
//   }

//   Future show(
//     String message, {
//     Duration duration = const Duration(seconds: 3),
//   }) async {
//     await Future.delayed(const Duration(milliseconds: 100));
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           message,
//           style: const TextStyle(
//             color: Colors.white,
//           ),
//         ),
//         duration: duration,
//       ),
//     );
//   }
// }
