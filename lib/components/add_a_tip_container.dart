import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tbo_the_best_one/components/custom_container.dart';
import 'package:tbo_the_best_one/components/text_container.dart';
import 'package:tbo_the_best_one/controllers/cart_controller.dart';
import 'package:tbo_the_best_one/utilities/constants.dart';

class AddATipContainer extends StatefulWidget {
  @override
  _AddATipContainerState createState() => _AddATipContainerState();
}

class _AddATipContainerState extends State<AddATipContainer> {
  int selectedTipIndex;

  @override
  void initState() {
    selectedTipIndex = -1;
    super.initState();
  }

  final List<int> tips = [25, 50, 90, 100, 125, 150];

  @override
  Widget build(BuildContext context) {
    final CartController cart = Provider.of<CartController>(context);
    if (cart.isEmpty) return SizedBox.shrink();
    return CustomContainer(
      padding: 0,
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            color: Color(0xFFFFF8F5),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.transparent,
                  child: Image.asset(
                    'assets/images/mask-clipart.png',
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Add tip to support you delivery hero"),
                      SizedBox(height: 5),
                      Text(
                        "Your delivery hero risks his life to deliver grocery safely in the times of crisis.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(color: Colors.grey, height: 1, thickness: 1),
          Container(
            color: Colors.white,
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(10),
              itemBuilder: (context, index) {
                return TextContainer(
                  "$kRupeeSymbol ${tips[index]}",
                  margin: EdgeInsets.only(left: 10),
                  width: 75,
                  selected: index == selectedTipIndex,
                  onTap: () {
                    if (selectedTipIndex == index)
                      selectedTipIndex = -1;
                    else
                      selectedTipIndex = index;
                    cart.setTip(
                      selectedTipIndex == -1 ? 0 : tips[selectedTipIndex],
                    );
                    setState(() {});
                  },
                );
              },
              itemCount: tips.length,
            ),
          ),
        ],
      ),
    );
  }
}
