import 'dart:async';
import 'package:flutter/material.dart';
import 'package:notifications/services/local_notificarions_services.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class PamidorScreen extends StatefulWidget {
  const PamidorScreen({super.key});

  @override
  State<PamidorScreen> createState() => _PamidorScreenState();
}

class _PamidorScreenState extends State<PamidorScreen> {
  final formKey = GlobalKey<FormState>();
  final dateTextEditingController = TextEditingController();
  Timer? countdownTimer;
  Timer? currentTimeTimer;
  Duration remainingDuration = Duration();
  DateTime currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();

    currentTimeTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        currentTime = DateTime.now();
      });
    });
  }

  void startTimer(int minutes) {
    if (countdownTimer != null) {
      countdownTimer!.cancel();
    }

    setState(() {
      remainingDuration = Duration(minutes: minutes);
    });

    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingDuration.inSeconds > 0) {
        setState(() {
          remainingDuration -= const Duration(seconds: 1);
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    currentTimeTimer?.cancel();
    dateTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int minutes = remainingDuration.inMinutes;
    int seconds = remainingDuration.inSeconds % 60;

    return Scaffold(
      backgroundColor: const Color.fromARGB(171, 7, 7, 60),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(209, 4, 4, 44),
        centerTitle: true,
        title: const Text(
          "Pamildor",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: const Color.fromARGB(255, 13, 23, 26),
                ),
                child: Center(
                  child: Text(
                    "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}",
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                width: 200,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '${currentTime.hour.toString().padLeft(2, '0')}:${currentTime.minute.toString().padLeft(2, '0')}:${currentTime.second.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              ZoomTapAnimation(
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
                                  hintText: 'Enter minute',
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value!.trim().isEmpty) {
                                    return "Please, enter minute";
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
                              if (formKey.currentState!.validate()) {
                                int inputMinutes =
                                    int.parse(dateTextEditingController.text);
                                startTimer(inputMinutes);
                                LocalNotificarionsServices
                                    .pamidorShowPeriodicNotification(
                                        dateTextEditingController.text);
                                dateTextEditingController.clear();
                                Navigator.pop(context);
                              }
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
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color.fromARGB(176, 11, 56, 93),
                  ),
                  child: const Center(
                    child: Text(
                      "Timer",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
