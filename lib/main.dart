import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:untitled5/admin_screen/admin_dashboard_screen.dart';
import 'package:untitled5/bookings/booking_form_al_karim.dart';
import 'package:untitled5/bookings/booking_form_grandeur.dart';
import 'package:untitled5/client_screen/ai_budget_tracking.dart';
import 'package:untitled5/client_screen/chat.dart';
import 'package:untitled5/client_screen/client_screen.dart';
import 'package:untitled5/client_screen/home.dart';
import 'package:untitled5/client_screen/ai_budget_tracking.dart';
import 'signup_screen.dart';
import 'splash_screen.dart';
import 'service_provider/service_provider_main.dart';
import 'logout.dart';

// Firebase configuration for web
const firebaseConfig = {
  'apiKey': "AIzaSyD62GgUCxIpgXxPars0nf9NtmK65EK2X0o",
  'authDomain': "planfusion-76dcd.firebaseapp.com",
  'databaseURL': "https://planfusion-76dcd-default-rtdb.firebaseio.com",
  'projectId': "planfusion-76dcd",
  'storageBucket': "planfusion-76dcd.firebasestorage.app",
  'messagingSenderId': "547070959814",
  'appId': "1:547070959814:web:b4df209985625e7a9eb7c7",
  'measurementId': "G-D4C2727ND8"
};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://gidofdfgiiawlahmdpjd.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdpZG9mZGZnaWlhd2xhaG1kcGpkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDY3MTQ4MjEsImV4cCI6MjA2MjI5MDgyMX0.pI0BskYSxmWl2cGTbydRZ5n1fxKuLfUA37Y9aMLvuzM',
  );

  if (kIsWeb) {
    // Initialize Firebase for web
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: firebaseConfig['apiKey']!,
        // authDomain: '',
        authDomain: firebaseConfig['authDomain']!,
        projectId: firebaseConfig['projectId']!,
        storageBucket: firebaseConfig['storageBucket']!,
        // messagingSenderId: firebaseConfig['messagingSenderId']!,
        appId: firebaseConfig['appId']!,
        messagingSenderId: '',
        databaseURL: "https://planfusion-76dcd-default-rtdb.firebaseio.com/"
      ),
    );
  } else {
    // Initialize Firebase for Android/iOS
    await Firebase.initializeApp();
  }

  runApp(const PlanFusionApp());
}

class PlanFusionApp extends StatelessWidget {
  const PlanFusionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PlanFusion AI Driven Budget Wedding App',
      initialRoute: '/',
      routes: {
        // '/': (context) => const ClientScreen(),
        '/': (context) => const SplashScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/serviceProvider': (context) => const ServiceProviderMain(), // Navigation to Service Provider Section
        '/logout': (context) => const LogoutScreen(), // Add logout screen route
      },
    );
  }
}

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addDocument(String collection, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).add(data);
      print("Document added to $collection successfully.");
    } catch (e) {
      print("Error adding document to $collection: $e");
    }
  }

  Future<void> getDocuments(String collection) async {
    try {
      QuerySnapshot snapshot = await _firestore.collection(collection).get();
      for (var doc in snapshot.docs) {
        print("Document ID: ${doc.id}, Data: ${doc.data()}");
      }
    } catch (e) {
      print("Error fetching documents from $collection: $e");
    }
  }
}
