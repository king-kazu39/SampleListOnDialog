import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final targetProvider = StateProvider<int>((ref) => 0);

void showMyDialog(BuildContext context) {
  final anchorKey = GlobalKey();
  // ダイアログが開いたときに、アンカーアイテムを表示する
  SchedulerBinding.instance.addPostFrameCallback((_) {
    Scrollable.ensureVisible(anchorKey.currentContext!);
  });
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Consumer(builder: (context, ref, _) {
          return SizedBox(
            height: 400,
            child: SingleChildScrollView(
              child: Column(
                children: _myRadioList(ref, anchorKey),
              ),
            ),
          );
        }),
      );
    },
  );
}

List<Widget> _myRadioList(
  WidgetRef ref,
  GlobalKey anchorKey,
) {
  return List.generate(100, (index) {
    final target = ref.watch(targetProvider);
    final title = index == target ? '$index <<< This is TargetIndex' : '$index';
    return RadioListTile<int>(
      key: index == target ? anchorKey : null,
      title: Text(title),
      value: index,
      groupValue: target,
      onChanged: (int? value) {
        if (value != null) {
          ref.read(targetProvider.notifier).state = value;
        }
      },
    );
  });
}
