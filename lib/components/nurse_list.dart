import 'package:nars/components/nurse_long_card.dart';
import 'package:nars/constants.dart';
import 'package:nars/models/demo/nurse_demo.dart';
import 'package:nars/screens/nurse_detail/nurse_detail_screen.dart';
import 'package:flutter/material.dart';
import 'section_title.dart';

class NurseList extends StatefulWidget {
  const NurseList({Key? key}) : super(key: key);

  @override
  State<NurseList> createState() => _NurseListState();
}

class _NurseListState extends State<NurseList> {
  final List<Nurse> _nurses = [];
  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: [
              const SizedBox(height: defaultPadding / 2),
              SectionTitle(
                title: "Nurses",
                hasSeeAll: true,
                pressSeeAll: () {},
              ),
              Column(
                children: List.generate(
                  nurses.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: defaultPadding),
                    child: NurseLongCard(
                      nurse: nurses[index],
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NurseDetailScreen(
                              nurse: nurses[index],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              )
            ],
          );
  }
}
