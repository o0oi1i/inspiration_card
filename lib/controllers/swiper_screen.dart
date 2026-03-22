import 'package:flutter/material.dart';
import 'package:inspiration_card/views/card/glass_card.dart';
import 'package:inspiration_card/views/background/cyber_painter.dart';
import 'package:inspiration_card/views/background/tight_glow.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;


class CyberShanHaiSwiper extends StatefulWidget {
  const CyberShanHaiSwiper({super.key});

  @override
  CyberShanHaiSwiperState createState() => CyberShanHaiSwiperState();
}

class CyberShanHaiSwiperState extends State<CyberShanHaiSwiper> with TickerProviderStateMixin {
  final List<List<Color>> cardGradients = [
    [const Color(0xFFFF00D6), const Color(0xFFFF4D00)], 
    [const Color(0xFF00FFFF), const Color(0xFF0019FF)], 
    [const Color(0xFF70FF00), const Color(0xFF15FF00)], 
    [const Color(0xFF9E00FF), const Color(0xFFFF00DD)], 
    [const Color(0xFFFFC700), const Color(0xFFFF5E00)], 
  ];
  
  final List<String> shanHaiNames = ["烛龙", "帝江", "饕餮", "九尾狐", "鲲鹏", "凤凰", "麒麟", "精卫", "毕方", "白泽", "梼杌", "獬豸", "狻猊", "猰萐", "青龙", "朱雀", "玄武", "白虎", "应龙", "陆吾"];
  late List<String> currentNames;
  final math.Random _random = math.Random();

  Offset _position = Offset.zero;
  bool _isDragging = false;
  double _swipeProgress = 0.0;
  
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    currentNames = List.generate(cardGradients.length, (index) => _getRandomName());
    _controller = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
  }

  String _getRandomName() => shanHaiNames[_random.nextInt(shanHaiNames.length)];

  void _updatePosition(DragUpdateDetails details) {
    setState(() {
      _isDragging = true;
      _position += details.delta;
      final threshold = MediaQuery.of(context).size.width / 4;
      _swipeProgress = (_position.dx.abs() / threshold).clamp(0.0, 1.0);
    });
  }

  void _onDragEnd(DragEndDetails details) {
    final threshold = MediaQuery.of(context).size.width / 4;
    if (_position.dx.abs() > threshold) {
      _animateFlyOut(_position.dx > 0);
    } else {
      _animateBack();
    }
  }

  void _animateBack() {
    _animation = Tween<Offset>(begin: _position, end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut), 
    )..addListener(() => setState(() {
        _position = _animation.value;
        final threshold = MediaQuery.of(context).size.width / 4;
        _swipeProgress = (_position.dx.abs() / threshold).clamp(0.0, 1.0);
      }));
    _controller.forward(from: 0);
    _isDragging = false;
  }

  void _animateFlyOut(bool isRight) {
    final screenWidth = MediaQuery.of(context).size.width;
    _animation = Tween<Offset>(
      begin: _position, 
      end: Offset(isRight ? screenWidth * 2.0 : -screenWidth * 2.0, _position.dy),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward(from: 0).then((_) {
      setState(() {
        final color = cardGradients.removeAt(0);
        cardGradients.add(color);
        currentNames.removeAt(0);
        currentNames.add(_getRandomName());
        _position = Offset.zero;
        _swipeProgress = 0.0; 
        _isDragging = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF010103),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: CyberSpacePainter(
                  offset: _position,
                  activeColor: cardGradients[0][0],
                  progress: _swipeProgress,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: TightGlowBackground(
                glowOffset: _position * 1, 
                glowColor: cardGradients[0][0],
                progress: _swipeProgress,
              ),
            ),
          ),
          Center(
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: cardGradients.asMap().entries.map((entry) {
                int index = entry.key;
                if (index > 4) return const SizedBox.shrink(); 
                return _buildCard(index);
              }).toList().reversed.toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(int index) {
    const cardWidth = 180.0;
    const cardHeight = 260.0;
    double yOffset = index * - 13.0; 
    double scale = 1.0 + (index * 0.07);
    double opacity = 1.0 * math.pow(0.618, index).toDouble();

    if (_isDragging || _controller.isAnimating) {
      double p = Curves.easeOutQuart.transform(_swipeProgress);
      yOffset += p * 15.0;
      scale -= p * 0.08;
      double nextOpacity = 0.6 * math.pow(0.55, index - 1 >= 0 ? index - 1 : 0).toDouble();
      opacity = ui.lerpDouble(opacity, nextOpacity, p)!;
    }

    Widget cardBody = GlassCard(
      name: currentNames[index],
      colors: cardGradients[index],
      width: cardWidth,
      height: cardHeight,
      isTop: index == 0,
    );

    if (index == 0) {
      return GestureDetector(
        onPanUpdate: _updatePosition,
        onPanEnd: _onDragEnd,
        child: Transform.translate(
          offset: _position,
          child: Transform.rotate(
            angle: (_position.dx / 5) * (math.pi / 180),
            child: Opacity(
              opacity: (0.6 - _swipeProgress * 0.3).clamp(0.0, 1.0),
              child: cardBody,
            ),
          ),
        ),
      );
    }

    return Transform.translate(
      offset: Offset(0, yOffset),
      child: Transform.scale(
        scale: scale,
        child: Opacity(opacity: opacity.clamp(0.0, 1.0), child: cardBody),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}