import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'firebase_work/image_picker_upload.dart';

class FirebaseWork extends StatefulWidget {
  const FirebaseWork({super.key});

  @override
  State<FirebaseWork> createState() => _FirebaseWorkState();
}

class _FirebaseWorkState extends State<FirebaseWork> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(" Image & text data upload and view"),
      ),

      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal, // Allow horizontal scrolling
            child: Row(
               crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> ImagePickerUpload()));
                    },
                    child: Text("Data Image picker upload"),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () {  },
                    child: Text("Data Image View"),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () {  },
                    child: Text("Data Image Edit"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

    );
  }
}
