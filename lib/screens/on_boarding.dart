import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zarea_user/constants/constants.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
final _pageController = PageController(
    initialPage: 0,
    );
int currentPage = 0;
final List<Widget> _pages = [
  Column(
    children: [
      Expanded(child: Image.asset('assets/images/deliverfood.png')),
       Text("Order Online from Your Favourite Store", style: KpageViewTextStyle,textAlign: TextAlign.center,),
    ],
  ),
  Column(
    children: [
      Expanded(child: Image.asset('assets/images/enteraddress.png')),
       Text("Set Your Delivery Location", style: KpageViewTextStyle,),
    ],
  ),
  Column(
    children: [
      Expanded(child: Image.asset('assets/images/orderfood.png')),
       Text("Quick Deliver to Your Doorstep", style: KpageViewTextStyle,),
    ],
  ),
];
  @override
  Widget build(BuildContext context) {
    return  Column(
         children: [
           Expanded(
             child: PageView(
               controller: _pageController,
               children: _pages,
               onPageChanged: (index){
                 setState((){
                   currentPage = index;
                 });
               },
             ),
           ),
     SizedBox(height: 20.h,),
     DotsIndicator(
    dotsCount: _pages.length,
    position: currentPage.toDouble(),
    decorator:  DotsDecorator(
      size: Size.square(9.r),
      activeSize: Size(18.w, 9.h),
    activeColor: Theme.of(context).primaryColor,
      activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r),
      )
    ),
    ),
           SizedBox(height: 20.h,),
         ],
    );
  }
}
