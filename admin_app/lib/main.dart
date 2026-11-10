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
    return MaterialApp(debugShowCheckedModeBanner: false, home: AdminDashboard());
  }
}

class AdminDashboard extends StatelessWidget {
  AdminDashboard({super.key});
  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ADMIN PANEL"), backgroundColor: Colors.red),
      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection('orders').snapshots(),
        builder: (c, s) {
          if (!s.hasData) return const Center(child: CircularProgressIndicator());
          double total = 0;
          for (var d in s.data!.docs) { total += (d.data() as Map)['totalAmount'] ?? 0; }
          return Column(children: [
            Card(color: Colors.green[100], child: ListTile(title: Text("TOTAL SALE: Rs $total"), subtitle: Text("Orders: ${s.data!.docs.length}"))),
            Expanded(child: ListView(children: s.data!.docs.map((doc) {
              var d = doc.data() as Map<String, dynamic>;
              return ListTile(title: Text(d['customerName'] ?? 'Order'), subtitle: Text("Rs ${d['totalAmount']} - ${d['status']}"), trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => doc.reference.delete()));
            }).toList())),
          ]);
        },
      ),
    );
  }
}
