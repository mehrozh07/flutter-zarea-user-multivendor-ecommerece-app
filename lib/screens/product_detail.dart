import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zarea_user/widgets/cart_buttons/bottom_sheet.dart';

class ProductDetail extends StatelessWidget {
  static const id = 'Product-Screen';
  final DocumentSnapshot? document;
  const ProductDetail({Key? key, this.document}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('Shop'),
      ),
        bottomSheet: BottomSheetWidget(snapshot: document,),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(.3),
                      border: Border.all(color: Theme.of(context).primaryColor),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 8, right: 8, top: 2,bottom: 2
                      ),
                      child: Text('${document?['brand']}',
                      style: GoogleFonts.poppins(

                      ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              Text('${document?['productName']}',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),),
              const SizedBox(height: 10,),
              Text('${document?['weight']}Kg',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),),
              const SizedBox(height: 10,),
              Row(
                children: [
                  Text('Rs.${document?['price']}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),),
                  const SizedBox(width: 15,),
                  Text('Rs.${document?['comapredPrice']}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      decoration: TextDecoration.lineThrough,
                    ),),
                  const SizedBox(width: 15,),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(4)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6, right: 6, top: 3, bottom: 3),
                      child: Text('20% OFF',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white,
                        ),),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Hero(
                    tag: document?['productImage'],
                child: Image.network(document?['productImage'],)),
              ),
              const SizedBox(height: 10,),
              Divider(color: Colors.grey.shade300, thickness: 6,),
              Padding(
                padding: const EdgeInsets.only(left: 8,right: 8),
                child: Text('About this Product',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                  ),),
              ),
              Divider(color: Colors.grey.shade300,),
              Padding(
                padding: const EdgeInsets.only(left: 8,right: 8),
                child: ExpandableText(
                  expandText: 'see more',
                  collapseText: 'see Less',
                  maxLines: 2,
                  '${document?['productDescription']}',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${document?['sku']}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),),
                  Text('${document?['seller']['shopName']}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),),
                ],
              ),

            ],
          ),
        ),
    );
  }
}
