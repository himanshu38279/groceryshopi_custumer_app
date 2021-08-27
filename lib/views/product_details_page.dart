import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';
import 'package:tbo_the_best_one/api/repository.dart';
import 'package:tbo_the_best_one/components/buy_membership_bottom_container.dart';
import 'package:tbo_the_best_one/components/cart_add_button.dart';
import 'package:tbo_the_best_one/components/custom_loader.dart';
import 'package:tbo_the_best_one/components/discount_card.dart';
import 'package:tbo_the_best_one/components/my_app_bar.dart';
import 'package:tbo_the_best_one/components/my_image_slider.dart';
import 'package:tbo_the_best_one/components/product_list_view.dart';
import 'package:tbo_the_best_one/components/shimmers.dart';
import 'package:tbo_the_best_one/components/text_container.dart';
import 'package:tbo_the_best_one/controllers/cart_controller.dart';
import 'package:tbo_the_best_one/models/product.dart';
import 'package:tbo_the_best_one/models/user.dart';

// ignore: must_be_immutable
class ProductDetailsPage extends StatefulWidget {
  static const id = 'product_details_page';
  Product product;

  ProductDetailsPage(this.product);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  Future<List<String>> _imagesFuture;
  String selectedVariantId;
  Map<String, Product> _variantsMap;

  User user;

  Product get _selectedProduct {
    return selectedVariantId == null
        ? widget.product
        : _variantsMap[selectedVariantId];
  }

  bool _isLoading;

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    if (widget.product.name == null) {
      _isLoading = true;
      setState(() {});
      widget.product =
          await Repository.getProductDetails(id: widget.product.id);
      _isLoading = false;
      setState(() {});
    } else
      _isLoading = false;

    _imagesFuture =
        Repository.getProductImagesList(productId: widget.product.id);

    _variantsMap ??= {};
    widget.product.productVariants ??= [];
    if (widget.product.productVariants.isNotEmpty) {
      for (Product variant in widget.product.productVariants) {
        _variantsMap[variant.id] = variant;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    final cart = Provider.of<CartController>(context);
    return SafeArea(
      child: _isLoading
          ? Scaffold(body: Center(child: CustomLoader()))
          : Scaffold(
              appBar: MyAppBar(
                screenId: ProductDetailsPage.id,
                title: Text(_selectedProduct.name),
              ),
              bottomNavigationBar: BuyMembershipBottomContainer(),
              body: CustomLoadingScreen(
                isLoading: cart.getLoadingStatus(_selectedProduct.id),
                child: ListView(
                  children: [
                    FutureBuilder<List<String>>(
                      future: _imagesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final _images =
                              [_selectedProduct.image] + snapshot.data;
                          return MyImageSlider(
                            autoPlay: false,
                            showDots: true,
                            photoUrls: _images,
                          );
                        } else
                          return ContainerShimmer();
                      },
                    ),
                    Divider(color: Colors.grey, thickness: 0.5, height: 1),
                    _buildProductDetailsContainer(context),
                    Divider(color: Colors.grey, thickness: 0.5, height: 1),
                    _buildVariantsContainer(),
                    Divider(color: Colors.grey[300], thickness: 15),
                    _buildTabBar(context),
                    Divider(color: Colors.grey[300], thickness: 15),
                    ProductListView(
                      title: "Similar Products",
                      categoryId: widget.product.categoryId,
                      subCategoryId: widget.product.subcategoryId,
                    ),
                    // ProductListView(title: "Most Popular"),
                  ],
                ),
              ),
            ),
    );
  }

  ListView _buildTabBar(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        if (widget.product.productDetails != null)
          _buildExpansionTile(
            text: "Description",
            widget: HtmlWidget(widget.product.productDetails),
          ),
        // _buildExpansionTile(text: "Offer", value: "Brand Offer"),
        // _buildExpansionTile(
        //   text: "Key Features",
        //   value: [
        //     "a type specimen book. It has survived not only five centuri",
        //     "s containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem",
        //     "eb sites still in their infancy. Various versions have evolved over the years, som",
        //   ].join('\n'),
        // ),
        _buildExpansionTile(
          text: "Unit",
          value: widget.product.productUnit,
        ),
        // _buildExpansionTile(
        //   text: "Disclaimer",
        //   value:
        //       "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuri",
        // ),
        _buildExpansionTile(
          text: "Barcode",
          initiallyExpanded: false,
          widget: BarcodeWidget(
            drawText: false,
            barcode: Barcode.code128(),
            data: widget.product.code,
            errorBuilder: (context, error) => Text("Barcode not available"),
            padding: const EdgeInsets.all(5),
            height: 150,
          ),
        ),
      ],
    );
  }

  ExpansionTile _buildExpansionTile({
    @required String text,
    bool initiallyExpanded = true,
    String value,
    Widget widget,
  }) {
    return ExpansionTile(
      initiallyExpanded: initiallyExpanded,
      title: Text(text),
      expandedAlignment: Alignment.centerLeft,
      childrenPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      children: [
        if (widget == null)
          Text(
            value,
            style: TextStyle(color: Colors.grey[600]),
          )
        else
          widget,
      ],
    );
  }

  Widget _buildVariantsContainer({bool showTitle = true}) {
    if (widget.product.productVariants.length > 0)
      return Container(
        padding: EdgeInsets.all(10),
        height: showTitle ? 90 : 60,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showTitle) ...[Text("Variants"), SizedBox(height: 10)],
            Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final variant = widget.product.productVariants[index];
                  return TextContainer(
                    variant.name,
                    margin: EdgeInsets.only(left: 10),
                    selected: selectedVariantId == variant.id,
                    onTap: () {
                      if (selectedVariantId != null) {
                        if (variant.id == selectedVariantId)
                          selectedVariantId = null;
                        else
                          selectedVariantId = variant.id;
                      } else
                        selectedVariantId = variant.id;
                      setState(() {});
                    },
                  );
                },
                itemCount: widget.product.productVariants.length,
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      );
    else
      return SizedBox.shrink();
  }

  Container _buildProductDetailsContainer(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_selectedProduct.isOnDiscount)
            DiscountCard(_selectedProduct.discount)
          else
            SizedBox.shrink(),
          SizedBox(height: 15),
          Text(
            widget.product.name,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          if (_selectedProduct.isOnDiscount) ...[
            SizedBox(height: 20),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontFamily: 'ProductSans',
                ),
                children: [
                  TextSpan(
                    text: "Product MRP :     ",
                    style: TextStyle(fontSize: 17),
                  ),
                  TextSpan(
                    text: _selectedProduct.originalPriceAsString,
                    style: TextStyle(
                      fontSize: 14,
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ] else
            SizedBox.shrink(),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontFamily: 'ProductSans',
                  ),
                  children: [
                    TextSpan(text: "Selling Price :     "),
                    TextSpan(
                      text: _selectedProduct.priceAsString,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    TextSpan(text: "\n"),
                    TextSpan(
                      text: "(inclusive of all taxes)",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              CardAddButton(product: _selectedProduct, width: 100),
            ],
          ),
        ],
      ),
    );
  }
}
