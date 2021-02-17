library tooltip;

import 'package:flutter/cupertino.dart';
import './BallonPositioner.dart';
import './BallonTransition.dart';
import './Ballon.dart';

// ignore: must_be_immutable
class CustomTooltip extends StatefulWidget {
  /// The [child] which the tooltip will target to
  final Widget child;

  /// Sets the tooltip direction
  /// defaults to [TooltipDirection.up]
  final TooltipDirection tooltipDirection;

  /// Defines the content that its placed inside the tooltip ballon
  final Widget content;

  /// If true, it will display the tool , if false it will hide it
  final bool show;

  final Function onClose;

  /// Sets the content padding
  /// defautls to: `const EdgeInsets.symmetric(horizontal: 20, vertical: 16),`
  final EdgeInsets ballonPadding;

  /// sets the duration of the tooltip entrance animation
  /// defaults to [460] milliseconds
  final Duration animationDuration;

  /// [top], [right], [bottom], [left] position the Tooltip absolute relative to the whole screen
  double top, right, bottom, left;

  /// [minWidth], [minHeight], [maxWidth], [maxHeight] optional size constraints.
  /// If a constraint is not set the size will ajust to the content
  double minWidth, minHeight, maxWidth, maxHeight;

  ///
  /// The distance of the tip of the arrow's tip to the center of the target
  final double arrowTipDistance;

  ///
  /// The length of the Arrow
  final double arrowLength;

  ///
  /// the stroke width of the border
  final double borderWidth;

  ///
  /// The minium padding from the Tooltip to the screen limits
  final double minimumOutSidePadding;

  ///
  /// The corder radii of the border
  final double borderRadius;

  ///
  /// The width of the arrow at its base
  final double arrowBaseWidth;

  ///
  /// The color of the border
  final Color borderColor;

  ///
  /// The color of the border
  final Color backgroundColor;

  ///
  /// Set a custom list of [BoxShadow]
  /// defaults to `const BoxShadow(color: const Color(0x45222222), blurRadius: 8, spreadRadius: 2),`
  final List<BoxShadow> customShadows;

  ///
  /// Set a handler for listening to a `tap` event on the tooltip (This is the recommended way to put your logic for dismissing the tooltip)
  final Function() tooltipTap;

  ///
  /// If you want to automatically dismiss the tooltip whenever a user taps on it, set this flag to [true]
  /// For more control on when to dismiss the tooltip please rely on the [show] property and [tooltipTap] handler
  /// defaults to [false]
  final bool hideOnTooltipTap;

  ///
  /// Pass a `RouteObserver` so that the widget will listen for route transition and will hide tooltip when
  /// the widget's route is not active
  final RouteObserver<PageRoute> routeObserver;

  CustomTooltip({
    Key key,
    @required this.child,
    this.tooltipDirection = TooltipDirection.up,
    @required this.content,
    @required this.show,
    this.onClose,
    this.ballonPadding = const EdgeInsets.all(0),
    this.maxWidth,
    this.minWidth,
    this.maxHeight,
    this.minHeight,
    this.arrowTipDistance = 6,
    this.arrowLength = 8,
    this.minimumOutSidePadding = 0,
    this.arrowBaseWidth = 16,
    this.borderRadius = 4,
    this.borderWidth = 0,
    this.borderColor = const Color(0xFF50FFFF),
    this.animationDuration = const Duration(milliseconds: 360),
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.customShadows = const [
      const BoxShadow(
          color: const Color(0x45222222), blurRadius: 8, spreadRadius: 2),
    ],
    this.tooltipTap,
    this.hideOnTooltipTap = true,
    this.routeObserver,
  })  : assert(show != null),
        super(key: key);

  @override
  _CustomTooltipState createState() => _CustomTooltipState();
}

class _CustomTooltipState extends State<CustomTooltip> with RouteAware {
  bool _displaying = false;

  final LayerLink layerLink = LayerLink();

  // To avoid rebuild state of widget for each rebuild
  GlobalKey _transitionKey = GlobalKey();
  GlobalKey _positionerKey = GlobalKey();

  bool _routeIsShowing = true;

  OverlayEntry overlayEntry;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // widget.routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    _removeTooltip();
    widget.routeObserver?.unsubscribe(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.show) {
        _showTooltip();
      }
      widget.routeObserver?.subscribe(this, ModalRoute.of(context));
    });
  }

  @override
  void didUpdateWidget(CustomTooltip oldWidget) {
    if (oldWidget.routeObserver != widget.routeObserver) {
      oldWidget.routeObserver?.unsubscribe(this);
      widget.routeObserver?.subscribe(this, ModalRoute.of(context));
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (oldWidget.tooltipDirection != widget.tooltipDirection ||
          (oldWidget.show != widget.show && widget.show)) {
        _transitionKey = GlobalKey();
      }
      if (!_routeIsShowing) {
        return;
      }
      _removeTooltip();
      if (widget.show) {
        _showTooltip();
      } else if (oldWidget.show) {
        _showTooltip(buildHidding: true);
        // setState(() {
        // });
      }
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: layerLink,
      child: widget.child,
    );
  }

  void _showTooltip({
    bool buildHidding = false,
  }) {
    if (_displaying || !mounted) {
      return;
    }
    overlayEntry = _buildOverlay(
      buildHidding: buildHidding,
    );
    Overlay.of(context, rootOverlay: false).insert(overlayEntry);
    _displaying = true;
  }

  // void _hideToolTip() {
  //   _hide = true;
  // }

  void _removeTooltip() {
    if (!_displaying) {
      return;
    }
    this.overlayEntry.remove();
    _displaying = false;
  }

  OverlayEntry _buildOverlay({
    bool buildHidding = false,
  }) {
    return OverlayEntry(
      builder: (overlayContext) {
        return BallonPositioner(
          key: _positionerKey,
          link: layerLink,
          tooltipDirection: widget.tooltipDirection,
          maxHeight: widget.maxHeight,
          minHeight: widget.minHeight,
          maxWidth: widget.maxWidth,
          minWidth: widget.minWidth,
          child: BalloonTransition(
            key: _transitionKey,
            duration: widget.animationDuration,
            tooltipDirection: widget.tooltipDirection,
            hide: buildHidding,
            animationEnd: (status) {
              if (status == AnimationStatus.dismissed) {
                _removeTooltip();
              }
            },
            child: Ballon(
              content: widget.content,
              borderRadius: widget.borderRadius,
              arrowBaseWidth: widget.arrowBaseWidth,
              arrowLength: widget.arrowLength,
              arrowTipDistance: widget.arrowTipDistance,
              ballonPadding: widget.ballonPadding,
              borderColor: widget.borderColor,
              borderWidth: widget.borderWidth,
              tooltipDirection: widget.tooltipDirection,
              backgroundColor: widget.backgroundColor,
              shadows: widget.customShadows,
              onTap: () {
                if (widget.hideOnTooltipTap) {
                  _removeTooltip();
                  _showTooltip(buildHidding: true);
                }
                if (widget.tooltipTap != null) {
                  widget.tooltipTap();
                }
              },
            ),
          ),
          // arrowBaseWidth: widget.arrowBaseWidth,
          arrowLength: widget.arrowLength,
          arrowTipDistance: widget.arrowTipDistance,
          outsidePadding: widget.minimumOutSidePadding,
          context: context,
        );
      },
    );
  }

  @override
  void didPush() {
    _routeIsShowing = true;
    // Route was pushed onto navigator and is now topmost route.
    if (widget.show) {
      _removeTooltip();
      _showTooltip();
    }
  }

  @override
  void didPushNext() {
    _routeIsShowing = false;
    _removeTooltip();
  }

  @override
  void didPopNext() async {
    _routeIsShowing = true;
    if (widget.show) {
      _removeTooltip();
      await Future.delayed(Duration(milliseconds: 100));
      _showTooltip();
    }
    // Covering route was popped off the navigator.
  }
}
