import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/Colors/coluors.dart';
import '../../../core/theme/text_styles/text_styeles.dart';
import '../models/doctor_model.dart';

class DoctorCard extends StatelessWidget {
  final Doctor doctor;
  final VoidCallback? onTap;

  const DoctorCard({
    super.key,
    required this.doctor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Doctor Image
                  Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.r),
                      color: Colours.LightBlue.withValues(alpha: 0.1),
                    ),
                    child: doctor.imageUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(30.r),
                            child: Image.network(
                              doctor.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person,
                                  size: 30.w,
                                  color: Colours.DarkBlue,
                                );
                              },
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 30.w,
                            color: Colours.DarkBlue,
                          ),
                  ),
                  SizedBox(width: 12.w),

                  // Doctor Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor.name,
                          style: TextStyles.black16blod,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          doctor.specialty,
                          style: TextStyles.grey14.copyWith(
                            color: Colours.DarkBlue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 14.w,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Text(
                                doctor.location,
                                style: TextStyles.grey12,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Availability indicator
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: doctor.isAvailable
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      doctor.isAvailable ? 'Available' : 'Busy',
                      style: TextStyles.grey12.copyWith(
                        color: doctor.isAvailable ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              // Rating and Price Row
              Row(
                children: [
                  // Rating
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 16.w,
                        color: Colors.amber,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        doctor.rating.toStringAsFixed(1),
                        style: TextStyles.black14blod,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '(${doctor.reviewCount} reviews)',
                        style: TextStyles.grey12,
                      ),
                    ],
                  ),
                  const Spacer(),

                  // Price
                  Text(
                    '\$${doctor.consultationPrice.toStringAsFixed(0)}',
                    style: TextStyles.black16blod.copyWith(
                      color: Colours.DarkBlue,
                    ),
                  ),
                  Text(
                    '/consultation',
                    style: TextStyles.grey12,
                  ),
                ],
              ),

              SizedBox(height: 8.h),

              // Experience and Languages
              Row(
                children: [
                  Icon(
                    Icons.work,
                    size: 14.w,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '${doctor.experienceYears} years experience',
                    style: TextStyles.grey12,
                  ),
                  SizedBox(width: 16.w),
                  if (doctor.languages.isNotEmpty) ...[
                    Icon(
                      Icons.language,
                      size: 14.w,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        doctor.languages.take(2).join(', '),
                        style: TextStyles.grey12,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),

              SizedBox(height: 12.h),

              // Description
              if (doctor.description.isNotEmpty) ...[
                Text(
                  doctor.description,
                  style: TextStyles.grey14,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12.h),
              ],

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: Navigate to booking
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Book appointment with ${doctor.name}'),
                            backgroundColor: Colours.DarkBlue,
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colours.DarkBlue),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        'Book Appointment',
                        style: TextStyles.black14blod.copyWith(
                          color: Colours.DarkBlue,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: Colours.LightBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: IconButton(
                      onPressed: () {
                        // TODO: Add to favorites
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Added ${doctor.name} to favorites'),
                            backgroundColor: Colours.DarkBlue,
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.favorite_border,
                        size: 20.w,
                        color: Colours.DarkBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
