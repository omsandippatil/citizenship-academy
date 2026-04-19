import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import 'profile_selection_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocus = FocusNode();

  bool _isLoading = false;
  String? _error;
  String _logoAsset = 'assets/login/normal.png';
  bool _otpBannerVisible = false;
  String _otpCode = '';
  int _filledDigits = 0;
  DateTime? _lastInputTime;
  bool _scaredTriggered = false;
  bool _buttonHovered = false;
  bool _fieldFocused = false;

  late AnimationController _entryController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  late AnimationController _logoController;
  late Animation<double> _logoScaleAnim;

  late AnimationController _bannerController;
  late Animation<Offset> _bannerSlideAnim;
  late Animation<double> _bannerFadeAnim;

  late AnimationController _successController;
  late Animation<double> _successScaleAnim;

  late AnimationController _shakeController;
  late Animation<double> _shakeAnim;

  late AnimationController _cursorController;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim =
        CurvedAnimation(parent: _entryController, curve: Curves.easeOut);
    _slideAnim =
        Tween<Offset>(begin: const Offset(0, 0.18), end: Offset.zero).animate(
          CurvedAnimation(parent: _entryController, curve: Curves.easeOutCubic),
        );
    _entryController.forward();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _logoScaleAnim = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _bannerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _bannerSlideAnim =
        Tween<Offset>(begin: const Offset(0, -1.5), end: Offset.zero).animate(
          CurvedAnimation(
              parent: _bannerController, curve: Curves.easeOutCubic),
        );
    _bannerFadeAnim =
        CurvedAnimation(parent: _bannerController, curve: Curves.easeOut);

    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _successScaleAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _successController, curve: Curves.easeOutBack),
    );

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnim = Tween<double>(begin: 0, end: 1).animate(_shakeController);

    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _phoneFocus.addListener(() {
      if (mounted) setState(() => _fieldFocused = _phoneFocus.hasFocus);
    });

    _startIdleTimer();
  }

  @override
  void dispose() {
    _entryController.dispose();
    _logoController.dispose();
    _bannerController.dispose();
    _successController.dispose();
    _shakeController.dispose();
    _cursorController.dispose();
    _phoneController.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  void _startIdleTimer() {
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      final now = DateTime.now();
      final idle = _lastInputTime == null ||
          now.difference(_lastInputTime!).inSeconds >= 5;
      if (idle && _filledDigits < 10 && !_scaredTriggered) {
        _scaredTriggered = true;
        _changeLogo('assets/login/scared.png');
      }
    });
  }

  void _changeLogo(String asset) {
    _logoController.forward(from: 0).then((_) {
      if (!mounted) return;
      setState(() => _logoAsset = asset);
      _logoController.reverse();
    });
  }

  void _onPhoneChanged(String value) {
    _lastInputTime = DateTime.now();
    _scaredTriggered = false;
    _startIdleTimer();

    setState(() {
      _filledDigits = value.length;
      _error = null;
    });

    if (_logoAsset == 'assets/login/scared.png') {
      _changeLogo('assets/login/normal.png');
    }

    if (value.length == 10) {
      _triggerOtpFlow();
    }
  }

  void _triggerOtpFlow() async {
    _otpCode = _generateOtp();
    setState(() => _otpBannerVisible = true);
    _bannerController.forward(from: 0);

    await Future.delayed(const Duration(seconds: 4));
    if (!mounted) return;
    _bannerController.reverse().then((_) {
      if (mounted) setState(() => _otpBannerVisible = false);
    });
  }

  String _generateOtp() {
    final now = DateTime.now();
    return ((now.millisecondsSinceEpoch ~/ 1000) % 900000 + 100000).toString();
  }

  void _login() async {
    final phone = _phoneController.text;
    if (phone.length != 10) {
      setState(() => _error = 'Enter all 10 digits');
      _shakeController.forward(from: 0);
      return;
    }
    setState(() {
      _isLoading = true;
      _error = null;
    });

    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _logoAsset = 'assets/login/success.png';
    });
    _successController.forward(from: 0);

    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const ProfileSelectionScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isWide = w > 900;
    final isMedium = w > 600 && w <= 900;
    final cardWidth = isWide ? 520.0 : (isMedium ? 460.0 : double.infinity);

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isWide || isMedium ? 24 : 20,
                vertical: isWide ? 64 : 40,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: cardWidth == double.infinity ? 600 : cardWidth,
                  ),
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: SlideTransition(
                      position: _slideAnim,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildLogo(isWide),
                          SizedBox(height: isWide ? 56 : 48),
                          _buildCard(isWide),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_otpBannerVisible) _buildOtpBanner(isWide),
        ],
      ),
    );
  }

  Widget _buildLogo(bool isWide) {
    final logoSize = isWide ? 140.0 : 120.0;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withValues(alpha: 0.18),
                blurRadius: 52,
                spreadRadius: 10,
              ),
              BoxShadow(
                color: AppTheme.gold.withValues(alpha: 0.12),
                blurRadius: 30,
                spreadRadius: 4,
              ),
            ],
          ),
          child: AnimatedBuilder(
            animation: Listenable.merge([_logoController, _successController]),
            builder: (context, child) {
              final scale = _logoAsset == 'assets/login/success.png'
                  ? _successScaleAnim.value
                  : _logoScaleAnim.value;
              return Transform.scale(scale: scale, child: child);
            },
            child: Image.asset(
              _logoAsset,
              width: logoSize,
              height: logoSize,
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(height: isWide ? 24 : 20),
        Text(
          'Citizenship Academy',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isWide ? 30 : 26,
            fontWeight: FontWeight.w900,
            color: AppTheme.textDark,
            height: 1.15,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                  color: AppTheme.gold, shape: BoxShape.circle),
            ),
            const SizedBox(width: 7),
            const Text(
              'The Apprentice Project',
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.muted,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(width: 7),
            Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                  color: AppTheme.gold, shape: BoxShape.circle),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCard(bool isWide) {
    return AnimatedBuilder(
      animation: _shakeAnim,
      builder: (context, child) {
        final offset = _shakeAnim.value > 0
            ? Offset(8 * (0.5 - (_shakeAnim.value % 0.25 / 0.25)).abs(), 0)
            : Offset.zero;
        return Transform.translate(offset: offset, child: child);
      },
      child: Container(
        padding: EdgeInsets.all(isWide ? 40 : 28),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppTheme.border, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withValues(alpha: 0.08),
              blurRadius: 40,
              offset: const Offset(0, 12),
            ),
            BoxShadow(
              color: AppTheme.gold.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Welcome back',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.softGold,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppTheme.gold.withValues(alpha: 0.35), width: 1),
                  ),
                  child: const Text(
                    'TAP',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.gold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Enter your 10-digit mobile number',
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.muted,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 28),
            _buildCircleDigitRow(),
            if (_error != null) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  const Icon(Icons.error_outline,
                      size: 14, color: Colors.redAccent),
                  const SizedBox(width: 6),
                  Text(
                    _error!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (_) => setState(() => _buttonHovered = true),
                onExit: (_) => setState(() => _buttonHovered = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: _buttonHovered
                        ? [
                            BoxShadow(
                              color: AppTheme.primary.withValues(alpha: 0.32),
                              blurRadius: 22,
                              offset: const Offset(0, 7),
                            ),
                          ]
                        : const [],
                  ),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _buttonHovered
                          ? AppTheme.primary.withValues(alpha: 0.9)
                          : AppTheme.primary,
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(vertical: isWide ? 20 : 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.arrow_forward_rounded, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'Continue',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.info_outline,
                      size: 12, color: AppTheme.muted),
                  const SizedBox(width: 5),
                  Text(
                    'Demo mode — any 10-digit number works',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.muted.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleDigitRow() {
    const double circleSize = 30.0;

    return GestureDetector(
      onTap: () => _phoneFocus.requestFocus(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Zero-size hidden TextField that captures all input
          SizedBox(
            width: 0,
            height: 0,
            child: Opacity(
              opacity: 0,
              child: TextField(
                controller: _phoneController,
                focusNode: _phoneFocus,
                keyboardType: TextInputType.number,
                maxLength: 10,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(counterText: ''),
                onChanged: _onPhoneChanged,
              ),
            ),
          ),
          // Visible circle indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(10, (i) {
              final digit = i < _phoneController.text.length
                  ? _phoneController.text[i]
                  : '';
              final isFilled = digit.isNotEmpty;
              final isCursor = _fieldFocused && i == _filledDigits;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                width: circleSize,
                height: circleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isFilled
                      ? AppTheme.primary.withValues(alpha: 0.08)
                      : isCursor
                          ? AppTheme.primary.withValues(alpha: 0.04)
                          : AppTheme.softGreen,
                  border: Border.all(
                    color: isFilled
                        ? AppTheme.primary
                        : isCursor
                            ? AppTheme.primary.withValues(alpha: 0.65)
                            : AppTheme.border,
                    width: isFilled || isCursor ? 2.0 : 1.5,
                  ),
                  boxShadow: isCursor
                      ? [
                          BoxShadow(
                            color: AppTheme.primary.withValues(alpha: 0.16),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : const [],
                ),
                child: Center(
                  child: isFilled
                      ? Text(
                          digit,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.primary,
                            height: 1,
                          ),
                        )
                      : isCursor
                          ? AnimatedBuilder(
                              animation: _cursorController,
                              builder: (context, _) => Opacity(
                                opacity: _cursorController.value,
                                child: Container(
                                  width: 1.5,
                                  height: 13,
                                  decoration: BoxDecoration(
                                    color: AppTheme.primary,
                                    borderRadius: BorderRadius.circular(1),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
          // Progress bar dots
          LayoutBuilder(
            builder: (context, constraints) {
              final double dotWidth = (constraints.maxWidth - 9 * 5) / 10;
              return Row(
                children: List.generate(10, (i) {
                  final isFilled = i < _filledDigits;
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOut,
                        width: dotWidth,
                        height: 2.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color:
                              isFilled ? AppTheme.primary : AppTheme.border,
                        ),
                      ),
                      if (i < 9) const SizedBox(width: 5),
                    ],
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOtpBanner(bool isWide) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: _bannerSlideAnim,
        child: FadeTransition(
          opacity: _bannerFadeAnim,
          child: SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 520),
                margin: EdgeInsets.fromLTRB(
                    isWide ? 0 : 16, 12, isWide ? 0 : 16, 0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: AppTheme.textDark,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: AppTheme.gold.withValues(alpha: 0.12),
                      blurRadius: 14,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: AppTheme.gold.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.lock_outline_rounded,
                        color: AppTheme.gold,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            const TextSpan(text: 'Your OTP is '),
                            TextSpan(
                              text: _otpCode,
                              style: const TextStyle(
                                color: AppTheme.gold,
                                fontWeight: FontWeight.w900,
                                fontSize: 15,
                                letterSpacing: 3,
                              ),
                            ),
                            const TextSpan(
                                text: ' — do not share it with anyone'),
                          ],
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
}