import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample_list_on_dialog/showdialog_with_riverpod.dart' as dialog;

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int target = 0;
  int tmpTarget = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => showMyDialog(context),
              child: const Text('Show My Dialog'),
            ),
            ElevatedButton(
              onPressed: () => dialog.showMyDialog(context),
              child: const Text('Show My Dialog with Riverpod'),
            ),
          ],
        ),
      ),
    );
  }

  void showMyDialog(BuildContext context) {
    final anchorKey = GlobalKey();
    // ダイアログが開いたときに、アンカーアイテムを表示する
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Scrollable.ensureVisible(anchorKey.currentContext!);
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: StatefulBuilder(builder: (context, setState) {
            return SizedBox(
              height: 550,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: _myRadioList(
                          tmpTarget,
                          anchorKey,
                          setState,
                        ),
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
                            tmpTarget = 0;
                            Navigator.pop(context);
                          },
                          child: const Text('キャンセル'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            target = tmpTarget;
                            Navigator.pop(context);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  /// 100個まで要素があるラジオボタンのリスト(0~99)
  List<Widget> _myRadioList(
    int currentValue,
    GlobalKey anchorKey,
    StateSetter setState,
  ) {
    return List.generate(100, (index) {
      /// 選択されたラジオボタン付リストアイテムは目印をつける
      final title =
          index == currentValue ? '$index <<< This is TargetIndex' : '$index';
      return RadioListTile<int>(
        key: index == currentValue ? anchorKey : null,
        title: Text(title),
        value: index,
        groupValue: currentValue,
        onChanged: (int? value) {
          if (value != null) {
            setState(() {
              tmpTarget = value;
            });
          }
        },
      );
    });
  }
}
