import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zarea_user/auth_providers/cart_provider.dart';
import 'package:zarea_user/auth_providers/coupen_provider.dart';
import 'package:zarea_user/screens/cart_list.dart';
import 'package:zarea_user/screens/map_screen.dart';
import 'package:zarea_user/screens/profile_screen.dart';
import 'package:zarea_user/services/cart_service.dart';
import 'package:zarea_user/services/order_service.dart';
import 'package:zarea_user/services/store_services.dart';
import 'package:zarea_user/services/user_services.dart';
import 'package:zarea_user/utils/error_message.dart';
import 'package:zarea_user/widgets/coupon_widget.dart';
import '../auth_providers/location_provider.dart';

class CartScreen extends StatefulWidget {
  static const id = 'Cart-Screen';
  final DocumentSnapshot? snapshot;
  const CartScreen({Key? key, this.snapshot}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartService cartService = CartService();
  StoresServices services = StoresServices();
  OrderService orderService = OrderService();
  DocumentSnapshot? snapshot;
  bool loading = false;
  bool checkingUser = false;
  double discount = 0;
  int deliveryFee = 70;

  UserServices userServices = UserServices();
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    services.getStoreDetails(widget.snapshot!['sellerUid']).then((value){
      snapshot = value;
    });
    getPref();
    super.initState();
  }
  String? location = '';
  String? address = '';

  getPref() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? location =  preferences.getString('location');
    final String? address =  preferences.getString('address');
    if(mounted){
      setState((){
        this.location = location;
        this.address = address;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    var text = MediaQuery.textScaleFactorOf(context);
    CartProvider cartProvider = Provider.of(context);
    LocationProvider locationProvider = Provider.of(context);
    var couponProvider = Provider.of<CouponProvider>(context);
    setState(() {
      double coupon = cartProvider.subTotal;
      double discountRate = couponProvider.discountRate/100;
      discount = coupon*discountRate;
    });
    var totalPayable = cartProvider.subTotal + deliveryFee-discount;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade300,
      bottomSheet: cartProvider.snapshot ==null ?
      const CircularProgressIndicator()  :
      Container(
        height: 140,
        color: Colors.blueGrey.shade900,
        child: Column(
          children: [
            Container(
              height: 92,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    Row(
                      children:  [
                        const Expanded(
                          child: Text('Deliver to the Address',
                            style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                        InkWell(
                          onTap: (){
                            setState((){
                              checkingUser = true;
                            });
                           locationProvider.getCurrentPosition(context).then((value){
                             setState(() {
                               checkingUser = false;
                             });
                             if(value!=null){
                               PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                                 context,
                                 settings: const RouteSettings(name: MapScreen.id),
                                 screen:   const MapScreen(),
                                 withNavBar: false,
                                 pageTransitionAnimation: PageTransitionAnimation.cupertino,
                               );
                             }else{
                               setState(() {
                                 checkingUser = false;
                               });
                               Utils.flushBarErrorMessage('Permission Not Allowed', context);
                               if(cartProvider.cod == true){
                                 if (kDebugMode) {
                                   print('cash on delivery');
                                 }
                               }else{
                                 if (kDebugMode) {
                                   print('online pay');
                                 }
                               }
                             }

                           });
                          },
                          child: loading? const CircularProgressIndicator() : const Text('Change',
                            style: TextStyle(color: Colors.red,
                                fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),
                    Container(
                      child: Text('$location $address',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: text*12,
                      ),),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Rs.${totalPayable.toStringAsFixed(0)}',
                        style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),),
                      const Text('Including tax',
                        style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),)
                    ],
                  ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: const RoundedRectangleBorder(),
                      ),
                        onPressed: (){
                        userServices.getUserById(user!.uid).then((value){
                          if(value.id.isEmpty){
                            PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                              context,
                              settings: const RouteSettings(name: ProfileScreen.id),
                              screen:   const ProfileScreen(),
                              pageTransitionAnimation: PageTransitionAnimation.cupertino,
                            );
                          }else{
                            saveOrder(cartProvider, totalPayable, couponProvider);
                            EasyLoading.showSuccess('Your Order is Placed');
                          }
                        });
                        },
                        child: const Text('Checkout',
                          style: TextStyle(
                          color: Colors.white
                        ),))
                ],),
              ),
            ),
          ],
        ),
      ),
      body: NestedScrollView(headerSliverBuilder: (context, nested){
        return [
           SliverAppBar(
            title:  Text('${widget.snapshot!['shopName']}',),
            centerTitle: true,
            elevation: 0,
            snap: true,
            floating: true,
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ];
      },
          body: snapshot  == null ?  const Center(child: CircularProgressIndicator()) : cartProvider.quantity> 0?  ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            children: [
              const Divider(color: Colors.blueGrey,),
              // if(snapshot!=null)
              CartList(documentSnapshot: snapshot,),
              //Coupon Code Applying
               CouponWidget(couponString: snapshot?.id),
              //bill Details here
              Padding(
                padding: const EdgeInsets.only(left: 4,right: 4,top: 4, bottom: 80),
                child: SizedBox(
                  width: double.infinity,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Bill Details',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),),
                              Text(cartProvider.subTotal.toStringAsFixed(0),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          if(discount>0)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:  [
                              const Text('Discount',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),),
                              Text(discount.toStringAsFixed(0),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text('Delivery Fee',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),),
                              Text('70',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Divider(color: Colors.grey.shade300,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:  [
                              const Text('Total Amount Payable',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),),
                              Text(totalPayable.toStringAsFixed(0),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Theme.of(context).primaryColor.withOpacity(0.3),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children:  [
                                  const Expanded(child: Text('Total Saving')),
                                  Text(cartProvider.saving.toStringAsFixed(0))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ): const Center(child: Text('Cart is Empty',
            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 28),)),
      ),
    );
  }
  saveOrder(CartProvider _cartProvider, payable, CouponProvider couponProvider){
    orderService.saveOrder({
      'products': _cartProvider.orders,
      'deliveryFee': deliveryFee,
      "userId": user?.uid,
      "totalPayable": payable,
      "discount": discount,
      "cod": _cartProvider.cod,
      "discountCode": couponProvider.document ==null? null : couponProvider.document!['title'],
      'seller': {"shopName": widget.snapshot!['shopName'], "sellerId": widget.snapshot!['sellerUid']},
      'timeStamp': DateTime.now().toString(),
      "orderStatus": "Ordered",
      "deliveryBoy": {
        'name': "",
        "phone": "",
        "location": "",
      }
    }).then((value){
      cartService.deleteCart().then((value){
        Navigator.pop(context);
      });
    });

  }
}
