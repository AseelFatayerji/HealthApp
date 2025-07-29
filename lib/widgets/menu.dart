import 'package:flutter/material.dart';
import 'package:healthapp/providers/pedometer.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';

class selectionmenu extends StatelessWidget {
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
                child: Text("Female"),
              ),
              TextButton(
                onPressed: () {
                  provider.updateGender("Male");
                },
                child: Text("Male"),
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
