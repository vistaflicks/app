import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vista_flicks/core/values/size_constant.dart';
import 'package:vista_flicks/core/widgets/common_bg_container.dart';
import 'package:vista_flicks/ui/utils/helper/base_widget.dart';

import '../../../../framework/controller/auth/on_boarding/on_boarding_controller.dart';
import 'helper/register_form_widget.dart';
import 'helper/welcom_to_vista_widget.dart';

// class RegisterFormPage extends GetView<OnBordingController> {
//   const RegisterFormPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: CommonBgContainer(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             getVerticalHeight(100),
//             const WelcomToVistaFlicksWidget(),
//             getVerticalHeight(41),
//             RegisterFormWidget(),
//           ],
//         ),
//       ),
//     );
//   }
// }

class RegisterFormScreen extends ConsumerStatefulWidget {
  final String inputController;

  const RegisterFormScreen({super.key, required this.inputController});

  @override
  ConsumerState<RegisterFormScreen> createState() => _RegisterFormScreenState();
}

class _RegisterFormScreenState extends ConsumerState<RegisterFormScreen>
    with BaseConsumerStatefulWidget {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final registerFormScreenWatch = ref.watch(onBoardingController);
      registerFormScreenWatch.disposeController(isNotify: true);
    });
  }

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CommonBgContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getVerticalHeight(100.h),
            const WelcomeToVistaFlicksWidget(),
            getVerticalHeight(41.h),
            RegisterFormWidget(
              inputController: widget.inputController,
            ),
          ],
        ),
      ),
    );
  }
}

// class RegisterFormPage extends GetView<RegisterFormController> {
//   const RegisterFormPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: Get.width,
//         height: Get.height,
//         padding: EdgeInsets.symmetric(horizontal: getWidth(16)),
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             fit: BoxFit.cover,
//             image: AssetImage(
//               Assets.images.gradientBg.path,
//             ),
//           ),
//         ),
//         child: Column(
//           children: [
//             getVerticalHeight(100),
//             WelcomToVistaFlicksWidget(),
//             getVerticalHeight(41),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Expanded(
//                   child: CustomTextFormField(
//                     hintText: "First Name",
//                     onChanged: (value) {},
//                   ),
//                 ),
//                 getHorizonatlWidth(20),
//                 Expanded(
//                   child: CustomTextFormField(
//                     hintText: "last Name",
//                     onChanged: (value) {},
//                   ),
//                 ),
//               ],
//             ),
//             CustomTextFormField(
//               hintText: "Enter Email",
//               onChanged: (value) {},
//             ),
//             CustomTextFormField(
//               hintText: "Phone Number",
//               onChanged: (value) {},
//             ),
//             getVerticalHeight(15),
//             Container(
//               decoration: BoxDecoration(
//                   color: AppColours.black.withOpacity(.3),
//                   borderRadius: BorderRadius.circular(10)),
//               child: DropdownButtonFormField<String>(
//                 decoration: InputDecoration(
//                   fillColor: AppColours.black.withOpacity(.3),
//                   hintText: "Select Your Age",
//                   hintStyle: AppTextstyles.lableStyle,
//                   floatingLabelStyle: AppTextstyles.hintStyle,
//                   border: OutlineInputBorder(
//                     borderSide: BorderSide.none,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 dropdownColor: AppColours.black.withOpacity(0.8),
//                 items: List.generate(100, (index) => (index + 1).toString())
//                     .map((age) => DropdownMenuItem(
//                           value: age,
//                           child: MyRegularText(age + " years",
//                               style: AppTextstyles.lableStyle),
//                         ))
//                     .toList(),
//                 onChanged: (value) {
//                   // Handle age selection
//                 },
//               ),
//             ),
//             getVerticalHeight(15),
//             Container(
//               decoration: BoxDecoration(
//                   color: AppColours.black.withOpacity(.3),
//                   borderRadius: BorderRadius.circular(10)),
//               child: DropdownButtonFormField<String>(
//                 decoration: InputDecoration(
//                   hintText: "Select Your Gender",
//                   hintStyle: AppTextstyles.lableStyle,
//                   floatingLabelStyle: AppTextstyles.lableStyle,
//                   border: OutlineInputBorder(
//                     borderSide: BorderSide.none,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 dropdownColor: AppColours.black.withOpacity(0.8),
//                 items: ["Male", "Female", "Other"]
//                     .map((gender) => DropdownMenuItem(
//                           value: gender,
//                           child: MyRegularText(gender,
//                               style: AppTextstyles.lableStyle),
//                         ))
//                     .toList(),
//                 onChanged: (value) {
//                   // Handle gender selection
//                 },
//               ),
//             ),
//             getVerticalHeight(15),
//             CustomButton(
//               style:
//                   BaseTextStyle.buttonM.copyWith(color: AppColours.primeryTxt),
//               color: AppColours.red,
//               text: AppStrings.,
//               fun: () {},
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
