import 'package:flutter/material.dart';

import '../../config/style.dart';
import '../../utils/space.dart';

class ReloadDialog extends StatefulWidget {
  final String text;
  final void Function() reload;
  const ReloadDialog({required this.text, required this.reload, super.key});

  @override
  State<ReloadDialog> createState() => _ReloadDialogState();
}

class _ReloadDialogState extends State<ReloadDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: lightBlue,
        child: Container(
          // alignment: Alignment.center,
          height: 150.0,
          width: 300.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: mainWhite,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              hspace(30.0),
              Text(
                widget.text,
                style: const TextStyle(
                  color: mainBlack,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              hspace(30.0),
              GestureDetector(
                onTap: widget.reload,
                child: Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: darkBlue,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                  ),
                  height: 40.0,
                  width: 300.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.refresh,
                        size: 25.0,
                        color: mainWhite,
                      ),
                      wspace(10.0),
                      const Text(
                        "재시도",
                        style: TextStyle(
                          color: mainWhite,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // GestureDetector(
              //   onTap: widget.reload,
              //   child: Container(
              //     alignment: Alignment.center,
              //     height: 40.0,
              //     width: 100.0,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(10.0),
              //       color: darkBlue,
              //     ),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         const Icon(
              //           Icons.refresh,
              //           size: 25.0,
              //           color: mainWhite,
              //         ),
              //         wspace(10.0),
              //         const Text(
              //           "재시도",
              //           style: TextStyle(
              //             color: mainWhite,
              //             fontSize: 14.0,
              //             fontWeight: FontWeight.w500,
              //           ),
              //         ),
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
