import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import '../../core/config/config.dart';
import '../../core/services/auth_service.dart';
import '../../core/theme/Colors/coluors.dart';
import '../../core/theme/text_styles/text_styeles.dart';
import '../../routes/routes.dart';
import '../auth/admin/add_admin.dart';
import '../home_screen/teams/add_member.dart';

/// Dedicated admin dashboard for managing the app
class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService.instance;

    return Scaffold(
      backgroundColor: Colours.White,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Admin Dashboard',
          style: TextStyles.lightBlue20blod,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(authService),
            SizedBox(height: 30.h),
            _buildQuickStats(),
            SizedBox(height: 30.h),
            _buildAdminActions(context),
            SizedBox(height: 30.h),
            _buildSystemInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(AuthService authService) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colours.DarkBlue, Colours.LightBlue],
        ),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.admin_panel_settings,
                color: Colours.White,
                size: 30.w,
              ),
              SizedBox(width: 10.w),
              Text(
                'Admin Panel',
                style: TextStyles.white20blod.copyWith(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            'Welcome back, ${authService.currentUserName ?? 'Admin'}!',
            style: TextStyles.white20blod.copyWith(
              fontSize: 16.sp,
              color: Colours.White.withValues(alpha: 0.9),
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            'Manage your clinic\'s operations and content',
            style: TextStyles.white20blod.copyWith(
              fontSize: 14.sp,
              color: Colours.White.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Stats',
          style: TextStyles.lightBlue20blod.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15.h),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.people,
                title: 'Total Users',
                value: '1,234',
                color: Colours.LightBlue,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _buildStatCard(
                icon: Icons.phone,
                title: 'Meetings Today',
                value: '45',
                color: Colours.DarkBlue,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.pending_actions,
                title: 'Pending Requests',
                value: '12',
                color: Colors.orange,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _buildStatCard(
                icon: Icons.star,
                title: 'Avg Rating',
                value: '4.8',
                color: Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24.w,
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAdminActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Admin Actions',
          style: TextStyles.lightBlue20blod.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15.h),
        _buildActionCard(
          context: context,
          icon: IconlyBold.add_user,
          title: config.localization['addadmin'] ?? 'Add Admin',
          description: 'Grant admin privileges to users',
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const AddAdmin()),
            );
          },
        ),
        SizedBox(height: 10.h),
        _buildActionCard(
          context: context,
          icon: IconlyBold.plus,
          title: config.localization['addBanner'] ?? 'Add Banner',
          description: 'Create promotional banners',
          onTap: () {
            Navigator.pushNamed(context, Routes.addBannedRoute);
          },
        ),
        SizedBox(height: 10.h),
        _buildActionCard(
          context: context,
          icon: IconlyBold.plus,
          title: config.localization['addMember'] ?? 'Add Team Member',
          description: 'Add new team members',
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const AddMember()),
            );
          },
        ),
        SizedBox(height: 10.h),
        _buildActionCard(
          context: context,
          icon: IconlyBold.category,
          title: config.localization['adminrequset'] ?? 'Manage Requests',
          description: 'View and manage meeting requests',
          onTap: () {
            Navigator.pushNamed(context, Routes.allRequestsMeetRoute);
          },
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
          color: Colours.White,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Colours.LightBlue.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: Colours.LightBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: Icon(
                icon,
                color: Colours.LightBlue,
                size: 24.w,
              ),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyles.lightBlue20blod.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    description,
                    style: TextStyles.gray15blod.copyWith(
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colours.LightBlue,
              size: 16.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'System Information',
          style: TextStyles.lightBlue20blod.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(15.w),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: Colors.grey[300]!,
            ),
          ),
          child: Column(
            children: [
              _buildInfoRow('App Version', '1.0.0'),
              _buildInfoRow('Last Updated', 'Today'),
              _buildInfoRow('Server Status', 'Online'),
              _buildInfoRow('Database', 'Connected'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyles.gray15blod.copyWith(
              fontSize: 14.sp,
            ),
          ),
          Text(
            value,
            style: TextStyles.lightBlue20blod.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
