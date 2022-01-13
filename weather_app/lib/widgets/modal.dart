import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModalPicker extends StatelessWidget {
  final Color borderColor;
  final String label;
  final ValueChanged<dynamic> valueChanged;
  final List<DropdownMenuItem> items;
  final AutovalidateMode autoValidateMode;

  const ModalPicker(
      {required Key key,
      this.borderColor = const Color(0xFFBCBBC1),
      required this.label,
      required this.valueChanged,
      required this.items,
      required this.autoValidateMode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget labelToPrint = Text(this.label);

    return FormField(
        autovalidateMode: this.autoValidateMode,
        builder: (FormFieldState state) {
          if (state.value != null && this.items != null) {
            var res = this.items.where((it) => it.value == state.value).toList();
            if (res.length > 0) {
              labelToPrint = res[0].child;
            }
          }
          return GestureDetector(
            onTap: () async => await _showModalDialog(context, state),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: state.hasError ? Color(0xFFD32F2F) : Colors.white,
                    ),
                  ),
                  height: 70.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SafeArea(
                      top: false,
                      bottom: false,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              (labelToPrint as Text).data.toString(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                state.hasError
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(12, 4, 0, 0),
                        child: Text(
                          state.hasError ? state.errorText.toString() : "",
                          style: TextStyle(color: Color(0xFFD32F2F), fontSize: 12),
                        ),
                      )
                    : Container(),
              ],
            ),
          );
        });
  }

  Future<dynamic> _showModalDialog(BuildContext context, FormFieldState state) async {
    double scrProp = MediaQuery.of(context).size.height * 0.5;
    double itmProp = items.length * 120.0;
    double popupHeight = min(scrProp, itmProp);
    double popupWidth = MediaQuery.of(context).size.width;

    await showCupertinoModalPopup<dynamic>(
      context: context,
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
          clipBehavior: Clip.hardEdge,
          child: Container(
            height: popupHeight,
            width: popupWidth,
            decoration: BoxDecoration(
              backgroundBlendMode: BlendMode.xor,
              color: CupertinoColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.elliptical(30, 30),
                topRight: Radius.elliptical(30, 30),
              ),
            ),
            child: DefaultTextStyle(
              style: const TextStyle(
                color: CupertinoColors.black,
                fontSize: 22.0,
              ),
              child: GestureDetector(
                // Blocks taps from propagating to the modal sheet and popping.
                onTap: () {},
                child: SafeArea(
                  top: false,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.elliptical(20, 20),
                        topRight: Radius.elliptical(20, 20),
                      ),
                    ),
                    color: Colors.black,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: popupWidth,
                          height: 60,
                          decoration: BoxDecoration(
                            color: CupertinoColors.black,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.elliptical(20, 20),
                              topRight: Radius.elliptical(20, 20),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              label,
                              style: TextStyle(fontSize: 18, color: Colors.orange, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 50),
                          child: Divider(),
                        ),
                        Container(
                          color: Colors.white,
                          margin: EdgeInsets.only(top: 60),
                          child: ListView(
                            children: _buildItems(context, state),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildItems(BuildContext context, FormFieldState state) {
    List<Widget> wg = [];
    items.forEach((e) {
      wg.addAll([
        ListTile(
          onTap: () {
            state.didChange(e.value);
            if (valueChanged != null) {
              valueChanged(e.value);
            }
            Navigator.pop(context);
          },
          title: Align(alignment: Alignment.center, child: e.child),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
          child: Divider(),
        ),
      ]);
    });
    return wg;
  }
}
