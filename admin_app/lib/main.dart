// ADMIN APP - com.admin.app - FULL CODE A2Z
// Features: Approve/Reject, Full Control Both Apps, Charge/Commission Set, QR Scan Reveal Supplier, Courier Support

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() async { WidgetsFlutterBinding.ensureInitialized(); await Firebase.initializeApp(); runApp(AdminApp()); }

class AdminApp extends StatelessWidget { @override Widget build(BuildContext c)=>MaterialApp(home: AdminHome()); }

class AdminHome extends StatefulWidget { @override State<AdminHome> createState()=>_AdminHomeState(); }
class _AdminHomeState extends State<AdminHome> {
  double dCust=40, dExtra=50, pFee=10, comm=0;
  @override Widget build(BuildContext c){
    return Scaffold(appBar: AppBar(title: Text("Admin Control - Budget Dost SR")), body: SingleChildScrollView(child: Column(children: [
      Card(child: Column(children: [
        Text("CONTROL - Choti Moti Change Jab Chaahe", style: TextStyle(fontWeight: FontWeight.bold)),
        ListTile(title: Text("Delivery Customer: $dCust"), trailing: Icon(Icons.edit)),
        ListTile(title: Text("Extra Delivery (Tum Doge 199/10 se): $dExtra")),
        ListTile(title: Text("Platform Fee (10 wala): $pFee")),
        ListTile(title: Text("Supplier Commission: $comm % (Abhi Zero)")),
        ElevatedButton(onPressed: (){ FirebaseFirestore.instance.collection('settings').doc('charges').set({'deliveryCustomer':dCust,'deliveryExtra':dExtra,'platformFee':pFee,'commission':comm}); }, child: Text("Save - Dono App me Update Ho Jayega")),
      ])),
      ElevatedButton(onPressed: (){ Navigator.push(c, MaterialPageRoute(builder: (_)=>QRScreen())); }, child: Text("SCAN Sticker - Supplier Real Detail Dekho - Customer ko nahi dikhega")),
      Divider(), Text("Approve / Reject Products"),
      StreamBuilder(stream: FirebaseFirestore.instance.collection('products').where('approved',isEqualTo:false).snapshots(), builder: (cx,s){
        if(!s.hasData) return CircularProgressIndicator();
        return Column(children: s.data!.docs.map((d)=>ListTile(title: Text(d['name']), subtitle: Text("Code:${d['supplierCode']} - Price:${d['price']}"), trailing: Row(mainAxisSize: MainAxisSize.min, children: [IconButton(icon: Icon(Icons.check,color: Colors.green), onPressed: ()=>d.reference.update({'approved':true})), IconButton(icon: Icon(Icons.close,color: Colors.red), onPressed: ()=>d.reference.delete())]))).toList());
      }),
      Text("Orders - Courier Support"),
      StreamBuilder(stream: FirebaseFirestore.instance.collection('orders').where('status',isEqualTo:'packed_for_courier').snapshots(), builder: (cx,s){
        if(!s.hasData) return Text("No Packed Orders");
        return Column(children: s.data!.docs.map((d)=>ListTile(title: Text(d['orderId']), subtitle: Text("AWB:${d['awb']} - Supplier:${d['supplierCode']} - Courier Support ke paas aaya"))).toList());
      })
    ])));
  }
}

class QRScreen extends StatelessWidget {
  @override Widget build(BuildContext c){
    return Scaffold(appBar: AppBar(title: Text("QR Scan - Supplier Reveal")), body: MobileScanner(onDetect: (cap) async {
      String data=cap.barcodes.first.rawValue!; // ORDER:xxx|SUP:SR-102|AWB:xxx
      String code=data.split("|")[1].split(":")[1];
      var snap=await FirebaseFirestore.instance.collection('suppliers').where('code',isEqualTo:code).get();
      if(snap.docs.isNotEmpty){ var sup=snap.docs.first.data(); showDialog(context: c, builder: (_)=>AlertDialog(title: Text("Real Supplier - Return Yahi Hoga"), content: Text("Code:$code\nName:${sup['name']}\nAddress:${sup['fullAddress']}\nPhone:${sup['phone']}"))); }
    }));
  }
}
