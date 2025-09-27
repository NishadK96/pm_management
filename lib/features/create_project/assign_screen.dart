import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipsum_user/core/constants/icon_constants.dart';
import 'package:ipsum_user/core/theme/app_colors.dart';
import 'package:ipsum_user/core/widgets/long_button.dart';

class AssignProjectScreen extends StatefulWidget {

   AssignProjectScreen({super.key});

  @override
  State<AssignProjectScreen> createState() => _AssignProjectScreenState();
}

class _AssignProjectScreenState extends State<AssignProjectScreen> {
  final List<String> names = [
    "Razi",
    "Rabi",
    "Siraj",
    "Sreehari",
    "Rzi",
    "Ram",
    "Ravi",
    "Shami",
  ];

   // Track selected contacts
   final Set<String> selectedNames = {};

   // Colors for avatars
   final List<Color> avatarColors = [
     Colors.teal,
     Colors.yellow,
     Colors.pink,
     Colors.orange,
     Colors.red,
     Colors.blueGrey,
   ];

  @override
  Widget build(BuildContext context) {
    var h=MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Container(
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: const Color(0xFFE6ECF0),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          shadows: [
            BoxShadow(
              color: Color(0x05000000),
              blurRadius: 8,
              offset: Offset(1, 1),
              spreadRadius: 0,
            )
          ],
        ),
        padding: EdgeInsets.only(left: 16),
        child: TextFormField(
          // controller: projectTitleController,
          // maxLines: 3,
          // readOnly: true,

          decoration:  InputDecoration(
              border: InputBorder.none,
              hintStyle: GoogleFonts.poppins(fontSize: 14),
            hint: Text("Search ...",style: GoogleFonts.poppins(fontSize: 14),),
            suffixIcon: Container(padding: EdgeInsets.all(10),child: SvgPicture.string(IconConst().closeIcon,))
          ),
        ),
      ),),
      body: Column(
        children: [
          SizedBox(
            height: h/1.4,
            child: ListView.separated(
              itemCount: names.length,
              physics: NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                String name = names[index];
                bool isSelected = selectedNames.contains(name);

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: avatarColors[index % avatarColors.length],
                    child: Text(
                      name[0],
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(name),
                  trailing:  GestureDetector(
                    onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedNames.remove(name);
                    } else {
                      selectedNames.add(name);
                    }
                  });
                },
                child: SvgPicture.string(
                 IconConst().unSelectIcon,   // ✅ your custom checked icon
                color:   isSelected
                  ?AppColors.primary:AppColors.grey, // ⬜ your custom unchecked icon
                width: 15,
                height: 15,
                ),
                ),
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedNames.remove(name);
                      } else {
                        selectedNames.add(name);
                      }
                    });
                  },
                );
              },
            ),
          ),

          SizedBox(height: 40,),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),

            child:LongButton(label:  'Assign Project' , onTap: (){})


          )
        ],
      ),
    );
  }
}

