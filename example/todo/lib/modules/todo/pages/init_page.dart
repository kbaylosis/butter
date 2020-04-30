import 'package:butter/butter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models/init_model.dart';

class InitPage extends BaseStatelessPageView {
  final InitModel model;

  InitPage({this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: this._body(),
    );
  }

  _body() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            width: 300,
            child: Image.asset('assets/logo.png'),
          ),
          Container(
            child: RaisedButton(
              child: Text('Proceed'),
              onPressed: this.model.proceed,
            ),
          ),
        ],
      ),
    );
  }
}
