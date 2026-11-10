import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(BudgetDostApp());
}

class BudgetDostApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Budget Dost Customer',
      theme: ThemeData(primarySwatch: Colors.orange, useMaterial3: true),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final phoneCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.shopping_bag, size: 80, color: Colors.orange),
          SizedBox(height: 12),
          Text('Budget Dost - Customer', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          TextField(controller: phoneCtrl, decoration: InputDecoration(labelText: 'Phone', border: OutlineInputBorder())),
          SizedBox(height: 20),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () async {
            await FirebaseAuth.instance.signInAnonymously();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=> HomeScreen()));
          }, child: Text('Login (Test)')))
        ]),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Razorpay _razorpay;
  List<Map<String, dynamic>> cart = [];

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (res) {
      FirebaseFirestore.instance.collection('orders').add({
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'cart': cart,
        'paymentId': res.paymentId,
        'status': 'Paid',
        'time': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment Success')));
      setState(() => cart.clear());
    });
  }

  double getTotal() => cart.fold(0, (s, i) => s + (i['price'] as num? ?? 0));

  void openCheckout() {
    var options = {
      'key': 'rzp_test_Tve76lZWuKemRw',
      'amount': (getTotal() * 100).toInt(),
      'name': 'Budget Dost',
      'description': 'Order Payment',
      'prefill': {'contact': '9999999999', 'email': 'test@budgetdost.com'},
      'theme': {'color': '#FF6B00'}
    };
    try { _razorpay.open(options); } catch(e) { print(e); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Budget Dost')),
      body: Column(children: [
        Padding(padding: EdgeInsets.all(12), child: TextField(decoration: InputDecoration(hintText: 'Search product...', prefixIcon: Icon(Icons.search), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))))),
        Expanded(child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('products').snapshots(),
          builder: (c, snap) {
            if (!snap.hasData) return Center(child: CircularProgressIndicator());
            if (snap.data!.docs.isEmpty) return Center(child: Text('No products yet'));
            return GridView.builder(padding: EdgeInsets.all(10), gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.75), itemCount: snap.data!.docs.length, itemBuilder: (c,i){
              var d = snap.data!.docs[i].data() as Map<String,dynamic>;
              return Card(child: Column(children: [
                Expanded(child: Icon(Icons.image, size: 50)),
                Text(d['name'] ?? 'Product', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('₹${d['price'] ?? 0}'),
                ElevatedButton(onPressed: ()=> setState(()=> cart.add(d)), child: Text('Add'))
              ]));
            });
          },
        )),
        if (cart.isNotEmpty) Container(padding: EdgeInsets.all(12), color: Colors.orange.shade50, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('₹${getTotal()} (${cart.length})', style: TextStyle(fontWeight: FontWeight.bold)),
          ElevatedButton(onPressed: openCheckout, child: Text('Pay Now'))
        ]))
      ]),
    );
  }
}
