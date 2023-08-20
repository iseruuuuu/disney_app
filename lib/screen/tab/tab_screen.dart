import 'package:disney_app/core/theme/theme.dart';
import 'package:disney_app/screen/tab/tab_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabScreen extends ConsumerWidget {
  const TabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tabScreenViewModelProvider);
    final controller = ref.watch(tabScreenViewModelProvider.notifier);
    return Scaffold(
      body: controller.pageList[state.selectedIndex],
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey.shade400),
          ),
        ),
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.white,
          selectedItemColor: AppColorStyle.appColor,
          unselectedItemColor: Colors.grey,
          iconSize: 30,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: state.selectedIndex,
          onTap: controller.onTap,
          items: const [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 10),
                child: Icon(
                  Icons.home,
                  size: 35,
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 10),
                child: Icon(
                  Icons.account_circle,
                  size: 35,
                ),
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
