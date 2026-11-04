import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async { WidgetsFlutterBinding.ensureInitialized(); await Firebase.initializeApp(); runApp(SupplierApp()); }
class SupplierApp extends StatelessWidget { @override Widget build(BuildContext context){ return MaterialApp(home: SupplierLogin(), debugShowCheckedModeBanner: false); } }

class SupplierLogin extends StatefulWidget { @override _SupplierLoginState createState()=>_SupplierLoginState(); }
class _SupplierLoginState extends State<SupplierLogin>{
  final nameC=TextEditingController(); final shopC=TextEditingController(); final phoneC=TextEditingController(); final otpC=TextEditingController();
  String verId=""; bool otpSent=false;
  void sendOtp() async { await FirebaseAuth.instance.verifyPhoneNumber(phoneNumber:'+91${phoneC.text}', codeSent:(id,t){setState((){verId=id; otpSent=true;});}, verificationCompleted:(c){}, verificationFailed:(e){ ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message!))); }, codeAutoRetrievalTimeout:(id){}); }
  void verify() async { var cred=PhoneAuthProvider.credential(verificationId:verId, smsCode:otpC.text); await FirebaseAuth.instance.signInWithCredential(cred);
    await FirebaseFirestore.instance.collection('suppliers').doc(FirebaseAuth.instance.currentUser!.uid).set({'supplierName':nameC.text,'shopName':shopC.text,'phone':phoneC.text,'subscription':199,'commission':0,'created':FieldValue.serverTimestamp()});
    Navigator.pushReplacement(context, MaterialPageRoute(builder:(_)=>SupplierHome())); }
  @override Widget build(BuildContext context){ return Scaffold(body: Padding(padding: EdgeInsets.all(20), child: Column(mainAxisAlignment: MainAxisAlignment.center, children:[
    Text('Supplier Login', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), SizedBox(height: 20),
    TextField(controller: nameC, decoration: InputDecoration(labelText: 'Supplier Name', border: OutlineInputBorder())),
    SizedBox(height: 10), TextField(controller: shopC, decoration: InputDecoration(labelText: 'Shop Name', border: OutlineInputBorder())),
    SizedBox(height: 10), TextField(controller: phoneC, decoration: InputDecoration(labelText: 'Number', prefixText: '+91 ', border: OutlineInputBorder())),
    if(otpSent) Padding(padding: EdgeInsets.only(top:10), child: TextField(controller: otpC, decoration: InputDecoration(labelText: 'OTP', border: OutlineInputBorder()))),
    SizedBox(height: 20), SizedBox(width: double.infinity, child: ElevatedButton(onPressed: otpSent?verify:sendOtp, child: Text(otpSent?'Verify & Login':'Send OTP'))),
  ]))); }
}

class SupplierHome extends StatefulWidget { @override _SupplierHomeState createState()=>_SupplierHomeState(); }
class _SupplierHomeState extends State<SupplierHome>{
  bool stickerPrinted=false;
  @override Widget build(BuildContext context){ return Scaffold(appBar: AppBar(title: Text('Supplier - Rs199/month, 0% Commission'), backgroundColor: Colors.orange), body: ListView(padding: EdgeInsets.all(12), children:[
    Card(child: ListTile(title: Text('Add Product - Easy'), subtitle: Text('Photo + Price + GST - Unlimited options'), trailing: Icon(Icons.add), onTap:(){ Navigator.push(context, MaterialPageRoute(builder:(_)=>AddProduct())); })),
    Card(child: ListTile(title: Text('Orders - Courier Delivery'), subtitle: Text('Sticker ke bina ship button nahi dabega'), onTap:(){})),
    SizedBox(height: 10),
    Container(padding: EdgeInsets.all(12), color: Colors.yellow.shade100, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
      Text('Delivery Info:', style: TextStyle(fontWeight: FontWeight.bold)),
      Text('Delivery Charge Rs90 (40+50). Extra tumhare jeb se jayega, 199 + customer 10 se adjust hoga. COD wallet me courier apna rakh kar baaki dega. Supplier ko 7 din baad paisa milega.'),
      Text('Courier khud support ke paas ayega.'),
      SizedBox(height: 10),
      CheckboxListTile(title: Text('Maine Sticker Print Kiya - FROM: Budget Dost SR Warehouse (Supplier Hidden)'), value: stickerPrinted, onChanged: (v){setState((){stickerPrinted=v!;});}),
      SizedBox(width: double.infinity, child: ElevatedButton(onPressed: stickerPrinted?(){ ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Courier ko notify kiya - Support se contact karega'))); }:null, child: Text('Ready to Ship'))),
    ])),
  ])); }
}

class AddProduct extends StatefulWidget { @override _AddProductState createState()=>_AddProductState(); }
class _AddProductState extends State<AddProduct>{
  final nameC=TextEditingController(); final priceC=TextEditingController(); final gstC=TextEditingController(text:'18'); final hsnC=TextEditingController();
  Map<String, TextEditingController> custom={};
  @override Widget build(BuildContext context){ return Scaffold(appBar: AppBar(title: Text('Product with GST')), body: Padding(padding: EdgeInsets.all(16), child: ListView(children:[
    TextField(controller: nameC, decoration: InputDecoration(labelText: 'Product Name - Any Type')),
    TextField(controller: priceC, decoration: InputDecoration(labelText: 'Base Price'), keyboardType: TextInputType.number),
    TextField(controller: gstC, decoration: InputDecoration(labelText: 'GST % - 0,5,12,18,28')), 
    TextField(controller: hsnC, decoration: InputDecoration(labelText: 'HSN Code')),
    SizedBox(height: 15), Text('Unlimited Custom Options - Har tarah ka product', style: TextStyle(fontWeight: FontWeight.bold)),
    ...custom.entries.map((e)=>Padding(padding: EdgeInsets.only(top:8), child: TextField(controller: e.value, decoration: InputDecoration(labelText: e.key, border: OutlineInputBorder())))).toList(),
    TextButton(onPressed:(){ setState((){ custom['Option ${custom.length+1}']=TextEditingController(); }); }, child: Text('+ Add More Field - Unlimited')),
    SizedBox(height: 20),
    ElevatedButton(onPressed:() async {
      await FirebaseFirestore.instance.collection('products').add({'name':nameC.text,'price':double.tryParse(priceC.text)??0,'gst':int.tryParse(gstC.text)??18,'hsn':hsnC.text,'supplierId':FirebaseAuth.instance.currentUser!.uid,'status':'pending','custom':custom.map((k,v)=>MapEntry(k,v.text)),'created':FieldValue.serverTimestamp()});
      Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Submitted for Admin Approval')));
    }, child: Text('Submit Product')),
  ]))); }
}
