import 'package:flutter/material.dart';
import 'package:healthapp/providers/pedometer.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';

class HeightMenu extends StatelessWidget {
  const HeightMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PedometerProvider>();
    return GestureDetector(
      onTap: () {
        showPopover(
          context: context,
          height: 100,
          width: 120,
          direction: PopoverDirection.top,
          backgroundColor: Theme.of(context).colorScheme.surface,
          bodyBuilder: (context) => Column(
            children: [
              TextButton(
                onPressed: () {
                  provider.updateGender("Female");
                },
                child: Text("m"),
              ),
              TextButton(
                onPressed: () {
                  provider.updateGender("Female");
                },
                child: Text("cm"),
              ),
              TextButton(
                onPressed: () {
                  provider.updateGender("Male");
                },
                child: Text("feet"),
              ),
            ],
          ),
        );
      },
      child: Icon(
        Icons.more_vert,
        color: Theme.of(context).textTheme.bodyMedium?.color,
        size: 20,
      ),
    );
  }
}
