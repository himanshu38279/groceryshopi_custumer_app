import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:tbo_the_best_one/components/address_bottom_sheet.dart';
import 'package:tbo_the_best_one/components/custom_loader.dart';
import 'package:tbo_the_best_one/components/my_button.dart';
import 'package:tbo_the_best_one/utilities/constants.dart';

class OrderThroughListUpload extends StatefulWidget {
  static const id = 'order_through_list_upload';

  @override
  _OrderThroughListUploadState createState() => _OrderThroughListUploadState();
}

class _OrderThroughListUploadState extends State<OrderThroughListUpload> {
  final _picker = ImagePicker();

  List<File> _images = [];
  final String address_id = "";

  Future<void> _pickImage(ImageSource source) async {
    final selected = await _picker.getImage(source: source);
    //if (selected != null) _images.add(File(selected.path));
    setState(() {});
  }

  Future<void> selectImages() async {
    // List<Media> _listImagePaths = await ImagePickers.pickerPaths(
    //     galleryMode: GalleryMode.image,
    //     selectCount: 10,
    //     showGif: false,
    //     showCamera: false,
    //     compressSize: 500,
    //     uiConfig: UIConfig(uiThemeColor: kAppBarColor),
    //     cropConfig: CropConfig(enableCrop: false, width: 2, height: 1));
    // _listImagePaths.forEach((element) {
    //   _images.add(File(element.path));
    //   //print("File: ${element.path}");
    // });
    showDialog(
        context: context,
        builder: (context) => Center(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4)),
                width: 200,
                height: 100,
                child: Row(
                  children: [
                    Expanded(
                        child: Center(
                      child: GestureDetector(
                        child: Icon(
                          Icons.camera_alt,
                          size: 33,
                        ),
                        onTap: () {
                          _pickImage(ImageSource.camera);
                        },
                      ),
                    )),
                    Container(
                      width: 1,
                      color: Colors.grey,
                      height: double.infinity,
                    ),
                    Expanded(
                        child: Center(
                      child: GestureDetector(
                        child: Icon(
                          Icons.photo_library,
                          size: 33,
                        ),
                        onTap: () {
                          _pickImage(ImageSource.gallery);
                        },
                      ),
                    ))
                  ],
                ),
              ),
            ));
    setState(() {});
  }

  bool _isLoading = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomLoadingScreen(
        isLoading: _isLoading,
        child: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text('Order Through List Upload'),
          ),
          body: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.9),
            itemBuilder: (context, index) {
              return Container(
                color: Colors.white,
                child: Stack(
                  children: [
                    Center(
                      child: Image.file(
                        _images[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              setState(() => _images.removeAt(index)),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            itemCount: _images.length,
          ),
          floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              backgroundColor: Theme.of(context).accentColor,
              onPressed: selectImages),
          bottomNavigationBar: MyButton(
            text: "Choose address",
            onTap: () async {
              if ((_images ?? []).isEmpty) {
                Fluttertoast.showToast(msg: "Please select at least one image");
                return;
              } else {
                Fluttertoast.showToast(msg: "Please select Address");
                scaffoldKey.currentState.showBottomSheet((context) {
                  return AddressBottomSheet(fileLatest: _images, type: "image");
                }, elevation: 100);
              }
            },
          ),
        ),
      ),
    );
  }
}
