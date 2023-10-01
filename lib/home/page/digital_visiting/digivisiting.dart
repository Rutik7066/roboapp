
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roboapp/home/page/digital_visiting/create.dart';
import 'package:roboapp/home/page/digital_visiting/update.dart';
import 'package:roboapp/provider.dart';



class DigiVisiting extends StatefulWidget {
  const DigiVisiting({super.key});

  @override
  State<DigiVisiting> createState() => _DigiVisitingState();
}

class _DigiVisitingState extends State<DigiVisiting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(builder: (context, ref, child) {
        AsyncValue<RecordModel?> data = ref.watch(userData);
        return data.when(
          loading: () => const CircularProgressIndicator(),
          error: (err, stack) => Text('Error: $err'),
          data: (record) {
            if (record == null) {
              return const CreateCard();
            } else {
              return UpdateCard(
                record: record,
              );
            }
          },
        );
      }),
    );
  }
}
