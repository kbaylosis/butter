import 'package:butter/butter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:submodules/config/app.dart';
import 'package:submodules/utils/sub_module_page_specs.dart';

import '../components/navbar.dart';
import '../models/home_model.dart';

//
// BaseStatefulPageView provides you with beforeLoad() and beforeUpdate() functions.
// Stick to using BaseStatelessPageView if you don't need these.
//
class HomePage extends BaseStatefulPageView {
  final HomeModel model;

  HomePage({ this.model });

  // This allows the page to re-route before being able to render.
  // Useful for handling login sessions or some asynchronous tasks.
  @override
  beforeLoad() {
    if (this.model.checkIfInit()) {
      if (this.model.subModule == null) {
        this.model.onTapMenuItem(AppConfig.defaultHomePage);
      }
    } else {
      this.model.exit();
      return;
    }

    return true;
  }
  
  @override
  Widget build(BuildContext context) {
    // The following shows one way on how to handle subModules. This mechanism
    // allows you to have nested modules (a module within a module within a module, etc).
    var module = this.model.subModule?.getCurrentRoute(context);

    // The definition of PageSpecs varies from app to app so change the PageSpecs
    // definition in the utils as you need.
    final PageSpecs specs = module?.page?.specs;

    var appBar = specs != null && specs.hasAppBar ? AppBar(
      leading: specs?.leading ?? Container(),
      centerTitle: true,
      title: Text(
        specs?.title ?? '',
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      actions: specs?.actions,
    ) : null;
    var safeArea = specs != null && specs.inSafeArea ? SafeArea(
      child: this.model.subModule,
    ) : this.model.subModule;

    return SafeArea(
      child: Scaffold(
        appBar: appBar,
        body: safeArea,
        bottomNavigationBar: Navbar(this.model),
      ),
    );
  }
}