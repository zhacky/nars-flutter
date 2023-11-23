import 'package:nars/api/address_api.dart';
import 'package:nars/api/hospital_api.dart';
import 'package:nars/components/app_bar_default.dart';
import 'package:nars/components/container_loading_indicate.dart';
import 'package:nars/components/dropdown_form_field_string.dart';
import 'package:nars/components/input_form_field.dart';
import 'package:nars/components/section_title.dart';
import 'package:nars/constants.dart';
import 'package:nars/enumerables/flavor.dart';
import 'package:nars/helpers/responsive.dart';
import 'package:nars/models/address/barangay.dart';
import 'package:nars/models/hospital/add_hospital_param.dart';
import 'package:nars/models/address/province.dart';
import 'package:nars/models/address/region.dart';
import 'package:nars/models/address/town.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HospitalFormScreen extends StatefulWidget {
  const HospitalFormScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HospitalFormScreen> createState() => _HospitalFormScreenState();
}

class _HospitalFormScreenState extends State<HospitalFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _submitted = false;
  bool isLoading = false;
  bool isLoadingRegion = false;
  bool isLoadingProvince = false;
  bool isLoadingTown = false;
  bool isLoadingBarangay = false;
  bool firstLoad = true;
  String? _hospital;
  String? _region;
  String? _province;
  String? _town;
  String? _barangay;
  String? _address;
  List<Region>? regions;
  List<Province>? provinces;
  List<Town>? towns;
  List<Barangay>? barangays;

  Future getRegions() async {
    var result = await AddressApi.getRegions();
    setState(() {
      regions = result;
      // if (widget.address != null && firstLoad) {
      //   _region = widget.address?.regionCode;
      //   getProvinces();
      // }
    });
  }

  Future getProvinces() async {
    var result = await AddressApi.getProvincesByRegionCode(_region!);
    setState(() {
      provinces = result;
      // if (widget.address != null && firstLoad) {
      //   _province = widget.address?.provinceCode;
      //   getTowns();
      // }
    });
  }

  Future getTowns() async {
    var result = await AddressApi.getTownsByProvinceCode(_region!, _province!);
    setState(() {
      towns = result;
      // if (widget.address != null && firstLoad) {
      //   _town = widget.address?.townCode;
      //   getBarangays();
      // }
    });
  }

  Future getBarangays() async {
    var result = await AddressApi.getBarangaysByTownCode(_town!);
    setState(() {
      barangays = result;
      // if (widget.address != null && firstLoad) {
      //   _barangay = widget.address?.barangayCode;
      //   firstLoad = false;
      // }
    });
  }

  void submit() async {
    setState(() => _submitted = true);
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (isValid!) {
      setState(() => isLoading = true);
      _formKey.currentState?.save();

      // if (widget.address != null) {
      //   widget.information.addressAlls!
      //       .removeWhere((x) => x.id == widget.address?.id);
      // }

      var result = await HospitalApi.addHospital(
        AddHospitalParam(
          name: _hospital!,
          description: '-',
          imageLink: '-',
          address: Address(
            regionCode: _region!,
            provinceCode: _province!,
            townCode: _town!,
            barangayCode: _barangay!,
            address: _address!,
            isDefault: true,
          ),
        ),
      );

      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    getRegions();
    // _address = widget.address?.address;
    // print('init widget.information');
    // print(informationToJson(widget.information));

    // if (widget.address != null) {
    //   print('init widget.address');
    //   print(addressAllToJson(widget.address!));
    // }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flavor = Provider.of<Flavor>(context);
    Size size = MediaQuery.of(context).size;
    // Address? address = widget.address;
    // String? _province = address?.province;

    Widget _buildHospitalField() {
      return InputFormField(
        label: 'Hospital Name',
        // hintText: 'Home no, Bldg no, Street',
        // initialValue: _address,
        onSaved: (value) => setState(() => _hospital = value!),
      );
    }

    Widget _buildRegionField() {
      return DropdownFormFieldString(
        label: isLoadingRegion ? 'loading..' : 'Region',
        onChanged: (value) => setState(() {
          _region = value!;
          _province = null;
          _town = null;
          _barangay = null;
          getProvinces();
        }),
        validator: (value) {
          if (value == null) {
            return 'This field is required';
          } else {
            return null;
          }
        },
        value: _region,
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
          _province = value!;
          _town = null;
          _barangay = null;
          getTowns();
        }),
        validator: (value) {
          if (value == null) {
            return 'This field is required';
          } else {
            return null;
          }
        },
        value: _province,
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
          _town = value!;
          _barangay = null;
          getBarangays();
        }),
        validator: (value) {
          if (value == null) {
            return 'This field is required';
          } else {
            return null;
          }
        },
        value: _town,
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
          _barangay = value!;
        }),
        validator: (value) {
          if (value == null) {
            return 'This field is required';
          } else {
            return null;
          }
        },
        value: _barangay,
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
        initialValue: _address,
        onSaved: (value) => setState(() => _address = value!),
      );
    }

    return Scaffold(
      appBar: AppBarDefault(
        title: 'Request a Hospital',
      ),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHospitalField(),
                const SizedBox(height: defaultPadding),
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
                ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(defaultBorderRadius),
                  ),
                  child: Material(
                    color: kPrimaryColor,
                    child: InkWell(
                      onTap: () {
                        submit();
                      },
                      child: ContainerLoadingIndicator(isLoading: isLoading),
                    ),
                  ),
                ),
                // if (widget.address != null) ...[
                //   const SizedBox(height: defaultPadding),
                //   // ButtonDefault(
                //   //   width: size.width / 3,
                //   //   fontColor: Colors.redAccent,
                //   //   bgColor: Colors.white,
                //   //   title: 'Delete',
                //   //   press: () {
                //   //     showDialog(
                //   //       context: context,
                //   //       builder: (context) => AlertDialog(
                //   //         title: Text(
                //   //           'Delete',
                //   //           style: Theme.of(context).textTheme.headline6,
                //   //         ),
                //   //         content: const Text(
                //   //             'Are you sure you want to delete this address on your profile?'),
                //   //         actions: [
                //   //           TextButton(
                //   //             onPressed: () {
                //   //               Navigator.of(context).pop();
                //   //             },
                //   //             child: const Text('No'),
                //   //           ),
                //   //           TextButton(
                //   //             onPressed: () {
                //   //               submit(isDelete: true);
                //   //             },
                //   //             child: const Text('Yes'),
                //   //           ),
                //   //         ],
                //   //       ),
                //   //     );
                //   //   },
                //   // ),
                // ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
