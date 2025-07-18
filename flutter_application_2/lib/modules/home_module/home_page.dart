import 'package:flutter/material.dart';
import 'package:flutter_application_2/modules/live_module/live_mic_page.dart';
import 'package:flutter_application_2/modules/live_module/live_room_page.dart';
import 'package:flutter_application_2/commom/styles/colors.dart';
import 'models/home_card_info.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> tabs = const [
    'NEARBY',
    'POPULAR',
    'MULTI GUEST',
    'PK',
    'SUPER STAR',
  ];
  final List<String> subTabs = const [
    'All',
    'Education Guest',
    'Game',
    'Fun Entertainment',
    'Super Star',
  ];

  late List<HomeCardInfo> cards;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this, initialIndex: 1);
    // mock 数据
    cards = HomeCardInfo.mockList(16);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Theme.of(context).colorScheme.onPrimary,
          unselectedLabelColor: Theme.of(context).colorScheme.onPrimary.withAlpha((0.7 * 255).toInt()),
          indicatorColor: Theme.of(context).colorScheme.onPrimary,
          tabs: tabs.map((e) => Tab(text: e)).toList(),
        ),
        backgroundColor: AppColors.primary,
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: Column(
        children: [
          // 二级Tab
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: subTabs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Container(
                    height: 32,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: index == 0
                          ? AppColors.primary.withAlpha((0.15 * 255).toInt())
                          : Theme.of(context).dividerColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      subTabs[index],
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ),
          // 卡片瀑布流
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemCount: cards.length,
              itemBuilder: (context, index) {
                final card = cards[index];
                if (card.roomType == 'mic_room') {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LiveMicRoomPage(
                            title: card.title,
                            coverUrl: card.coverUrl,
                          ),
                        ),
                      );
                    },
                    child: LiveCard(
                      coverUrl: card.coverUrl,
                      title: card.title,
                      tag: card.tag,
                      viewers: card.viewers,
                    ),
                  );
                } else {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LivePage(
                            // 可传 title/coverUrl
                          ),
                        ),
                      );
                    },
                    child: LiveCard(
                      coverUrl: card.coverUrl,
                      title: card.title,
                      tag: card.tag,
                      viewers: card.viewers,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class LiveCard extends StatelessWidget {
  final String coverUrl;
  final String title;
  final String tag;
  final int viewers;
  const LiveCard({
    super.key,
    required this.coverUrl,
    required this.title,
    required this.tag,
    required this.viewers,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // 背景图片
          Positioned.fill(
            child: Image.network(
              coverUrl,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(color: Theme.of(context).dividerColor),
            ),
          ),
          // 顶部标签
          Positioned(
            left: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: tag == 'Live Room' ? AppColors.primary : AppColors.accent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                tag,
                style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 12),
              ),
            ),
          ),
          // 右上角观众数
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$viewers',
                style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 12),
              ),
            ),
          ),
          // 底部标题
          Positioned(
            left: 8,
            bottom: 8,
            child: Text(
              title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
