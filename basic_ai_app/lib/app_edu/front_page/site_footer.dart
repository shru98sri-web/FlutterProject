import 'package:flutter/material.dart';

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      padding: const EdgeInsets.fromLTRB(
        30,
        70,
        30,
        30,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1200,
          ),
          child: Column(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  return Wrap(
                    spacing: 80,
                    runSpacing: 40,
                    children: [
                      SizedBox(
                        width: 300,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'AI Career Guidance',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: 15),
                            Text(
                              'Navigate your future with AI.',
                              style: TextStyle(
                                color: Colors.white60,
                              ),
                            ),
                            SizedBox(height: 15),
                            Text(
                              'The world’s leading AI career platform, '
                              'helping professionals navigate the complex '
                              'landscape of modern industries.',
                              style: TextStyle(
                                color: Colors.white54,
                                height: 1.5,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _footerColumn(
                        'Platform',
                        [
                          'Career Mapping',
                          'Resume Scoring',
                          'Enterprise Workforce',
                          'Career API',
                        ],
                      ),
                      _footerColumn(
                        'Company',
                        [
                          'Our Mission',
                          'Partners',
                          'Contact',
                        ],
                      ),
                      _footerColumn(
                        'Legal',
                        [
                          'Privacy Policy',
                          'Terms & Conditions',
                          'Refund Policy',
                        ],
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 55),
              const Divider(
                color: Colors.white12,
              ),
              const SizedBox(height: 25),
              const Text(
                '© 2026 AI Career Guidance.',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _footerColumn(
    String title,
    List<String> items,
  ) {
    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 18),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                item,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
