// 🎯 Dart imports:
import 'dart:collection';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:logger/logger.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

// 🌎 Project imports:
import 'package:authenticator/core/router/app.router.dart';
import 'package:authenticator/core/utils/shape.util.dart';
import 'package:authenticator/features/settings/logger/ansi.parser.dart';
import 'package:authenticator/widgets/app_bar_title.dart';
import 'package:authenticator/widgets/app_pop_button.dart';

ListQueue<OutputEvent> _outputEventBuffer = ListQueue();

class LogConsolePage extends StatefulWidget {
  const LogConsolePage({super.key});

  @override
  State<LogConsolePage> createState() => _LogConsolePageState();

  static void add(OutputEvent outputEvent, {int? bufferSize = 20}) {
    while (_outputEventBuffer.length >= (bufferSize ?? 1)) {
      _outputEventBuffer.removeFirst();
    }
    _outputEventBuffer.add(outputEvent);
  }
}

class RenderedEvent {
  final int id;
  final Level level;
  final TextSpan span;
  final String lowerCaseText;

  RenderedEvent(this.id, this.level, this.span, this.lowerCaseText);
}

class _LogConsolePageState extends State<LogConsolePage> {
  final ListQueue<RenderedEvent> _renderedBuffer = ListQueue();
  List<RenderedEvent> _filteredBuffer = [];

  final _scrollController = ScrollController();
  final _filterController = TextEditingController();

  ValueNotifier<Level> filterLevel = ValueNotifier(Level.trace);
  ValueNotifier<double> logFontSize = ValueNotifier(14);

  var _currentId = 0;
  ValueNotifier<bool> scrollListenerEnabled = ValueNotifier(true);
  ValueNotifier<bool> followBottom = ValueNotifier(true);

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (!scrollListenerEnabled.value) return;
      var scrolledToBottom = _scrollController.offset >=
          _scrollController.position.maxScrollExtent;
      followBottom.value = scrolledToBottom;
    });

    _filterController.addListener(() => _refreshFilter());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _renderedBuffer.clear();
    for (var event in _outputEventBuffer) {
      _renderedBuffer.add(_renderEvent(event));
    }
    _refreshFilter();
  }

  void _refreshFilter() {
    var newFilteredBuffer = _renderedBuffer.where((it) {
      var logLevelMatches = it.level.index >= filterLevel.value.index;
      if (!logLevelMatches) {
        return false;
      } else if (_filterController.text.isNotEmpty) {
        var filterText = _filterController.text.toLowerCase();
        return it.lowerCaseText.contains(filterText);
      } else {
        return true;
      }
    }).toList();
    setState(() {
      _filteredBuffer = newFilteredBuffer;
    });

    if (followBottom.value) {
      Future.delayed(Duration.zero, _scrollToBottom);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        leading: AppPopButton.wrapper(context),
        title: const AppBarTitle(fallbackRouter: AppRouter.logger),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: "Increase Font Size",
            onPressed: () => logFontSize.value++,
          ),
          IconButton(
            icon: const Icon(Icons.remove),
            tooltip: "Decrease Font Size",
            onPressed: () => logFontSize.value--,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: 1600,
            child: ListView.builder(
              shrinkWrap: true,
              controller: _scrollController,
              itemCount: _filteredBuffer.length,
              itemBuilder: (context, index) {
                var logEntry = _filteredBuffer[index];
                return ValueListenableBuilder(
                  valueListenable: logFontSize,
                  builder: (context, fontSize, _) {
                    return SelectableText.rich(
                      logEntry.span,
                      key: Key(logEntry.id.toString()),
                      style: TextStyle(fontSize: fontSize),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _filterController,
                decoration: const InputDecoration(
                  labelText: "Filter log output",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 20),
            ValueListenableBuilder(
              valueListenable: filterLevel,
              builder: (context, level, _) {
                return DropdownButton<Level>(
                  value: level,
                  borderRadius: Shape.small,
                  padding: const EdgeInsets.all(8.0),
                  items: const [
                    DropdownMenuItem(
                      value: Level.trace,
                      child: Text("Trace"),
                    ),
                    DropdownMenuItem(
                      value: Level.debug,
                      child: Text("Debug"),
                    ),
                    DropdownMenuItem(
                      value: Level.info,
                      child: Text("Info"),
                    ),
                    DropdownMenuItem(
                      value: Level.warning,
                      child: Text("Warning"),
                    ),
                    DropdownMenuItem(
                      value: Level.error,
                      child: Text("Error"),
                    ),
                    DropdownMenuItem(
                      value: Level.fatal,
                      child: Text("Fatal"),
                    )
                  ],
                  onChanged: (value) {
                    if (value == null) return;
                    filterLevel.value = value;
                    _refreshFilter();
                  },
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: AnimatedOpacity(
        opacity: followBottom.value ? 0 : 1,
        duration: const Duration(milliseconds: 150),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 60),
          child: FloatingActionButton(
            mini: true,
            clipBehavior: Clip.antiAlias,
            onPressed: _scrollToBottom,
            child: Icon(
              Icons.arrow_downward,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.lightBlue[900],
            ),
          ),
        ),
      ),
    );
  }

  void _scrollToBottom() async {
    scrollListenerEnabled.value = false;

    followBottom.value = true;

    var scrollPosition = _scrollController.position;
    await _scrollController.animateTo(
      scrollPosition.maxScrollExtent,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );

    scrollListenerEnabled.value = true;
  }

  RenderedEvent _renderEvent(OutputEvent event) {
    var parser = AnsiParser(Theme.of(context).brightness == Brightness.dark);
    var text = event.lines.join('\n');
    parser.parse(text);
    return RenderedEvent(
      _currentId++,
      event.level,
      TextSpan(children: parser.spans),
      text.toLowerCase(),
    );
  }
}

class LogBar extends StatelessWidget {
  final bool dark;
  final Widget child;

  const LogBar({
    required this.dark,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            if (!dark)
              BoxShadow(
                color: Colors.grey[400]!,
                blurRadius: 3,
              ),
          ],
        ),
        child: Material(
          color: dark ? Colors.blueGrey[900] : Colors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
            child: child,
          ),
        ),
      ),
    );
  }
}
