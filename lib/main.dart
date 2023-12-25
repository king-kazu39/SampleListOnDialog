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
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                height: 400,
                child: SingleChildScrollView(
                  child: Column(
                    children: List<Widget>.generate(100, (index) {
                      if (index == target) {
                        return RadioListTile<int>(
                          key: anchorKey,
                          title: Text('$index <<< This is TargetIndex'),
                          value: index,
                          groupValue: target,
                          onChanged: (int? value) {
                            setState(() {
                              target = value!;
                            });
                          },
                        );
                      }
                      return RadioListTile<int>(
                        title: Text('$index'),
                        value: index,
                        groupValue: target,
                        onChanged: (int? value) {
                          setState(() {
                            target = value!;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
        );
      },
    );

    // ダイアログが開いたときに、アンカーアイテムを表示する
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Scrollable.ensureVisible(anchorKey.currentContext!);
    });
  }
}
