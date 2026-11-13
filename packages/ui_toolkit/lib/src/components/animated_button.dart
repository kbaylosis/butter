import 'package:butter/butter.dart';
import 'package:flutter/material.dart';

import 'button_icon.dart';
import 'rive_animation.dart';

class AnimatedButton extends StatefulWidget {
  final String? asset;
  final bool enabled;
  final double height;
  final String? title;
  final String? idleAnim;
  final String hoverAnim;
  final VoidCallback? onPressed;
  final String? placeholder;
  final double width;

  const AnimatedButton({
    super.key,
    this.asset,
    this.enabled = true,
    this.height = 50,
    this.idleAnim,
    required this.hoverAnim,
    this.onPressed,
    this.placeholder,
    this.title,
    this.width = 100,
  });

  @override
  State<StatefulWidget> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  late String _animation;
  static const grey = ColorFilter.matrix(<double>[
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ]);

  @override
  void initState() {
    super.initState();
    _animation = widget.idleAnim ?? widget.hoverAnim;
  }

  @override
  Widget build(BuildContext context) => ButtonIcon(
        onPressed: widget.enabled
            ? () {
                setState(() => _animation = widget.hoverAnim);
                Future.delayed(
                    const Duration(seconds: 1), () => widget.onPressed!());
              }
            : null,
        child: MouseRegion(
          child: Column(
            children: [
              RiveAnimation(
                animation: _animation,
                asset: widget.asset,
                enabled: widget.enabled,
                height: widget.height,
                placeholder: widget.placeholder == null
                    ? null
                    : ColorFiltered(
                        colorFilter: widget.enabled
                            ? const ColorFilter.mode(
                                Colors.transparent,
                                BlendMode.multiply,
                              )
                            : _AnimatedButtonState.grey,
                        child: Image.asset(widget.placeholder!),
                      ),
                width: widget.width,
              ),
              const SizedBox(height: 5),
              Text(widget.title!,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.apply(fontSizeDelta: -3)),
            ],
          ),
          onEnter: (_) => mounted
              ? setState(() {
                  Butter.d('onEnter: ${widget.asset}');
                  _animation = widget.hoverAnim;
                })
              : null,
          onExit: (_) => mounted
              ? setState(() {
                  Butter.d('onExit: ${widget.asset}');
                  _animation = widget.idleAnim ?? widget.hoverAnim;
                })
              : null,
        ),
      );
}
