import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ipsum_user/core/constants/icon_constants.dart';
import 'package:ipsum_user/core/widgets/custom_textfield.dart';
import 'package:ipsum_user/core/widgets/title_widget.dart';

class ProfileDetailsScreen extends StatelessWidget {
  const ProfileDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var w= MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: TitleWidget(label: 'Profile Details')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    width: 160,
                    height: 181,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          "https://img.freepik.com/premium-photo/happy-man-ai-generated-portrait-user-profile_1119669-1.jpg?w=2000",
                        ),
                        fit: BoxFit.cover,
                      ),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 3, color: Colors.white),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: SvgPicture.string(IconConst().editProfile),
                  ),
                ],
              ),
              SizedBox(height: 16),
              CustomTextField(label: "Full Name"),
              SizedBox(height: 16),
              CustomTextField(label: "Address"),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: w/2.3,
                      child: CustomTextField(label: "Contact in native place")),Container(
                    width: w/2.3,
                      child: CustomTextField(label: "Contact in Saudi")),
                ],
              ),
              SizedBox(height: 16),
              CustomTextField(label: "Permanent contact number"),

              SizedBox(height: 16),
              CustomTextField(label: "Email"),

              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: w/2.3,
                      child: CustomTextField(label: "Join Date")),Container(
                      width: w/2.3,
                      child: CustomTextField(label: "Duration")),
                ],
              ),
              SizedBox(height: 16),Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      width: w/2.3,
                      child: CustomTextField(label: "Designation")),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: w/2.3,
                      child: CustomTextField(label: "Iqama Number")),Container(
                      width: w/2.3,
                      child: CustomTextField(label: "Expiry")),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: w/2.3,
                      child: CustomTextField(label: "Baladiya Number")),Container(
                      width: w/2.3,
                      child: CustomTextField(label: "Expiry")),
                ],
              ),
              SizedBox(height: 16),Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: w/2.3,
                      child: CustomTextField(label: "Insurance number")),Container(
                      width: w/2.3,
                      child: CustomTextField(label: "Expiry")),
                ],
              ),
              SizedBox(height: 16),Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: w/2.3,
                      child: CustomTextField(label: "Passport Number")),Container(
                      width: w/2.3,
                      child: CustomTextField(label: "Expiry")),
                ],
              ),
              SizedBox(height: 16),
              // CustomTextField(label: "Job Details"),

              SizedBox(height: 16),
              // ElevatedButton(
              //   onPressed: () {},
              //   child: Text('Save Details'),
              //   style: ElevatedButton.styleFrom(
              //     minimumSize: Size(double.infinity, 50),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
