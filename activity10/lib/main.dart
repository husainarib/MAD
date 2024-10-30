import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:..,
    );
  }
}

class Product {
  String id;
  String name;
  double price;

  Product({
    required this.id,
    required this.name,
    required this.price,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as String,
      name: map['name'] as String,
      price: map['price'] as double,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }
}

class ProductService { 
  final CollectionReference productsCollection = FirebaseFirestore.instance.collection('products');

  // Method to create a new product
  Future<void> createProduct (Product product) { 
    return productsCollection.doc(product.id).set(product.toMap());
  }

   // Method to read all products
  Future<List<Product>> getProducts() {
    return productsCollection.get().then((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Method to update a product
  Future<void> updateProduct(Product product) {
    return productsCollection.doc(product.id).update(product.toMap());
  }

  // Method to delete a product
  Future<void> deleteProduct(String productId) {
    return productsCollection.doc(productId).delete();
  }
}
