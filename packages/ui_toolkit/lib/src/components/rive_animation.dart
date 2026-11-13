import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rive/rive.dart';

class RiveAnimation extends StatefulWidget {
  final String? asset;
  final String animation;
  final bool enabled;
  final BoxFit fit;
  final double? height;
  final void Function(Artboard? artboard)? onLoaded;
  final Widget? placeholder;
  final double? width;

  const RiveAnimation({
    super.key,
    this.asset,
    required this.animation,
    this.enabled = true,
    this.fit = BoxFit.contain,
    this.height,
    this.onLoaded,
    this.placeholder,
    this.width,
  });

  @override
  State<StatefulWidget> createState() => _RiveAnimationState();
}

class _RiveAnimationState extends State<RiveAnimation> {
  Artboard? _artboard;
  SimpleAnimation? _animationController;

  @override
  void initState() {
    super.initState();

    if (widget.asset == null) {
      return;
    }

    _animationController = SimpleAnimation(widget.animation);

    // Load the animation file from the bundle, note that you could also
    // download this. The RiveFile just expects a list of bytes.
    rootBundle.load(widget.asset!).then((data) async {
      // Load the RiveFile from the binary data.
      final file = RiveFile.import(data);

      // The artboard is the root of the animation and gets drawn in the
      // Rive widget.
      final artboard = file.mainArtboard;
      // Add a controller to play back a known animation on the main/default
      // artboard.We store a reference to it so we can toggle playback.
      artboard.addController(SimpleAnimation(widget.animation));

      Future.microtask(() => mounted
          ? setState(() {
              _artboard = artboard;
              _artboard!.addController(_animationController!);
              if (widget.onLoaded != null) {
                widget.onLoaded!(_artboard);
              }
            })
          : null);
    });
  }

  @override
  void didUpdateWidget(covariant RiveAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_animationController != null) {
      _artboard?.removeController(_animationController!);
    }

    _animationController = SimpleAnimation(widget.animation);
    _artboard?.addController(_animationController!);
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        height: widget.height,
        width: widget.width,
        child: _artboard == null || !widget.enabled
            ? (widget.placeholder ?? Container())
            : Rive(
                artboard: _artboard!,
                fit: widget.fit,
              ),
      );
}
