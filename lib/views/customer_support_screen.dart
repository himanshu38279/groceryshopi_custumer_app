import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';
import 'package:tbo_the_best_one/components/custom_loader.dart';
import 'package:tbo_the_best_one/components/my_app_bar.dart';
import 'package:tbo_the_best_one/components/shimmers.dart';
import 'package:tbo_the_best_one/controllers/app_settings_controller.dart';
import 'package:tbo_the_best_one/utilities/constants.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class CustomerSupportScreen extends StatelessWidget {
  static const id = 'customer_support_screen';

  int _faqNumber = 1;

  @override
  Widget build(BuildContext context) {
    final _controller = Provider.of<AppSettingsController>(context);
    final _faqS = _controller.getFAQs;
    final _contacts = _controller.getContactDetails;
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          screenId: id,
          title: Text("Customer Support"),
        ),
        body: _controller.faqsLoading
            ? CustomLoader()
            : ListView(
                children: _faqS.keys
                    .map((e) => _buildTile({'q': e, 'a': _faqS[e]}))
                    .toList(),
              ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: _controller.contactDetailsLoading
              ? [
                  FABShimmer(),
                  SizedBox(height: 10),
                  FABShimmer(),
                  SizedBox(height: 10),
                  FABShimmer(),
                ]
              : [
                  FloatingActionButton(
                    onPressed: () async {
                      final _link =
                          "https://wa.me/${_contacts['whats_number']}";
                      if (await canLaunch(_link)) await launch(_link);
                    },
                    backgroundColor: Theme.of(context).accentColor,
                    heroTag: null,
                    child: Icon(Icons.message),
                  ),
                  SizedBox(height: 10),
                  FloatingActionButton(
                    onPressed: () async {
                      final _mail = "mailto:${_contacts['support_email']}";
                      if (await canLaunch(_mail)) await launch(_mail);
                    },
                    backgroundColor: Theme.of(context).accentColor,
                    heroTag: null,
                    child: Icon(Icons.mail),
                  ),
                  SizedBox(height: 10),
                  FloatingActionButton(
                    onPressed: () async {
                      final _phone = "tel://${_contacts['support_mobile']}";
                      if (await canLaunch(_phone)) await launch(_phone);
                    },
                    backgroundColor: Theme
                        .of(context)
                        .accentColor,
                    heroTag: null,
                    child: Icon(Icons.phone),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(Map<String, String> data) {
    return Column(
      children: [
        ExpansionTile(
          initiallyExpanded: false,
          childrenPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          expandedAlignment: Alignment.centerLeft,
          backgroundColor: kLightYellow,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "${_faqNumber++}.",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 10),
              Expanded(child: Text(data['q'])),
            ],
          ),
          children: [HtmlWidget(data['a'])],
        ),
        SizedBox(height: 5),
      ],
    );
  }
}
