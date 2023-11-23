import 'package:nars/components/hospital_cards.dart';
import 'package:nars/components/nurse_list.dart';
import 'package:nars/components/search_form.dart';
import 'package:nars/constants.dart';
import 'package:flutter/material.dart';

class NursesScreen extends StatefulWidget {
  const NursesScreen({Key? key}) : super(key: key);

  @override
  _NursesScreenState createState() => _NursesScreenState();
}

class _NursesScreenState extends State<NursesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Text("Find Your", style: TextStyle(fontSize: 22)),
            // Text(
            //   "Nurse",
            //   style: Theme.of(context)
            //       .textTheme
            //       .headline4!
            //       .copyWith(fontWeight: FontWeight.w500, color: Colors.black),
            // ),
            // const SizedBox(height: defaultPadding),
            // const SearchForm(),
            // const SizedBox(height: defaultPadding / 2),
            // const HospitalCards(),
            // const SizedBox(height: defaultPadding / 2),
            // const NurseList(),
          ],
        ),
      ),
    );
  }
}
