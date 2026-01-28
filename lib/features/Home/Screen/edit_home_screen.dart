import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/Home/Cubits/edit_home_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditHomeScreen extends StatefulWidget {
  const EditHomeScreen({super.key});

  @override
  State<EditHomeScreen> createState() => _EditHomeScreenState();
}

class _EditHomeScreenState extends State<EditHomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<EditHomeCubit>().loadMenu(UiUtils.homeMenuList);
  }

  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      //appBar: AppBar(title: Text('CustomScrollView Example')),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            iconTheme: IconThemeData(
              color: colorScheme.surface, //change your color here
            ),
            backgroundColor: colorScheme.primary,
            expandedHeight: context.isTablet ? context.height * 0.12 : context.height * 0.18,

            // expandedHeight: ResponsiveUtils.tabletBreakpoint ? context.height * 0.12 : context.height * 0.18,
            pinned: true,

            // stretch: true,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final topPadding = MediaQuery.of(context).padding.top;
                final collapsedHeight = kToolbarHeight + topPadding;
                final expandedHeight = context.isTablet ? context.height * 0.12 : context.height * 0.18;

                final percent = ((constraints.maxHeight - collapsedHeight) / (expandedHeight - collapsedHeight)).clamp(0.0, 1.0);

                const paddingExpanded = 10;
                const paddingCollapsed = 56; // safe for back icon

                return FlexibleSpaceBar(
                  centerTitle: false,
                  titlePadding: EdgeInsetsDirectional.only(start: paddingCollapsed + (paddingExpanded - paddingCollapsed) * percent, bottom: 16),
                  title: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextView(text: context.tr('editHomeScreenKey'), fontSize: 18.sp(context), color: colorScheme.surface, fontWeight: FontWeight.bold),

                      if (percent > 0.1) CustomTextView(text: context.tr('editHomeScreenDescKey'), fontSize: 12.sp(context), color: colorScheme.surface) else const SizedBox.shrink(),
                    ],
                  ),
                );
              },
            ),
          ),

          BlocConsumer<EditHomeCubit, EditHomeState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is EditHomeSuccess) {
                final homeMenuData = state.menuItems;

                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return ResponsivePadding(
                      topPadding: context.height * 0.01,
                      bottomPadding: 5,
                      child: ReorderableListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        proxyDecorator: (child, index, animation) {
                          return Material(
                            color: Colors.transparent,
                            elevation: 6,
                            borderRadius: BorderRadius.circular(14),
                            child: ClipRRect(borderRadius: BorderRadius.circular(14), child: child),
                          );
                        },
                        itemCount: homeMenuData.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final homeMenu = homeMenuData[index];

                          return Container(
                            key: ValueKey(homeMenu.id),
                            margin: EdgeInsetsDirectional.only(bottom: context.height * 0.018),
                            padding: EdgeInsetsDirectional.symmetric(vertical: context.height * 0.01, horizontal: context.width * 0.03),
                            decoration: BoxDecoration(color: colorScheme.surface, borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                Icon(homeMenu.icon, size: 22.sp(context), color: colorScheme.primary),
                                SizedBox(width: context.width * 0.05),
                                Expanded(
                                  child: CustomTextView(text: context.tr(homeMenu.title), fontSize: 16.sp(context), color: colorScheme.onTertiary),
                                ),
                                Switch(
                                  trackOutlineColor: WidgetStateProperty.all(colorScheme.primary),
                                  inactiveThumbColor: colorScheme.onTertiary,
                                  activeThumbColor: colorScheme.primary,
                                  thumbColor: WidgetStateProperty.all(colorScheme.primary),

                                  value: homeMenu.isOn,
                                  onChanged: (bool value) => setState(() {
                                    if (activeIndex != 0 && activeIndex != index) {
                                      homeMenuData[activeIndex].isOn = false;
                                    }

                                    homeMenu.isOn = value;

                                    context.read<EditHomeCubit>().saveMenu(homeMenuData);
                                  }),
                                ),

                                ReorderableDragStartListener(
                                  index: index,
                                  // enabled: index == 0,
                                  child: Row(
                                    children: [
                                      SizedBox(width: context.width * 0.02),
                                      Icon(Icons.menu, size: 30.sp(context), color: index == 0 ? const Color.fromARGB(255, 111, 110, 110) : colorScheme.primary),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },

                        onReorder: (oldIndex, newIndex) {
                          // if (newIndex == 0) return;
                          if (newIndex > oldIndex) newIndex -= 1;

                          final item = homeMenuData.removeAt(oldIndex);
                          homeMenuData.insert(newIndex, item);

                          context.read<EditHomeCubit>().saveMenu(homeMenuData);
                        },
                      ),
                    );
                  }, childCount: 1),
                );
              }

              return const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsetsDirectional.all(32),
                  child: Center(child: CustomCircularProgressIndicator()),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
