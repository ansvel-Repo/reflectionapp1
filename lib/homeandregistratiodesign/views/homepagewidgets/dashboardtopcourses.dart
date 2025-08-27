import 'package:ansvel/homeandregistratiodesign/util/colors.dart';
import 'package:ansvel/homeandregistratiodesign/util/constants/sizes.dart';
import 'package:ansvel/loginapp/src/features/core/models/dashboard/courses_model.dart';
import 'package:flutter/material.dart';
// import 'package:ansvel/ridewithme/themes/app_them_data.dart';

// import '../../../../../constants/colors.dart';
// import '../../../../../constants/sizes.dart';
// import '../../../models/dashboard/courses_model.dart';

class DashboardTopCourses extends StatelessWidget {
  const DashboardTopCourses({
    Key? key,
    required this.txtTheme,
    required this.isDark,
  }) : super(key: key);

  final TextTheme txtTheme;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final list = DashboardTopCoursesModel.list;
    return SizedBox(
      height: 250,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: list[index].onPress,
          child: SizedBox(
            width: 350,
            height: 300,
            child: Padding(
              padding: const EdgeInsets.only(right: 10, top: 5),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: isDark ? tSecondaryColor : Colors.deepPurple[100],
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title and Image Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            list[index].title,
                            style: txtTheme.headlineMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Flexible(
                          child: Image(
                            image: AssetImage(list[index].image),
                            height: 110,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),

                    /// Play Button and Text Info Row
                    Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 20, shape: const CircleBorder()),
                          onPressed: () {},
                          child: const Icon(Icons.play_arrow),
                        ),
                        const SizedBox(width: tDashboardCardPadding),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                list[index].heading,
                                style: txtTheme.headlineMedium,
                                softWrap: true, // ✅ This ensures wrapping
                              ),
                              Text(
                                list[index].subHeading,
                                style: txtTheme.bodyMedium,
                                softWrap: true, // ✅ This ensures wrapping
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
