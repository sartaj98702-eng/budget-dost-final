import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const AdminApp());
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: SuperAdminPanel());
  }
}

class SuperAdminPanel extends StatefulWidget {
  @override
  State<SuperAdminPanel> createState() => _SuperAdminPanelState();
}

class _SuperAdminPanelState extends State<SuperAdminPanel> {
  final db = FirebaseFirestore.instance;
  final settingsRef = FirebaseFirestore.instance.collection('settings').doc('app_settings');

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("SUPER ADMIN - Budget Dost"),
          backgroundColor: Colors.red,
          bottom: const TabBar(tabs: [Tab(text: "SALE"), Tab(text: "SETTINGS"), Tab(text: "PRODUCTS")]),
        ),
        body: TabBarView(children: [
          StreamBuilder<QuerySnapshot>(
            stream: db.collection('orders').snapshots(),
            builder: (c, s) {
              if (!s.hasData) return const Center(child: CircularProgressIndicator());
              double total = 0;
              for (var d in s.data!.docs) total += (d['totalAmount'] ?? 0);
              return Column(children: [
                Card(color: Colors.green[100], child: ListTile(title: Text("TOTAL SALE: Rs $total"), subtitle: Text("Orders: ${s.data!.docs.length}"))),
                Expanded(child: ListView(children: s.data!.docs.map((doc) {
                  var d = doc.data() as Map;
                  return ListTile(title: Text(d['customerName'] ?? 'Order'), subtitle: Text("Rs ${d['totalAmount']}"), trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => doc.reference.delete()));
                }).toList())),
              ]);
            },
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: settingsRef.snapshots(),
            builder: (c, snap) {
              if (!snap.hasData) return const Center(child: CircularProgressIndicator());
              var data = snap.data!.data() as Map<String, dynamic>? ?? {};
              bool show199 = data['show199Offer'] ?? true;
              double delivery = (data['deliveryCharge'] ?? 10).toDouble();
              double commission = (data['commissionPercent'] ?? 10).toDouble();
              bool appActive = data['isAppActive'] ?? true;
              return ListView(padding: const EdgeInsets.all(16), children: [
                SwitchListTile(title: const Text("199 Wala Offer Dikhana Hai?"), value: show199, onChanged: (v) => settingsRef.set({'show199Offer': v}, SetOptions(merge: true))),
                const Divider(),
                ListTile(title: Text("Delivery Charge: Rs $delivery"), subtitle: Slider(value: delivery, min: 0, max: 100, divisions: 20, label: "$delivery", onChanged: (v) => settingsRef.set({'deliveryCharge': v}, SetOptions(merge: true)))),
                const Divider(),
                ListTile(title: Text("Commission: $commission %"), subtitle: Slider(value: commission, min: 0, max: 50, divisions: 10, label: "$commission%", onChanged: (v) => settingsRef.set({'commissionPercent': v}, SetOptions(merge: true)))),
                const Divider(),
                SwitchListTile(title: const Text("App Chalu Hai?"), value: appActive, onChanged: (v) => settingsRef.set({'isAppActive': v}, SetOptions(merge: true))),
                const SizedBox(height: 20),
                const Text("Note: Ye change turant Customer aur Supplier App pe lag jayega!", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ]);
            },
          ),
          StreamBuilder<QuerySnapshot>(
            stream: db.collection('products').snapshots(),
            builder: (c, s) {
              if (!s.hasData) return const Center(child: CircularProgressIndicator());
              return ListView(children: s.data!.docs.map((doc) {
                var d = doc.data() as Map;
                return ListTile(title: Text(d['name'] ?? 'Product'), subtitle: Text("Price: ${d['price']}"), trailing: IconButton(icon: const Icon(Icons.edit), onPressed: () {
                  TextEditingController ctrl = TextEditingController(text: d['price'].toString());
                  showDialog(context: context, builder: (_) => AlertDialog(title: Text("Price badlo - ${d['name']}"), content: TextField(controller: ctrl, keyboardType: TextInputType.number), actions: [TextButton(onPressed: () { doc.reference.update({'price': int.tryParse(ctrl.text) ?? d['price']}); Navigator.pop(context); }, child: const Text("Save"))]));
                }));
              }).toList());
            },
          ),
        ]),
      ),
    );
  }
}
