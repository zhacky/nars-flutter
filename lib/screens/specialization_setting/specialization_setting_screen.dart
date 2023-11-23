import 'package:nars/api/auth_service.dart';
import 'package:nars/api/practitioner_api.dart';
import 'package:nars/components/app_bar_default.dart';
import 'package:nars/components/snack_bar_default.dart';
import 'package:nars/constants.dart';
import 'package:nars/enumerables/home_state.dart';
import 'package:nars/helpers/responsive.dart';
import 'package:nars/models/practitioner/add_practitioner_specializations_param.dart';
import 'package:nars/models/specialization/specialization.dart';
import 'package:nars/providers/specializations_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SpecializationSettingScreen extends StatelessWidget {
  const SpecializationSettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context).currentUser!;
    Size size = MediaQuery.of(context).size;
    List<Specialization> specializations = [];

    void save() async {
      try {
        List<int> ids = (specializations
            .where((x) => x.isSelected)
            .map((e) => e.id)).toList();
        await PractitionerApi.editPractitionerSpecializations(
          PractitionerAddSpecializationsParam(
            specialtiesIds: ids,
          ),
        );

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Done',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
            content: const Text('Saved successfully'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('Okay'),
              ),
            ],
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          snackBarDefault(),
        );
      }
    }

    return Scaffold(
      appBar: AppBarDefault(title: 'Specializations'),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: defaultPadding,
            horizontal: Responsive.isDesktop(context) ? size.width * 0.30 : 0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: defaultPadding),
              Padding(
                padding: const EdgeInsets.only(left: defaultPadding),
                child: Text(
                  'Select your specializations',
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              const SizedBox(height: defaultPadding),
              ChangeNotifierProvider(
                create: (context) => SpecializationsProvider(user.id),
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
                    specializations = model.specializations;
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: specializations.length,
                      itemBuilder: (context, index) {
                        final specialization = specializations[index];
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom:
                                  index == specializations.length - 1 ? 0 : 4),
                          child: ListTile(
                            tileColor: Colors.white,
                            horizontalTitleGap: 4,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: defaultPadding, vertical: 0),
                            title: Text(specialization.name),
                            trailing: (specialization.isSelected)
                                ? Container(
                                    width: 25,
                                    margin: const EdgeInsets.only(
                                        right: defaultPadding),
                                    child: SvgPicture.asset(
                                      'assets/icons/check.svg',
                                      color: kPrimaryColor,
                                    ),
                                  )
                                : null,
                            onTap: () {
                              model.selectSpecialization(specialization);
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              // Consumer<SpecializationsProvider>(
              //   builder: (context, specializationsProvider, child) => Column(
              //     children: [
              //       ...specializationsProvider.getSpecializations
              //           .map(
              //             (specialization) => Column(
              //               children: [
              //                 ListTile(
              //                   tileColor: Colors.white,
              //                   horizontalTitleGap: 4,
              //                   contentPadding: const EdgeInsets.symmetric(
              //                       horizontal: defaultPadding, vertical: 0),
              //                   title: Text(specialization.title),
              //                   trailing: (specialization.selected)
              //                       ? Container(
              //                           width: 25,
              //                           margin: const EdgeInsets.only(
              //                               right: defaultPadding),
              //                           child: SvgPicture.asset(
              //                             'assets/icons/check.svg',
              //                             color: kPrimaryColor,
              //                           ),
              //                         )
              //                       : null,
              //                   onTap: () {
              //                     specializationsProvider.selectSpecialization(
              //                         specialization, !specialization.selected);
              //                   },
              //                 ),
              //                 const SizedBox(
              //                   height: 4,
              //                 )
              //               ],
              //             ),
              //           )
              //           .toList(),
              //     ],
              //   ),
              // ),
              const SizedBox(height: defaultPadding),
              Material(
                color: kPrimaryColor,
                child: InkWell(
                  onTap: () {
                    save();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 60,
                    child: const Text(
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
            ],
          ),
        ),
      ),
    );
  }
}
