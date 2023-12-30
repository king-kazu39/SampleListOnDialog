import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final numberListProvider = Provider(
  (ref) => List.generate(100, (index) => index),
);

// 最終的に決定した時の選択値になる
final targetProvider = StateProvider<int>((ref) => 0);
// 一時的に選択値を保持する
final temporaryTargetProvider = StateProvider<int>((ref) => 0);

void showMyDialog(BuildContext context) {
  final anchorKey = GlobalKey();
  // ダイアログが開いたときに、アンカーアイテムを表示する
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Scrollable.ensureVisible(anchorKey.currentContext!);
  });
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Consumer(
        builder: (context, ref, _) {
          return AlertDialog(
            content: SizedBox(
              height: 550,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: _myRadioList(ref, anchorKey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // キャンセルしたらダイアログを開いた時の選択値に戻す
                            ref.read(temporaryTargetProvider.notifier).state =
                                ref.read(targetProvider);
                            Navigator.pop(context);
                          },
                          child: const Text('キャンセル'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            final tempTarget =
                                ref.read(temporaryTargetProvider);
                            // 一時的な選択値を最終の選択値にする
                            ref.read(targetProvider.notifier).state =
                                tempTarget;
                            Navigator.pop(context);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

List<Widget> _myRadioList(
  WidgetRef ref,
  GlobalKey anchorKey,
) {
  final numbers = ref.read(numberListProvider);
  final target = ref.watch(temporaryTargetProvider);

  final List<Widget> numberRadioList = [];
  for (final number in numbers) {
    final title =
        number == target ? '$number <<< This is TargetIndex' : '$number';
    numberRadioList.add(
      RadioListTile<int>(
        key: number == target ? anchorKey : null,
        title: Text(title),
        value: number,
        groupValue: target,
        onChanged: (int? value) {
          if (value != null) {
            ref.read(temporaryTargetProvider.notifier).state = value;
          }
        },
      ),
    );
  }
  return numberRadioList;
}
