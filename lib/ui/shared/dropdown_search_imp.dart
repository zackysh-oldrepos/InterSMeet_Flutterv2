// ignore_for_file: avoid_print

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intersmeet/core/constants/colorsz.dart';

// ignore: must_be_immutable
class DropdownSearchImp<T> extends StatefulWidget {
  final String labelText;
  final String hintText;
  final List<T> items;
  final bool enabled;
  T? selectedItem;
  final String Function(T? item) itemAsString;
  final void Function(T? item) onChanged;

  DropdownSearchImp({
    Key? key,
    required this.labelText,
    required this.hintText,
    this.enabled = true,
    required this.items,
    required this.selectedItem,
    required this.itemAsString,
    required this.onChanged,
  }) : super(key: key);

  @override
  _DropdownSearchImpState<T> createState() => _DropdownSearchImpState<T>();
}

class _DropdownSearchImpState<T> extends State<DropdownSearchImp<T>> {
  // T? selectedItem;

  @override
  void initState() {
    // selectedItem = widget.selectedItem;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      // key: widget.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: DropdownSearch<T>(
          // @ State
          mode: Mode.BOTTOM_SHEET,
          showSearchBox: true,
          items: widget.items,
          enabled: widget.enabled,
          selectedItem: widget.selectedItem,
          onChanged: (item) {
            setState(() {
              widget.selectedItem = item;
            });
            widget.onChanged(item);
          },
          itemAsString: widget.itemAsString,
          // @ UI
          dropdownBuilder: (context, selectedItem) {
            return Row(
              children: [
                Expanded(
                  child: Text(
                    widget.itemAsString(selectedItem),
                    textAlign: TextAlign.left,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                MaterialButton(
                  height: 20,
                  shape: const CircleBorder(),
                  highlightColor: Colors.red[200],
                  minWidth: 34,
                  onPressed: () {
                    setState(() {
                      widget.selectedItem = null;
                    });
                    widget.onChanged(null);
                  },
                  child: const Icon(
                    Icons.close_outlined,
                    size: 20,
                  ),
                )
              ],
            );
          },
          dropdownSearchDecoration: InputDecoration(
            labelText: widget.labelText,
            contentPadding: const EdgeInsets.fromLTRB(12, 12, 0, 0),
            border: const OutlineInputBorder(),
          ),
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.fromLTRB(12, 12, 8, 0),
              labelText: widget.hintText,
            ),
          ),
          popupTitle: Container(
            height: 50,
            decoration: const BoxDecoration(
              color: Colorz.complexDrawerBlueGrey,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                widget.labelText,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          popupShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
        ),
      ),
    );
  }
}
