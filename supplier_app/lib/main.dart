import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const SupplierApp());
}

class SupplierApp extends StatelessWidget {
  const SupplierApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (c, s) => s.hasData ? const Dashboard() : const LoginPage(),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final pass = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.store, size: 80, color: Colors.blue),
          TextField(controller: email, decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder())),
          const SizedBox(height: 15),
          TextField(controller: pass, obscureText: true, decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder())),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: () async { await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text.trim(), password: pass.text.trim()); }, child: const Text("LOGIN")),
        ]),
      ),
    );
  }
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Orders"), actions: [IconButton(onPressed: () => FirebaseAuth.instance.signOut(), icon: const Icon(Icons.logout))]),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          return ListView(children: snap.data!.docs.map((doc) {
            var d = doc.data() as Map<String, dynamic>;
            return Card(child: ListTile(title: Text(d['customerName'] ?? 'Order'), subtitle: Text("₹${d['totalAmount']} - ${d['status']}"), trailing: IconButton(icon: const Icon(Icons.check), onPressed: () => doc.reference.update({'status': 'Accepted'}))));
          }).toList());
        },
      ),
    );
  }
}
