import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class SliderWidget extends StatefulWidget {
  const SliderWidget({Key? key}) : super(key: key);

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {

  int _index = 0;
  int _dataLength = 1;

  Future getSliderImage() async{
    var fireStore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await fireStore.collection('slider').get();
    if(mounted){
      setState((){
        _dataLength = snapshot.docs.length;
      });
    }
    return snapshot.docs;
  }
  @override
  void initState() {
    getSliderImage();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          if(_dataLength != 0)
            FutureBuilder(
              future: getSliderImage(),
                builder: (_, AsyncSnapshot snapShot){
              return snapShot.data == null?  SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
              ) :
              Padding(
                padding: const EdgeInsets.only(top: 4,left: 4,right: 5),
                child: CarouselSlider.builder(
                    itemCount: snapShot.data.length,
                    itemBuilder: (BuildContext context, int index, int){
                      DocumentSnapshot sliderImage = snapShot.data[index]?? 0;
                      Map getImage = sliderImage.data() as Map;
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(6))
                        ),
                        child: Image.network(getImage['image'], fit: BoxFit.fill,)
                      );
                    },
                    options: CarouselOptions(
                      viewportFraction: 1,
                      initialPage: 0,
                      autoPlay: true,
                      height: 150.h,
                      onPageChanged: (int i, carouselPageChangedReason){
                        setState((){
                          _index = i;
                        });
                      }
                    ),
                ),
              );
            }),
          if(_dataLength != 0)DotsIndicator(
              dotsCount: _dataLength,
            position: _index.toDouble(),
            decorator: DotsDecorator(
              size: Size.square(5.r),
              activeSize: const Size(18, 5),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              activeColor: Theme.of(context).primaryColor,
            ),
          )
        ]
      );
  }
}
