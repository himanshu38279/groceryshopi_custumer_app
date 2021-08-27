import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:tbo_the_best_one/components/my_cached_network_image.dart';

class MyImageSlider extends StatefulWidget {
  final bool autoPlay;
  final bool showDots;
  final List<String> photoUrls;

  static const double height = 200;

  MyImageSlider({
    @required this.autoPlay,
    @required this.photoUrls,
    this.showDots = false,
  });

  @override
  _MyImageSliderState createState() => _MyImageSliderState();
}

class _MyImageSliderState extends State<MyImageSlider> {
  int _currentIndex = 0;

  int _photosLength;

  @override
  void initState() {
    super.initState();
    _photosLength = widget.photoUrls.length;
  }

  @override
  Widget build(BuildContext context) {
    if (_photosLength == 0) return SizedBox.shrink();
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.symmetric(
              vertical: BorderSide(color: Colors.grey, width: 0.5),
            ),
            color: Color(0xFFF0F0F0),
          ),
          padding: EdgeInsets.symmetric(vertical: 10),
          child: CarouselSlider.builder(
            itemBuilder: (context, index) {
              return MyCachedNetworkImage(
                zoomToFit: false,
                url: this.widget.photoUrls[index],
                width: double.infinity,
                height: double.infinity,
                borderRadius: 5,
                padding: EdgeInsets.symmetric(horizontal: 5),
              );
            },
            itemCount: this._photosLength,
            options: CarouselOptions(
              height: MyImageSlider.height,
              // enlargeCenterPage: true,
              viewportFraction: 0.9,
              initialPage: 0,
              enableInfiniteScroll: this._photosLength != 1,
              reverse: false,
              autoPlay: this.widget.autoPlay,
              autoPlayInterval: Duration(seconds: 2),
              autoPlayAnimationDuration: Duration(milliseconds: 200),
              autoPlayCurve: Curves.fastOutSlowIn,
              onPageChanged: (index, changeReason) {
                setState(() => _currentIndex = index);
              },
              scrollDirection: Axis.horizontal,
            ),
          ),
        ),
        if (this.widget.showDots)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int index = 0; index < this._photosLength; index++)
                Container(
                  width: 10.0,
                  height: 10.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index
                        ? Theme.of(context).accentColor
                        : Colors.grey,
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
