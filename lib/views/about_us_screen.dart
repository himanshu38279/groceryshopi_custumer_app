import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';
import 'package:tbo_the_best_one/components/custom_loader.dart';
import 'package:tbo_the_best_one/components/my_app_bar.dart';
import 'package:tbo_the_best_one/controllers/app_settings_controller.dart';
import 'package:tbo_the_best_one/utilities/constants.dart';

class AboutUsScreen extends StatelessWidget {
  static const id = 'about_us_screen';

  @override
  Widget build(BuildContext context) {
    final _controller = Provider.of<AppSettingsController>(context);
    final _settings = _controller.getSettings;
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          screenId: AboutUsScreen.id,
          title: Text("About Us"),
        ),
        body: _controller.settingsLoading
            ? CustomLoader()
            : ListView(
                children: _settings.keys.map((key) {
                  return Column(
                    children: [
                      ExpansionTile(
                        backgroundColor: kLightYellow,
                        title: Text(key),
                        childrenPadding: EdgeInsets.all(10),
                        initiallyExpanded: key == "About Us",
                        children: [HtmlWidget(_settings[key])],
                      ),
                      SizedBox(height: 5),
                    ],
                  );
                }).toList(),
              ),
      ),
    );
  }
}
