import 'package:nars/constants.dart';
import 'package:flutter/material.dart';

class ContainerLoadingIndicator extends StatelessWidget {
  const ContainerLoadingIndicator({
    Key? key,
    required this.isLoading,
    this.label = 'Save',
    this.loadingText = 'Loading..',
    this.labelColor = Colors.white,
  }) : super(key: key);

  final bool isLoading;
  final String label;
  final String loadingText;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 60,
      child: isLoading
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                ),
                const SizedBox(width: defaultPadding * .5),
                Text(
                  loadingText,
                  style: TextStyle(
                    fontSize: 18,
                    color: labelColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            )
          : Text(
              label,
              style: TextStyle(
                fontSize: 18,
                color: labelColor,
                fontWeight: FontWeight.w500,
              ),
            ),
    );
  }
}
