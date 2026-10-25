import 'package:flutter/material.dart';
import '../widgets/onboarding_page.dart';
import 'register_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _onboardingPages = [
    {
      'image': 'assets/images/onboarding1.png',
      'title': 'Track Your Goal',
      'description':
          "Don't worry if you have trouble determining your goals. We can help you determine your goals and track your goals.",
      'hasBuiltInBg': true,
    },
    {
      'image': 'assets/images/onboarding2.png',
      'title': 'Get Burn',
      'description':
          "Let's keep burning, to achieve yours goals, it hurts only temporarily, if you give up now you will be in pain forever.",
      'hasBuiltInBg': false,
    },
    {
      'image': 'assets/images/onbaording3.png',
      'title': 'Eat Well',
      'description':
          "Let's start a healthy lifestyle with us, we can determine your diet every day. healthy eating is fun.",
      'hasBuiltInBg': false,
    },
    {
      'image': 'assets/images/onboarding4.png',
      'title': 'Improve Sleep\nQuality',
      'description':
          "Improve the quality of your sleep with us, good quality sleep can bring a good mood in the morning.",
      'hasBuiltInBg': true,
    },
  ];

  void _nextPage() {
    if (_currentPage < _onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _getStarted() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 244, 244),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingPages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return OnboardingPage(
                    imagePath: _onboardingPages[index]['image'] as String,
                    title: _onboardingPages[index]['title'] as String,
                    description:
                        _onboardingPages[index]['description'] as String,
                    hasBuiltInBackground:
                        _onboardingPages[index]['hasBuiltInBg'] as bool,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(
                      _onboardingPages.length,
                      (index) => _buildDot(index),
                    ),
                  ),
                  _buildNextButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    bool isActive = _currentPage == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 8),
      width: isActive ? 30 : 10,
      height: 10,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF92A3FD) : const Color(0xFFD8E3FF),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget _buildNextButton() {
    bool isLastPage = _currentPage == _onboardingPages.length - 1;

    return GestureDetector(
      onTap: isLastPage ? _getStarted : _nextPage,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF92A3FD).withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          isLastPage ? Icons.check : Icons.arrow_forward_ios,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}
