import 'package:nars/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchForm extends StatelessWidget {
  const SearchForm({
    Key? key,
    this.focusNode,
  }) : super(key: key);

  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: TextFormField(
        focusNode: focusNode,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: defaultPadding,
            vertical: defaultPadding * 1.3,
          ),
          hintText: 'Type your location',
          filled: true,
          fillColor: Colors.white,
          border: outlineInputBorder,
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          // prefixIcon: SizedBox(
          //   width: 48,
          //   height: 48,
          //   child: Padding(
          //     padding: const EdgeInsets.all(12),
          //     child: SvgPicture.asset("assets/icons/search.svg"),
          //   ),
          // ),
          suffixIcon: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding / 2,
            ),
            child: SizedBox(
              height: 48,
              width: 48,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: kPrimaryColor,
                  padding: const EdgeInsets.all(defaultPadding * 0.8),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(defaultBorderRadius),
                    ),
                  ),
                ),
                child: SvgPicture.asset(
                  "assets/icons/search2.svg",
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const OutlineInputBorder outlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadius)),
  borderSide: BorderSide.none,
);
