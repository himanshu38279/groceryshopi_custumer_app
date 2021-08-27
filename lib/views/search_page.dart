import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tbo_the_best_one/api/repository.dart';
import 'package:tbo_the_best_one/components/custom_loader.dart';
import 'package:tbo_the_best_one/components/my_app_bar.dart';
import 'package:tbo_the_best_one/components/my_cached_network_image.dart';
import 'package:tbo_the_best_one/components/my_drawer.dart';
import 'package:tbo_the_best_one/components/my_search_field.dart';
import 'package:tbo_the_best_one/components/nothing_found_here.dart';
import 'package:tbo_the_best_one/controllers/loading_controller.dart';
import 'package:tbo_the_best_one/controllers/search_controller.dart';
import 'package:tbo_the_best_one/models/brand.dart';
import 'package:tbo_the_best_one/models/category.dart';
import 'package:tbo_the_best_one/models/product.dart';
import 'package:tbo_the_best_one/models/search_result.dart';
import 'package:tbo_the_best_one/views/category_screen.dart';
import 'package:tbo_the_best_one/views/product_details_page.dart';
import 'package:tbo_the_best_one/views/products_by_brand_screen.dart';

class SearchPage extends StatefulWidget {
  static const id = 'search_page';

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchText;
  SearchResult searchResult = SearchResult.fromJson({});
  Timer _timer;
  LoadingController loadingController;
  TextEditingController _controller;
  SearchController searchController;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    loadingController = Provider.of<LoadingController>(context);
    searchController = Provider.of<SearchController>(context);

    void _onChanged(String value) async {
      _timer?.cancel();
      _timer = Timer.periodic(
        Duration(milliseconds: 250),
        (t) async {
          if (t.tick == 1) {
            _timer?.cancel();
            if (searchText != value) {
              if (value != null && value.trim() != "") {
                searchText = value;
                if (!loadingController.isLoading)
                  loadingController.startLoading();
                searchResult = await Repository.search(searchText);
                if (loadingController.isLoading)
                  loadingController.stopLoading();
              } else
                searchResult = SearchResult.fromJson({});
            }
            setState(() {});
          }
        },
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: MyAppBar(
          screenId: SearchPage.id,
          title: MySearchField(
            color: Colors.white,
            autoFocus: true,
            showPrefix: false,
            showUnderline: true,
            onChanged: _onChanged,
            controller: _controller,
          ),
        ),
        drawer: MyDrawer(),
        body: CustomLoadingScreen(
          child: ListView(
            children: [
              if (searchController.recentSearches.isNotEmpty) ...[
                Material(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Recent Searches",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 5),
                        Wrap(
                          spacing: 10,
                          children: searchController.recentSearches
                              .map(
                                (e) => GestureDetector(
                                  onTap: () {
                                    _controller.text = e;
                                    setState(() {});
                                    _onChanged(e);
                                  },
                                  child: Chip(
                                    labelPadding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    label: Text(e),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      side: BorderSide(
                                          color: Theme.of(context).accentColor),
                                    ),
                                    backgroundColor: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.3),
                                    clipBehavior: Clip.hardEdge,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              if (searchResult.isEmpty)
                NothingFoundHere()
              else
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildListView(
                      heading: "CATEGORIES",
                      list: searchResult?.categories ?? [],
                      onTap: (id) {
                        Navigator.pushNamed(
                          context,
                          CategoryScreen.id,
                          arguments: {'category': Category(id: id)},
                        );
                      },
                    ),
                    _buildListView(
                      heading: "BRANDS",
                      list: searchResult?.brands ?? [],
                      onTap: (id) {
                        Navigator.pushNamed(
                          context,
                          ProductsByBrandScreen.id,
                          arguments: Brand(id: id),
                        );
                      },
                    ),
                    _buildListView(
                      heading: "PRODUCTS",
                      list: searchResult?.products ?? [],
                      onTap: (id) {
                        Navigator.pushNamed(
                          context,
                          ProductDetailsPage.id,
                          arguments: Product(id: id),
                        );
                      },
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListView({
    @required String heading,
    @required List<SearchItem> list,
    @required void Function(String) onTap,
  }) {
    if (list.length == 0)
      return SizedBox.shrink();
    else
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              heading,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
          Material(
            color: Colors.white,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    list[index].name,
                    style: TextStyle(fontSize: 14),
                  ),
                  contentPadding: EdgeInsets.zero,
                  leading: MyCachedNetworkImage(
                    url: list[index].image,
                    width: 25,
                    height: 25,
                    borderRadius: 5,
                    padding: const EdgeInsets.only(left: 15),
                  ),
                  trailing: Text(list[index].priceAsString),
                  onTap: () {
                    searchController.addRecentSearch(searchText);
                    return onTap(list[index].id);
                  },
                );
              },
              itemCount: list.length,
            ),
          ),
        ],
      );
  }
}
