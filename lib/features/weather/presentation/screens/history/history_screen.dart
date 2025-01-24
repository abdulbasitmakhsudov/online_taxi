import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:lottie/lottie.dart';
import 'package:online_taxi/core/app_preferences/isar_helper.dart';
import 'package:online_taxi/core/constants/app_colors.dart';
import 'package:online_taxi/core/constants/app_fonts.dart';
import 'package:online_taxi/core/extensions/navigation_extension.dart';
import 'package:online_taxi/features/weather/domain/entity/history_entity.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final IsarHelper isarHelper = IsarHelper();
  List<HistoryModel> histories = [];

  @override
  void initState() {
    super.initState();
    _loadHistories();
  }

  Future<void> _loadHistories() async {
    final data = await isarHelper.getAllHistories();
    setState(() {
      histories = data.map((e) => e.toModel()).toList();
    });
  }

  Future<void> _clearHistories() async {
    await isarHelper.deleteAllHistory(histories.map((e) => e.id!).toList());
    setState(() {
      histories.clear();
    });
  }

  void _showClearConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Clear History',
            style: pbold,
          ),
          content: const Text(
            'Are you sure you want to clear all history?',
            style: pmedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: pmedium,
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _clearHistories();
              },
              child: const Text(
                'OK',
                style: pmedium,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        toolbarHeight: 64,
        backgroundColor: AppColors.appBarLight,
        title: const Text('History'),
        leading: IconButton(
          onPressed: () => popScreen(context),
          icon: const Icon(Icons.chevron_left_outlined),
        ),
        actions: [
          histories.isNotEmpty
              ? IconButton(
            onPressed: _showClearConfirmationDialog,
            icon: const Icon(Icons.delete_outline),
          )
              : 0.horizontalSpace,
        ],
      ),
      body: histories.isEmpty
          ? Center(
        child: Lottie.asset(
          'assets/lottie/empty.json',
          width: 200.w,
          height: 200.h,
        ),
      )
          : GroupedListView<HistoryModel, DateTime>(
        elements: histories,
        groupBy: (history) =>
            DateTime(
              history.time.year,
              history.time.month,
              history.time.day,
            ),
        groupSeparatorBuilder: (DateTime date) =>
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8)
                  ),
                  child: Text('${date.year}-${date.month}-${date.day}',
                      style: pmedium),
                ),
              ),
            ),
        itemBuilder: (context, history) =>
            HistoryListItem(history: history),
        itemComparator: (a, b) => b.time.compareTo(a.time),
        order: GroupedListOrder.DESC,
      ),
    );
  }
}

class HistoryListItem extends StatelessWidget {
  final HistoryModel history;

  const HistoryListItem({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        '${history.from} → ${history.to}',
        style: pmedium,
      ),
      subtitle: Text(
        '${history.time.hour}:${history.time.minute}',
        style: pregular,
      ),
    );
  }
}
