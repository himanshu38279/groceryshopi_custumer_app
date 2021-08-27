import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tbo_the_best_one/components/my_image_slider.dart';

extension _ShimmerExtension on Widget {
  Widget shimmer() {
    return Shimmer.fromColors(
      child: this,
      baseColor: Colors.grey[400],
      highlightColor: Colors.white,
      period: Duration(milliseconds: 350),
    );
  }
}

class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 5),
      height: 130,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
      ),
      child: Row(
        children: [
          Container(
            color: Colors.grey,
            width: 125,
            height: 125,
          ).shimmer(),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: double.infinity,
                  height: 20,
                  color: Colors.grey,
                ).shimmer(),
                SizedBox(height: 5),
                Container(
                  width: double.infinity,
                  height: 20,
                  color: Colors.grey,
                ).shimmer(),
                SizedBox(height: 5),
                Container(
                  width: double.infinity,
                  height: 20,
                  color: Colors.grey,
                ).shimmer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.all(10),
      itemBuilder: (context, index) {
        return ProductCardShimmer();
      },
      itemCount: 10,
    );
  }
}

class ContainerShimmer extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;

  const ContainerShimmer({
    this.height = MyImageSlider.height,
    this.width = double.infinity,
    this.borderRadius = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width,
      height: this.height,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(this.borderRadius),
      ),
    ).shimmer();
  }
}

class FABShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: FloatingActionButton(
        onPressed: null,
        heroTag: null,
      ).shimmer(),
    );
  }
}
