import 'package:flutter/widgets.dart';

class FadeIndexedStack extends StatefulWidget {
  final Duration duration;
  final int index;
  final List<Widget> children;

  const FadeIndexedStack({
    super.key,
    this.duration = const Duration(milliseconds: 180),
    required this.index,
    required this.children,
  });

  @override
  State<FadeIndexedStack> createState() => _FadeIndexedStackState();
}

class _FadeIndexedStackState extends State<FadeIndexedStack> with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  int index = 0;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    index = widget.index;
    controller.value = 1.0;
  }

  @override
  void didUpdateWidget(covariant FadeIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.duration != controller.duration) {
      controller.duration = widget.duration;
    }
    if (widget.index != index) {
      controller.reverse().then((_) {
        setState(() => index = widget.index);
        controller.forward();
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: controller,
      child: IndexedStack(
        index: index,
        children: widget.children,
      ),
    );
  }
}
