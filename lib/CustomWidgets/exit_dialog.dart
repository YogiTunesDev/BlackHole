import 'package:blackhole/CustomWidgets/gradient_containers.dart';
import 'package:flutter/material.dart';

class EditPlaylistExitDialog extends StatelessWidget {
  final String title;
  final String subTitle;
  final String mainButtonText;
  final String secondaryButtonText;

  final VoidCallback mainButtonCallback;
  final VoidCallback secondaryButtonCallback;

  const EditPlaylistExitDialog({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.mainButtonText,
    required this.secondaryButtonText,
    required this.mainButtonCallback,
    required this.secondaryButtonCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.width / 1.6,
          width: MediaQuery.of(context).size.width / 1.4,
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            clipBehavior: Clip.antiAlias,
            child: GradientContainer(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          subTitle,
                          style: const TextStyle(
                            fontSize: 14.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.8,
                            child: TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Colors.green,
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    //side: BorderSide(color: Colors.red),
                                  ),
                                ),
                              ),
                              onPressed: mainButtonCallback,
                              child: Text(
                                mainButtonText,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              secondaryButtonText,
                              style: const TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
