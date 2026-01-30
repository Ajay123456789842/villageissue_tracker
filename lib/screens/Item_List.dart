import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:itemtracker/appservice_lifecycle.dart';
import 'package:itemtracker/cloud_sync/check_connectivity.dart';
import 'package:itemtracker/custom_methods/reusable_methods.dart';
import 'package:itemtracker/models/item_model.dart';
import 'package:itemtracker/providers/item_provider.dart';
import 'package:itemtracker/screens/Item_Input.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ItemList extends StatefulWidget {
  const ItemList({super.key});

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  void checkConnection(BuildContext context) {}

  @override
  void initState() {
    //_lifecycleService = AppLifecycleService();
    //_lifecycleService.start();
    CheckConnectivityService().checkConnectivity(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CheckConnectivityService().checkConnectivity(context);
    return Consumer<ItemProvider>(
      builder: (context, itemprovider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('VillageIssue_Tracker'),
            actions: [
              IconButton(
                  onPressed: () {
                    itemprovider.toggletheme();
                  },
                  icon: const Icon(Icons.brightness_6)),
              const SizedBox(
                width: 40,
              )
            ],
          ),
          body: LayoutBuilder(builder: (context, constraints) {
            bool iswide = constraints.maxWidth > 600;
            return AnimatedSwitcher(
              duration: Duration(milliseconds: 400),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(0.0, 0.1),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: iswide
                  ? _buildGridview(context: context)
                  : _buildListview(context: context),
            );
          }),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                  useSafeArea: true,
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return const ItemInput();
                  });
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

Widget _buildListview({required BuildContext context}) {
  return Consumer<ItemProvider>(
    builder: (context, itemprovider, child) {
      if (itemprovider.items.isNotEmpty) {
        return ListView.builder(
          itemCount: itemprovider.items.length,
          itemBuilder: (context, index) {
            ItemModel im = itemprovider.items[index];
            return Padding(
              padding: EdgeInsets.all(22.0.h),
              child: Builder(builder: (context) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ItemInput(
                              im: im,
                            )));
                  },
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 250),
                    scale: 1.0,
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB), // soft background
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(14.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ─── Header ───
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    im.name!,
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.2,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  transitionBuilder: (child, animation) =>
                                      FadeTransition(
                                          opacity: animation, child: child),
                                  child: Icon(
                                    im.isSynced!
                                        ? Icons.cloud_done_outlined
                                        : Icons.cloud_off_outlined,
                                    key: ValueKey(im.isSynced),
                                    size: 20.sp,
                                    color: im.isSynced!
                                        ? Colors.green.shade600
                                        : Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 10.h),

                            // ─── Image ───
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.file(
                                File(im.imgurl!),
                                height: 170.h,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),

                            SizedBox(height: 12.h),

                            // ─── Description ───
                            Text(
                              im.description!,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16.sp,
                                height: 1.8,
                                color: Colors.black,
                              ),
                            ),

                            SizedBox(height: 14.h),

                            // ─── Footer ───
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  im.createdAt!
                                      .toLocal()
                                      .toString()
                                      .substring(0, 16),
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.black,
                                  ),
                                ),
                                InkWell(
                                  borderRadius: BorderRadius.circular(30),
                                  onTap: () {
                                    itemprovider.removeitem(im.id!);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Item deleted'),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Icon(
                                      Icons.delete_outline_rounded,
                                      size: 20.sp,
                                      color: Colors.redAccent.withOpacity(0.8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        );
      } else {
        return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'You Dont have any items..please add some',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 8.sp),
              ),
            ],
          ),
        );
      }
    },
  );
}

Widget _buildGridview({required BuildContext context}) {
  // ReusableMethods rm = ReusableMethods();
  int crossaxiscou = ScreenUtil().screenWidth > 600 ? 3 : 2;
  return Consumer<ItemProvider>(
    builder: (context, itemprovider, child) {
      if (itemprovider.items.isNotEmpty) {
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossaxiscou,
              mainAxisSpacing: 12.h,
              crossAxisSpacing: 12.w,
              childAspectRatio: 1),
          itemCount: itemprovider.items.length,
          itemBuilder: (context, index) {
            ItemModel im = itemprovider.items[index];
            return Padding(
              padding: EdgeInsets.all(20.h),
              child: Builder(builder: (context) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ItemInput(
                              im: im,
                            )));
                  },
                  child: Card(
                      elevation: 3.h,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            im.name!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            im.description!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                          Text(im.createdAt!
                              .toLocal()
                              .toString()
                              .substring(0, 16)),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    itemprovider.removeitem(im.id!);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content:
                                          Text('Item deleted Successfully'),
                                    ));
                                  },
                                  icon: const Icon(Icons.delete)),
                              const SizedBox(
                                width: 20,
                              ),
                              Icon(
                                im.isSynced!
                                    ? Icons.cloud_done
                                    : Icons.cloud_off,
                                color: im.isSynced! ? Colors.green : Colors.red,
                              )
                            ],
                          )
                        ],
                      )),
                );
              }),
            );
          },
        );
      } else {
        return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'You Dont have any items..please add some',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
        );
      }
    },
  );
}
