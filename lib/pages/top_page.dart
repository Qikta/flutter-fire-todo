

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_fire/model/memo.dart';
import 'package:todo_fire/pages/add_edit_memo_page.dart';
import 'package:todo_fire/pages/memo_detail_page.dart';

class TopPage extends StatefulWidget {
  const TopPage({super.key, required this.title});

  final String title;

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  final memoCollection = FirebaseFirestore.instance.collection('memo');

  Future<void> deleteMemo(String id) async {
    final docs = FirebaseFirestore.instance.collection('memo').doc(id);
    await docs.delete();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: memoCollection.orderBy('createDate', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('memo not found...'));
          }
          final docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> data = docs[index].data() as Map<String, dynamic>;
              final Memo featchMemo = Memo(
                  id: docs[index].id,
                  title: data['title'],
                  detail: data['detail'],
                  createDate: data['createDate'],
                  updatedDate: data['updateDate']);

              return ListTile(
                title: Text(featchMemo.title),
                trailing: IconButton(
                  onPressed: () {
                    showModalBottomSheet(context: context, builder: (context) {
                      return SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AddEditMemoPage(currentMemo: featchMemo,)));
                              },
                              leading: const Icon(Icons.edit),
                              title: const Text('edit'),
                            ),
                            ListTile(
                              onTap: () async {
                                await deleteMemo(featchMemo.id);
                                Navigator.pop(context);
                              },
                              leading: const Icon(Icons.delete),
                              title: Text('delete'),
                            )
                          ],
                        ),
                      );
                    });
                  },
                  icon: const Icon(Icons.edit),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => MemoDetailPage(featchMemo)));
                },
              );
          });
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddEditMemoPage()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}