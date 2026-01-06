import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:readmore/readmore.dart';

import '../../../../../core/values/app_colours.dart';
import '../../../../../core/values/size_constant.dart';
import '../../../../../core/values/text_styles/base_textstyle.dart';
import '../../../../../gen/assets.gen.dart';

class ChatBubble extends StatefulWidget {
  final String text;
  final bool isUser;
  final bool animateTyping;
  bool animationCompleted;

  ChatBubble({
    super.key,
    required this.text,
    required this.isUser,
    this.animateTyping = false,
    required this.animationCompleted,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  AnimatedTextController animatedTextController = AnimatedTextController();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!widget.isUser)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Lottie.asset(
                height: getHeight(50.h),
                width: getWidth(50.w),
                Assets.lottie.animation1737368859751,
              ),
            ),
          Flexible(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 5,
                  )
                ],
                // border: Border.all(color: AppColors.border),
                color: widget.isUser
                    ? AppColors.primeryTxt.withOpacity(0.2)
                    : AppColors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: widget.animateTyping && !widget.animationCompleted
                        ? AnimatedTextKit(
                            pause: Duration(milliseconds: 100),
                            animatedTexts: [
                              TyperAnimatedText(
                                widget.text,
                                textStyle: BaseTextStyle.textM,
                                speed: const Duration(milliseconds: 40),
                              ),
                            ],
                            isRepeatingAnimation: false,
                            totalRepeatCount: 0,
                            displayFullTextOnTap: true,
                            stopPauseOnTap: true,
                            controller: animatedTextController,
                            onFinished: () {
                              animatedTextController.pause();
                              setState(() {
                                widget.animationCompleted = true;
                              });
                            },
                          )
                        : ReadMoreText(
                            widget.text,
                            style: BaseTextStyle.textM,
                            moreStyle: BaseTextStyle.textM
                                .copyWith(color: AppColors.red),
                            lessStyle: BaseTextStyle.textM
                                .copyWith(color: AppColors.red),
                            trimLines: 7,
                            colorClickableText: AppColors.red,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: 'Show more',
                            trimExpandedText: ' Show less',
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// }
// class ChatBubble extends StatefulWidget {
//   final String text;
//   final bool isUser;
//   final bool animateTyping;
//
//   const ChatBubble({
//     super.key,
//     required this.text,
//     required this.isUser,
//     this.animateTyping = false,
//   });
//
//   @override
//   State<ChatBubble> createState() => _ChatBubbleState();
// }
//
// class _ChatBubbleState extends State<ChatBubble> {
//   bool animationCompleted = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: widget.isUser ? Alignment.centerRight : Alignment.centerLeft,
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           if (!widget.isUser)
//             Lottie.asset(
//               height: getHeight(50.h),
//               width: getWidth(50.w),
//               Assets.lottie.animation1737368859751,
//             ),
//           Flexible(
//             child: Container(
//               margin: const EdgeInsets.symmetric(vertical: 8),
//               padding: const EdgeInsets.all(15),
//               decoration: BoxDecoration(
//                 border: Border.all(color: AppColors.border),
//                 color: widget.isUser
//                     ? AppColors.primeryTxt.withOpacity(0.2)
//                     : AppColors.black.withOpacity(0.5),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Flexible(
//                     child: widget.animateTyping && !animationCompleted
//                         ? AnimatedTextKit(
//                             animatedTexts: [
//                               TyperAnimatedText(
//                                 widget.text,
//                                 textStyle: BaseTextStyle.textM,
//                                 speed: const Duration(milliseconds: 40),
//                               ),
//                             ],
//                             isRepeatingAnimation: false,
//                             totalRepeatCount: 1,
//                             displayFullTextOnTap: true,
//                             stopPauseOnTap: true,
//                             onFinished: () {
//                               setState(() {
//                                 animationCompleted = true;
//                               });
//                             },
//                           )
//                         : ReadMoreText(
//                             widget.text,
//                             style: BaseTextStyle.textM,
//                             moreStyle: BaseTextStyle.textM
//                                 .copyWith(color: AppColors.red),
//                             lessStyle: BaseTextStyle.textM
//                                 .copyWith(color: AppColors.red),
//                             trimLines: 7,
//                             colorClickableText: AppColors.red,
//                             trimMode: TrimMode.Line,
//                             trimCollapsedText: 'Show more',
//                             trimExpandedText: ' Show less',
//                           ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/cupertino.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:lottie/lottie.dart';
// import 'package:readmore/readmore.dart';
//
// import '../../../../../core/values/app_colours.dart';
// import '../../../../../core/values/size_constant.dart';
// import '../../../../../core/values/text_styles/base_textstyle.dart';
// import '../../../../../gen/assets.gen.dart';
//
// class ChatBubble extends StatelessWidget {
//   final String text;
//   final bool isUser;
//
//   // final Widget? icon;
//
//   const ChatBubble({
//     super.key,
//     required this.text,
//     required this.isUser,
//     // this.icon
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           if (!isUser)
//             Lottie.asset(
//                 height: getHeight(50.h),
//                 width: getWidth(50.w),
//                 Assets.lottie.animation1737368859751),
//           Flexible(
//             child: Container(
//               margin: const EdgeInsets.symmetric(vertical: 8),
//               padding: const EdgeInsets.all(15),
//               decoration: BoxDecoration(
//                 border: Border.all(color: AppColors.border),
//                 color: isUser
//                     ? AppColors.primeryTxt.withOpacity(0.2)
//                     : AppColors.black.withOpacity(0.5),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Flexible(
//                     child: ReadMoreText(
//                       text,
//                       style: BaseTextStyle.textM,
//                       moreStyle:
//                           BaseTextStyle.textM.copyWith(color: AppColors.red),
//                       lessStyle:
//                           BaseTextStyle.textM.copyWith(color: AppColors.red),
//                       trimLines: 7,
//                       colorClickableText: AppColors.red,
//                       trimMode: TrimMode.Line,
//                       trimCollapsedText: 'Show more',
//                       trimExpandedText: ' Show less',
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
