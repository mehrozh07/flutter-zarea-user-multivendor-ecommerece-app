import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../auth_providers/store_provider.dart';
import '../product_widgets/product_list.dart';

class ProductListScreen extends StatelessWidget {
  static const id = 'Product-ListScreen';
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var storeProvider = Provider.of<StoreProvider>(context);
    return Scaffold(
        body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
      return [
        SliverAppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          title: Text('${storeProvider.selectCategory}',
              style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )
              ),),
        ),
      ];
    }, body:  ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
            children: [

              ProductList()
            ],),
    ),
    );
  }
}
