import 'package:nars/api/auth_service.dart';
import 'package:nars/api/practitioner_api.dart';
import 'package:nars/components/app_bar_default.dart';
import 'package:nars/components/snack_bar_default.dart';
import 'package:nars/constants.dart';
import 'package:nars/enumerables/home_state.dart';
import 'package:nars/helpers/responsive.dart';
import 'package:nars/models/practitioner/add_practitioner_service_param.dart';
import 'package:nars/models/service/service.dart';
import 'package:nars/providers/services_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context).currentUser!;
    Size size = MediaQuery.of(context).size;
    List<Service> services = [];

    void save() async {
      try {
        List<int> ids =
            (services.where((x) => x.isSelected).map((e) => e.id)).toList();
        print(ids);
        await PractitionerApi.editPractitionerServices(
          AddPractitionerServiceParam(
            serviceIds: ids,
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
      appBar: AppBarDefault(title: 'Services'),
      body: SingleChildScrollView(
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
                  'Select Services / Symptoms to cater for Patient Services when patients search for consultation',
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              const SizedBox(height: defaultPadding),
              ChangeNotifierProvider(
                create: (context) => ServicesProvider(user.id),
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
                    services = model.services;
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: services.length,
                      itemBuilder: (context, index) {
                        final service = services[index];
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: index == services.length - 1 ? 0 : 4),
                          child: ListTile(
                            tileColor: Colors.white,
                            horizontalTitleGap: 4,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: defaultPadding, vertical: 0),
                            title: Text(service.name),
                            trailing: (service.isSelected)
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
                              model.selectServices(service);
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
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
