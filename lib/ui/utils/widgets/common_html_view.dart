import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../../framework/provider/network/network.dart';
import '../const/app_constants.dart';
import '../theme/text_style.dart';

class CommonHtmlView extends ConsumerWidget {
  const CommonHtmlView({super.key, required this.dataString, this.textStyle});

  final String dataString;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return HtmlWidget(
      dataString,
      textStyle: textStyle ?? TextStyles.medium,
      onTapUrl: (url) {
        showLog('HtmlWidget Url $url');
        // ref
        //     .read(navigationStackController)
        //     .push(NavigationStackItem.cms(cmsUrl: url));
        return url != '';
      },
    );
  }
}
