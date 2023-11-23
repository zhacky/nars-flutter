import 'package:nars/api/address_api.dart';
import 'package:nars/api/patient_api.dart';
import 'package:nars/components/address_tile.dart';
import 'package:nars/components/app_bar_default.dart';
import 'package:nars/constants.dart';
import 'package:nars/helpers/responsive.dart';
import 'package:nars/models/address/addressAlls.dart';
import 'package:nars/models/patient/profile.dart';
import 'package:nars/screens/address_form/address_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({
    Key? key,
    required this.profileId,
  }) : super(key: key);

  final int profileId;

  @override
  _AddressesScreenState createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  // int _profile = TokenPreferences.getProfileId()!;
  List<Profile>? profiles;
  late Stream<List<AddressAll>> addressesStream;

  Future getProfiles() async {
    var result = await ProfileApi.getProfiles();
    setState(() {
      profiles = result;
    });
  }

  @override
  void initState() {
    super.initState();
    getProfiles();
    addressesStream = getAddresses(widget.profileId);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Stream<List<AddressAll>> getAddresses(int profileId) async* {
    yield await AddressApi.getAddresses(profileId);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBarDefault(title: 'Addresses'),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: defaultPadding,
          horizontal: Responsive.isDesktop(context) ? size.width * 0.30 : 0,
        ),
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: defaultPadding * 2),
              ListTile(
                tileColor: Colors.white,
                horizontalTitleGap: 4,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding, vertical: defaultPadding / 4),
                title: const Text('Add New Address'),
                leading: SvgPicture.asset(
                  'assets/icons/plus2.svg',
                  width: 30,
                ),
                onTap: () async {
                  var result =
                      await ProfileApi.getInformation(widget.profileId);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddressFormScreen(
                        profileId: widget.profileId,
                        information: result,
                      ),
                    ),
                  );
                  setState(() {
                    addressesStream = getAddresses(widget.profileId);
                  });
                },
              ),
              const SizedBox(height: defaultPadding * 2),
              StreamBuilder(
                stream: addressesStream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<AddressAll>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    List<AddressAll> addresses = snapshot.data!;
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: addresses.length,
                      itemBuilder: (BuildContext context, int index) {
                        AddressAll _data = addresses[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: AddressTile(
                            address: _data,
                            press: () async {
                              var result = await ProfileApi.getInformation(
                                  widget.profileId);
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddressFormScreen(
                                    profileId: widget.profileId,
                                    information: result,
                                    address: _data,
                                  ),
                                ),
                              );
                              setState(() {
                                addressesStream =
                                    getAddresses(widget.profileId);
                              });
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              // Column(
              //   children: List.generate(
              //     addresses.length,
              //     (index) => Column(
              //       children: [
              //         AddressTile(
              //           address: addresses[index],
              //           press: () {
              //             Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                 builder: (context) => AddressFormScreen(
              //                   address: addresses[index],
              //                 ),
              //               ),
              //             );
              //           },
              //         ),
              //         const SizedBox(
              //           height: 4,
              //         )
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
