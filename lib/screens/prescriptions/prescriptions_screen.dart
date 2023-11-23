import 'package:nars/api/prescription_api.dart';
import 'package:nars/components/app_bar_default.dart';
import 'package:nars/components/prescription_tile.dart';
import 'package:nars/constants.dart';
import 'package:nars/enumerables/flavor.dart';
import 'package:nars/helpers/responsive.dart';
import 'package:nars/models/prescription/prescription.dart';
import 'package:nars/screens/prescription_form/prescription_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PrescriptionsScreen extends StatefulWidget {
  const PrescriptionsScreen({
    Key? key,
    required this.appointmentId,
  }) : super(key: key);

  final int appointmentId;

  @override
  State<PrescriptionsScreen> createState() => _PrescriptionsScreenState();
}

class _PrescriptionsScreenState extends State<PrescriptionsScreen> {
  void _launchUrl(Uri _url) async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication))
      throw 'Could not launch $_url';
  }

  @override
  Widget build(BuildContext context) {
    final flavor = Provider.of<Flavor>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBarDefault(title: 'Prescriptions'),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: defaultPadding,
          horizontal: Responsive.isDesktop(context) ? size.width * 0.30 : 0,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (flavor != Flavor.Patient) ...[
                const SizedBox(height: defaultPadding * 2),
                ListTile(
                  tileColor: Colors.white,
                  horizontalTitleGap: 4,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding, vertical: defaultPadding / 4),
                  title: const Text('Add New Prescription'),
                  leading: SvgPicture.asset(
                    'assets/icons/plus2.svg',
                    width: 30,
                  ),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PrescriptionFormScreen(
                          appointmentId: widget.appointmentId,
                        ),
                      ),
                    );
                    setState(() {});
                  },
                ),
              ],
              const SizedBox(height: defaultPadding * 2),
              FutureBuilder(
                future: PrescriptionApi.getPrescriptions(widget.appointmentId),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Prescription>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    var data = snapshot.data!;
                    return Column(
                      children: List.generate(
                        data.length,
                        (index) => Column(
                          children: [
                            PrescriptionTile(
                              prescription: data[index],
                              press: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PrescriptionFormScreen(
                                      appointmentId: widget.appointmentId,
                                      prescription: data[index],
                                    ),
                                  ),
                                );
                                setState(() {});
                              },
                            ),
                            const SizedBox(
                              height: 4,
                            )
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: defaultPadding * 2),
              ListTile(
                tileColor: kPrimaryColor,
                horizontalTitleGap: 4,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding, vertical: defaultPadding / 4),
                title: const Text(
                  'Preview',
                  style: TextStyle(color: Colors.white),
                ),
                leading: SvgPicture.asset(
                  'assets/icons/print.svg',
                  color: Colors.white,
                  width: 30,
                ),
                onTap: () async {
                  var result = await PrescriptionApi.generatePrescription(
                      widget.appointmentId);
                  _launchUrl(Uri.parse(result.link));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
