import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/util/legacy_to_async_migration_util.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: SharedPreferencesDemo(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Scratch extends StatefulWidget {
  const Scratch({super.key});

  @override
  State<Scratch> createState() => ScratchState();
}

class ScratchState extends State<Scratch> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('drawer'),
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
          actions: [
            Icon(Icons.safety_check),
            Icon(Icons.safety_divider),
            Icon(Icons.fax_rounded),
          ],
        ),
        drawer: Drawer(
          shape: StarBorder(side: BorderSide(color: Colors.black87)),
          width: 300,
          child: ElevatedButton(child: Text('button1'), onPressed: () {}),
        ),
        body: FloatingActionButton(onPressed: () {}, child: Text('page1')),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Text('page2'),
          shape: CircleBorder(side: BorderSide()),
        ),
      ),
    );
  }
}

class scratchtwo extends StatefulWidget {
  const scratchtwo({super.key});

  @override
  State<scratchtwo> createState() => scratchtwoState();
  // TODO: implement createState
}

class scratchtwoState extends State<scratchtwo> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('Title')),
      body: Column(
        children: [
          SingleChildScrollView(),
          Image.network(''),
          SizedBox(height: 10),
          Image.network(''),
          SizedBox(height: 10),
          Image.network(''),
          SizedBox(height: 10),
          Image.network(''),
          SizedBox(height: 10),
          Image.network(''),
          SizedBox(height: 10),
          Icon(Icons.eighteen_up_rating),
          SizedBox(height: 10),
          Icon(Icons.eighteen_up_rating),
          SizedBox(height: 10),
          Icon(Icons.eighteen_up_rating),
          SizedBox(height: 10),
          Icon(Icons.eighteen_up_rating),
          SizedBox(height: 10),
          Icon(Icons.eighteen_up_rating),
          SizedBox(height: 10),
          Text('body'),
          Row(
            children: [
              Icon(Icons.fax_rounded),
              SizedBox(height: 10),
              Icon(Icons.fax_rounded),
              SizedBox(height: 10),
              Icon(Icons.fax_rounded),
              SizedBox(height: 10),
              Icon(Icons.fax_rounded),
              SizedBox(height: 10),
              Icon(Icons.fax_rounded),
              SizedBox(height: 10),
            ],
          ),
        ],
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QuickAlert Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final successAlert = buildButton(
      onTap: () {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Transaction Completed Successfully!',
          autoCloseDuration: const Duration(seconds: 2),
          showConfirmBtn: false,
        );
      },
      title: 'Success',
      text: 'Transaction Completed Successfully!',
      leadingImage: 'assets/success.gif',
    );

    final errorAlert = buildButton(
      onTap: () {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Oops...',
          text: 'Sorry, something went wrong',
          backgroundColor: Colors.black,
          titleColor: Colors.white,
          textColor: Colors.white,
        );
      },
      title: 'Error',
      text: 'Sorry, something went wrong',
      leadingImage: 'assets/error.gif',
    );

    final warningAlert = buildButton(
      onTap: () {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          text: 'You just broke protocol',
        );
      },
      title: 'Warning',
      text: 'You just broke protocol',
      leadingImage: 'assets/warning.gif',
    );

    final infoAlert = buildButton(
      onTap: () {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.info,
          text: 'Buy two, get one free',
        );
      },
      title: 'Info',
      text: 'Buy two, get one free',
      leadingImage: 'assets/info.gif',
    );

    final confirmAlert = buildButton(
      onTap: () {
        QuickAlert.show(
          onCancelBtnTap: () {
            Navigator.pop(context);
          },
          context: context,
          type: QuickAlertType.confirm,
          text: 'Do you want to logout',
          titleAlignment: TextAlign.right,
          textAlignment: TextAlign.right,
          confirmBtnText: 'Yes',
          cancelBtnText: 'No',
          confirmBtnColor: Colors.white,
          backgroundColor: Colors.black,
          headerBackgroundColor: Colors.grey,
          confirmBtnTextStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          barrierColor: Colors.white,
          titleColor: Colors.white,
          textColor: Colors.white,
        );
      },
      title: 'Confirm',
      text: 'Do you want to logout',
      leadingImage: 'assets/confirm.gif',
    );

    final loadingAlert = buildButton(
      onTap: () {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.loading,
          title: 'Loading',
          text: 'Fetching your data',
        );
      },
      title: 'Loading',
      text: 'Fetching your data',
      leadingImage: 'assets/loading.gif',
    );

    final customAlert = buildButton(
      onTap: () {
        var message = '';
        QuickAlert.show(
          context: context,
          type: QuickAlertType.custom,
          barrierDismissible: true,
          confirmBtnText: 'Save',
          customAsset: 'assets/custom.gif',
          widget: TextFormField(
            decoration: const InputDecoration(
              alignLabelWithHint: true,
              hintText: 'Enter Phone Number',
              prefixIcon: Icon(Icons.phone_outlined),
            ),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.phone,
            onChanged: (value) => message = value,
          ),
          onConfirmBtnTap: () async {
            if (message.length < 5) {
              await QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                text: 'Please input something',
              );
              return;
            }
            Navigator.pop(context);
            if (mounted) {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.success,
                text: "Phone number '$message' has been saved!.",
              );
            }
          },
        );
      },
      title: 'Custom',
      text: 'Custom Widget Alert',
      leadingImage: 'assets/custom.gif',
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "QuickAlert Demo",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          successAlert,
          const SizedBox(height: 20),
          errorAlert,
          const SizedBox(height: 20),
          warningAlert,
          const SizedBox(height: 20),
          infoAlert,
          const SizedBox(height: 20),
          confirmAlert,
          const SizedBox(height: 20),
          loadingAlert,
          const SizedBox(height: 20),
          customAlert,
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Card buildButton({
    required onTap,
    required title,
    required text,
    required leadingImage,
  }) {
    return Card(
      shape: const StadiumBorder(),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(backgroundImage: AssetImage(leadingImage)),
        title: Text(title ?? ""),
        subtitle: Text(text ?? ""),
        trailing: const Icon(Icons.keyboard_arrow_right_rounded),
      ),
    );
  }
}

class CheckBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RoundCheckBox(onTap: (selected) {}),
            const SizedBox(height: 12),
            RoundCheckBox(
              onTap: (selected) {},
              size: 60,
              uncheckedColor: Colors.yellow,
            ),
            const SizedBox(height: 12),
            RoundCheckBox(
              onTap: (selected) {},
              border: Border.all(width: 4, color: Colors.red),
              uncheckedColor: Colors.red,
              uncheckedWidget: Icon(Icons.close, color: Colors.white),
            ),
            const SizedBox(height: 12),
            RoundCheckBox(
              onTap: (selected) {},
              uncheckedWidget: Icon(Icons.close),
            ),
            const SizedBox(height: 12),
            RoundCheckBox(
              onTap: (selected) {},
              uncheckedWidget: Icon(Icons.close),
              animationDuration: Duration(milliseconds: 50),
            ),
            const SizedBox(height: 12),
            RoundCheckBox(
              onTap: (selected) {},
              checkedWidget: Icon(Icons.mood, color: Colors.white),
              uncheckedWidget: Icon(Icons.mood_bad),
              animationDuration: Duration(seconds: 1),
            ),
            const SizedBox(height: 12),
            RoundCheckBox(
              onTap: (selected) {},
              uncheckedWidget: Icon(Icons.close),
              isChecked: true,
            ),
            const SizedBox(height: 12),
            RoundCheckBox(
              onTap: (selected) => print(selected),
              uncheckedWidget: Icon(Icons.close),
              isChecked: true,
              size: 120,
            ),
            const SizedBox(height: 12),
            RoundCheckBox(
              onTap: null,
              uncheckedWidget: Icon(Icons.close),
              isChecked: true,
              size: 120,
            ),
            const SizedBox(height: 12),
            RoundCheckBox(
              onTap: null,
              uncheckedWidget: Icon(Icons.close),
              disabledColor: Colors.grey[300],
              isChecked: true,
              size: 48,
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class SharedPreferencesDemo extends StatefulWidget {
  const SharedPreferencesDemo({super.key});

  @override
  SharedPreferencesDemoState createState() => SharedPreferencesDemoState();
}

class SharedPreferencesDemoState extends State<SharedPreferencesDemo> {
  final Future<SharedPreferencesWithCache> _prefs =
      SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(
          // This cache will only accept the key 'counter'.
          allowList: <String>{'counter'},
        ),
      );
  late Future<int> _counter;
  int _externalCounter = 0;

  /// Completes when the preferences have been initialized, which happens after
  /// legacy preferences have been migrated.
  final Completer<void> _preferencesReady = Completer<void>();

  Future<void> _incrementCounter() async {
    final SharedPreferencesWithCache prefs = await _prefs;
    final int counter = (prefs.getInt('counter') ?? 0) + 1;

    setState(() {
      _counter = prefs.setInt('counter', counter).then((_) {
        return counter;
      });
    });
  }

  /// Gets external button presses that could occur in another instance, thread,
  /// or via some native system.
  Future<void> _getExternalCounter() async {
    final prefs = SharedPreferencesAsync();
    final int externalCounter = (await prefs.getInt('externalCounter')) ?? 0;
    setState(() {
      _externalCounter = externalCounter;
    });
  }

  Future<void> _migratePreferences() async {
    // #docregion migrate
    const sharedPreferencesOptions = SharedPreferencesOptions();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await migrateLegacySharedPreferencesToSharedPreferencesAsyncIfNecessary(
      legacySharedPreferencesInstance: prefs,
      sharedPreferencesAsyncOptions: sharedPreferencesOptions,
      migrationCompletedKey: 'migrationCompleted',
    );
    // #enddocregion migrate
  }

  @override
  void initState() {
    super.initState();
    _migratePreferences().then((_) {
      _counter = _prefs.then((SharedPreferencesWithCache prefs) {
        return prefs.getInt('counter') ?? 0;
      });
      _getExternalCounter();
      _preferencesReady.complete();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SharedPreferencesWithCache Demo')),
      body: Center(
        child: _WaitForInitialization(
          initialized: _preferencesReady.future,
          builder: (BuildContext context) => FutureBuilder<int>(
            future: _counter,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return const CircularProgressIndicator();
                case ConnectionState.active:
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Text(
                      'Button tapped ${snapshot.data ?? 0 + _externalCounter} time${(snapshot.data ?? 0 + _externalCounter) == 1 ? '' : 's'}.\n\n'
                      'This should persist across restarts.',
                    );
                  }
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// Waits for the [initialized] future to complete before rendering [builder].
class _WaitForInitialization extends StatelessWidget {
  const _WaitForInitialization({
    required this.initialized,
    required this.builder,
  });

  final Future<void> initialized;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: initialized,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.connectionState == ConnectionState.none) {
          return const CircularProgressIndicator();
        }
        return builder(context);
      },
    );
  }
}
