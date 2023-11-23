import 'dart:io';

import 'package:nars/api/document_api.dart';
import 'package:nars/components/alert_dialog_default.dart';
import 'package:nars/components/app_bar_default.dart';
import 'package:nars/components/container_loading_indicate.dart';
import 'package:nars/components/input_form_field.dart';
import 'package:nars/components/section_title.dart';
import 'package:nars/components/snack_bar_default.dart';
import 'package:nars/constants.dart';
import 'package:nars/enumerables/document_type.dart';
import 'package:nars/helpers/helpers.dart';
import 'package:nars/helpers/responsive.dart';
import 'package:nars/models/document/document.dart';
import 'package:nars/screens/gallery_widget/gallery_widget_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class DocumentFormScreen extends StatefulWidget {
  const DocumentFormScreen({
    Key? key,
    this.appointmentId,
    this.document,
  }) : super(key: key);

  final int? appointmentId;
  final Document? document;

  @override
  State<DocumentFormScreen> createState() => _DocumentFormScreenState();
}

class _DocumentFormScreenState extends State<DocumentFormScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _submitted = false;

  // late TransformationController controller;
  // TapDownDetails? tapDownDetails;
  // late AnimationController animationController;
  // Animation<Matrix4>? animation;
  // OverlayEntry? entry;

  File? image;
  DocumentType? _type;
  String? _other;

  @override
  void initState() {
    super.initState();

    _type = widget.document?.type;
    _other = widget.document?.other;

    // controller = TransformationController();
    // animationController = AnimationController(
    //   vsync: this,
    //   duration: const Duration(
    //     milliseconds: 300,
    //   ),
    // )
    //   ..addListener(() {
    //     controller.value = animation!.value;
    //   })
    //   ..addStatusListener((status) {
    //     if (status == AnimationStatus.completed &&
    //         controller.value.isIdentity()) {
    //       removeOverlay();
    //     }
    //   });

    // print('widget.document');
    // print(documentToJson(widget.document!));
  }

  @override
  void dispose() {
    // controller.dispose();
    // animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBarDefault(title: 'Upload New Record/Document'),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: defaultPadding,
            horizontal: Responsive.isDesktop(context)
                ? size.width * 0.30
                : defaultPadding,
          ),
          child: Column(
            children: [
              const SectionTitle(title: 'Record/Document'),
              const SizedBox(height: defaultPadding),
              _buildImageScrField(),
              const SizedBox(height: defaultPadding),
              _buildImageButtons(),
              const SizedBox(height: defaultPadding),
              Form(
                key: _formKey,
                autovalidateMode: _submitted
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                child: Column(
                  children: [
                    if (widget.appointmentId == null) ...[
                      DropdownButtonFormField<DocumentType>(
                        onChanged: (value) {
                          setState(() => _type = value!);
                        },
                        // onSaved: (value) => setState(() => _type = value!),
                        validator: (value) {
                          if (value == null) {
                            return 'This field is required';
                          } else {
                            return null;
                          }
                        },
                        value: _type,
                        // items: getDocumentTypes(),
                        items: getDocumentTypes(),
                        decoration: InputDecoration(
                          labelText: 'Type',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: defaultPadding * 1.5,
                            vertical: defaultPadding,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.circular(defaultBorderRadius),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: kPrimaryColor, width: 2),
                            borderRadius:
                                BorderRadius.circular(defaultBorderRadius),
                          ),
                        ),
                      ),
                      const SizedBox(height: defaultPadding),
                    ],
                    if (_type == DocumentType.Other ||
                        widget.appointmentId != null)
                      InputFormField(
                        label: 'Description',
                        onSaved: (value) => setState(() => _other = value!),
                        initialValue: _other,
                        validator: (value) {
                          if (value == '') {
                            return 'This field is required';
                          } else {
                            return null;
                          }
                        },
                      ),
                  ],
                ),
                // InputDropdownFormField(
                //   label: 'Type',
                //   onSaved: (value) => setState(() => _type = value!),
                //   validator: (value) {
                //     if (value == null) {
                //       return 'This field is required';
                //     } else {
                //       return null;
                //     }
                //   },
                //   value: _type,
                //   values: getDocumentTypes(),
                // ),
              ),
              const SizedBox(height: defaultPadding),
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(defaultBorderRadius),
                ),
                child: Material(
                  color: kPrimaryColor,
                  child: InkWell(
                    onTap: () async {
                      setState(() => _submitted = true);
                      final isValid = _formKey.currentState?.validate();
                      FocusScope.of(context).unfocus();

                      if (image == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          snackBarDefault(
                            text: 'Please upload an image',
                          ),
                        );
                        return;
                      }

                      if (isValid!) {
                        setState(() => isLoading = true);
                        _formKey.currentState?.save();

                        try {
                          Response result;
                          if (widget.appointmentId == null) {
                            result = await DocumentApi.uploadDocument(
                                image!, _type!.index, _other ?? '');
                          } else {
                            result =
                                await DocumentApi.uploadAppointmentDocument(
                                    image!,
                                    widget.appointmentId!,
                                    _other ?? '');
                          }
                          if (result.statusCode == 413) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              snackBarDefault(text: 'File too large'),
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialogDefault(
                                press: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                              ),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            snackBarDefault(),
                          );
                          print('Error: $e');
                        } finally {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }
                    },
                    child: ContainerLoadingIndicator(isLoading: isLoading),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future pickImage(ImageSource imgScr) async {
    try {
      final image = await ImagePicker().pickImage(source: imgScr);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Failed to pick image: $e');
      }
    }
  }

  Widget _buildImageButtons() {
    return Row(
      children: [
        Expanded(
          flex: 6,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(defaultBorderRadius),
            child: Material(
              color: Colors.white,
              child: InkWell(
                onTap: () => pickImage(ImageSource.gallery),
                child: Container(
                  padding: const EdgeInsets.all(defaultPadding),
                  alignment: Alignment.center,
                  child: Text(
                    'Upload from Gallery',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(color: kPrimaryColor),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: defaultPadding),
        Expanded(
          flex: 4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(defaultBorderRadius),
            child: Material(
              color: Colors.white,
              child: InkWell(
                onTap: () => pickImage(ImageSource.camera),
                child: Container(
                  padding: const EdgeInsets.all(defaultPadding),
                  alignment: Alignment.center,
                  child: Text(
                    'Take a Picture',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(color: kPrimaryColor),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future showPopup() {
    return showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            tileColor: Colors.white,
            horizontalTitleGap: 4,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding / 2),
            title: const Text('Camera'),
            onTap: () {
              pickImage(ImageSource.camera);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            tileColor: Colors.white,
            horizontalTitleGap: 4,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding / 2),
            title: const Text('Gallery'),
            onTap: () {
              pickImage(ImageSource.gallery);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  // void zoomImage(BuildContext context) {
  //   controller.value.isIdentity() ? showOverlay(context) : null;
  //   final position = tapDownDetails!.localPosition;

  //   const double scale = 3;
  //   final x = -position.dx * (scale - 1);
  //   final y = -position.dy * (scale - 1);
  //   final zoomed = Matrix4.identity()
  //     ..translate(x, y)
  //     ..scale(scale);

  //   final end = controller.value.isIdentity() ? zoomed : Matrix4.identity();

  //   animation = Matrix4Tween(
  //     begin: controller.value,
  //     end: end,
  //   ).animate(CurveTween(curve: Curves.easeOut).animate(animationController));

  //   animationController.forward(from: 0);
  // }

  Widget _buildImageScrField() {
    String? _imageScr = widget.document?.imageLink;
    final size = MediaQuery.of(context).size;
    return Builder(
      builder: (context) => GestureDetector(
        // onTapDown: (details) => tapDownDetails = details,
        onTap: () => _imageScr != null || image != null
            ? openGallery([_imageScr!], 0)
            : showPopup(),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(defaultBorderRadius),
            image: DecorationImage(
              image: image != null
                  ? FileImage(image!)
                  : (_imageScr != null
                      ? NetworkImage(_imageScr) as ImageProvider
                      : const AssetImage('assets/images/default_image.png')),
              fit: BoxFit.cover,
            ),
          ),
          alignment: Alignment.center,
          height: size.height * 0.3,
        ),
      ),
    );
  }

  // void showOverlay(BuildContext context) {
  //   final renderBox = context.findRenderObject()! as RenderBox;
  //   final offset = renderBox.localToGlobal(Offset.zero);
  //   final size = MediaQuery.of(context).size;

  //   entry = OverlayEntry(builder: (context) {
  //     return Stack(
  //       children: <Widget>[
  //         Positioned.fill(
  //           child: Container(
  //             color: Colors.white,
  //           ),
  //         ),
  //         Positioned(
  //           left: offset.dx,
  //           top: offset.dy,
  //           width: size.width,
  //           child: _buildImageScrField(),
  //         ),
  //       ],
  //     );
  //   });

  //   final overlay = Overlay.of(context)!;
  //   overlay.insert(entry!);
  // }

  // void removeOverlay() {
  //   entry?.remove();
  //   entry = null;
  // }

  void openGallery(List<String> documents, int index) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => GalleryWidget(
            urlImages: documents,
            index: index,
          ),
        ),
      );
}
