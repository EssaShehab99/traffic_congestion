import 'package:flutter/material.dart';
import '/views/shared/shared_values.dart';

class DropdownFieldWidget extends StatelessWidget {
  const DropdownFieldWidget(
      {Key? key,
      required this.hintText,
      this.prefixIcon,
      this.value,
      required this.items,
      this.onChanged,
      required this.keyDropDown,
      this.validator,
      this.focusNode})
      : super(key: key);
  final String hintText;
  final DropdownMenuItemModel? value;
  final Widget? prefixIcon;
  final List<DropdownMenuItemModel> items;
  final ValueChanged<DropdownMenuItemModel?>? onChanged;
  final Key? keyDropDown;
  final FormFieldValidator? validator;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      alignedDropdown: true,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(SharedValues.borderRadius),
        child: DropdownButtonFormField<DropdownMenuItemModel>(
          key: keyDropDown,
          borderRadius: BorderRadius.circular(SharedValues.borderRadius),
          value: value,
          focusNode: focusNode,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: onChanged,
          items: [
            for (var item in items)
              DropdownMenuItem(
                  value: item,
                  child: Text(
                    item.text,
                    style: Theme.of(context).textTheme.subtitle1,
                  ))
          ],
          icon: const SizedBox.shrink(),
          decoration: InputDecoration(
              prefixIcon: prefixIcon,
              hintText: hintText,
              suffixIcon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Theme.of(context).primaryColor,
              ),
              contentPadding:
                  const EdgeInsets.all(SharedValues.padding * 1.6)),
        ),
      ),
    );
  }
}

class DropdownMenuItemModel {
  dynamic id;
  String text;
  DropdownMenuItemModel({this.id, required this.text});
}
