import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() {
  runApp(const MyApp());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => showMyDialog(context),
          child: const Text('Show Dialog'),
        ),
      ),
    );
  }

  void showMyDialog(BuildContext context) {
    final anchorKey = GlobalKey();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: StatefulBuilder(builder: (context, setState) {
            return SizedBox(
              height: 400,
              child: SingleChildScrollView(
                child: Column(
                  children: _myRadioList(
                    target,
                    anchorKey,
                    setState,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );

    // ダイアログが開いたときに、アンカーアイテムを表示する
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Scrollable.ensureVisible(anchorKey.currentContext!);
    });
  }

  List<Widget> _myRadioList(
    int currentValue,
    GlobalKey anchorKey,
    StateSetter setState,
  ) {
    return List.generate(100, (index) {
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
              target = value;
            });
          }
        },
      );
    });
  }
}
