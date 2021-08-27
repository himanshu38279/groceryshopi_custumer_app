import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:tbo_the_best_one/controllers/loading_controller.dart';

class CustomLoadingScreen extends StatelessWidget {
  final Widget child;
  final bool isLoading;

  CustomLoadingScreen({@required this.child, this.isLoading});

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall:
          this.isLoading ?? Provider.of<LoadingController>(context).isLoading,
      progressIndicator: CustomLoader(),
      child: this.child,
    );
  }
}

class CustomLoader extends StatelessWidget {
  final Color color;

  const CustomLoader({this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitCircle(
        color: this.color ?? Theme.of(context).accentColor,
      ),
    );
  }
}

class CardLoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const CardLoadingOverlay({
    @required this.isLoading,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        this.child,
        this.isLoading
            ? Positioned.fill(
                child: Container(
                  color: Theme.of(context).accentColor.withOpacity(0.1),
                  child: CustomLoader(),
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
