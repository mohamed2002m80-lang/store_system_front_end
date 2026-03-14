import 'package:flutter/material.dart';
import 'package:store_system/helper/constant_app.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int selectedIndex = 0;
  static const double _desktopBreakpoint = 900;

  final List<_SidebarItemData> _items = const [
    _SidebarItemData(title: 'لوحة التحكم', icon: Icons.dashboard_rounded),
    _SidebarItemData(title: 'المبيعات', icon: Icons.point_of_sale_rounded),
    _SidebarItemData(title: 'المنتجات', icon: Icons.inventory_2_rounded),
    _SidebarItemData(title: 'المخازن', icon: Icons.warehouse_rounded),
    _SidebarItemData(title: 'المصاريف', icon: Icons.receipt_long_rounded),
    _SidebarItemData(title: 'الطلبيات', icon: Icons.shopping_bag_rounded),
    _SidebarItemData(title: 'المندوبين', icon: Icons.groups_rounded),
    _SidebarItemData(title: 'الموظفين', icon: Icons.badge_rounded),
    _SidebarItemData(title: 'تقارير', icon: Icons.bar_chart_rounded),
    _SidebarItemData(title: 'تسجيل خروج', icon: Icons.logout_rounded),
  ];

  List<Widget> get _pages => const [
    _SectionPage(title: 'لوحة التحكم'),
    _SectionPage(title: 'المبيعات'),
    _SectionPage(title: 'المنتجات'),
    _SectionPage(title: 'المخازن'),
    _SectionPage(title: 'المصاريف'),
    _SectionPage(title: 'الطلبيات'),
    _SectionPage(title: 'المندوبين'),
    _SectionPage(title: 'الموظفين'),
    _SectionPage(title: 'تقارير'),
    _SectionPage(title: 'تسجيل خروج'),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= _desktopBreakpoint;

        if (isDesktop) {
          return Scaffold(
            body: Row(
              children: [
                _Sidebar(
                  items: _items,
                  selectedIndex: selectedIndex,
                  onSelect: (index) => setState(() => selectedIndex = index),
                ),
                Expanded(
                  child: _HomeContent(pages: _pages, index: selectedIndex),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(_items[selectedIndex].title),
            backgroundColor: ConstantApp.primaryColor,
            foregroundColor: Colors.white,
          ),
          drawer: Drawer(
            child: SafeArea(
              child: _Sidebar(
                items: _items,
                selectedIndex: selectedIndex,
                width: double.infinity,
                onSelect: (index) {
                  setState(() => selectedIndex = index);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
          body: _HomeContent(pages: _pages, index: selectedIndex),
        );
      },
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.items,
    required this.selectedIndex,
    required this.onSelect,
    this.width = 280,
  });

  final List<_SidebarItemData> items;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      color: ConstantApp.primaryColor,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Text(
              'نظام المتجر',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 22),
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = index == selectedIndex;

                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => onSelect(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(item.icon, color: Colors.white, size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              fontSize: 17,
                            ),
                          ),
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
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.pages, required this.index});

  final List<Widget> pages;
  final int index;

  @override
  Widget build(BuildContext context) {
    return IndexedStack(index: index, children: pages);
  }
}

class _SectionPage extends StatelessWidget {
  const _SectionPage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _SidebarItemData {
  const _SidebarItemData({required this.title, required this.icon});

  final String title;
  final IconData icon;
}
