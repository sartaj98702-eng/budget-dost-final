import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async { WidgetsFlutterBinding.ensureInitialized(); await Firebase.initializeApp(); runApp(AdminApp()); }
class AdminApp extends StatelessWidget { @override Widget build(BuildContext context){ return MaterialApp(home: SecretAdminLogin(), debugShowCheckedModeBanner: false); } }

class SecretAdminLogin extends StatefulWidget { @override _SecretAdminLoginState createState()=>_SecretAdminLoginState(); }
class _SecretAdminLoginState extends State<SecretAdminLogin>{
  int tapCount=0;
  @override Widget build(BuildContext context){
    return Scaffold(body: Center(child: GestureDetector(onTap:(){ tapCount++; setState((){}); if(tapCount>=7){ Navigator.pushReplacement(context, MaterialPageRoute(builder:(_)=>AdminPanel())); } }, child: Column(mainAxisAlignment: MainAxisAlignment.center, children:[
      Icon(Icons.shopping_bag, size: 100, color: Color(0xFF0066CC)),
      Text('Budget Dost', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)), Text('Real Name - 7 baar tap secret', style: TextStyle(color: Colors.grey)),
      SizedBox(height: 20), Text('Taps: $tapCount / 7', style: TextStyle(fontSize: 18)),
    ]))));
  }
}

class AdminPanel extends StatelessWidget {
  @override Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: Text('Admin - Full Control'), backgroundColor: Color(0xFF0D47A1)), body: ListView(children:[
      ListTile(title: Text('Approve / Reject Products'), leading: Icon(Icons.verified), onTap:(){ Navigator.push(context, MaterialPageRoute(builder:(_)=>ApproveProducts())); }),
      ListTile(title: Text('Supplier Control - Rs199 + Commission'), leading: Icon(Icons.store), onTap:(){}),
      ListTile(title: Text('Set Charges - Product / Commission / Delivery 40+50 / Customer 10'), leading: Icon(Icons.settings), onTap:(){ Navigator.push(context, MaterialPageRoute(builder:(_)=>SettingsScreen())); }),
      ListTile(title: Text('Courier API - Shiprocket'), leading: Icon(Icons.local_shipping), subtitle: Text('Courier support ke paas ayega'), onTap:(){}),
      ListTile(title: Text('Orders - COD Wallet Split'), leading: Icon(Icons.account_balance_wallet), subtitle: Text('Courier apna rakhe, baaki supplier ko 7 din baad'), onTap:(){}),
      ListTile(title: Text('Sticker Privacy'), subtitle: Text('Customer ko supplier address/number nahi dikhega - Only Budget Dost SR Warehouse'), leading: Icon(Icons.privacy_tip)),
    ]));
  }
}

class ApproveProducts extends StatelessWidget {
  @override Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: Text('Pending - Approve/Reject Easy')), body: StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection('products').where('status', isEqualTo: 'pending').snapshots(), builder: (c,s){
      if(!s.hasData) return Center(child: CircularProgressIndicator());
      return ListView(children: s.data!.docs.map((d){ return Card(child: ListTile(title: Text(d['name']), subtitle: Text('Price ${d['price']} GST ${d['gst']}% HSN ${d['hsn']}'), trailing: Row(mainAxisSize: MainAxisSize.min, children:[
        IconButton(icon: Icon(Icons.check, color: Colors.green), onPressed:(){ d.reference.update({'status':'approved'}); }),
        IconButton(icon: Icon(Icons.close, color: Colors.red), onPressed:(){ d.reference.update({'status':'rejected'}); }),
      ]))); }).toList());
    }));
  }
}

class SettingsScreen extends StatefulWidget { @override _SettingsScreenState createState()=>_SettingsScreenState(); }
class _SettingsScreenState extends State<SettingsScreen>{
  final commC=TextEditingController(text:'0'); final custC=TextEditingController(text:'10'); final delC=TextEditingController(text:'90');
  @override Widget build(BuildContext context){ return Scaffold(appBar: AppBar(title: Text('Full Control')), body: Padding(padding: EdgeInsets.all(16), child: Column(children:[
    TextField(controller: commC, decoration: InputDecoration(labelText: 'Supplier Commission % - Abhi 0, Baad me set')),
    TextField(controller: custC, decoration: InputDecoration(labelText: 'Customer Platform Fee - 10')),
    TextField(controller: delC, decoration: InputDecoration(labelText: 'Delivery Charge 40+50 = 90')),
    SizedBox(height: 20),
    ElevatedButton(onPressed:(){ FirebaseFirestore.instance.collection('settings').doc('global').set({'commission':commC.text,'customerFee':custC.text,'deliveryCharge':delC.text,'updated':FieldValue.serverTimestamp()}); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saved - Dono app control ho gaya'))); }, child: Text('Save Settings')),
  ]))); }
}
