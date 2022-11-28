import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zarea_user/auth_providers/coupen_provider.dart';

class CouponWidget extends StatefulWidget {
  final String? couponString;
   const CouponWidget({Key? key, this.couponString}) : super(key: key);

  @override
  State<CouponWidget> createState() => _CouponWidgetState();
}

class _CouponWidgetState extends State<CouponWidget> {
  Color? color = Colors.grey.shade300;
  bool enable = false;
  var couponController = TextEditingController();
  bool visibility = false;


  @override
  Widget build(BuildContext context) {
    var coupon = Provider.of<CouponProvider>(context);
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
            child: Row(
              children: [
                Expanded(
                    child: SizedBox(
                      height: 40,
                      child: TextFormField(
                        controller: couponController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.grey.shade300,
                          hintText: 'Apply Voucher Code',
                          hintStyle: const TextStyle(color: Colors.grey),
                        ),
                        onChanged: (String? index){
                          if(index!.length <3){
                            setState(() {
                              color = Colors.grey;
                              enable = false;
                            });
                          }else if(index.isNotEmpty){
                            setState(() {
                              color = Theme.of(context).primaryColor;
                              enable = true;
                            });
                          }
                        },
                      ),
                    )),
                AbsorbPointer(
                  absorbing: enable ? false : true,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side:  BorderSide(color: color!),
                      shape: const RoundedRectangleBorder(
                      ),
                    ),
                    onPressed: (){
                      coupon.getCouponDetails( couponController.text, widget.couponString).then((value){
                        if(coupon.document == null){
                          setState(() {
                            coupon.discountRate =0;
                            visibility = false;
                          });
                          showDialogueText(couponController.text, 'Not Valid');
                          return;
                        }
                        if(coupon.expired == false){
                          setState(() {
                            visibility = true;
                          });
                          return;
                        }
                        if(coupon.expired == true){
                          setState(() {
                            coupon.discountRate =0;
                            visibility = false;
                          });
                          showDialogueText(couponController.text, 'Expired');
                        }
                      });
                    },
                    child: Text('Apply',style: TextStyle(
                      color: color!
                    ),),
                  ),
                )
              ],
            ),
          ),
          Visibility(
            visible: visibility,
            child: coupon.document == null ? Container() : Padding(
              padding: const EdgeInsets.all(8.0),
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                padding: const EdgeInsets.all(6),
                child: ClipRRect(
                  borderRadius:  const BorderRadius.all(
                      Radius.circular(12)),
                  child: Stack(
                    children: [
                      Container(
                        decoration:  BoxDecoration(
                          color: Colors.deepOrangeAccent.withOpacity(0.4),
                        ),
                        width: MediaQuery.of(context).size.width-80,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text('${coupon.document?['title']}'),
                            ),
                            const Divider(),
                            Text('${coupon.document?['description']}'),
                            Text('${coupon.document?['discount']} Discount on special Event'),
                          ],
                        ),
                      ),
                       Positioned(
                          right: -5,
                          top: -10,
                          child: IconButton(
                              onPressed: (){

                              },
                              icon: const Icon(Icons.clear),
                          ),
                       )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
  showDialogueText(code, validity) {
    showCupertinoDialog(
        context: context,
        builder: (context){
      return CupertinoAlertDialog(
        title: const Text('Apply Coupon'),
        content: Text('This Coupon $code you entered is $validity!, Please try with another code', maxLines: 3,),
        actions: [
          TextButton(
              onPressed: (){
              Navigator.pop(context);
              },
              child:  Text('Ok',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
              )
          )
        ],
      );
    });
  }
}
