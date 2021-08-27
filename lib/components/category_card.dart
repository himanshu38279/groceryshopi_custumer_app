import 'package:flutter/material.dart';
import 'package:tbo_the_best_one/components/my_cached_network_image.dart';
import 'package:tbo_the_best_one/models/category.dart';
import 'package:tbo_the_best_one/views/category_screen.dart';

class CategoryCard extends StatelessWidget {
  final Category category;

  CategoryCard(this.category);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, CategoryScreen.id, arguments: {
          'category': category,
        });
      },
      child: Container(
        margin: EdgeInsets.all(5),
        height: 175,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
          border: Border.all(color: Theme.of(context).accentColor, width: 3),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            MyCachedNetworkImage(url: category.image, borderRadius: 7),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 45,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: Theme.of(context).accentColor),
                child: Text(
                  category.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
