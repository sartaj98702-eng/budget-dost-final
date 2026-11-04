import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(CustomerApp());
}

class CustomerApp extends StatelessWidget {
  @override Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget Dost SR',
      theme: ThemeData(primaryColor: Color(0xFF0066CC)),
      home: LoginScreen(), debugShowCheckedModeBanner: false,
    );
  }
}

class LoginScreen extends StatefulWidget { @override _LoginScreenState createState() => _LoginScreenState(); }
class _LoginScreenState extends State<LoginScreen> {
  final phoneC = TextEditingController(); final otpC = TextEditingController();
  String verId=""; bool otpSent=false;
  void sendOtp() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91${phoneC.text}',
      verificationCompleted: (c) async { await FirebaseAuth.instance.signInWithCredential(c); Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>HomeScreen())); },
      verificationFailed: (e){ ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message!))); },
      codeSent: (id, token){ setState((){ verId=id; otpSent=true; }); },
      codeAutoRetrievalTimeout: (id){ verId=id; },
    );
  }
  void verify() async {
    var cred = PhoneAuthProvider.credential(verificationId: verId, smsCode: otpC.text);
    await FirebaseAuth.instance.signInWithCredential(cred);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>HomeScreen()));
  }
  @override Widget build(BuildContext context) {
    return Scaffold(body: Padding(padding: EdgeInsets.all(20), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.shopping_bag, size: 80, color: Color(0xFF0066CC)),
      Text('Budget Dost', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0066CC))),
      Text('ज़रूरत का सामान अब एक ही जगह', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      SizedBox(height: 30),
      TextField(controller: phoneC, decoration: InputDecoration(labelText: 'Mobile Number', prefixText: '+91 ', border: OutlineInputBorder()), keyboardType: TextInputType.phone),
      if(otpSent) Padding(padding: EdgeInsets.only(top:10), child: TextField(controller: otpC, decoration: InputDecoration(labelText: 'OTP', border: OutlineInputBorder()))),
      SizedBox(height: 20),
      SizedBox(width: double.infinity, child: ElevatedButton(onPressed: otpSent?verify:sendOtp, child: Text(otpSent?'Verify OTP':'Send Real OTP'), style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0066CC), padding: EdgeInsets.all(15)))),
    ])));
  }
}

class HomeScreen extends StatelessWidget {
  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xFF0066CC), title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Budget Dost SR'), Text('ज़रूरत का सामान अब एक ही जगह', style: TextStyle(fontSize: 10))]),
        actions: [IconButton(icon: Icon(Icons.support_agent), onPressed: (){ /* WhatsApp Admin */ }), IconButton(icon: Icon(Icons.person), onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (_)=>ProfileScreen())); })],
        bottom: PreferredSize(preferredSize: Size.fromHeight(110), child: Padding(padding: EdgeInsets.all(8), child: Column(children: [
          TextField(decoration: InputDecoration(hintText: 'Search by Pincode...', filled: true, fillColor: Colors.white, prefixIcon: Icon(Icons.location_on), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),),
          SizedBox(height: 8),
          TextField(decoration: InputDecoration(hintText: 'Search Product...', filled: true, fillColor: Colors.white, prefixIcon: Icon(Icons.search), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),),
        ])))),
      body: Column(children: [
        Container(height: 90, color: Color(0xFFFFF3E0), child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Icon(Icons.checkroom), Icon(Icons.chair), Icon(Icons.brush), Icon(Icons.shopping_cart), Icon(Icons.toys), // 5 saman logo
        ])),
        Expanded(child: ProductGrid()),
      ]),
    );
  }
}

class ProductGrid extends StatelessWidget {
  late Razorpay _razorpay;
  ProductGrid(){ _razorpay=Razorpay(); }
  void openRazorpay(int amount){ _razorpay.open({'key':'rzp_test_Tve76lZWuKemRw','amount':amount*100,'name':'Budget Dost SR','description':'Payment'}); }
  @override Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection('products').where('status', isEqualTo: 'approved').snapshots(), builder: (c,s){
      if(!s.hasData) return Center(child: CircularProgressIndicator());
      return GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.7), itemCount: s.data!.docs.length, itemBuilder: (ctx,i){
        var p=s.data!.docs[i]; double price=(p['price']??0).toDouble(); int gst=(p['gst']??18); double incl=price+(price*gst/100);
        return Card(child: Column(children: [
          Expanded(child: p['image']!=null?Image.network(p['image'], fit: BoxFit.cover):Icon(Icons.image)),
          Padding(padding: EdgeInsets.all(4), child: Text(p['name']??'', maxLines: 1)),
          Text('₹${incl.toStringAsFixed(0)} incl GST', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0066CC))),
          Row(children: [
            Expanded(child: ElevatedButton(onPressed: (){}, child: Text('Cart', style: TextStyle(fontSize: 10)))),
            SizedBox(width: 4),
            Expanded(child: ElevatedButton(onPressed: (){ openRazorpay(incl.toInt()+10); }, child: Text('Buy', style: TextStyle(fontSize: 10)), style: ElevatedButton.styleFrom(backgroundColor: Colors.orange))),
          ]),
        ]));
      });
    });
  }
}

class ProfileScreen extends StatelessWidget {
  @override Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Best Profile')), body: ListView(children: [
      ListTile(title: Text('My Addresses'), subtitle: Text('Add / Change easily'), trailing: Icon(Icons.edit_location)),
      ListTile(title: Text('Help - Admin WhatsApp / Number'), subtitle: Text('Koi need pade to'), onTap: (){}),
      ListTile(title: Text('Logout'), onTap: (){ FirebaseAuth.instance.signOut(); Navigator.pop(context); }),
    ]));
  }
}
