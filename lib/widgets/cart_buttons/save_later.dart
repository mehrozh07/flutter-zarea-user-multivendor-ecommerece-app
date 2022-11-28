import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';

class SaveLater extends StatefulWidget {
  final DocumentSnapshot? snapshot;
  const SaveLater({Key? key, this.snapshot}) : super(key: key);

  @override
  State<SaveLater> createState() => _SaveLaterState();
}

class _SaveLaterState extends State<SaveLater> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: const RoundedRectangleBorder(
                  side: BorderSide.none),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            onPressed: () async{
              EasyLoading.show(status: 'Saving');
              await saveForLater().then((value){
                EasyLoading.showSuccess('Saved');
              });
            },
            child: Row(
              children: [
                const Icon(Icons.favorite, color: Colors.white,),
                const SizedBox(width: 3,),
                Text(
                  'Add to Fav',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> saveForLater() {
    CollectionReference favourite = FirebaseFirestore.instance.collection('favProducts');
    User? user = FirebaseAuth.instance.currentUser;
    return favourite.add({
      'product': widget.snapshot?.data(),
      'customerId': user?.uid,
    });
  }
}
