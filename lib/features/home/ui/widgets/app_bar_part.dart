import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_delivery/core/constants/app_colors.dart';
import 'package:food_delivery/core/constants/app_strings.dart';
import 'package:food_delivery/shared/data/models/food_model.dart';
import 'package:food_delivery/core/routes/app_router.dart';
import 'package:food_delivery/features/cart/ui/cubits/cart_cubit.dart';
import 'package:food_delivery/shared/widgets/custom_circle_button.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:food_delivery/core/services/toast_service.dart';
import 'package:food_delivery/core/di/di.dart';

class AppBarPart extends StatelessWidget {
  final String fullName;
  const AppBarPart({super.key, required this.fullName});

  Future<void> seedFoods() async {
    final supabase = Supabase.instance.client;

    try {
      // 1. Seed categories
      await supabase.from('all_categories').upsert([
        {
          'title': 'Pasta',
          'image': 'https://images.pexels.com/photos/1437267/pexels-photo-1437267.jpeg',
          'startingPrice': 75.0,
        },
        {
          'title': 'Burger',
          'image': 'https://images.pexels.com/photos/1639557/pexels-photo-1639557.jpeg',
          'startingPrice': 60.0,
        },
        {
          'title': 'Pizza',
          'image': 'https://images.pexels.com/photos/1566837/pexels-photo-1566837.jpeg',
          'startingPrice': 90.0,
        },
      ]);

      // 2. Seed restaurants
      await supabase.from('restaurants').upsert([
        {
          'name': 'Rose Garden Restaurant',
          'delivery_cost': 'Free',
          'image_url': 'https://images.pexels.com/photos/1099680/pexels-photo-1099680.jpeg',
          'images': [
            "https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg",
            "https://images.pexels.com/photos/376464/pexels-photo-376464.jpeg",
            "https://images.pexels.com/photos/958545/pexels-photo-958545.jpeg",
          ],
          'found_food': ["Burger", "Chicken", "Rice", "Wings"],
          'rate': '4.9',
          'description': "Maecenas sed diam eget risus varius blandit sit amet non magna. Integer posuere erat a ante venenatis dapibus posuere velit aliquet.",
          'delivery_time': '30 min',
          'categories': ['burger', 'pasta', 'pizza']
        },
        {
          'name': 'Italiano Bistro',
          'delivery_cost': '25 EGP',
          'image_url': 'https://images.pexels.com/photos/958545/pexels-photo-958545.jpeg',
          'images': [
            "https://images.pexels.com/photos/376464/pexels-photo-376464.jpeg",
            "https://images.pexels.com/photos/1099680/pexels-photo-1099680.jpeg",
          ],
          'found_food': ["Pasta", "Lasagna", "Pizza"],
          'rate': '4.7',
          'description': "Delicious classical Italian cuisine served fresh daily with hand-picked premium local ingredients.",
          'delivery_time': '25 min',
          'categories': ['pasta', 'pizza']
        }
      ]);

      // 3. Seed foods
      await supabase.from('foods').upsert([
        {
          'title': 'Spaghetti Bolognese',
          'description': 'Classic Italian pasta with rich beef tomato sauce',
          'price': 85,
          'restaurant_name': 'Italiano Bistro',
          'quantity': 1,
          'rating': 4.5,
          'delivery_time': '30 min',
          'delivery_cost': '25 EGP',
          'size': 'Medium',
          'category': 'Pasta',
          'image': 'https://images.pexels.com/photos/1437267/pexels-photo-1437267.jpeg',
        },
        {
          'title': 'Fettuccine Alfredo',
          'description': 'Creamy pasta with parmesan and butter sauce',
          'price': 90,
          'restaurant_name': 'Italiano Bistro',
          'quantity': 1,
          'rating': 4.6,
          'delivery_time': '35 min',
          'delivery_cost': '28 EGP',
          'size': 'Medium',
          'category': 'Pasta',
          'image': 'https://images.pexels.com/photos/1437267/pexels-photo-1437267.jpeg',
        },
        {
          'title': 'Penne Arrabiata',
          'description': 'Spicy tomato-based pasta with garlic and chili',
          'price': 75,
          'restaurant_name': 'Italiano Bistro',
          'quantity': 1,
          'rating': 4.2,
          'delivery_time': '25 min',
          'delivery_cost': '20 EGP',
          'size': 'Medium',
          'category': 'Pasta',
          'image': 'https://images.pexels.com/photos/1437267/pexels-photo-1437267.jpeg',
        },
        {
          'title': 'Lasagna',
          'description': 'Layers of pasta with beef, tomato sauce, and cheese',
          'price': 95,
          'restaurant_name': 'Italiano Bistro',
          'quantity': 1,
          'rating': 4.7,
          'delivery_time': '40 min',
          'delivery_cost': '30 EGP',
          'size': 'Large',
          'category': 'Pasta',
          'image': 'https://images.pexels.com/photos/1437267/pexels-photo-1437267.jpeg',
        },
        {
          'title': 'Classic Burger',
          'description': 'Grilled beef patty with cheese, lettuce, tomato, and special sauce',
          'price': 80,
          'restaurant_name': 'Rose Garden Restaurant',
          'quantity': 1,
          'rating': 4.8,
          'delivery_time': '20 min',
          'delivery_cost': 'Free',
          'size': 'Regular',
          'category': 'Burger',
          'image': 'https://images.pexels.com/photos/1639557/pexels-photo-1639557.jpeg',
        }
      ]);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomCircleButton(
          backgroundColor: const Color(0xFFECF0F4),
          onPressed: () => _showMenuBottomSheet(context),
          size: 60.h,
          icon: FaIcon(FontAwesomeIcons.barsStaggered, color: AppColors.darkBlue),
        ),
        SizedBox(width: 10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppStrings.deliverTo.toUpperCase(),
              style: GoogleFonts.sen(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
            ),
            SizedBox(
              width: 150.w,
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.sen(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFF676767),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.darkBlue,
                    size: 27.h,
                  ),
                ],
              ),
            ),
          ],
        ),
        const Spacer(),
        BlocSelector<CartCubit, List<FoodModel>, int>(
          selector: (state) {
            return state.length;
          },
          builder: (context, length) {
            return length == 0
                ? CustomCircleButton(
                    backgroundColor: AppColors.darkBlue,
                    onPressed: () => context.push(AppPaths.cart),
                    size: 60.h,
                    icon: FaIcon(
                      FontAwesomeIcons.basketShopping,
                      color: AppColors.white,
                    ),
                  )
                : Badge(
                    backgroundColor: AppColors.secondary,
                    offset: Offset(-5.w, -2.h),
                    label: Text(
                      length.toString(),
                      style: GoogleFonts.sen(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.normal,
                        color: AppColors.white,
                      ),
                    ),
                    child: CustomCircleButton(
                      backgroundColor: AppColors.darkBlue,
                      size: 60.h,
                      onPressed: () => context.push(AppPaths.cart),
                      icon: FaIcon(
                        FontAwesomeIcons.basketShopping,
                        color: AppColors.white,
                      ),
                    ),
                  );
          },
        ),
      ],
    );
  }

  void _showMenuBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      backgroundColor: AppColors.white,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 50.w,
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: AppColors.lightGray,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  "Zappit Options",
                  style: GoogleFonts.sen(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                  ),
                ),
                SizedBox(height: 15.h),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.secondary.withOpacity(0.1),
                    child: const Icon(Icons.info_outline, color: AppColors.secondary),
                  ),
                  title: Text(
                    "About Zappit",
                    style: GoogleFonts.sen(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBlue,
                    ),
                  ),
                  subtitle: Text(
                    "Company credits & developer profiles",
                    style: GoogleFonts.sen(
                      fontSize: 13.sp,
                      color: AppColors.textGray,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showAboutDialog(context);
                  },
                ),
                Divider(color: AppColors.lightGray, height: 20.h),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.darkBlue.withOpacity(0.1),
                    child: const Icon(Icons.dns_outlined, color: AppColors.darkBlue),
                  ),
                  title: Text(
                    "Seed Database Foods",
                    style: GoogleFonts.sen(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBlue,
                    ),
                  ),
                  subtitle: Text(
                    "Load initial sample restaurant & food data",
                    style: GoogleFonts.sen(
                      fontSize: 13.sp,
                      color: AppColors.textGray,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    try {
                      await seedFoods();
                      if (context.mounted) {
                        getIt<ToastService>().showSuccessToast(
                          context: context,
                          message: "Database seeded successfully!",
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        getIt<ToastService>().showErrorToast(
                          context: context,
                          message: "Failed to seed database: $e",
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          backgroundColor: AppColors.white,
          child: Padding(
            padding: EdgeInsets.all(24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16.h),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.bolt,
                    color: AppColors.secondary,
                    size: 40.h,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  "Zappit",
                  style: GoogleFonts.sen(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "ParallelogramFoundation",
                  style: GoogleFonts.sen(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  "Founded by",
                  style: GoogleFonts.sen(
                    fontSize: 12.sp,
                    color: AppColors.textGray,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  "Sarwar Altaf Dar & Burhan Hamid Dar",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.sen(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  "Meet The Developers",
                  style: GoogleFonts.sen(
                    fontSize: 12.sp,
                    color: AppColors.textGray,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildDeveloperButton(
                      name: "Sarwar Altaf",
                      url: "https://github.com/techxsarwar/",
                    ),
                    _buildDeveloperButton(
                      name: "Burhan Hamid",
                      url: "https://github.com/BurhanHamidDar",
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Close",
                    style: GoogleFonts.sen(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDeveloperButton({required String name, required String url}) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkBlue,
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      ),
      icon: FaIcon(FontAwesomeIcons.github, size: 16.h),
      label: Text(
        name,
        style: GoogleFonts.sen(
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () async {
        final Uri uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
    );
  }
}
