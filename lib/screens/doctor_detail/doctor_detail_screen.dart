import 'package:nars/api/practitioner_api.dart';
import 'package:nars/components/app_bar_default.dart';
import 'package:nars/components/card_container.dart';
import 'package:nars/components/container_loading_indicate.dart';
import 'package:nars/components/doctor_card_experience.dart';
import 'package:nars/constants.dart';
import 'package:nars/helpers/responsive.dart';
import 'package:nars/models/practitioner/practitioner.dart';
import 'package:nars/screens/make_appointment/make_appointment_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DoctorDetailScreen extends StatefulWidget {
  const DoctorDetailScreen({
    Key? key,
    required this.practitioner,
  }) : super(key: key);

  // final bool heart = false;
  final Practitioner practitioner;

  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBarDefault(
        title: 'Dr. ' + widget.practitioner.fullName!,
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: SvgPicture.asset(
        //       "assets/icons/heart2.svg",
        //       color: Colors.white,
        //     ),
        //   )
        // ],
      ),
      body: Column(
        children: [
          CachedNetworkImage(
            key: UniqueKey(),
            imageUrl: widget.practitioner.profilePicture!,
            imageBuilder: (context, imageProvider) => Container(
              height: MediaQuery.of(context).size.height * 0.4,
              // width: width,
              decoration: BoxDecoration(
                // shape: boxShape,
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              // width: width,
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
          Expanded(
            child: CardContainer(
              padding: EdgeInsets.fromLTRB(
                  Responsive.isDesktop(context)
                      ? size.width * 0.3
                      : defaultPadding,
                  defaultPadding * 2,
                  Responsive.isDesktop(context)
                      ? size.width * 0.3
                      : defaultPadding,
                  0),
              // borderRadius: const BorderRadius.only(
              //   topLeft: Radius.circular(defaultBorderRadius * 2),
              //   topRight: Radius.circular(defaultBorderRadius * 2),
              // ),
              borderRadius: const BorderRadius.all(Radius.zero),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.practitioner.specialization != null)
                      Row(
                        children: List.generate(
                          widget.practitioner.specialization!.length,
                          (index) => Text(
                            widget.practitioner.specialization![index].name +
                                (index ==
                                        widget.practitioner.specialization!
                                                .length -
                                            1
                                    ? ''
                                    : ', '),
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    // Row(
                    //   children: [
                    //     Text(
                    //       doctor.specialty,
                    //       style: Theme.of(context).textTheme.headline6,
                    //     )
                    //   ],
                    // ),
                    if (widget.practitioner.title != null)
                      Row(
                        children: [
                          Text(
                            widget.practitioner.title!,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ],
                      ),
                    const SizedBox(
                      height: defaultPadding / 4,
                    ),
                    // Row(
                    //   children: [
                    //     Rating(rating: doctor.rating),
                    //   ],
                    // ),
                    if (widget.practitioner.description != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: defaultPadding),
                        child: Text(
                          widget.practitioner.description!,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(right: defaultPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // DoctorCardPatient(
                          //     label: 'Patient', amount: doctor.patient),
                          DoctorCardExperience(
                              experience:
                                  widget.practitioner.yearOfExperience!),
                          // DoctorCardPatient(
                          //     label: 'Reviews', amount: doctor.patient),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: CardContainer(
        // width: 300,
        padding: EdgeInsets.symmetric(
            horizontal: Responsive.isDesktop(context)
                ? size.width * 0.3
                : defaultPadding,
            vertical: defaultPadding),
        borderRadius: null,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
          child: Material(
            color: kPrimaryColor,
            child: InkWell(
              onTap: () async {
                setState(() => isLoading = true);
                Practitioner _practitioner =
                    await PractitionerApi.getPractitioner(
                        widget.practitioner.id!);

                setState(() => isLoading = false);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MakeAppointmentScreen(
                      practitioner: _practitioner,
                    ),
                  ),
                );
              },
              child: ContainerLoadingIndicator(
                isLoading: isLoading,
                label: 'Book an Appointment',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
