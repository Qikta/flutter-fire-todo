import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/memo.dart';

class AddEditMemoPage extends StatefulWidget {
  final Memo? currentMemo;
  const AddEditMemoPage({Key? key, this.currentMemo}) : super(key: key);

  @override
  State<AddEditMemoPage> createState() => _AddEditMemoPageState();
}

class _AddEditMemoPageState extends State<AddEditMemoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController detailController = TextEditingController();

  Future<void> createMemo() async{
    final memoCollection = FirebaseFirestore.instance.collection('memo');
    await memoCollection.add({
      'title': titleController.text,
      'detail': detailController.text,
      'createDate': Timestamp.now()
    });
  }

  Future<void> updateMemo() async{
    final docs = FirebaseFirestore.instance.collection('memo').doc(widget.currentMemo!.id);
    await docs.update({
      'title': titleController.text,
      'detail': detailController.text,
      'updateDate': Timestamp.now()
    });
  }

  @override
  void initState() {
    super.initState();
    if(widget.currentMemo != null) {
      titleController.text = widget.currentMemo!.title;
      detailController.text = widget.currentMemo!.detail;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.currentMemo == null ? 'add memo' : 'edit memo'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40,),
            const Text('title'),
            const SizedBox(height: 20,),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black)
              ),
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                controller: titleController,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 10)),
              )),
            const SizedBox(height: 40,),
            const Text('detail'),
            const SizedBox(height: 20,),
            Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black)
                ),
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  controller: detailController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 10)),
                )),
            const SizedBox(height: 40,),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              alignment: Alignment.center,
              child: ElevatedButton(
                  onPressed: () async {
                    if(widget.currentMemo == null) {
                      await createMemo();
                    } else {
                      await updateMemo();
                    }
                    Navigator.pop(context);
                  },
                  child: Text(widget.currentMemo == null ? 'add memo' : 'edit memo')),
            )
          ],
        ),
      )
    );
  }
}
