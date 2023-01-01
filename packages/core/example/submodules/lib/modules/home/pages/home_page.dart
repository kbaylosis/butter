import 'package:butter/butter.dart';
import 'package:flutter/material.dart';

import '../../../app/app.dart';
import '../../../config/app_config.dart';
import '../../../utils/sub_module_page_specs.dart';
import '../components/navbar.dart';
import '../models/home_model.dart';

//
// BaseStatefulPageView provides you with beforeLoad() and beforeUpdate() functions.
// Stick to using BaseStatelessPageView if you don't need these.
//
class HomePage extends BaseStatefulPageView {
  final HomeModel? model;

  HomePage({this.model});

  // This allows the page to re-route before being able to render.
  // Useful for handling login sessions or some asynchronous tasks.
  // Kindly use this with care. Most weight of asynchronous processes must be
  // put inside Actions... not here.
  @override
  bool? beforeLoad(BuildContext context) {
    if (this.model!.checkIfInit()) {
      if (!this.model!.initialized) {
        this.model!.onTapMenuItem!(AppConfig.defaultHomePage);
      }
    } else {
      this.model!.exit();
      return null;
    }

    return true;
  }

  @override
  Widget build(BuildContext context, {bool loading = false}) {
    // The following shows one way on how to handle subModules. This mechanism
    // allows you to have nested modules (a module within a module within a module, etc).
    final module = App.getChild(context, this.model!);
    if (module == null) {
      return Scaffold();
    }

    // The definition of PageSpecs varies from app to app so change the PageSpecs
    // definition in the utils as you need.
    final PageSpecs? specs = module.page?.specs as PageSpecs?;

    var appBar = specs != null && specs.hasAppBar
        ? AppBar(
            leading: specs.leading ?? Container(),
            centerTitle: true,
            title: Text(
              specs.title ?? '',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            actions: specs.actions,
          )
        : null;
    var safeArea = specs != null && specs.inSafeArea
        ? SafeArea(
            child: module,
          )
        : module;

    return SafeArea(
      child: Scaffold(
        appBar: appBar,
        body: safeArea,
        bottomNavigationBar: Navbar(
          model: this.model,
          routeName: App.getRouteName(context),
        ),
      ),
    );
  }
}
