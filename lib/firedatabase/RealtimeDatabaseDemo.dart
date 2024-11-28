import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RealtimeDatabaseDemo extends StatefulWidget {
  @override
  _RealtimeDatabaseDemoState createState() => _RealtimeDatabaseDemoState();
}

class _RealtimeDatabaseDemoState extends State<RealtimeDatabaseDemo> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  List<Map<dynamic, dynamic>> _dataList = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _addData(String name, String text) {
    String id = _dbRef.child("users").push().key ?? "";
    _dbRef
        .child("users/$id")
        .set({"id": id, "name": name, "contactNo": text}).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Data added successfully!'),
      ));
    });
  }

  void _fetchData() {
    _dbRef.child("users").onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          _dataList = data.values
              .map((value) => value as Map<dynamic, dynamic>)
              .toList();
        });
      }
    });
  }

  void _deleteData(String id) {
    _dbRef.child("users/$id").remove().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Data deleted successfully!'),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Realtime Database Example")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "contact no",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Allows only digits
                  LengthLimitingTextInputFormatter(10),
                ]),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (_numberController.text.isNotEmpty) {
                  _addData(_nameController.text, _numberController.text);
                  _numberController.clear();
                  _nameController.clear();
                }
              },
              child: const Text("Add Data"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _dataList.length,
                itemBuilder: (context, index) {
                  final item = _dataList[index];
                  return ListTile(
                    title: Text(item['name']),
                    // subtitle: Text(item['contactNo']),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteData(item['id']),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
