import 'package:nars/api/practitioner_api.dart';
import 'package:nars/components/card_asset_image.dart';
import 'package:nars/components/card_network_image.dart';
import 'package:nars/components/doctor_long_card.dart';
import 'package:nars/components/section_title.dart';
import 'package:nars/components/search_form.dart';
import 'package:nars/constants.dart';
import 'package:nars/enumerables/home_state.dart';
import 'package:nars/helpers/responsive.dart';
import 'package:nars/models/practitioner/practitioner.dart';
import 'package:nars/models/practitioner/get_practitioners_param.dart';
import 'package:nars/models/pagination/pagination_param.dart';
import 'package:nars/providers/hospitals_provider.dart';
import 'package:nars/providers/services_provider.dart';
import 'package:nars/providers/specializations_provider.dart';
import 'package:nars/screens/doctor_detail/doctor_detail_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FindDoctorScreen extends StatefulWidget {
  const FindDoctorScreen({
    Key? key,
    required this.update,
  }) : super(key: key);

  // method() => createState().focusOnNode();

  final ValueChanged<int> update;

  @override
  _FindDoctorScreenState createState() => _FindDoctorScreenState();
}

class _FindDoctorScreenState extends State<FindDoctorScreen> {
  late Stream<List<Practitioner>> practitionersStream;
  // final List<Doctor> _doctors = [];
  // FocusNode myFocusNode = FocusNode();
  int? specializationId;
  int? serviceId;
  int? hospitalId;

  Stream<List<Practitioner>> getPractitioners() async* {
    yield await PractitionerApi.getPractitioners(
      GetPractitionersParam(
        pageCommon: PageCommon(
          page: 1,
          pageSize: 100,
        ),
        userType: 2,
        status: 0,
        specializationId: specializationId,
        symptomsId: serviceId,
        hospitalId: hospitalId,
      ),
    );
  }

  Future<void> _refresh() async {
    setState(() {});
  }

  // @override
  // void initState() {
  //   super.initState();

  //   myFocusNode = FocusNode();
  // }

  // @override
  // void dispose() {
  //   // Clean up the focus node when the Form is disposed.
  //   myFocusNode.dispose();

  //   super.dispose();
  // }

  // void focusOnNode() async {
  //   // print('Sample123');
  //   // initState();
  //   // myFocusNode.requestFocus();
  // }

  Widget _buildSpecializations() {
    return Column(
      children: [
        SectionTitle(
          title: 'Specializations',
          hasSeeAll: true,
          pressSeeAll: () {},
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
          child: SizedBox(
            height: 110,
            child: ChangeNotifierProvider(
              create: (context) => SpecializationsProvider(null),
              child: Builder(
                builder: (context) {
                  final model = Provider.of<SpecializationsProvider>(context);
                  if (model.homeState == HomeState.Loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (model.homeState == HomeState.Error) {
                    return Center(
                      child: Text(
                          'Something went wrong, please try again.\n${model.message}'),
                    );
                  }
                  final specializations = model.specializations;
                  return ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                      },
                    ),
                    child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: specializations.length,
                      itemBuilder: (context, index) {
                        final specialization = specializations[index];
                        return Padding(
                          padding: EdgeInsets.only(
                              right: index == specializations.length - 1
                                  ? 0
                                  : defaultPadding),
                          child: CardNetworkImage(
                            imageLink: specialization.imageLink!,
                            title: specialization.name,
                            selected: specialization.isSelected,
                            press: () {
                              setState(() {
                                specializationId =
                                    model.filterSpecialization(specialization);
                              });
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServices() {
    return Column(
      children: [
        SectionTitle(
          title: 'Symptoms or Diagnosed Conditions',
          hasSeeAll: true,
          pressSeeAll: () {},
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
          child: SizedBox(
            height: 110,
            child: ChangeNotifierProvider(
              create: (context) => ServicesProvider(null),
              child: Builder(
                builder: (context) {
                  final model = Provider.of<ServicesProvider>(context);
                  if (model.homeState == HomeState.Loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (model.homeState == HomeState.Error) {
                    return Center(
                      child: Text(
                          'Something went wrong, please try again.\n${model.message}'),
                    );
                  }
                  final services = model.services;
                  return ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                      },
                    ),
                    child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: services.length,
                      itemBuilder: (context, index) {
                        final service = services[index];
                        return Padding(
                          padding: EdgeInsets.only(
                              right: index == services.length - 1
                                  ? 0
                                  : defaultPadding),
                          child: CardNetworkImage(
                            imageLink: service.imageLink,
                            title: service.name,
                            selected: service.isSelected,
                            press: () {
                              setState(() {
                                serviceId = model.filterServices(service);
                              });
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHospitals() {
    return Column(
      children: [
        SectionTitle(
          title: 'Hospitals',
          hasSeeAll: true,
          pressSeeAll: () {},
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
          child: SizedBox(
            height: 80,
            child: ChangeNotifierProvider(
              create: (context) => HospitalsProvider(),
              child: Builder(
                builder: (context) {
                  final model = Provider.of<HospitalsProvider>(context);
                  if (model.homeState == HomeState.Loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (model.homeState == HomeState.Error) {
                    return Center(
                      child: Text(
                          'Something went wrong, please try again.\n${model.message}'),
                    );
                  }
                  final hospitals = model.hospitals;
                  return ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                      },
                    ),
                    child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: hospitals.length,
                      itemBuilder: (context, index) {
                        final hospital = hospitals[index];
                        return Padding(
                          padding: EdgeInsets.only(
                              right: index == hospitals.length - 1
                                  ? 0
                                  : defaultPadding),
                          child: SizedBox(
                            width: 170,
                            height: 80,
                            child: CardAssetImage(
                              title: hospital.name,
                              selected: hospital.isSelected,
                              press: () {
                                setState(() {
                                  hospitalId = model.filterHospital(hospital);
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    practitionersStream = getPractitioners();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     widget.update(0);
      //   },
      // ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: defaultPadding,
            horizontal: Responsive.isDesktop(context)
                ? size.width * 0.30
                : defaultPadding,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Find Your', style: TextStyle(fontSize: 22)),
              Text(
                'Specialist',
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(fontWeight: FontWeight.w500, color: Colors.black),
              ),
              const SizedBox(height: defaultPadding),
              const SearchForm(),
              const SizedBox(height: defaultPadding / 2),
              _buildSpecializations(),
              const SizedBox(height: defaultPadding / 2),
              _buildServices(),
              const SizedBox(height: defaultPadding / 2),
              _buildHospitals(),
              const SizedBox(height: defaultPadding / 2),
              // const SizedBox(height: defaultPadding / 2),
              SectionTitle(
                title: 'Doctors',
                hasSeeAll: true,
                pressSeeAll: () {},
              ),
              StreamBuilder(
                stream: practitionersStream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Practitioner>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    List<Practitioner> practitioners = snapshot.data!;
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: practitioners.length,
                      itemBuilder: (BuildContext context, int index) {
                        Practitioner _data = practitioners[index];
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: index == practitioners.length - 1
                                  ? 0
                                  : defaultPadding),
                          child: DoctorLongCard(
                            practitioner: _data,
                            press: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DoctorDetailScreen(
                                    practitioner: _data,
                                  ),
                                ),
                              );
                              setState(() {
                                widget.update(0);
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
