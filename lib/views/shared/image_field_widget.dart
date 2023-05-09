// import 'dart:convert';
// import 'dart:io';
//
// import 'package:easy_localization/easy_localization.dart';
// import 'package:traffic_congestion/views/shared/shared_components.dart';
//
// import '/views/shared/shared_values.dart';
// import 'package:flutter/material.dart';
//
// class ImageFieldWidget extends StatefulWidget {
//   const ImageFieldWidget({
//     Key? key,
//     this.hintText,
//     this.values,
//     this.onChanged,
//     this.max, this.validator,
//   }) : super(key: key);
//   final List<String>? values;
//   final String? hintText;
//   final ValueChanged<String>? onChanged;
//   final int? max;
//   final FormFieldValidator<List<String>?>? validator;
//
//   @override
//   State<ImageFieldWidget> createState() => _ImageFieldWidgetState();
// }
//
// class _ImageFieldWidgetState extends State<ImageFieldWidget> {
//   Future<void> addImages(List<String> imagesPath,FormFieldState fieldState) async {
//     for (String path in imagesPath) {
//       if ((widget.values?.length ?? 0) < (widget.max ?? 10)) {
//         widget.values?.add(await _convertToBase64(path));
//         fieldState.didChange(widget.values);
//       } else {
//         break;
//       }
//     }
//     if ((widget.values?.length ?? 0) > (widget.max ?? 10)) {
//       // ignore: use_build_context_synchronously
//       SharedComponents.showSnackBar(
//           context, "${"maximum-photos".tr()}: ${widget.max ?? 10}");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FormField(
//         validator: widget.validator,
//       initialValue: widget.values,
//       builder: (field) => Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (widget.hintText != null)
//             Text("${widget.hintText}",
//                 style: Theme.of(context).textTheme.labelMedium),
//           const SizedBox(height: SharedValues.padding),
//           Container(
//             width: double.infinity,
//             height: 200,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(SharedValues.borderRadius),
//                 border:
//                     Border.all(width: 2, color: Theme.of(context).primaryColor)),
//             child: ListView(
//               scrollDirection: Axis.horizontal,
//               children: [
//                 Container(
//                   width: 150,
//                   margin: const EdgeInsets.all(SharedValues.padding),
//                   decoration: BoxDecoration(
//                       borderRadius:
//                           BorderRadius.circular(SharedValues.borderRadius),
//                       border: Border.all(
//                           width: 2, color: Theme.of(context).primaryColor)),
//                   child: InkWell(
//                     onTap: () async {
//                       final ImagePicker picker = ImagePicker();
//                       final images = await picker.pickMultiImage(
//                           imageQuality: 80, maxWidth: 250);
//                       await addImages(images.map((e) => e.path).toList(),field);
//                       setState(() {});
//                     },
//                     child: Icon(Icons.add, color: Theme.of(context).primaryColor),
//                   ),
//                 ),
//                 for (var i = 0; i < (widget.values?.length ?? 0); ++i)
//                   Container(
//                     width: 150,
//                     margin: const EdgeInsets.all(SharedValues.padding),
//                     decoration: BoxDecoration(
//                         borderRadius:
//                             BorderRadius.circular(SharedValues.borderRadius),
//                         border: Border.all(
//                             width: 2, color: Theme.of(context).primaryColor)),
//                     child: Stack(
//                       alignment: Alignment.bottomCenter,
//                       children: [
//                         Image.memory(base64.decode(widget.values![i]),
//                             fit: BoxFit.cover,
//                             height: double.infinity,
//                             width: double.infinity),
//                         Container(
//                           width: double.infinity,
//                           height: 35,
//                           decoration: BoxDecoration(
//                               color: Theme.of(context).colorScheme.error),
//                           child: InkWell(
//                               onTap: () {
//                                 setState(() {
//                                   widget.values?.removeAt(i);
//                                 });
//                               },
//                               child: const Icon(Icons.delete)),
//                         )
//                       ],
//                     ),
//                   )
//               ],
//             ),
//           ),
//           if (field.hasError) ...[
//             const SizedBox(height: SharedValues.padding),
//             Container(
//               color: Theme.of(context).colorScheme.error,
//               height: 1,
//               margin:
//               const EdgeInsets.symmetric(horizontal: SharedValues.padding),
//             ),
//             Container(
//                 margin: const EdgeInsets.symmetric(
//                     horizontal: SharedValues.padding * 1.5,
//                     vertical: SharedValues.padding * 0.5),
//                 alignment: AlignmentDirectional.centerStart,
//                 child: Text(
//                   field.errorText!,
//                   style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12),
//                 )),
//           ],
//         ],
//       ),
//     );
//   }
//
//   Future<String> _convertToBase64(String path) async {
//     return base64Encode(File(path).readAsBytesSync());
//   }
// }
