import 'package:nars/components/app_bar_default.dart';
import 'package:nars/enumerables/home_state.dart';
import 'package:nars/providers/specializations_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(title: 'Test'),
      body: ChangeNotifierProvider(
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
            return ListView.builder(
              itemCount: specializations.length,
              itemBuilder: (context, index) {
                final specialization = specializations[index];
                return ListTile(
                  onTap: () {
                    model.deleteSpecialization(
                        specialization, !specialization.isDeleted!);
                  },
                  title: Text(specialization.name +
                      (specialization.isDeleted! ? ' (Deleted)' : '')),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
