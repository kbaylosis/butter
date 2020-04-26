import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'base_page_view.dart';

abstract class BaseStatefulPageView extends StatefulWidget implements BasePageView {

  @override
  State<StatefulWidget> createState() => _BaseStatefulPageViewState();

  beforeLoad() => true;

  beforeUpdate() => true;

  Widget buildLoading(BuildContext context) {
    return Scaffold();
  }

  Widget build(BuildContext context) {
    return Scaffold();
  }

  Widget buildError(BuildContext context) {
    return Scaffold();
  }

  @override
  get specs => null;
}

class _BaseStatefulPageViewState extends State<BaseStatefulPageView> {
  bool initialized;
  var loadRetVal;

  @override
  void initState() {
    super.initState();

    initialized = false;
  }

  @override
  void dispose() {
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: this._cycle(), 
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return widget.build(context);
        } else if (snapshot.hasError) {
          return widget.buildError(context);
        }
        
        return widget.buildLoading(context);
      },
    );
  }

  Future _cycle() {
    if (initialized) {
      if (loadRetVal == null) {
        return null;
      }

      return Future.microtask(() async {
        return await widget.beforeUpdate();
      });
    }

    initialized = true;
    return Future.microtask(() async {
      loadRetVal = await widget.beforeLoad();
      return loadRetVal;
    });
  }
}