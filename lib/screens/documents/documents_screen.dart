import 'package:nars/api/auth_service.dart';
import 'package:nars/api/document_api.dart';
import 'package:nars/components/app_bar_default.dart';
import 'package:nars/components/document_tile.dart';
import 'package:nars/constants.dart';
import 'package:nars/enumerables/flavor.dart';
import 'package:nars/enumerables/status.dart';
import 'package:nars/helpers/responsive.dart';
import 'package:nars/screens/document_form/document_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({
    Key? key,
    required this.status,
  }) : super(key: key);
  final Status status;

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final flavor = Provider.of<Flavor>(context);
    final userId = Provider.of<AuthService>(context).currentUser!.id;

    return Scaffold(
      appBar: AppBarDefault(title: 'Medical Records/Documents'),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 0,
            horizontal: Responsive.isDesktop(context) ? size.width * 0.30 : 0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (flavor != Flavor.Patient &&
                  widget.status == Status.WaitingForApproval)
                Container(
                  width: size.width,
                  padding: const EdgeInsets.all(defaultPadding),
                  color: Colors.orangeAccent.withOpacity(0.9),
                  child: const Text(
                    'You are required to provide the following documents:\n• PRC ID\n• Selfie with PRC ID',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
              // DefaultButton(
              //   svgScr: '',
              //   title: 'Test',
              //   press: () async {
              //     var result = await DocumentApi.getPractitionerDocuments(userId);
              //     print('result');
              //     print(documentToJson(result[0]));
              //   },
              // ),
              const SizedBox(height: defaultPadding * 2),
              ListTile(
                tileColor: Colors.white,
                horizontalTitleGap: 4,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding, vertical: defaultPadding / 4),
                title: const Text('Upload New Record/Document'),
                leading: SvgPicture.asset(
                  'assets/icons/plus2.svg',
                  width: 30,
                ),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DocumentFormScreen(),
                    ),
                  );
                  setState(() {});
                },
              ),
              const SizedBox(height: defaultPadding * 2),
              FutureBuilder(
                future: DocumentApi.getPractitionerDocuments(userId),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Column(
                      children: List.generate(
                        snapshot.data.length,
                        (index) => Column(
                          children: [
                            DocumentTile(
                              document: snapshot.data[index],
                              press: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DocumentFormScreen(
                                      document: snapshot.data[index],
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(
                              height: 4,
                            )
                          ],
                        ),
                      ),
                    );
                    // ListView.builder(
                    //   shrinkWrap: true,
                    //   itemCount: snapshot.data.length,
                    //   itemBuilder: (BuildContext context, int index) {
                    //     return DocumentTile(
                    //       document: snapshot.data[index],
                    //       press: () {
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //             builder: (context) => DocumentFormScreen(
                    //               document: snapshot.data[index],
                    //             ),
                    //           ),
                    //         );
                    //       },
                    //     );
                    //   },
                    // );
                  } else {
                    return const ListTile(
                      tileColor: Colors.white,
                      horizontalTitleGap: 4,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: defaultPadding,
                          vertical: defaultPadding / 2),
                      title: Text('Loading...'),
                      // onTap: press,
                    );
                  }
                },
              ),
              // Column(
              //   children: List.generate(
              //     userDocuments.length,
              //     (index) => Column(
              //       children: [
              //         UserDocumentTile(
              //           userDocument: userDocuments[index],
              //           press: () {
              //             Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                 builder: (context) => DocumentFormScreen(
              //                   userDocument: userDocuments[index],
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
