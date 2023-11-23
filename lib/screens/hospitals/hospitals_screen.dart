import 'package:nars/api/auth_service.dart';
import 'package:nars/api/hospital_api.dart';
import 'package:nars/components/app_bar_default.dart';
import 'package:nars/components/hospital_tile.dart';
import 'package:nars/constants.dart';
import 'package:nars/helpers/responsive.dart';
import 'package:nars/models/practitioner/practitioner_hospital.dart';
import 'package:nars/screens/hospital_schedule_form/hospital_schedule_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class HospitalsScreen extends StatefulWidget {
  const HospitalsScreen({
    Key? key,
  }) : super(key: key);

  @override
  _HospitalsScreenState createState() => _HospitalsScreenState();
}

class _HospitalsScreenState extends State<HospitalsScreen> {
  late Stream<List<PractitionerHospital>> hospitalsStream;

  Stream<List<PractitionerHospital>> getPractitionerHospitals(
      int practitionerId) async* {
    yield await HospitalApi.getPractitionerHospitals(practitionerId);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final user = Provider.of<AuthService>(context).currentUser!;
    hospitalsStream = getPractitionerHospitals(user.id);

    return Scaffold(
      appBar: AppBarDefault(title: 'Hospital & Schedules'),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: defaultPadding,
            horizontal: Responsive.isDesktop(context) ? size.width * 0.30 : 0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: defaultPadding * 2),
              ListTile(
                tileColor: Colors.white,
                horizontalTitleGap: 4,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding, vertical: defaultPadding / 4),
                title: const Text('Add Hospital & Schedule'),
                leading: SvgPicture.asset(
                  'assets/icons/plus2.svg',
                  width: 30,
                ),
                onTap: () async {
                  // var result = await ProfileApi.getInformation(_profile);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HospitalScheduleFormScreen(),
                    ),
                  );
                  setState(() {
                    hospitalsStream = getPractitionerHospitals(user.id);
                  });
                },
              ),
              const SizedBox(height: defaultPadding * 2),
              StreamBuilder(
                stream: hospitalsStream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<PractitionerHospital>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    List<PractitionerHospital> practitionerHospital =
                        snapshot.data!;
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: practitionerHospital.length,
                      itemBuilder: (BuildContext context, int index) {
                        PractitionerHospital _data =
                            practitionerHospital[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: HospitalTile(
                            hospital: _data,
                            press: () async {
                              // var result = await ProfileApi.getInformation(_profile);
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      HospitalScheduleFormScreen(
                                    practitionerHospital:
                                        practitionerHospital[index],
                                  ),
                                ),
                              );
                              setState(() {
                                hospitalsStream =
                                    getPractitionerHospitals(user.id);
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
            ],
          ),
        ),
      ),
    );
  }
}
