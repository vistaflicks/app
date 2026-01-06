import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/values/app_colours.dart';
import '../../../../../../core/values/size_constant.dart';
import '../../../../../../core/values/text_styles/base_textstyle.dart';
import '../../../../../../core/widgets/custom_text_form_field.dart';
import '../../../../../../framework/provider/network/network.dart';
import '../../../../../../gen/assets.gen.dart';

class ShareBottomSheet extends ConsumerStatefulWidget {
  const ShareBottomSheet({super.key});

  @override
  ConsumerState<ShareBottomSheet> createState() => _ShareBottomSheetState();
}

class _ShareBottomSheetState extends ConsumerState<ShareBottomSheet> {
  Set<int> selectedGroups = {};

  void toggleSelection(int index) {
    setState(() {
      if (selectedGroups.contains(index)) {
        selectedGroups.remove(index);
      } else {
        selectedGroups.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 80,
      ),
      child: Column(
        children: [
          CustomTextFormField(
            prefix: Icon(CupertinoIcons.search, color: AppColors.primeryTxt),
            fillColor: AppColors.lightGray1,
            hintText: "Search group name",
            onChanged: (String value) {},
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              itemCount: 20,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final isSelected = selectedGroups.contains(index);
                return GestureDetector(
                  onTap: () => toggleSelection(index),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected ? AppColors.red : Colors.transparent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 60.w,
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Wrap(
                                children: List.generate(
                                  4,
                                  (i) => SizedBox(
                                    height: getHeight(25),
                                    width: getWidth(25),
                                    child: CircleAvatar(
                                      radius: 15,
                                      backgroundImage:
                                          AssetImage(Assets.images.av10.path),
                                    ),
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.red,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'User ${index + 1}',
                          style:
                              BaseTextStyle.textS.copyWith(color: Colors.white),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showSendButton(context);
    });
  }

  void _showSendButton(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (_) => ValueListenableBuilder(
        valueListenable: ValueNotifier(selectedGroups.isNotEmpty),
        builder: (_, __, ___) => selectedGroups.isNotEmpty
            ? Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border(
                    top: BorderSide(color: AppColors.border),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // perform send action
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child:
                            Text("Send to ${selectedGroups.length} group(s)"),
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
