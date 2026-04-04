import 'package:flutter/material.dart';
import 'package:interval_timer/pages/home.dart';
import 'package:interval_timer/services/settings_service.dart';
import 'package:interval_timer/services/haptic_service.dart';
import 'package:interval_timer/l10n/app_localizations.dart';
import '../../const.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late final AnimationController _iconController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  );
  late final Animation<double> _iconScale = CurvedAnimation(
    parent: _iconController,
    curve: Curves.elasticOut,
  );

  @override
  void initState() {
    super.initState();
    _iconController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
    _iconController.reset();
    _iconController.forward();
  }

  void _nextPage() {
    HapticService.selection();
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  void _finish() {
    HapticService.medium();
    SettingsService.setJumpInVisible(false);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const Home(screenIndex: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.centerRight,
              child: _currentPage < 2
                  ? Padding(
                      padding: const EdgeInsets.only(top: 12, right: 20),
                      child: GestureDetector(
                        onTap: _finish,
                        child: Text(
                          l10n.onboarding_skip,
                          style: body1(context).copyWith(
                            color: context.colors.neutral400,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(height: 40),
            ),
            // Pages
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  _buildWelcomePage(context, l10n),
                  _buildFeaturesPage(context, l10n),
                  _buildReadyPage(context, l10n),
                ],
              ),
            ),
            // Dots + Button
            Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, bottom: 32, top: 16),
              child: Column(
                children: [
                  _buildDots(),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      child: Text(
                        _currentPage < 2
                            ? l10n.onboarding_next
                            : l10n.onboarding_get_started,
                        style: body1Bold(context).copyWith(
                          color: context.colors.neutral50,
                        ),
                      ),
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

  Widget _buildWelcomePage(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _iconScale,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    context.colors.neutral850,
                    context.colors.neutral600,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: context.colors.neutral850.withValues(alpha: 0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Icon(
                Icons.timer_rounded,
                size: 64,
                color: context.colors.neutral50,
              ),
            ),
          ),
          const SizedBox(height: 48),
          Text(
            l10n.onboarding_welcome,
            style: heading1Bold(context),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.onboarding_welcome_desc,
            style: body1(context).copyWith(
              color: context.colors.neutral500,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesPage(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            l10n.onboarding_features_title,
            style: heading1Bold(context),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.onboarding_features_desc,
            style: body1(context).copyWith(
              color: context.colors.neutral500,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          ScaleTransition(
            scale: _iconScale,
            child: Column(
              children: [
                _buildFeatureRow(
                  context,
                  Icons.fitness_center_rounded,
                  l10n.training,
                  l10n.onboarding_feature_training,
                  context.colors.success500,
                ),
                const SizedBox(height: 16),
                _buildFeatureRow(
                  context,
                  Icons.pause_circle_outline_rounded,
                  l10n.pause,
                  l10n.onboarding_feature_pause,
                  context.colors.warning500,
                ),
                const SizedBox(height: 16),
                _buildFeatureRow(
                  context,
                  Icons.repeat_rounded,
                  l10n.sets,
                  l10n.onboarding_feature_sets,
                  context.colors.error500,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(
    BuildContext context,
    IconData icon,
    String title,
    String description,
    Color accentColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.colors.neutral200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: accentColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: body1Bold(context)),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: body2(context).copyWith(
                    color: context.colors.neutral500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadyPage(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _iconScale,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    context.colors.success500,
                    context.colors.success700,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: context.colors.success500.withValues(alpha: 0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Icon(
                Icons.rocket_launch_rounded,
                size: 64,
                color: context.colors.neutral50,
              ),
            ),
          ),
          const SizedBox(height: 48),
          Text(
            l10n.onboarding_ready_title,
            style: heading1Bold(context),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.onboarding_ready_desc,
            style: body1(context).copyWith(
              color: context.colors.neutral500,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final isActive = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive
                ? context.colors.neutral850
                : context.colors.neutral300,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
