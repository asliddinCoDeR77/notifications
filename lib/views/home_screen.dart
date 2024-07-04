// import 'package:flutter/material.dart';
// import 'package:notification/controllers/mativation_controller.dart';
// import 'package:notification/services/local_notificarions_services.dart';
// import 'package:zoom_tap_animation/zoom_tap_animation.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final mativationController = MativationController();
//   final formKey = GlobalKey();
//   final dateTextEditingController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     mativationController.getMativation();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 14, 14, 121),
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const SizedBox(height: 70),
//             Text(
//               mativationController.list.first.a,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//                 fontSize: 20,
//               ),
//             ),
//             const SizedBox(height: 50),
//             SizedBox(
//               width: 320,
//               child: Text(
//                 mativationController.list.first.q,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                   fontSize: 20,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 100),
//             Center(
//               child: ZoomTapAnimation(
//                 onTap: () {
//                   showDialog(
//                     context: context,
//                     builder: (context) {
//                       return AlertDialog(
//                         title: const Text("Input interval"),
//                         content: Form(
//                           key: formKey,
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               TextFormField(
//                                 controller: dateTextEditingController,
//                                 decoration: const InputDecoration(
//                                   hintText: 'Enter Matevation interval minut',
//                                 ),
//                                 validator: (value) {
//                                   if (value!.trim().isEmpty) {
//                                     return "Please, enter question";
//                                   }
//                                   return null;
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                         actions: [
//                           TextButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             child: const Text(
//                               "Cancel",
//                               style: TextStyle(color: Colors.redAccent),
//                             ),
//                           ),
//                           TextButton(
//                             onPressed: () async {
//                               LocalNotificarionsServices
//                                   .showPeriodicNotification(
//                                 dateTextEditingController.text,
//                               );

//                               dateTextEditingController.clear();

//                               Navigator.pop(context);
//                             },
//                             child: const Text(
//                               "Add",
//                               style: TextStyle(color: Colors.teal),
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                 },
//                 child: Container(
//                   width: 200,
//                   height: 200,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(100),
//                     color: const Color.fromARGB(255, 142, 212, 231),
//                   ),
//                   child: const Center(
//                     child: Text(
//                       "Matevation",
//                       style: TextStyle(
//                         fontSize: 20,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:notifications/controllers/mativation_controller.dart';

import 'package:notifications/services/local_notificarions_services.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final mativationController = MativationController();
  final formKey = GlobalKey<FormState>();
  final dateTextEditingController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    mativationController.getMativation().then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 14, 14, 121),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 70),
                  Text(
                    mativationController.list.isNotEmpty
                        ? mativationController.list[0].a
                        : 'No data',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 50),
                  SizedBox(
                    width: 320,
                    child: Text(
                      mativationController.list.isNotEmpty
                          ? mativationController.list.first.q
                          : 'No data',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                  Center(
                    child: ZoomTapAnimation(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Input interval"),
                              content: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      controller: dateTextEditingController,
                                      decoration: const InputDecoration(
                                        hintText:
                                            'Enter Motivation interval minute',
                                      ),
                                      validator: (value) {
                                        if (value!.trim().isEmpty) {
                                          return "Please, enter question";
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.redAccent),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    LocalNotificarionsServices
                                        .showPeriodicNotification(
                                      dateTextEditingController.text,
                                    );

                                    dateTextEditingController.clear();

                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Add",
                                    style: TextStyle(color: Colors.teal),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: const Color.fromARGB(255, 142, 212, 231),
                        ),
                        child: const Center(
                          child: Text(
                            "Motivation",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
