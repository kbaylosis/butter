import 'package:butter/butter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:submodules/utils/sub_module_page_specs.dart';

import '../models/newsfeed_model.dart';

class NewsFeedPage extends BaseStatefulPageView {
  final NewsFeedModel? model;

  NewsFeedPage({this.model});

  // specs and PageSpecs provide a way for mother pages to retrieve data from child pages
  // The definition of PageSpecs varies from app to app so change the PageSpecs
  // definition in the utils as you need. The _specs doesn't have to be final.
  // You may change the specs depending on the state of your page.
  final _specs = PageSpecs(
    inSafeArea: true, // Try setting these to false and see what happens.
    hasAppBar: true, // Try setting these to false and see what happens.
    title: 'Newsfeed',
  );

  @override
  get specs {
    return this._specs;
  }

  // This allows the page to re-route before being able to render.
  // Useful for handling login sessions or some asynchronous task.
  // Kindly use this with care. Most weight of asynchronous processes must be
  // put inside Actions... not here.
  @override
  beforeLoad(BuildContext context) async {
    return Future.delayed(Duration(seconds: 3), () => true);
  }

  // Animation while the page is being loaded.
  @override
  Widget buildLoading(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Loading Newsfeed...'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Newsfeed loaded!'),
      ),
    );
  }
}
