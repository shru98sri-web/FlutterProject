import 'package:basic_ai_app/app_edu/front_page/about_section.dart';
import 'package:basic_ai_app/app_edu/front_page/final_cta.dart';
import 'package:basic_ai_app/app_edu/front_page/growth_section.dart';
import 'package:basic_ai_app/app_edu/front_page/hero_section.dart';
import 'package:basic_ai_app/app_edu/front_page/interview_section.dart';
import 'package:basic_ai_app/app_edu/front_page/marquee_section.dart';
import 'package:basic_ai_app/app_edu/front_page/platform_section.dart';
import 'package:basic_ai_app/app_edu/front_page/site_footer.dart';
import 'package:basic_ai_app/app_edu/front_page/site_header.dart';
import 'package:basic_ai_app/app_edu/front_page/stats_section.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SelectionArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SiteHeader(),
            ),
            SliverToBoxAdapter(
              child: HeroSection(),
            ),
            SliverToBoxAdapter(
              child: MarqueeSection(),
            ),
            SliverToBoxAdapter(
              child: StatsSection(),
            ),
            SliverToBoxAdapter(
              child: PlatformSection(),
            ),
            SliverToBoxAdapter(
              child: AboutSection(),
            ),
            SliverToBoxAdapter(
              child: GrowthSection(),
            ),
            SliverToBoxAdapter(
              child: InterviewSection(),
            ),
            SliverToBoxAdapter(
              child: FinalCta(),
            ),
            SliverToBoxAdapter(
              child: SiteFooter(),
            ),
          ],
        ),
      ),
    );
  }
}
