import 'package:nars/api/appointment_api.dart';
import 'package:nars/api/notification_api.dart';
import 'package:nars/api/videocall_api.dart';
import 'package:nars/components/app_bar_default.dart';
import 'package:nars/components/button_default.dart';
import 'package:nars/components/card_container.dart';
import 'package:nars/components/document_tile.dart';
import 'package:nars/components/subtitle.dart';
import 'package:nars/components/text_pill.dart';
import 'package:nars/conference/conference_cubit.dart';
import 'package:nars/conference/conference_page.dart';
import 'package:nars/constants.dart';
import 'package:nars/enumerables/appointment_status.dart';
import 'package:nars/enumerables/flavor.dart';
import 'package:nars/enumerables/usertype.dart';
import 'package:nars/helpers/helpers.dart';
import 'package:nars/helpers/responsive.dart';
import 'package:nars/models/appointment/appointment.dart';
import 'package:nars/api/auth_service.dart';
import 'package:nars/models/chat/firebase_database.dart';
import 'package:nars/models/document/document.dart';
import 'package:nars/models/user/auth.dart';
import 'package:nars/models/videocall/join_video_call_param.dart';
import 'package:nars/room/join_room_cubit.dart';
import 'package:nars/screens/doctor_note/doctor_note_screen.dart';
import 'package:nars/screens/document_form/document_form_screen.dart';
import 'package:nars/screens/gallery_widget/gallery_widget_screen.dart';
import 'package:nars/screens/medcert_remark/medcert_remark_screen.dart';
import 'package:nars/screens/message_screen/message_screen.dart';
import 'package:nars/screens/prescriptions/prescriptions_screen.dart';
import 'package:nars/screens/reschedule/reschedule_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nars/shared/twilio_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({
    Key? key,
    required this.appointmentId,
  }) : super(key: key);

  final int appointmentId;

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  FirebaseDatabase databaseFirebase = new FirebaseDatabase();
  String topic = "";
  @override
  void initState() {
    super.initState();
    getName();
  }

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  Future<void> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var topic = prefs.getString('name') == null ? "" : prefs.getString('name')!;

    print("TOPICz");
    print(topic);

    if (!kIsWeb) {
      FirebaseMessaging.onMessage.listen((event) async {
        // NotificationApi.showNotification(
        //     body: event.notification!.body, title: event.notification!.title);

        setState(() {});
        print("onMessage");
      });

      if (topic != "")
        await messaging.subscribeToTopic(
            topic + "Appointment" + widget.appointmentId.toString());
    }

    print(topic + "Appointment" + widget.appointmentId.toString());
  }

  Future<void> approve(Appointment data) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Approve',
          style: Theme.of(context).textTheme.headline6,
        ),
        content:
            const Text('Are you sure you want to approve this appointment?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();

              EasyLoading.show(status: 'loading...');
              var result =
                  await AppointmentApi.approveAppointment(widget.appointmentId);
              if (result.statusCode == 200) {
                // List<String> users = [
                //   data.practitionerPhoneNumber!,
                //   data.patientPhoneNumber!
                // ];
                // Map<String, dynamic> chatRoomMap = {
                //   "user": users,
                //   "chatRoom": widget.appointmentId.toString()
                // };
                // databaseFirebase.createChatRoom(
                //     widget.appointmentId.toString(), chatRoomMap);
                EasyLoading.showSuccess('Appointment approved');
              }else{
                EasyLoading.showSuccess('Error: ${result.body.toString()}');
              }
              setState(() {});
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  Future<void> completed(Appointment data) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Completed',
          style: Theme.of(context).textTheme.headline6,
        ),
        content: const Text(
            'Are you sure you want to mark this appointment as completed?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();

              EasyLoading.show(status: 'loading...');
              var result = await AppointmentApi.completeAppointment(
                  widget.appointmentId);
              if (result.statusCode == 200) {
                // List<String> users = [
                //   data.practitionerPhoneNumber!,
                //   data.patientPhoneNumber!
                // ];
                // Map<String, dynamic> chatRoomMap = {
                //   "user": users,
                //   "chatRoom": widget.appointmentId.toString()
                // };
                // databaseFirebase.createChatRoom(
                //     widget.appointmentId.toString(), chatRoomMap);
              }
              EasyLoading.showSuccess('Appointment completed');
              setState(() {});
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context).currentUser!;
    final flavor = Provider.of<Flavor>(context);
    final bool showPatient = flavor != Flavor.Patient;
    Size size = MediaQuery.of(context).size;

    Widget _buildHeader(
        Appointment appointment, bool isNurse, RoomCubit bloc, Auth user) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CachedNetworkImage(
              key: UniqueKey(),
              imageUrl: showPatient
                  ? appointment.patientProfilePicture!
                  : appointment.practitionerProfilePicture!,
              imageBuilder: (context, imageProvider) => CardContainer(
                height: 130,
                width: 130,
                padding: null,
                color: Colors.white,
                boxShape: BoxShape.circle,
                borderRadius: null,
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Container(
                height: 130,
                width: 130,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
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
              errorWidget: (context, url, error) => Container(
                color: kBackgroundColor,
                child: const Icon(
                  Icons.error,
                  color: Colors.redAccent,
                ),
              ),
            ),
            const SizedBox(height: defaultPadding),
            Text(
              (appointment.practitionerId == null && !showPatient
                      ? 'Waiting for a Nurse'
                      : showPatient || isNurse
                          ? ''
                          : 'Dr. ') +
                  (showPatient
                      ? appointment.patientName!
                      : appointment.practitionerName!),
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(fontWeight: FontWeight.w500, color: Colors.white),
            ),
            if (!showPatient)
              Wrap(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  appointment.practitionerSpecialization!.length,
                  (index) => Text(
                    appointment.practitionerSpecialization![index] +
                        (index ==
                                appointment.practitionerSpecialization!.length -
                                    1
                            ? ''
                            : ', '),
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
            const SizedBox(height: defaultPadding),
            if ([
                  AppointmentStatus.Approved,
                  AppointmentStatus.Ongoing,
                ].contains(appointment.appointmentStatus) &&
                !isNurse)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              //     ButtonDefault(
              //       title: 'Message',
              //       svgScr: 'assets/icons/message2.svg',
              //       horizontalPadding: defaultPadding,
              //       bgColor: Colors.white.withOpacity(0.3),
              //       press: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) => MessageScreen(
              //               chatRoom: appointment.id.toString(),
              //               appointment: appointment,
              //             ),
              //           ),
              //         );
              //       },
              //     ),
              //     const SizedBox(width: defaultPadding),
              //     ButtonDefault(
              //       title: 'Voice Call',
              //       svgScr: 'assets/icons/phone3.svg',
              //       horizontalPadding: defaultPadding * .7,
              //       bgColor: Colors.white.withOpacity(0.3),
              //       press: () {},
              //     ),
              //     ButtonDefault(
              //       title: 'Video Call',
              //       svgScr: 'assets/icons/video.svg',
              //       horizontalPadding: defaultPadding,
              //       bgColor: Colors.white.withOpacity(0.3),
              //       press: () async {
              //         EasyLoading.show(status: 'loading...');
              //         var result =
              //             await VideoCallApi.joinVideoCall(JoinVideoCallParam(
              //           appointmentId: widget.appointmentId,
              //           profileId: showPatient
              //               ? appointment.practitionerId!
              //               : appointment.patientId!,
              //         ));
              //         debugPrint('joinVideoCall: ${result.body}');
              //         debugPrint('appointment.id: ${appointment.id}');
              //         debugPrint(
              //             'appointment.patientId: ${appointment.patientId}');
              //         debugPrint(
              //             'appointment.patientUserId: ${appointment.patientUserId}');
              //         await bloc.submit();
              //         EasyLoading.dismiss();
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) => JoinRoomPage(
              //               username: user.name,
              //               appointmentId: appointment.id,
              //             ),
              //           ),
              //         );
              //       },
              //     ),
                ],
              ),
          ],
        ),
      );
    }

    Widget _buildPatientInfo(Appointment appointment) {
      return CardContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Patient Info',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: defaultPadding / 2),
            const Divider(),
            const SizedBox(height: defaultPadding / 2),
            const SubtitleDefault(title: 'Gender'),
            Text(appointment.patientGender!),
            const SizedBox(height: defaultPadding),
            const SubtitleDefault(title: 'Contact'),
            Text(appointment.patientPhoneNumber!),
            const SizedBox(height: defaultPadding),
            const SubtitleDefault(title: 'Email'),
            Text(appointment.patientEmail!),
            const SizedBox(height: defaultPadding),
            const SubtitleDefault(title: 'Date of Birth'),
            Text(DateFormat('MMMM d, yyyy')
                    .format(appointment.patientDateOfBirth!) +
                '\n(' +
                ageCompute(
                        appointment.patientDateOfBirth!, appointment.schedule)
                    .toString() +
                ' yrs old at the date of this appointment)'),
            const SizedBox(height: defaultPadding),
          ],
        ),
      );
    }

    Widget _buildDetails(Appointment appointment, bool isNurse) {
      return CardContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Details',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: defaultPadding / 2),
            const Divider(),
            const SizedBox(height: defaultPadding / 2),
            if ([
              AppointmentStatus.ReschedByPatient,
              AppointmentStatus.ReschedByPractitioner
            ].contains(appointment.appointmentStatus)) ...[
              const SubtitleDefault(title: 'Reason for re-scheduling'),
              Text(appointment.reasonForRescheduling ?? ''),
              const SizedBox(height: defaultPadding),
            ],
            const SubtitleDefault(title: 'Date'),
            Text(DateFormat('MMMM d, yyyy').format(appointment.schedule)),
            const SizedBox(height: defaultPadding),
            const SubtitleDefault(title: 'Time'),
            Text(DateFormat('h:mm a').format(appointment.schedule)),
            const SizedBox(height: defaultPadding),
            const SubtitleDefault(title: 'Type'),
            Text(isNurse ? 'Home Service' : appointment.bookingType),
            const SizedBox(height: defaultPadding),
            const SubtitleDefault(title: 'Status'),
            TextPill(
              status: getAppointmentStatusName(appointment.appointmentStatus),
            ),
            if (!isNurse) ...[
              const SizedBox(height: defaultPadding),
              const SubtitleDefault(title: 'Requested for Medical Certificate'),
              Text(appointment.medCertFee == null ? 'No' : 'Yes'),
            ],
            const SizedBox(height: defaultPadding),
            const SubtitleDefault(title: 'COVID Patient'),
            Text(getCovidStatus(appointment.covidStatus!)),
            if (appointment.dateOfTest != null) ...[
              const SizedBox(height: defaultPadding),
              const SubtitleDefault(title: 'Date of COVID Test'),
              Text(DateFormat('MMMM d, yyyy').format(appointment.dateOfTest!)),
            ],
            if (isNurse) ...[
              const SizedBox(height: defaultPadding),
              const SubtitleDefault(title: 'Hour/s of service'),
              Text(NumberFormat("0").format(appointment.minutes! / 60)),
              const SizedBox(height: defaultPadding),
              const SubtitleDefault(title: 'Services'),
              Text(
                  appointment.nurseAppointmentDetail!.nurseServicesEnums ?? ''),
              const SizedBox(height: defaultPadding),
              const SubtitleDefault(title: 'Patient Mobility'),
              Text(getMobility(
                  appointment.nurseAppointmentDetail!.patientMobilityEnum)),
              const SizedBox(height: defaultPadding),
              const SubtitleDefault(title: 'Patient Contraptions'),
              Text(appointment.nurseAppointmentDetail!.patientContraptionEnum ??
                  ''),
            ],
            if (flavor == Flavor.Practitioner) ...[
              const SizedBox(height: defaultPadding),
              const SubtitleDefault(title: 'Consultation Fee'),
              Text(
                  NumberFormat("#,###.00").format(appointment.practitionerFee)),
              const SizedBox(height: defaultPadding),
              const SubtitleDefault(title: 'System Fee'),
              Text(NumberFormat("#,###.00").format(appointment.systemFee)),
              const SizedBox(height: defaultPadding),
              if (appointment.medCertFee != null) ...[
                const SubtitleDefault(title: 'Medical Certificate Fee'),
                Text(NumberFormat("#,###.00").format(appointment.medCertFee)),
                const SizedBox(height: defaultPadding),
              ],
              const SubtitleDefault(title: 'Total'),
              Text(NumberFormat("#,###.00").format(appointment.total)),
            ],
          ],
        ),
      );
    }

    Widget _buildReason(Appointment appointment) {
      return CardContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reason for Consultation',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: defaultPadding / 2),
            const Divider(),
            const SizedBox(height: defaultPadding / 2),
            Text(appointment.reason!),
          ],
        ),
      );
    }

    Widget _buildDoctorNote(Appointment appointment) {
      return CardContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Doctor's Note",
                  style: Theme.of(context).textTheme.headline6,
                ),
                ButtonDefault(
                  svgScr: 'assets/icons/pencil.svg',
                  title: 'Update',
                  horizontalPadding: defaultPadding * .6,
                  fontSize: 16,
                  verticalPadding: defaultPadding * .6,
                  bgColor: kPrimaryColor,
                  fontColor: Colors.white,
                  press: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DoctorNoteScreen(
                          appointment: appointment,
                        ),
                      ),
                    );
                    setState(() {});
                  },
                ),
              ],
            ),
            const SizedBox(height: defaultPadding / 2),
            const Divider(),
            const SizedBox(height: defaultPadding / 2),
            const SubtitleDefault(title: 'Vital Signs'),
            Text(appointment.appointmentDetail?.vitalSigns ?? ''),
            const SizedBox(height: defaultPadding),
            const SubtitleDefault(title: 'Chief Complaint'),
            Text(appointment.appointmentDetail?.chiefComplaint ?? ''),
            const SizedBox(height: defaultPadding),
            const SubtitleDefault(title: 'Subjective'),
            Text(appointment.appointmentDetail?.subjective ?? ''),
            const SizedBox(height: defaultPadding),
            const SubtitleDefault(title: 'Objective'),
            Text(appointment.appointmentDetail?.objective ?? ''),
            const SizedBox(height: defaultPadding),
            const SubtitleDefault(title: 'Assessment'),
            Text(appointment.appointmentDetail?.assessment ?? ''),
            const SizedBox(height: defaultPadding),
            const SubtitleDefault(title: 'Plan'),
            Text(appointment.appointmentDetail?.plan ?? ''),
          ],
        ),
      );
    }

    Widget _buildDocuments(Appointment appointment) {
      return CardContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Documents',
                  style: Theme.of(context).textTheme.headline6,
                ),
                if (flavor == Flavor.Patient || user.userType == UserType.Nurse)
                  ButtonDefault(
                    svgScr: 'assets/icons/document2.svg',
                    title: 'Upload',
                    horizontalPadding: defaultPadding * .6,
                    fontSize: 16,
                    verticalPadding: defaultPadding * .6,
                    bgColor: kPrimaryColor,
                    fontColor: Colors.white,
                    press: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DocumentFormScreen(
                            appointmentId: widget.appointmentId,
                          ),
                        ),
                      );
                      setState(() {});
                    },
                  ),
              ],
            ),
            const SizedBox(height: defaultPadding / 2),
            const Divider(),
            const SizedBox(height: defaultPadding / 2),
            if (appointment.appointmentDocuments != null)
              Column(
                children: List.generate(
                  appointment.appointmentDocuments!.length,
                  (index) {
                    var document = appointment.appointmentDocuments![index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Container(
                        decoration: BoxDecoration(
                          color: kPrimaryColor.withOpacity(0.8),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(defaultBorderRadius / 2),
                          ),
                        ),
                        child: ListTile(
                          // tileColor: Colors.redAccent,
                          // horizontalTitleGap: 4,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding, vertical: 0),
                          title: Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                document.other ?? 'Document Name',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          // onTap: () {
                          //   launchUrl(Uri.parse(document.imageLink));
                          // },
                          onTap: () {
                            openGallery(
                                appointment.appointmentDocuments!
                                    .map((e) => e.imageLink)
                                    .toList(),
                                index);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            // const SubtitleDefault(title: 'Vital Signs'),
            // Text(appointment.appointmentDetail?.vitalSigns ?? ''),
          ],
        ),
      );
    }

    return FutureBuilder(
      future: AppointmentApi.getAppointmentById(widget.appointmentId),
      builder: (BuildContext context, AsyncSnapshot<Appointment> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var data = snapshot.data!;
          bool isNurse = data.nurseAppointmentDetail != null;
          return Scaffold(
            backgroundColor: kPrimaryColor,
            appBar: AppBarDefault(
              title: 'Appointment',
            ),
            body: SingleChildScrollView(
              child: BlocProvider(
                create: (context) =>
                    RoomCubit(backendService: TwilioFunctionsService.instance),
                child: BlocConsumer<RoomCubit, RoomState>(
                  listener: (context, state) async {
                    if (state is RoomLoaded) {
                      await Navigator.of(context).push(
                        MaterialPageRoute<ConferencePage>(
                          fullscreenDialog: true,
                          builder: (BuildContext context) =>
                              // ConferencePage(roomModel: bloc),
                              BlocProvider(
                            create: (BuildContext context) => ConferenceCubit(
                              identity: state.identity,
                              token: state.token,
                              name: state.name,
                            ),
                            child: const ConferencePage(),
                          ),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    var isLoading = false;
                    RoomCubit bloc = context.read<RoomCubit>();
                    context.read<RoomCubit>().name = user.name;
                    context.read<RoomCubit>().room = data.id.toString();
                    if (state is RoomLoading) {
                      isLoading = true;
                    }
                    return CardContainer(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: defaultPadding,
                        horizontal: Responsive.isDesktop(context)
                            ? size.width * 0.30
                            : defaultPadding,
                      ),
                      color: kPrimaryColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(data, isNurse, bloc, user),
                          if (flavor != Flavor.Patient) ...[
                            _buildPatientInfo(data),
                            const SizedBox(height: defaultPadding),
                          ],
                          _buildDetails(data, isNurse),
                          const SizedBox(height: defaultPadding),
                          _buildReason(data),
                          if (flavor == Flavor.Practitioner &&
                              user.userType == UserType.Doctor &&
                              [
                                AppointmentStatus.Approved,
                                AppointmentStatus.Ongoing,
                                AppointmentStatus.Completed
                              ].contains(data.appointmentStatus)) ...[
                            const SizedBox(height: defaultPadding),
                            _buildDoctorNote(data),
                          ],
                          const SizedBox(height: defaultPadding),
                          _buildDocuments(data),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            bottomNavigationBar: CardContainer(
              padding: flavor == Flavor.Patient &&
                      data.appointmentStatus == AppointmentStatus.Approved
                  ? EdgeInsets.zero
                  : EdgeInsets.symmetric(
                      vertical: defaultPadding,
                      horizontal: Responsive.isDesktop(context)
                          ? size.width * 0.30
                          : defaultPadding,
                    ),
              width: size.width,
              borderRadius: null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (data.appointmentStatus == AppointmentStatus.Completed &&
                      !isNurse) ...[
                    ButtonDefault(
                      title: 'Medical Certificate',
                      fontSize: 18,
                      verticalPadding: defaultPadding / 1.2,
                      bgColor: kPrimaryColor,
                      fontColor: Colors.white,
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MedcertRemarkScreen(
                              appointment: data,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: defaultPadding),
                    Expanded(
                      child: ButtonDefault(
                        title: 'Prescription',
                        fontSize: 18,
                        verticalPadding: defaultPadding / 1.2,
                        bgColor: kPrimaryColor,
                        fontColor: Colors.white,
                        press: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PrescriptionsScreen(
                                appointmentId: widget.appointmentId,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  if (flavor == Flavor.Patient &&
                      data.appointmentStatus == AppointmentStatus.Pending)
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: defaultPadding * .5),
                      child: Text(
                        'Waiting for Approval',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  if (flavor == Flavor.Practitioner &&
                      [
                        AppointmentStatus.Pending,
                        AppointmentStatus.ReschedByPatient
                      ].contains(data.appointmentStatus)) ...[
                    Expanded(
                      child: ButtonDefault(
                        title: 'Re-schedule',
                        fontSize: 18,
                        verticalPadding: defaultPadding / 1.2,
                        bgColor: Colors.orangeAccent,
                        fontColor: Colors.white,
                        press: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RescheduleScreen(
                                appointment: data,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: defaultPadding),
                    Expanded(
                      child: ButtonDefault(
                        title: 'Approve',
                        fontSize: 18,
                        verticalPadding: defaultPadding / 1.2,
                        bgColor: kPrimaryColor,
                        fontColor: Colors.white,
                        press: () async {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                'Approve',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              content: const Text(
                                  'Are you sure you want to approve this appointment?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('No'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.of(context).pop();

                                    EasyLoading.show(status: 'loading...');
                                    var result =
                                        await AppointmentApi.approveAppointment(
                                            widget.appointmentId);
                                    if (result.statusCode == 200) {
                                      List<String> users = [
                                        data.practitionerPhoneNumber!,
                                        data.patientPhoneNumber!
                                      ];
                                      Map<String, dynamic> chatRoomMap = {
                                        "users": users,
                                        "chatRoom":
                                            widget.appointmentId.toString()
                                      };
                                      databaseFirebase.createChatRoom(
                                          widget.appointmentId.toString(),
                                          chatRoomMap);
                                    }
                                    EasyLoading.showSuccess(
                                        'Appointment approved');
                                    setState(() {});
                                  },
                                  child: const Text('Yes'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  if (flavor == Flavor.Patient &&
                      [
                        AppointmentStatus.ReschedByPatient,
                        AppointmentStatus.ReschedByPractitioner
                      ].contains(data.appointmentStatus)) ...[
                    Expanded(
                      child: ButtonDefault(
                        title: 'Re-schedule',
                        fontSize: 18,
                        verticalPadding: defaultPadding / 1.2,
                        bgColor: Colors.orangeAccent,
                        fontColor: Colors.white,
                        press: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RescheduleScreen(
                                appointment: data,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: defaultPadding),
                    Expanded(
                      child: ButtonDefault(
                        title: 'Approve',
                        fontSize: 18,
                        verticalPadding: defaultPadding / 1.2,
                        bgColor: kPrimaryColor,
                        fontColor: Colors.white,
                        press: () {
                          approve(data);
                        },
                      ),
                    ),
                  ],
                  if (flavor == Flavor.Practitioner &&
                      data.appointmentStatus == AppointmentStatus.Approved) ...[
                    Expanded(
                      child: ButtonDefault(
                        title: 'Not Attended',
                        fontSize: 18,
                        verticalPadding: defaultPadding / 1.2,
                        bgColor: Colors.orangeAccent,
                        fontColor: Colors.white,
                        press: () {},
                      ),
                    ),
                    const SizedBox(width: defaultPadding),
                    Expanded(
                      child: ButtonDefault(
                        title: 'Completed',
                        fontSize: 18,
                        verticalPadding: defaultPadding / 1.2,
                        bgColor: kPrimaryColor,
                        fontColor: Colors.white,
                        press: () {
                          completed(data);
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: kPrimaryColor,
            appBar: AppBarDefault(
              title: 'Appointment',
            ),
            body: const Center(
              child: SizedBox(
                height: 100,
                width: 100,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }

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
