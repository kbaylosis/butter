import 'package:butter/butter.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';

import '../../butter_toolkit.dart';
import '../../utils/screens.dart';
import 'formatters/numeric_text_formatter.dart';

class PhoneField extends StatefulWidget {
  final String initialIsoCode;
  final String? code;
  final String? hintText;
  final String? number;
  final void Function(String? code, String? number, {bool done}) onChanged;
  final bool readOnly;

  const PhoneField({
    super.key,
    this.initialIsoCode = 'PH',
    this.code,
    this.hintText,
    this.number,
    required this.onChanged,
    this.readOnly = false,
  });

  @override
  State<StatefulWidget> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  String? _initialIsoCode;
  String? _code;
  String? _number;

  @override
  void initState() {
    super.initState();

    _initialIsoCode = widget.initialIsoCode;
    _code = widget.code;
    _number = widget.number;
  }

  @override
  void didUpdateWidget(covariant PhoneField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialIsoCode != widget.initialIsoCode) {
      _initialIsoCode = widget.initialIsoCode;
    }

    if (oldWidget.code != widget.code) {
      _code = widget.code;
    }

    if (oldWidget.number != widget.number) {
      _number = widget.number;
    }
  }

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            height: Screens(context).isMobile ? 57 : 49.5,
            width: 150,
            decoration: BoxDecoration(
              border: Border.all(
                  color: ButterToolkit().brandInfo.grayLight.withOpacity(0.5)),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6.0),
                bottomLeft: Radius.circular(6.0),
              ),
            ),
            child: GestureDetector(
              child: _selectedPhoneCode(),
              onTap: () => _openCountryPickerDialog(context),
            ),
          ),
          Expanded(
            child: TextFormField(
              initialValue: _number,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color:
                          ButterToolkit().brandInfo.grayLight.withOpacity(0.5)),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(6.0),
                    bottomRight: Radius.circular(6.0),
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color:
                          ButterToolkit().brandInfo.grayLight.withOpacity(0.5)),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(6.0),
                    bottomRight: Radius.circular(6.0),
                  ),
                ),
                labelStyle: TextStyle(
                  color: ButterToolkit().brandInfo.grayLighter,
                  fontSize: 16,
                ),
                counterText: '',
              ),
              inputFormatters: [
                NumericTextFormatter(),
              ],
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              maxLength: 10,
              onChanged: (value) => widget.onChanged(_code, value, done: false),
              onFieldSubmitted: (value) {
                widget.onChanged(_code, value, done: true);
              },
              readOnly: widget.readOnly,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      );

  Widget _selectedPhoneCode() {
    final country = CountryPickerUtils.getCountryByIsoCode(_initialIsoCode!);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CountryPickerUtils.getDefaultFlagImage(country),
        const SizedBox(
          width: 8.0,
        ),
        Text(" +${country.phoneCode}"),
      ],
    );
  }

  void _openCountryPickerDialog(BuildContext context) => showDialog(
        context: context,
        builder: (context) => CountryPickerDialog(
            titlePadding: const EdgeInsets.all(8.0),
            searchInputDecoration: const InputDecoration(hintText: 'Search...'),
            isSearchable: true,
            priorityList: [
              CountryPickerUtils.getCountryByIsoCode(_initialIsoCode!),
            ],
            onValuePicked: (Country country) => setState(() {
                  _code = country.phoneCode;
                  _initialIsoCode = country.isoCode;

                  widget.onChanged(_code, _number, done: false);
                  Butter.d("object ${country.isoCode}");
                }),
            itemBuilder: _buildDropdownItem),
        routeSettings:
            RouteSettings(name: ModalRoute.of(context)?.settings.name),
      );

  Widget _buildDropdownItem(Country country) => Row(
        children: [
          CountryPickerUtils.getDefaultFlagImage(country),
          const SizedBox(
            width: 8.0,
          ),
          Text("+${country.phoneCode} ${country.name}"),
        ],
      );
}
