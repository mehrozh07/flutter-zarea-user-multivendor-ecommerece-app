import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zarea_user/auth_providers/order_provider.dart';
import '../services/order_service.dart';
import 'package:chips_choice/chips_choice.dart';

class MyOrderScreen extends StatefulWidget {
  static const id = '/order-screen';
   MyOrderScreen({Key? key}) : super(key: key);

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  OrderService orderService = OrderService();

  User? user = FirebaseAuth.instance.currentUser;

  List<String> options = [
    'All order',
    "Ordered",
    'Accepted',
    'PickUp',
    'On the Way',
    'Delivered',
  ];
  int tag = 0;

  @override
  Widget build(BuildContext context) {
    var orders = Provider.of<OrderProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('My Order',
            style: GoogleFonts.poppins(
          fontSize: 16, fontWeight: FontWeight.bold,
              color: Colors.white,
        )),
      ),
      body: Column(
        children: [
          Container(
            height: 56,
            color: Colors.white,
            width: double.infinity,
            child: ChipsChoice<int>.single(
              choiceStyle:  const C2ChipStyle(
                  borderRadius: BorderRadius.all(Radius.circular(5))
              ),
              value: tag,
              onChanged: (val){
                if(val==0){
                  setState(() {
                    orders.status = '';
                  });
                }
                setState(() {
                  tag = val;
                    orders.status = options[val];
                });
              },
              choiceItems: C2Choice.listFrom<int, String>(
                source: options,
                value: (i, v) => i,
                label: (i, v) => v,
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: orderService.order.where('userId', isEqualTo: user?.uid)
                .where('orderStatus', isEqualTo: tag> 0 ? orders.status : null).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                );
              }
              if (snapshot.data?.size ==0) {
                return Text(tag>0 ? 'No ${options[tag]} available' : "No Orders, Continue Shopping" );
              }
              return Expanded(
                child: ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    return Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          visualDensity: const VisualDensity(horizontal: -4),
                          leading: CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.white,
                            child: orderService.statusIcons(document),
                          ),
                          title: Text(document['orderStatus'],
                          style: TextStyle(
                            color: orderService.statusColor(document),
                          ),),
                          subtitle: Text(
                            'On ${DateFormat.yMMMd().format(DateTime.parse(document['timeStamp']))}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Amount: ${document['totalPayable'].toStringAsFixed(0)}',
                                style: const TextStyle(fontSize: 12),),
                              Text('Payment Type: ${document['cod']==true? "Pay Online" : "Cash On Delivery"}',
                                style: const TextStyle(fontSize: 10),),
                            ],
                          ),
                        ),
                         //TODO: Delivery Boy Details Container with contact and Live Location
                        if(document['deliveryBoy']['name'].length>2)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 20),
                          child: ListTile(
                            tileColor: Theme.of(context).primaryColor.withOpacity(0.3),
                              trailing: TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    backgroundColor: Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  onPressed: () async{
                                    // For android
                                    var uri = 'sms:${document['deliveryBoy']['phone']}?body=Hi there? Where are you now??';
                                    if (await launch(uri)) {
                                    await launch(uri);
                                    } else {
                                    // iOS
                                    var uri = 'sms:${document['deliveryBoy']['phone']}?body=Hello there where you now?';
                                    if (await launch(uri)) {
                                    await launch(uri);
                                    } else {
                                    throw 'Could not launch $uri';
                                    }
                                    }
                                  },
                                  child: const Icon(Icons.message_rounded, color: Colors.white,)),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage('${document['deliveryBoy']['image']}',),
                            ),
                            title: Text('${document['deliveryBoy']['name']}'),
                            subtitle: Text(orderService.statusComment(document)),
                          ),
                        ),
                         ExpansionTile(
                          title: const Text('Order Details',style: TextStyle(fontWeight: FontWeight.bold),),
                        subtitle: const Text('View Order Details',style: TextStyle(fontWeight: FontWeight.normal),),
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: document['products'].length,
                              itemBuilder: (context, index){
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(document['products'][index]['productImage']),
                              ),
                              title: Text("${document['products'][index]['productName']}",
                                style: const TextStyle(fontWeight: FontWeight.bold),),
                              subtitle: Text("${document['products'][index]['quantity']}"
                                  " x ${document["products"][index]["price"]}"
                                  " = ${document["products"][index]["total"].toStringAsFixed(0)}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),),
                            );
                          }),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              color: Theme.of(context).primaryColor.withOpacity(0.3),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Text('Seller: ',style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54) ,),
                                        Text('${document["seller"]['shopName']}',
                                          style: const TextStyle(fontSize: 14, color: Colors.black54) ,)
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    if(document['discount']>0)
                                     Column(
                                       children: [
                                         Row(
                                           children: [
                                             const Text('Discount: ',style: TextStyle(
                                                 fontSize: 16,
                                                 fontWeight: FontWeight.bold,
                                                 color: Colors.black54) ,),
                                             Text('${document["discount"]}',
                                               style: const TextStyle(fontSize: 14, color: Colors.black54) ,)
                                           ],
                                         ),
                                         const SizedBox(height: 10,),
                                         Row(
                                           children: [
                                             const Text('Discount Code: ',style: TextStyle(
                                                 fontSize: 16,
                                                 fontWeight: FontWeight.bold,
                                                 color: Colors.black54) ,),
                                             Text('${document["discountCode"]}',
                                               style: const TextStyle(fontSize: 14, color: Colors.black54) ,)
                                           ],
                                         )
                                       ],
                                     ),

                                    Row(
                                      children: [
                                        const Text('Delivery Fee: ',style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54) ,),
                                        Text('${document["deliveryFee"]}',
                                          style: const TextStyle(fontSize: 14, color: Colors.black54) ,)
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Divider(color: Colors.black87, thickness: 2,),
                        ),
                      ],

                    );
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
