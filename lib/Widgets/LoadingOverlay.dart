import 'package:flutter/material.dart';

import '../Utils/AppLoading.dart';

class LoadingOverlay extends StatelessWidget {
  final Widget child;

  const LoadingOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,

        ValueListenableBuilder<bool>(
          valueListenable: AppLoading.isLoading,
          builder: (_, isLoading, __) {
            if (!isLoading) return const SizedBox();

            return Container(
              color: Colors.black.withOpacity(0.4),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ValueListenableBuilder<String>(
                    valueListenable: AppLoading.message,
                    builder: (_, msg, __) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(),
                          // const SizedBox(height: 12),
                          // Text(msg),
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}