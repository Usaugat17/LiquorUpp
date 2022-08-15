import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:liquor_inventory/utils/config/palette.dart';
import 'package:liquor_inventory/utils/utils.dart';

@immutable
class ExpandableFab extends StatefulWidget {
  ExpandableFab({
    Key? key,
    required this.initialOpen,
    required this.distance,
    required this.children,
  }) : super(key: key);

  bool initialOpen;
  final double distance;
  final List<Widget> children;

  @override
  _ExpandableFabState createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;

  @override
  void initState() {
    // Utils.addButtonState = this;
    print("Redrawing");
    super.initState();
    widget.initialOpen = widget.initialOpen;
    _controller = AnimationController(
      value: widget.initialOpen ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggle() {
    setState(() {
      widget.initialOpen = !widget.initialOpen;
      if (widget.initialOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.initialOpen) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
      child: SizedBox.expand(
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            _buildTapToCloseFab(),
            ..._buildExpandingActionButtons(),
            _buildTapToOpenFab(),
          ],
        ),
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56.0,
      height: 56.0,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          child: InkWell(
            onTap: toggle,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(
                Icons.close,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    // hardcoded angle in degrees for individual buttons for now
    children.add(
      _ExpandingActionButton(
        directionInDegrees: 45.0,
        maxDistance: widget.distance,
        progress: _expandAnimation,
        child: widget.children[0],
      ),
    );
    children.add(
      _ExpandingActionButton(
        directionInDegrees: 135.0,
        maxDistance: widget.distance,
        progress: _expandAnimation,
        child: widget.children[1],
      ),
    );
    return children;
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: widget.initialOpen,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          widget.initialOpen ? 0.7 : 1.0,
          widget.initialOpen ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: widget.initialOpen ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton(
            onPressed: toggle,
            backgroundColor: Palette.accentedRed,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    Key? key,
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  }) : super(key: key);

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final sWidth = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: sWidth * 0.5 +
              offset.dx -
              25, // 25 seems to be the radius for the action buttons hmmm
          bottom: offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}

@immutable
class ActionButton extends StatelessWidget {
  ActionButton({
    Key? key,
    this.onPressed,
    required this.icon,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Widget icon;
  dynamic toggle = () {};

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: Palette.accentedRed,
      elevation: 4.0,
      child: IconButton(
        onPressed: () {
          onPressed!();
          toggle();
        },
        icon: icon,
        color: Colors.white,
        // iconSize: 30.0,
      ),
    );
  }
}
