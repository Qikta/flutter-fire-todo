

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_fire/model/memo.dart';
import 'package:todo_fire/pages/memo_detail_page.dart';

class TopPage extends StatefulWidget {
  const TopPage({super.key, required this.title});

  final String title;

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  List<Memo> memoList = [];
  
  Future<void> featchMemo() async {
    final memoCollection = await FirebaseFirestore.instance.collection('memo').get();
    final docs = memoCollection.docs;
    for (var item in docs) {
      Memo featchMemo = Memo(
          title: item.data()['title'],
          detail: item.data()['detail'],
          createDate: item.data()['createDate']
      );
      memoList.add(featchMemo);
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    featchMemo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: memoList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(memoList[index].title),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => MemoDetailPage(memoList[index])));
            },
          );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}