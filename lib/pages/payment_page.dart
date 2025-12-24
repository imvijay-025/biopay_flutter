import 'package:biometric_pay/pages/success_page.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:math' as math;

class PaymentPage extends StatefulWidget {
  final String receiver;
  const PaymentPage({super.key, required this.receiver});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage>
    with TickerProviderStateMixin {
  final TextEditingController amountController = TextEditingController();
  final LocalAuthentication auth = LocalAuthentication();
  late AnimationController _pulseController;
  late AnimationController _rippleController;
  late AnimationController _scanController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rippleAnimation;
  late Animation<double> _scanAnimation;
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();

    // Gentle pulse animation for fingerprint icon
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Smooth glow animation
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();

    _rippleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeInOut),
    );

    // Smooth scan line animation
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();

    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rippleController.dispose();
    _scanController.dispose();
    amountController.dispose();
    super.dispose();
  }

  Future<void> authenticateAndPay() async {
    if (amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an amount'),
          backgroundColor: Color(0xFFE91E63),
        ),
      );
      return;
    }

    setState(() {
      _isAuthenticating = true;
    });

    bool isAuthenticated = false;

    try {
      isAuthenticated = await auth.authenticate(
        localizedReason: 'Confirm payment using fingerprint',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() {
      _isAuthenticating = false;
    });

    if (isAuthenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SuccessPage(
            receiver: widget.receiver,
            amount: amountController.text,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF000000),
              const Color(0xFF1A0A2E),
              const Color(0xFF16213E),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    // App Bar
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Make Payment",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Receiver Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF9C27B0),
                                    Color(0xFFE91E63),
                                  ],
                                ),
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                widget.receiver[0].toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Paying to",
                                    style: TextStyle(
                                      color: Colors.white60,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.receiver,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Amount Input
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Enter Amount",
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: amountController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                prefixText: "₹ ",
                                prefixStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                                border: InputBorder.none,
                                hintText: "0.00",
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.3),
                                  fontSize: 32,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Animated Fingerprint Section
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40.0),
                      child: _buildAnimatedFingerprintSection(),
                    ),

                    // Pay Button
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF9C27B0),
                              Color(0xFFE91E63),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF9C27B0).withOpacity(0.4),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap:
                                _isAuthenticating ? null : authenticateAndPay,
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              alignment: Alignment.center,
                              child: _isAuthenticating
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    )
                                  : const Text(
                                      "Authenticate & Pay",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedFingerprintSection() {
    return Column(
      children: [
        const Text(
          "Touch the fingerprint sensor",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: 200,
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Smooth glow effect
              AnimatedBuilder(
                animation: _rippleAnimation,
                builder: (context, child) {
                  final glowOpacity = (0.3 +
                          0.2 * math.sin(_rippleAnimation.value * 2 * math.pi))
                      .clamp(0.2, 0.5);
                  return Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF9C27B0).withOpacity(glowOpacity),
                          const Color(0xFFE91E63)
                              .withOpacity(glowOpacity * 0.5),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  );
                },
              ),

              // Main fingerprint container
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF9C27B0).withOpacity(0.4),
                            const Color(0xFFE91E63).withOpacity(0.2),
                            Colors.transparent,
                          ],
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF9C27B0).withOpacity(0.6),
                          width: 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF9C27B0).withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Smooth scan line animation
                          AnimatedBuilder(
                            animation: _scanAnimation,
                            builder: (context, child) {
                              final scanY = _scanAnimation.value * 180;
                              return Positioned(
                                top: scanY - 2,
                                child: Container(
                                  width: 180,
                                  height: 3,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        const Color(0xFFE91E63)
                                            .withOpacity(0.8),
                                        const Color(0xFF9C27B0)
                                            .withOpacity(0.8),
                                        const Color(0xFFE91E63)
                                            .withOpacity(0.8),
                                        Colors.transparent,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              );
                            },
                          ),

                          // Fingerprint icon
                          CustomPaint(
                            size: const Size(120, 120),
                            painter: FingerprintPainter(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Custom painter for fingerprint graphics
class FingerprintPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF9C27B0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Draw fingerprint pattern (concentric arcs)
    for (int i = 0; i < 8; i++) {
      final currentRadius = radius - (i * 8);
      if (currentRadius > 0) {
        // Top arc
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: currentRadius),
          math.pi * 0.3,
          math.pi * 0.4,
          false,
          paint..color = const Color(0xFF9C27B0).withOpacity(0.8 - i * 0.1),
        );
        // Bottom arc
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: currentRadius),
          math.pi * 1.3,
          math.pi * 0.4,
          false,
          paint..color = const Color(0xFFE91E63).withOpacity(0.8 - i * 0.1),
        );
      }
    }

    // Draw center circle
    canvas.drawCircle(
      center,
      15,
      Paint()
        ..color = const Color(0xFFE91E63)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
