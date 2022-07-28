import 'dart:async';

import 'package:flutter/material.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({Key? key}) : super(key: key);

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 3),
    vsync: this,
  )..repeat();
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  );

  @override
  void initState() {
    super.initState();
    // _controller = AnimationController(
    //   duration: const Duration(seconds: 2),
    //   vsync: this,
    // );
    // _angle = Tween<double>(begin: 0, end: 360).animate(_controller)..addListener(() {
    //   setState(() {

    //   });
    // });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    streamController.close();
    super.dispose();
  }

  StreamController<int> streamController = StreamController();
  int counter = 0;
  bool isTimerActive = false;

  String get loadingText {
    if (_animation.value == 1) return "Done";
    return "Loading %${(_animation.value * 100).toStringAsFixed(0)}";
  }

  void startTimer() {
    if (isTimerActive) return;
    isTimerActive = true;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isTimerActive) {
        timer.cancel();
        return;
      }
      increaseCounterAndAddToStream();
    });
  }

  void increaseCounterAndAddToStream() {
    counter += 1;
    streamController.sink.add(counter);
  }

  void stopTimer() {
    if (!isTimerActive) return;
    isTimerActive = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: indigoLinearGradient,
            ),
          ),
          SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 40,
                  color: Colors.white,
                  alignment: Alignment.centerLeft,
                  child: SizeTransition(
                    sizeFactor: _animation,
                    axis: Axis.horizontal,
                    axisAlignment: -1,
                    child: Container(
                      color: Colors.red,
                      // width: 20,
                    ),
                  ),
                ),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (ctx, child) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(loadingText,
                          style: Theme.of(context).textTheme.headline6),
                    );
                  },
                ),
                const SizedBox(height: 20),
                // RotationTransition(
                //   turns: _controller,
                //   child: Container(
                //     width: 200,
                //     height: 200,
                //     decoration: BoxDecoration(
                //       color: Colors.pink,
                //       borderRadius: BorderRadius.circular(8),
                //       boxShadow: const [
                //         BoxShadow(
                //           color: Colors.grey,
                //           spreadRadius: 2,
                //           blurRadius: 6,
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                const SizedBox(height: 100),
                Center(
                  child: StreamBuilder(
                      initialData: 0,
                      stream: streamController.stream,
                      builder: (context, snapshot) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Colors.indigo,
                          ),
                          child: Text(
                            "Time: ${snapshot.data}",
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                ?.copyWith(color: Colors.white),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: stopTimer,
            child: const Icon(Icons.pause),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: startTimer,
            child: const Icon(Icons.play_arrow),
          ),
        ],
      ),
    );
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              tileMode: TileMode.decal,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: const [
                Colors.indigo,
                Colors.indigoAccent,
              ],
              stops: [0, _controller.value],
            ),
          ),
        );
      },
    );
  }

  LinearGradient get indigoLinearGradient => const LinearGradient(
        tileMode: TileMode.decal,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.indigo,
          Colors.indigoAccent,
        ],
      );
}
