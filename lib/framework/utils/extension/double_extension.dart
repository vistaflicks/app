import 'package:vista_flicks/framework/utils/extension/context_extension.dart';

import '../../../ui/utils/theme/theme.dart';

extension DoubleExtension on double {
  /// Leaves given height of space
  double height(BuildContext context) => context.height * (this / 100);

  /// Leaves given width of space
  double width(BuildContext context) => context.width * (this / 100);
}
