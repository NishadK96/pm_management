import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ipsum_user/core/constants/icon_constants.dart';
import 'package:ipsum_user/core/theme/app_colors.dart';

class ProjectList extends StatelessWidget {
  const ProjectList({super.key});

  final int count = 1;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return count == 0
        ? // Empty project placeholder
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Project List",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 5),
              Container(
                width: size.width,
                height: 2,
                color: AppColors.dividerGrey,
              ),
              SizedBox(height: 10),
              SizedBox(
                width: size.width,
                child: SvgPicture.string(IconConst().emptyProjectIcon),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Project List',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildProjectListItem(),
              // You can add more projects as needed here
            ],
          );
  }

  Widget _buildProjectListItem(
    // String title,
    // String description,
    // String startDate,
    // String endDate,
    // String priority,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _filterChip("All", false),
            const SizedBox(width: 8),
            _filterChip("High", true),
            const SizedBox(width: 8),
            _filterChip("Medium", false),
            const SizedBox(width: 8),
            _filterChip("Low", false),
          ],
        ),
        SizedBox(height: 20,),
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            shadows: [
              BoxShadow(
                color: Color(0x26000000),
                blurRadius: 4,
                offset: Offset(0, 0),
                spreadRadius: 0,
              )
            ],
          ),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "The Logo Process Is A Dummy Task List\nFor Design Purpose 1",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),

              // Progress bar
              Row(
                children: [
                  const Expanded(
                    child: LinearProgressIndicator(
                      value: 0.05,
                      backgroundColor: Colors.grey,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "05%",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Dates + Priority
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.calendar_month, size: 16, color: Colors.black54),
                      SizedBox(width: 4),
                      Text("12 Jan 2025", style: TextStyle(fontSize: 12)),
                      SizedBox(width: 12),
                      Icon(Icons.flag, size: 16, color: Colors.black54),
                      SizedBox(width: 4),
                      Text("20 Sep 2025", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "High",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
  // Reusable filter chip
  Widget _filterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.shade100 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.blue : Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
