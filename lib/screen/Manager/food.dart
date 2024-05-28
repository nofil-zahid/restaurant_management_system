import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant_management_system/widgets/drawer.dart';

class Food extends StatefulWidget {
  const Food({Key? key}) : super(key: key);

  @override
  State<Food> createState() => _FoodState();
}

class _FoodState extends State<Food> {
  // Text field controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _desController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  late CollectionReference<Map<String, dynamic>> _items;

  String imageUrl = '';
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _items = FirebaseFirestore.instance.collection("food_menu");
  }

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {

    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['food_nm'];
      _desController.text = documentSnapshot['food_des'];
      _priceController.text = documentSnapshot['price'];
      imageUrl = documentSnapshot['img'] ?? '';
    }

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            right: 20,
            left: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text("Enter New Food"),
              ),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                    labelText: 'Name', hintText: 'eg Biryani'),
              ),
              TextField(
                controller: _desController,
                decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'eg Spicy and Veg + Mutton'),
              ),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(
                    labelText: 'Price', hintText: 'eg Rs. 1000'),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                  child: IconButton(
                      onPressed: () async {
                        final file = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);

                        if (file == null) return;

                        String fileName =
                            DateTime.now().microsecondsSinceEpoch.toString();

                        Reference referenceRoot = FirebaseStorage.instance.ref();
                        Reference referenceDireImages = referenceRoot.child('images');
                        Reference referenceImageToUpload = referenceDireImages.child(fileName);

                        try {
                          await referenceImageToUpload.putFile(File(file.path));
                          imageUrl =
                              await referenceImageToUpload.getDownloadURL();
                          print("Image uploaded to: $imageUrl");
                        } catch (error) {
                          print("File not uploaded: $error");
                        }
                      },
                      icon: const Icon(Icons.camera_alt))),
              Center(
                  child: ElevatedButton(
                      onPressed: () async {
                        final String name = _nameController.text;
                        final String description = _desController.text;
                        final String price = _priceController.text;

                        if (name.isNotEmpty && description.isNotEmpty) {
                          if (documentSnapshot != null) {
                            await _items.doc(documentSnapshot.id).update({
                              "food_nm": name,
                              "food_des": description,
                              "img": imageUrl,
                              'price': price
                            });
                          } else {
                            await _items.add({
                              "food_nm": name,
                              "food_des": description,
                              "img": imageUrl,
                              'price': price
                            });
                          }
                          _nameController.text = '';
                          _desController.text = '';
                          imageUrl = '';
                          setState(() {
                            isEditing = false;
                          });
                          Navigator.of(context).pop();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Please fill all fields")));
                        }
                      },
                      child: Text(isEditing ? 'Edit' : 'Create')
                    )
                  )
            ],
          ),
        );
      },
    );
  }

  void _editItem(DocumentSnapshot documentSnapshot) {
    setState(() {
      isEditing = true;
    });
    _create(documentSnapshot);
  }

  void _deleteItem(DocumentSnapshot documentSnapshot) async {
    await _items.doc(documentSnapshot.id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Food Menu"),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _items.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Some error occurred: ${snapshot.error}"),
            );
          }
          if (snapshot.hasData) {
            List<DocumentSnapshot> documents = snapshot.data!.docs;

            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (BuildContext context, int index) {
                DocumentSnapshot thisItem = documents[index];
                return ListTile(
                  title: Text(
                    "${thisItem['food_nm']}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${thisItem['food_des']}"),
                      const SizedBox(height: 5),
                      Text(
                        'Price: Rs. ${thisItem['price']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  leading: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      border: Border.all(width: 3, color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: thisItem['img'] != null && thisItem['img'].trim().isNotEmpty
                          ? Image.network(
                              "${thisItem['img']}",
                              fit: BoxFit.cover,
                              width: 70,
                              height: 70,
                            )
                          : const SizedBox(),
                    ),
                  ),
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Options"),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                ListTile(
                                  leading: const Icon(Icons.edit),
                                  title: const Text('Edit'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _editItem(thisItem);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.delete),
                                  title: const Text('Delete'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _deleteItem(thisItem);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _create();
        },
        child: const Icon(Icons.add),
      ),
      drawer: const MyDrawer(),
    );
  }
}
