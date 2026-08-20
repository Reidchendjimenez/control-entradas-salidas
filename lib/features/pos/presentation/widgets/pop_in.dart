import 'package:flutter/material.dart';

/// Entrada animada tipo "pop": fade + escala 0.85 → 1 con rebote
/// (`Curves.easeOutBack`). Acepta un `delay` para encadenar/stagger los
/// elementos. Reemplaza a `FadeInUp` (fade + slide up).
class PopIn extends StatefulWidget {
  const PopIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 420),
  });

  final Widget child;
  final Duration delay;
  final Duration duration;

  @override
  State<PopIn> createState() => _PopInState();
}

class _PopInState extends State<PopIn> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  late final CurvedAnimation _scale = CurvedAnimation(
    parent: _ctrl,
    curve: Curves.easeOutBack,
  );

  @override
  void initState() {
    super.initState();
    if (widget.delay > Duration.zero) {
      Future.delayed(widget.delay, () {
        if (mounted) _ctrl.forward();
      });
    } else {
      _ctrl.forward();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _ctrl,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.85, end: 1).animate(_scale),
        child: widget.child,
      ),
    );
  }
}