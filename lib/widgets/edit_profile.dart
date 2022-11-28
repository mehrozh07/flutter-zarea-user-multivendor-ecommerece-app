import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zarea_user/services/user_services.dart';
import 'package:zarea_user/utils/error_message.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _fromKey = GlobalKey<FormState>();
  var firstName = TextEditingController();
  var secondName = TextEditingController();
  var email = TextEditingController();
  var phone = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  UserServices userServices = UserServices();

  @override
  void initState() {
    userServices.getUserById(user!.uid).then((value){
      if(mounted){
        firstName.text = value['firstName'];
        secondName.text = value['lastName'];
        email.text = value['email'];
      }
    });
    super.initState();
  }
 updateProfile() {
    FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
      'firstName': firstName.text,
      'lastName': secondName.text,
      'email': email.text,
    });
  }
  @override
  Widget build(BuildContext context) {
    setState(() {
      phone.text = user!.phoneNumber!;
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text('Edit Profile',style: TextStyle(fontSize: 16,color: Colors.white),),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
                child: CupertinoButton(
                  color: Theme.of(context).primaryColor,
                  disabledColor: Theme.of(context).primaryColor,
                  child: const Text('Save',
                    style: TextStyle(color: Colors.white),),
                onPressed: (){
              if(_fromKey.currentState!.validate()){
                updateProfile();
                Navigator.pop(context);
              }else{
                Utils.flushBarErrorMessage('Field cant be empty', context);
              }
                },
                ),
            ),
          ],
        ),
      ),
      body: Form(
        key: _fromKey,
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            Row(
              children: [
                Expanded(child: TextFormField(
                  controller: firstName,
                  validator: (value){
                    if(value!.isEmpty){
                      return "*required";
                    }
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "First Name",
                    labelStyle: TextStyle(color: Colors.grey),
                    // contentPadding: EdgeInsets.zero,
                  ),
                )),
                const SizedBox(width: 20,),
                Expanded(child: TextFormField(
                  validator: (value){
                    if(value!.isEmpty){
                      return "*required";
                    }
                  },
                  controller: secondName,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Last Name",
                    labelStyle: TextStyle(color: Colors.grey),
                    // contentPadding: EdgeInsets.zero,
                  ),
                )),
              ],
            ),
            const SizedBox(height: 10,),
            TextFormField(
              validator: (value){
                if(value!.isEmpty){
                  return "*required";
                }
              },
              controller: phone,
              enabled: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "mobile",
                labelStyle: TextStyle(color: Colors.grey),
                // contentPadding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: 10,),
            TextFormField(
              validator: (value){
                if(value!.isEmpty){
                  return "*required";
                }
              },
              controller: email,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "email",
                labelStyle: TextStyle(color: Colors.grey),
                // contentPadding: EdgeInsets.zero,
              ),
            )
          ],
        ),
      ),
    );
  }
}
