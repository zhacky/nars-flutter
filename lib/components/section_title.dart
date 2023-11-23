import 'package:nars/components/subtitle.dart';
import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    Key? key,
    required this.title,
    this.hasSeeAll = false,
    this.pressSeeAll,
  }) : super(key: key);

  final String title;
  final bool hasSeeAll;
  final VoidCallback? pressSeeAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SubtitleDefault(title: title),
        hasSeeAll
            ? TextButton(
                onPressed: pressSeeAll,
                child: const Text(
                  "See All",
                  style: TextStyle(color: Colors.black54),
                ),
              )
            : const SizedBox.shrink()
      ],
    );
  }
}
