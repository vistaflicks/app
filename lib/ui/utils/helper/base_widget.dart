import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_builder/responsive_builder.dart';

mixin BaseStatefulWidget<Page extends StatefulWidget> on State<Page> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      breakpoints: const ScreenBreakpoints(desktop: 1000, tablet: 812, watch: 100),
      mobile: (BuildContext context) {
        ScreenUtil.init(context, designSize: const Size(375, 812));
        return buildPage(context);
      },
      tablet: (BuildContext context) {
        ScreenUtil.init(context, designSize: const Size(812, 1366));
        return buildPage(context);
      },
      desktop: (BuildContext context) {
        ScreenUtil.init(context, designSize: const Size(1366, 812));
        return buildPage(context);
      },
    );
  }

  Widget buildPage(BuildContext context);
}

mixin BaseStatelessWidget on StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      breakpoints: const ScreenBreakpoints(desktop: 1000, tablet: 812, watch: 100),
      mobile: (BuildContext context) {
        ScreenUtil.init(context, designSize: const Size(375, 812));
        return buildPage(context);
      },
      tablet: (BuildContext context) {
        ScreenUtil.init(context, designSize: const Size(812, 1366));
        return buildPage(context);
      },
      desktop: (BuildContext context) {
        ScreenUtil.init(context, designSize: const Size(1366, 812));
        return buildPage(context);
      },
    );
  }

  Widget buildPage(BuildContext context);
}

mixin BaseConsumerWidget on ConsumerWidget {
  @override
  Widget build(BuildContext context, ref) {
    return ScreenTypeLayout.builder(
      breakpoints: const ScreenBreakpoints(desktop: 1000, tablet: 812, watch: 100),
      mobile: (BuildContext context) {
        ScreenUtil.init(context, designSize: const Size(375, 812));
        return buildPage(context, ref);
      },
      tablet: (BuildContext context) {
        ScreenUtil.init(context, designSize: const Size(812, 1366));
        return buildPage(context, ref);
      },
      desktop: (BuildContext context) {
        ScreenUtil.init(context, designSize: const Size(1366, 812));
        return buildPage(context, ref);
      },
    );
  }

  Widget buildPage(BuildContext context, WidgetRef ref);
}

mixin BaseConsumerWidgetStateFullWidget<Page extends ConsumerStatefulWidget> on State<Page> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      breakpoints: const ScreenBreakpoints(desktop: 1000, tablet: 812, watch: 100),
      mobile: (BuildContext context) {
        ScreenUtil.init(context, designSize: const Size(375, 812));
        return buildPage(context);
      },
      tablet: (BuildContext context) {
        ScreenUtil.init(context, designSize: const Size(812, 1366));
        return buildPage(context);
      },
      desktop: (BuildContext context) {
        ScreenUtil.init(context, designSize: const Size(1366, 812));
        return buildPage(context);
      },
    );
  }

  Widget buildPage(BuildContext context);
}

mixin BaseConsumerStatefulWidget<Page extends ConsumerStatefulWidget> on State<Page> {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      breakpoints: const ScreenBreakpoints(desktop: 1000, tablet: 812, watch: 100),
      mobile: (BuildContext context) {
        ScreenUtil.init(context, designSize: const Size(375, 812));
        return buildPage(context);
      },
      tablet: (BuildContext context) {
        ScreenUtil.init(context, designSize: const Size(812, 1366));
        return buildPage(context);
      },
      desktop: (BuildContext context) {
        ScreenUtil.init(context, designSize: const Size(1366, 812));
        return buildPage(context);
      },
    );
  }

  Widget buildPage(BuildContext context);
}
