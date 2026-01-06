import '../../../core/values/app_colours.dart';
import '../../../framework/provider/network/network.dart';

class Error404Mobile extends StatelessWidget {
  const Error404Mobile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.black,
      body: Center(
        child: Text('404 Not Found'),
      ),
    );
  }
}
