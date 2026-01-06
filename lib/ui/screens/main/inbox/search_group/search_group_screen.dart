import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vista_flicks/core/values/app_colours.dart';
import 'package:vista_flicks/core/values/size_constant.dart';
import 'package:vista_flicks/core/values/text_styles/base_textstyle.dart';
import 'package:vista_flicks/core/widgets/custom_text_form_field.dart';
import 'package:vista_flicks/core/widgets/my_regular_text.dart';
import 'package:vista_flicks/framework/controller/invite_friend/search_controller.dart';
import 'package:vista_flicks/framework/repository/chat/model/group_details_response_model.dart';
import 'package:vista_flicks/framework/utils/local_storage/session.dart';
import 'package:vista_flicks/ui/routing/navigation_stack_item.dart';
import 'package:vista_flicks/ui/routing/stack.dart';

import 'package:vista_flicks/gen/assets.gen.dart';
import 'package:vista_flicks/ui/utils/helper/group_chat_manager/group_chat_manager.dart';

class SearchGroupScreen extends ConsumerStatefulWidget {
  const SearchGroupScreen({super.key});

  @override
  ConsumerState<SearchGroupScreen> createState() => _SearchGroupScreenState();
}

class _SearchGroupScreenState extends ConsumerState<SearchGroupScreen> {
  /// TextEditing Controller
  TextEditingController searchCTR = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final searchWatch = ref.read(searchController);
      searchWatch.disposeController(isNotify: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchWatch = ref.watch(searchController);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: getWidth(16)),
        color: AppColors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getVerticalHeight(50),
            CustomTextFormField(
              fillColor: AppColors.lightGray1,
              prefix: IconButton(
                  onPressed: () {
                    ref.read(navigationStackController).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.primeryTxt,
                  )),
              hintText: "Search by group or name name",
              hintStyle: BaseTextStyle.textM.copyWith(fontSize: 16, color: AppColors.placeholder),
              onChanged: (value) {
                if (value.length > 1) {
                  searchWatch.getSearchGroupsList(search: value);
                } else {
                  searchWatch.disposeController(isNotify: true);
                }
              },
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  onTap: () {
                    ref.read(navigationStackController).push(NavigationStackItem.qrScanner());
                    // Get.toNamed(Routes.QRSCANNER);
                  },
                  contentPadding: EdgeInsets.symmetric(vertical: getHeight(0)),
                  leading: SizedBox(
                    height: getHeight(48),
                    width: getWidth(48),
                    child: CircleAvatar(
                      backgroundColor: AppColors.border,
                      child: SvgPicture.asset(
                        Assets.icons.tablerIconQrcode,
                        color: AppColors.red,
                      ),
                    ),
                  ),
                  title: const MyRegularText(
                    "Scan QR Code",
                    style: BaseTextStyle.lableM,
                  ),
                ),
                ListTile(
                  onTap: () {
                    ref.read(navigationStackController).push(NavigationStackItem.createGroup());
                    // Get.toNamed(Routes.CREATEGROUP);
                  },
                  contentPadding: EdgeInsets.symmetric(vertical: getHeight(0)),
                  leading: SizedBox(
                    height: getHeight(48),
                    width: getWidth(48),
                    child: CircleAvatar(
                      backgroundColor: AppColors.border,
                      child: SvgPicture.asset(
                        Assets.icons.tablerIconUsersGroup,
                        color: AppColors.red,
                      ),
                    ),
                  ),
                  title: const MyRegularText(
                    "Create New Group",
                    style: BaseTextStyle.lableM,
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(vertical: getHeight(0)),
                  itemCount: searchWatch.groupList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        ref.read(navigationStackController).push(NavigationStackItem.singleGroup(groupDetailsResponseModel: searchWatch.groupList[index]));
                      },
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: getHeight(0)),
                        leading: SizedBox(
                          width: 60,
                          child: Wrap(
                            children: List.generate(
                              searchWatch.groupList[index].members?.length ?? 0,
                              (i) {
                                return SizedBox(
                                  height: getHeight(25),
                                  width: getWidth(25),
                                  child: CircleAvatar(
                                    radius: 15,
                                    backgroundImage: NetworkImage(searchWatch.groupList[index].members?[i].userImage ?? ''),
                                    // backgroundColor: Colors.grey[800],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        horizontalTitleGap: 0,
                        title: MyRegularText(
                          searchWatch.groupList[index].groupName ?? '',
                          style: BaseTextStyle.lableM,
                        ),
                        subtitle: MyRegularText(
                          "${searchWatch.groupList[index].members?.length} Members",
                          style: BaseTextStyle.textS.copyWith(color: AppColors.secondaryTxt),
                        ),
                      ),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
