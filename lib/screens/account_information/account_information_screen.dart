import 'dart:io';

import 'package:nars/api/address_api.dart';
import 'package:nars/api/practitioner_api.dart';
import 'package:nars/api/patient_api.dart';
import 'package:nars/components/alert_dialog_default.dart';
import 'package:nars/components/app_bar_default.dart';
import 'package:nars/components/dropdown_form_field_int.dart';
import 'package:nars/components/dropdown_form_field_string.dart';
import 'package:nars/components/input_form_field.dart';
import 'package:nars/components/section_title.dart';
import 'package:nars/components/snack_bar_default.dart';
import 'package:nars/constants.dart';
import 'package:nars/enumerables/gender.dart';
import 'package:nars/enumerables/usertype.dart';
import 'package:nars/helpers/helpers.dart';
import 'package:nars/helpers/responsive.dart';
import 'package:nars/models/address/addressAlls.dart';
import 'package:nars/models/address/barangay.dart';
import 'package:nars/models/address/province.dart';
import 'package:nars/models/address/region.dart';
import 'package:nars/models/address/town.dart';
import 'package:nars/models/information/information.dart';
import 'package:nars/models/patient/add_patient_profile_param.dart';
import 'package:nars/models/patient/edit_patient_profile_param.dart';
import 'package:nars/models/patient/patient_profile.dart';
import 'package:nars/models/patient/profile.dart';
import 'package:nars/enumerables/flavor.dart';
import 'package:nars/api/auth_service.dart';
import 'package:nars/models/practitioner/edit_practitioner_param.dart';
import 'package:nars/models/practitioner/practitioner.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AccountInformationScreen extends StatefulWidget {
  const AccountInformationScreen({
    Key? key,
    this.practitioner,
    this.patientProfile,
  }) : super(key: key);

  final Practitioner? practitioner;
  final Profile? patientProfile;

  @override
  State<AccountInformationScreen> createState() =>
      _AccountInformationScreenState();
}

class _AccountInformationScreenState extends State<AccountInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _submitted = false;
  bool isLoading = false;
  File? image;
  File? signature;

  Practitioner? practitioner;
  Profile? patientProfile;
  AddressAll? address;

  bool isLoadingRegion = false;
  bool isLoadingProvince = false;
  bool isLoadingTown = false;
  bool isLoadingBarangay = false;
  bool firstLoad = true;
  List<Region>? regions;
  List<Province>? provinces;
  List<Town>? towns;
  List<Barangay>? barangays;
  TextEditingController birthDateController = TextEditingController();

  Future getRegions() async {
    var result = await AddressApi.getRegions();
    setState(() {
      regions = result;
      if (!firstLoad) {
        getProvinces();
      }
    });
  }

  Future getProvinces() async {
    var result =
        await AddressApi.getProvincesByRegionCode(address!.regionCode!);
    setState(() {
      provinces = result;
      if (!firstLoad) {
        getTowns();
      }
    });
  }

  Future getTowns() async {
    var result = await AddressApi.getTownsByProvinceCode(
        address!.regionCode!, address!.provinceCode!);
    setState(() {
      towns = result;
      if (!firstLoad) {
        getBarangays();
      }
    });
  }

  Future getBarangays() async {
    var result = await AddressApi.getBarangaysByTownCode(address!.townCode!);
    setState(() {
      barangays = result;
      if (!firstLoad) {
        firstLoad = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    practitioner = widget.practitioner;
    patientProfile =
        widget.patientProfile == null && widget.practitioner == null
            ? Profile(
                id: 0,
                information: Information(
                    firstName: '',
                    lastName: '',
                    dateOfBirth: DateTime.now(),
                    gender: Gender.Male,
                    phoneNumber: '',
                    addressAlls: [AddressAll()]),
              )
            : widget.patientProfile;
    address = widget.patientProfile == null && widget.practitioner == null
        ? patientProfile!.information.addressAlls!.first
        : null;
    if (widget.patientProfile == null && widget.practitioner == null) {
      address!.isDefault = true;
    }
    getRegions();
    if (widget.practitioner != null) {
      birthDateController = TextEditingController(
        text: DateFormat('MM/dd/yyyy')
            .format(widget.practitioner!.information!.dateOfBirth),
      );
    }
    if (widget.patientProfile != null) {
      birthDateController = TextEditingController(
        text: DateFormat('MM/dd/yyyy')
            .format(widget.patientProfile!.information.dateOfBirth),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void save() async {
    try {
      if (practitioner != null) {
        // debugPrint('practitionerId: ${practitioner!.id}');
        // debugPrint('practitioner: ${practitionerToJson(practitioner!)}');
        if (practitioner!.signatureLink == null && signature == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            snackBarDefault(
              text: 'Please upload a signature',
            ),
          );
          return;
        }
        await PractitionerApi.editPractitioner(
          EditPractitionerProfileParam(
            id: practitioner!.id!,
            practitionerProfile: practitioner!,
          ),
        );
        // debugPrint('editPractitioner');
        // debugPrint(result.body);
        if (image != null) {
          await PractitionerApi.practitionerUploadProfilePicture(image!);
        }
        if (signature != null) {
          await PractitionerApi.practitionerUploadSignature(signature!);
        }
      } else if (widget.patientProfile != null) {
        debugPrint('editPatientProfile');
        await ProfileApi.editPatientProfile(
          EditPatientProfileParam(
            id: patientProfile!.id,
            patientProfile: PatientProfile(
              information: patientProfile!.information,
            ),
          ),
        );
        if (image != null) {
          await ProfileApi.patientProfileUploadProfilePicture(
            image!,
            patientProfile!.id,
          );
        }
      } else {
        var inserted = await ProfileApi.addPatientProfile(
          AddPatientProfileParam(
            patientProfile: PatientProfile(
              information: patientProfile!.information,
            ),
          ),
        );
        if (image != null) {
          await ProfileApi.patientProfileUploadProfilePicture(
            image!,
            inserted.patientProfileId,
          );
        }
      }
      DefaultCacheManager().emptyCache();
      imageCache.clear();
      imageCache.clearLiveImages();

      showDialog(
        context: context,
        builder: (context) => AlertDialogDefault(
          press: () {
            Navigator.of(context).pop();
            if (practitioner != null && widget.patientProfile != null) {
              Navigator.of(context)
                  .pop(practitioner ?? patientProfile!.information);
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarDefault(),
      );
      print('Error:');
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userType = Provider.of<AuthService>(context).currentUser!.userType;
    final flavor = Provider.of<Flavor>(context);
    Size size = MediaQuery.of(context).size;

    Widget _buildFirstNameField() {
      return InputFormField(
        label: 'First Name *',
        initialValue: practitioner != null
            ? practitioner!.information!.firstName
            : patientProfile != null
                ? patientProfile!.information.firstName
                : "",
        textInputAction: TextInputAction.next,
        onSaved: (value) => setState(() => practitioner != null
            ? practitioner!.information!.firstName = value!
            : patientProfile!.information.firstName = value!),
        validator: (value) {
          if (value!.isEmpty) {
            return 'This field is required';
          } else if (!RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
            return 'Please input alphabets only';
          } else {
            return null;
          }
        },
      );
    }

    Widget _buildMiddleNameField() {
      return InputFormField(
        label: 'Middle Name',
        initialValue: practitioner != null
            ? practitioner!.information!.middleName
            : patientProfile != null
                ? patientProfile!.information.middleName
                : "",
        textInputAction: TextInputAction.next,
        onSaved: (value) => setState(() => practitioner != null
            ? practitioner!.information!.middleName = value!
            : patientProfile!.information.middleName = value!),
        validator: (value) {},
      );
    }

    Widget _buildLastNameField() {
      return InputFormField(
        label: 'Last Name *',
        initialValue: practitioner != null
            ? practitioner!.information!.lastName
            : patientProfile != null
                ? patientProfile!.information.lastName
                : "",
        textInputAction: TextInputAction.done,
        onSaved: (value) => setState(() => practitioner != null
            ? practitioner!.information!.lastName = value!
            : patientProfile!.information.lastName = value!),
        validator: (value) {
          if (value!.isEmpty) {
            return 'This field is required';
          } else if (!RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
            return 'Please input alphabets only';
          } else {
            return null;
          }
        },
      );
    }

    Widget _buildBirthDateField() {
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          showDatePicker(
            context: context,
            initialDatePickerMode: DatePickerMode.year,
            initialDate: practitioner != null
                ? practitioner!.information!.dateOfBirth
                : patientProfile!.information.dateOfBirth,
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          ).then((date) => {
                setState(() {
                  practitioner != null
                      ? practitioner!.information!.dateOfBirth = date!
                      : patientProfile!.information.dateOfBirth = date!;
                  birthDateController.text =
                      DateFormat('MM/dd/yyyy').format(date);
                }),
              });
        },
        child: AbsorbPointer(
          child: InputFormField(
            label: 'Date of Birth *',
            textEditingController: birthDateController,
            onSaved: (value) {},
            validator: (value) {
              if (value!.isEmpty) {
                return 'This field is required';
              } else {
                return null;
              }
            },
          ),
        ),
      );
    }

    Widget _buildGenderField() {
      return DropdownFormFieldInt(
        label: 'Gender *',
        onChanged: (value) {},
        onSaved: (value) => setState(() => practitioner != null
            ? practitioner!.information!.gender = genderValues.map[value]!
            : patientProfile!.information.gender = genderValues.map[value]!),
        validator: (value) {
          if (value == null) {
            return 'This field is required';
          } else {
            return null;
          }
        },
        value: practitioner != null
            ? practitioner!.information!.gender.index
            : widget.patientProfile != null
                ? patientProfile!.information.gender.index
                : null,
        values: getGenders(),
      );
    }

    Widget _buildPhoneNumberField() {
      return InputFormField(
        label: 'Phone Number *',
        hintText: '(09##)-###-####',
        initialValue: practitioner != null
            ? practitioner!.information!.phoneNumber
            : patientProfile != null
                ? patientProfile!.information.phoneNumber
                : "",
        textInputAction: TextInputAction.next,
        formats: [phPhoneFormat],
        onSaved: (value) => setState(() => practitioner != null
            ? practitioner!.information!.phoneNumber = value!
            : patientProfile!.information.phoneNumber = value!),
        validator: (value) {
          if (value!.isEmpty) {
            return 'This field is required';
          } else if (value.length < 15) {
            return 'Phone number must be 11 digits';
          } else {
            return null;
          }
        },
      );
    }

    Widget _buildExperience() {
      return InputFormField(
        label: 'Year of Experience *',
        initialValue: practitioner != null
            ? practitioner!.yearOfExperience.toString()
            : null,
        textInputAction: TextInputAction.next,
        onSaved: (value) => setState(
            () => practitioner!.yearOfExperience = double.parse(value!)),
        validator: (value) {
          if (value!.isEmpty) {
            return 'This field is required';
          } else {
            return null;
          }
        },
      );
    }

    Widget _buildDescription() {
      return InputFormField(
        label: 'Description *',
        minLines: 2,
        maxLines: 10,
        initialValue: practitioner != null ? practitioner!.description : null,
        textInputAction: TextInputAction.next,
        onSaved: (value) => setState(() => practitioner!.description = value!),
        validator: (value) {
          if (value!.isEmpty) {
            return 'This field is required';
          } else {
            return null;
          }
        },
      );
    }

    Widget _buildEmailField() {
      return InputFormField(
        label: 'Email *',
        initialValue: practitioner!.userAccount!.email,
        textInputAction: TextInputAction.next,
        onSaved: (value) =>
            setState(() => practitioner!.userAccount!.email = value!),
        validator: (value) {
          if (value!.isEmpty) {
            return 'This field is required';
          } else if (!RegExp(
                  r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)')
              .hasMatch(value)) {
            return 'Please input correct email format';
          } else {
            return null;
          }
        },
      );
    }

    Widget _buildPRCNumberField() {
      return InputFormField(
        label: 'PRC Number *',
        initialValue: practitioner!.prc,
        textInputAction: TextInputAction.next,
        onSaved: (value) => setState(() => practitioner!.prc = value!),
        validator: (value) {
          if (value!.isEmpty) {
            return 'This field is required';
          } else {
            return null;
          }
        },
      );
    }

    // Widget _buildBankAccountField() {
    //   return InputFormField(
    //     label: 'Bank Account *',
    //     initialValue: _bankAccount,
    //     textInputAction: TextInputAction.next,
    //     onSaved: (value) => setState(() => _bankAccount = value!),
    //     validator: (value) {
    //       if (value!.isEmpty) {
    //         return 'This field is required';
    //       } else {
    //         return null;
    //       }
    //     },
    //   );
    // }

    Widget _buildRegionField() {
      return DropdownFormFieldString(
        label: isLoadingRegion ? 'loading..' : 'Region',
        onChanged: (value) => setState(() {
          address!.regionCode = value!;
          address!.provinceCode = null;
          address!.townCode = null;
          address!.barangayCode = null;
          getProvinces();
        }),
        validator: (value) {
          if (value == null) {
            return 'This field is required';
          } else {
            return null;
          }
        },
        value: address!.regionCode,
        values: regions?.map((x) {
          return DropdownMenuItem(
            child: Text(x.regionName + ' (' + x.name + ')'),
            value: x.code,
          );
        }).toList(),
      );
    }

    Widget _buildProvinceField() {
      return DropdownFormFieldString(
        label: isLoadingProvince ? 'Loading..' : 'Province',
        onChanged: (value) => setState(() {
          address!.provinceCode = value!;
          address!.townCode = null;
          address!.barangayCode = null;
          getTowns();
        }),
        validator: (value) {
          if (value == null) {
            return 'This field is required';
          } else {
            return null;
          }
        },
        value: address!.provinceCode,
        values: provinces?.map((x) {
          return DropdownMenuItem(
            child: Text(x.name),
            value: x.code,
          );
        }).toList(),
      );
    }

    Widget _buildTownField() {
      return DropdownFormFieldString(
        label: isLoadingTown ? 'Loading..' : 'Town',
        onChanged: (value) => setState(() {
          address!.townCode = value!;
          address!.barangayCode = null;
          getBarangays();
        }),
        validator: (value) {
          if (value == null) {
            return 'This field is required';
          } else {
            return null;
          }
        },
        value: address!.townCode,
        values: towns?.map((x) {
          return DropdownMenuItem(
            child: Text(x.name),
            value: x.code,
          );
        }).toList(),
      );
    }

    Widget _buildBarangayField() {
      return DropdownFormFieldString(
        label: isLoadingBarangay ? 'Loading..' : 'Barangay',
        onChanged: (value) => setState(() {
          address!.barangayCode = value!;
        }),
        validator: (value) {
          if (value == null) {
            return 'This field is required';
          } else {
            return null;
          }
        },
        value: address!.barangayCode,
        values: barangays?.map((x) {
          return DropdownMenuItem(
            child: Text(x.name),
            value: x.code,
          );
        }).toList(),
      );
    }

    Widget _buildAddressField() {
      return InputFormField(
        label: 'Address',
        hintText: 'Home no, Bldg no, Street',
        initialValue: address!.address,
        onSaved: (value) => setState(() => address!.address = value!),
      );
    }

    Widget _buildImageScrField() {
      String? _imageScr = widget.practitioner?.signatureLink;
      final size = MediaQuery.of(context).size;
      return Builder(
        builder: (context) => GestureDetector(
          // onTapDown: (details) => tapDownDetails = details,
          onTap: () => showPopup('signature'),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(defaultBorderRadius),
              image: DecorationImage(
                image: signature != null
                    ? FileImage(signature!)
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

    return Scaffold(
      appBar: AppBarDefault(title: 'Account Information'),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: defaultPadding,
            horizontal: Responsive.isDesktop(context)
                ? size.width * 0.30
                : defaultPadding,
          ),
          child: Form(
            key: _formKey,
            autovalidateMode: _submitted
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    showPopup('image');
                  },
                  child: Stack(
                    children: <Widget>[
                      CachedNetworkImage(
                        key: UniqueKey(),
                        imageUrl: practitioner != null
                            ? practitioner!.information!.profilePicture!
                            : patientProfile?.information.profilePicture ??
                                'https://myawsbucketnars.s3.ap-southeast-1.amazonaws.com/documents/default_profile.png',
                        imageBuilder: (context, imageProvider) => Container(
                          height: 130,
                          width: 130,
                          // padding: null,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.white,
                              width: 5,
                            ),
                            image: DecorationImage(
                              image: image != null
                                  ? FileImage(image!) as ImageProvider
                                  : imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => SizedBox(
                          height: 130,
                          width: 130,
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: Center(
                              child: CircularProgressIndicator(
                                value: downloadProgress.progress,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                            color: kPrimaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: TextButton(
                            style: ButtonStyle(
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                            ),
                            onPressed: () {
                              showPopup('image');
                            },
                            child: SvgPicture.asset(
                              'assets/icons/camera4.svg',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: defaultPadding),
                _buildFirstNameField(),
                const SizedBox(height: defaultPadding),
                _buildMiddleNameField(),
                const SizedBox(height: defaultPadding),
                _buildLastNameField(),
                const SizedBox(height: defaultPadding),
                _buildBirthDateField(),
                const SizedBox(height: defaultPadding),
                _buildGenderField(),
                const SizedBox(height: defaultPadding),
                _buildPhoneNumberField(),
                if (flavor != Flavor.Patient) ...[
                  const SizedBox(height: defaultPadding),
                  _buildEmailField(),
                  const SizedBox(height: defaultPadding),
                  _buildPRCNumberField(),
                ],
                if (userType == UserType.Doctor) ...[
                  const SizedBox(height: defaultPadding),
                  _buildExperience(),
                  const SizedBox(height: defaultPadding),
                  _buildDescription(),
                  const SizedBox(height: defaultPadding),
                  SectionTitle(title: 'Signature'),
                  const SizedBox(height: defaultPadding / 2),
                  _buildImageScrField(),
                ],
                if (practitioner == null && widget.patientProfile == null) ...[
                  const SizedBox(height: defaultPadding * 2),
                  const SectionTitle(title: 'Address'),
                  const SizedBox(height: defaultPadding),
                  _buildRegionField(),
                  const SizedBox(height: defaultPadding),
                  _buildProvinceField(),
                  const SizedBox(height: defaultPadding),
                  _buildTownField(),
                  const SizedBox(height: defaultPadding),
                  _buildBarangayField(),
                  const SizedBox(height: defaultPadding),
                  _buildAddressField(),
                  const SizedBox(height: defaultPadding),
                ],
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(
          vertical: defaultPadding,
          horizontal: Responsive.isDesktop(context)
              ? size.width * 0.30
              : defaultPadding,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
          child: Material(
            color: kPrimaryColor,
            child: InkWell(
              onTap: () {
                setState(() {
                  _submitted = true;
                });
                final isValid = _formKey.currentState?.validate();
                FocusScope.of(context).unfocus();

                if (isValid!) {
                  setState(() {
                    isLoading = true;
                  });
                  _formKey.currentState?.save();

                  save();
                }
              },
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                height: 60,
                child: isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          ),
                          SizedBox(width: defaultPadding * .5),
                          Text(
                            'LOADING..',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      )
                    : const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future pickImage(ImageSource imgScr, String type) async {
    try {
      final image = await ImagePicker().pickImage(source: imgScr);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        if (type == 'image') {
          this.image = imageTemporary;
        } else {
          signature = imageTemporary;
        }
      });
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Failed to pick image: $e');
      }
    }
  }

  Future showPopup(String type) {
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
              pickImage(ImageSource.camera, type);
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
              pickImage(ImageSource.gallery, type);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
