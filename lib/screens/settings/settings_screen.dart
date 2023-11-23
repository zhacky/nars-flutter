import 'package:nars/api/auth_service.dart';
import 'package:nars/api/practitioner_api.dart';
import 'package:nars/api/patient_api.dart';
import 'package:nars/components/app_bar_default.dart';
import 'package:nars/components/container_warning.dart';
import 'package:nars/components/list_tile_default.dart';
import 'package:nars/constants.dart';
import 'package:nars/enumerables/status.dart';
import 'package:nars/enumerables/usertype.dart';
import 'package:nars/helpers/responsive.dart';
import 'package:nars/models/patient/profile.dart';
import 'package:nars/enumerables/flavor.dart';
import 'package:nars/models/practitioner/practitioner.dart';
import 'package:nars/preferences/token_pref.dart';
import 'package:nars/screens/account_information/account_information_screen.dart';
import 'package:nars/screens/addresses/addresses_screen.dart';
import 'package:nars/screens/appointment_settings/appointment_settings_screen.dart';
import 'package:nars/screens/change_pin/change_pin_screen.dart';
import 'package:nars/screens/documents/documents_screen.dart';
import 'package:nars/screens/hospitals/hospitals_screen.dart';
import 'package:nars/screens/services/services_screen.dart';
import 'package:nars/screens/specialization_setting/specialization_setting_screen.dart';
import 'package:nars/screens/wallet/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Practitioner? practitioner;
  List<Profile>? profiles;
  int? _profileId = TokenPreferences.getProfileId();
  List<DropdownMenuItem<int>>? dropdowns;

  Future getProfiles() async {
    var result = await ProfileApi.getProfiles();
    setState(() {
      profiles = result;
      dropdowns = profiles?.map((x) {
        return DropdownMenuItem(
          child: Text(x.information.fullName),
          value: x.id,
        );
      }).toList();
      dropdowns!.add(const DropdownMenuItem(
        child: Text('Add New Profile'),
        value: 0,
      ));
    });
  }

  //initState
  @override
  void initState() {
    super.initState();
    if (_profileId != null) getProfiles();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flavor = Provider.of<Flavor>(context);
    final user = Provider.of<AuthService>(context).currentUser!;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBarDefault(
        title: 'Settings',
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 0,
          horizontal: Responsive.isDesktop(context) ? size.width * 0.30 : 0,
        ),
        child: FutureBuilder(
            future: flavor == Flavor.Practitioner
                ? PractitionerApi.getPractitioner(user.id)
                : ProfileApi.getPatientProfile(_profileId!),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                var data = snapshot.data!;

                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (flavor == Flavor.Practitioner &&
                          user.userType == UserType.Doctor) ...[
                        if (data.practitionerScheduleHospitals.isEmpty ||
                            data.specialization.isEmpty) ...[
                          Container(
                            width: size.width,
                            padding: const EdgeInsets.all(defaultPadding),
                            color: Colors.orangeAccent.withOpacity(0.9),
                            child: RichText(
                              text: TextSpan(
                                text: 'Please fill out the following:',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                                children: [
                                  if (data.practitionerDocuments.isEmpty)
                                    const TextSpan(
                                      text: '\n• Required Documents',
                                    ),
                                  if (data.signatureLink == null)
                                    const TextSpan(
                                      text: '\n• Account Information',
                                    ),
                                  if (data
                                      .practitionerScheduleHospitals.isEmpty)
                                    const TextSpan(
                                      text: '\n• Hospital & Schedule',
                                    ),
                                  if (data.specialization.isEmpty)
                                    const TextSpan(
                                      text: '\n• Specialization',
                                    ),
                                  if (data.medcertFee == null)
                                    const TextSpan(
                                      text: '\n• Appointment Settings',
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                      if (flavor == Flavor.Practitioner &&
                          user.userType == UserType.Nurse) ...[
                        if (data.practitionerDocuments.isEmpty) ...[
                          Container(
                            width: size.width,
                            padding: const EdgeInsets.all(defaultPadding),
                            color: Colors.orangeAccent.withOpacity(0.9),
                            child: RichText(
                              text: const TextSpan(
                                text: 'Please fill out the following:',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                                children: [
                                  TextSpan(
                                    text: '\n• Required Documents',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                      if (_profileId != null) ...[
                        const SizedBox(height: defaultPadding),
                        Padding(
                          padding: const EdgeInsets.only(left: defaultPadding),
                          child: Text(
                            'Profile',
                            style:
                                Theme.of(context).textTheme.subtitle2!.copyWith(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                        ),
                        const SizedBox(height: defaultPadding * .5),
                        DropdownButtonFormField<int>(
                          isExpanded: true,
                          onChanged: (value) async {
                            if (value == 0) {
                              var updatedData = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AccountInformationScreen(),
                                ),
                              );
                              setState(() {
                                data = updatedData;
                                if (_profileId != null) getProfiles();
                              });
                              setState(() {});
                            } else {
                              _profileId = value!;
                              setState(() async {
                                // addressesStream = getAddresses(value!);
                                _profileId = value;
                                data = await ProfileApi.getPatientProfile(
                                    _profileId!);
                                await TokenPreferences.setProfileId(
                                    _profileId!);
                              });
                            }
                          },
                          value: _profileId,
                          items: dropdowns,
                          decoration: const InputDecoration(
                            // labelText: 'Profiles',
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: defaultPadding * 1.5,
                              vertical: defaultPadding,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              // borderRadius: BorderRadius.circular(defaultBorderRadius),
                            ),
                            // focusedBorder: OutlineInputBorder(
                            //     // borderSide: const BorderSide(color: kPrimaryColor, width: 2),
                            //     // borderRadius: BorderRadius.circular(defaultBorderRadius),
                            //     ),
                          ),
                        ),
                      ],
                      const SizedBox(height: defaultPadding * 2),
                      Padding(
                        padding: const EdgeInsets.only(left: defaultPadding),
                        child: Text(
                          'Account Settings',
                          style:
                              Theme.of(context).textTheme.subtitle1!.copyWith(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                      const SizedBox(height: defaultPadding),
                      if (flavor != Flavor.Patient &&
                          data!.status == Status.WaitingForApproval) ...[
                        DefaultListTile(
                          title: 'Required Documents',
                          svgScr: 'assets/icons/document2.svg',
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DocumentsScreen(
                                  status: data!.status,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 2),
                      ],
                      DefaultListTile(
                        title: 'Account Information',
                        svgScr: 'assets/icons/profile.svg',
                        press: () async {
                          var updatedData = await Navigator.push(
                            context,
                            flavor == Flavor.Practitioner
                                ? MaterialPageRoute(
                                    builder: (context) =>
                                        AccountInformationScreen(
                                      practitioner: data,
                                    ),
                                  )
                                : MaterialPageRoute(
                                    builder: (context) =>
                                        AccountInformationScreen(
                                      patientProfile: data,
                                    ),
                                  ),
                          ); //SnackBar
                          setState(() {
                            data = updatedData;
                            if (_profileId != null) getProfiles();
                          });
                        },
                      ),
                      if (flavor == Flavor.Patient) ...[
                        const SizedBox(height: 2),
                        DefaultListTile(
                          title: 'Addresses',
                          svgScr: 'assets/icons/location2.svg',
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddressesScreen(
                                  profileId: _profileId!,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                      if (flavor != Flavor.Patient &&
                          user.userType == UserType.Doctor) ...[
                        const SizedBox(height: 2),
                        DefaultListTile(
                          title: 'Hospital & Schedule',
                          svgScr: 'assets/icons/location2.svg',
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HospitalsScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                      if (flavor == Flavor.Practitioner &&
                          user.userType == UserType.Doctor) ...[
                        const SizedBox(height: 2),
                        DefaultListTile(
                          title: 'Specialization',
                          svgScr: 'assets/icons/doctor.svg',
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SpecializationSettingScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 2),
                        DefaultListTile(
                          title: 'Services',
                          svgScr: 'assets/icons/list.svg',
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ServicesScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 2),
                        DefaultListTile(
                          title: 'Appointment Settings',
                          svgScr: 'assets/icons/appointment.svg',
                          press: () async {
                            var updatedData = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AppointmentSettingsScreen(
                                  practitioner: data,
                                ),
                              ),
                            );
                            setState(() {
                              data = updatedData;
                              if (_profileId != null) getProfiles();
                            });
                          },
                        ),
                      ],
                      const SizedBox(height: 2),
                      DefaultListTile(
                        title: 'Change PIN',
                        svgScr: 'assets/icons/pin.svg',
                        press: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChangePINScreen(),
                            ),
                          );
                        },
                      ),
                      if (flavor != Flavor.Patient &&
                          data!.status != Status.WaitingForApproval) ...[
                        const SizedBox(height: 2),
                        DefaultListTile(
                          title: 'Medical Records/Documents',
                          svgScr: 'assets/icons/document2.svg',
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DocumentsScreen(
                                  status: data!.status,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                      if (flavor == Flavor.Patient) ...[
                        const SizedBox(height: 2),
                        DefaultListTile(
                          title: 'Wallet',
                          svgScr: 'assets/icons/wallet2.svg',
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WalletScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                );
              } else {
                return Center(
                  child: Container(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            }),
      ),
    );
  }
}
