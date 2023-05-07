import 'package:flutter/material.dart';
import 'package:secondhand/screens/user/profile_page.dart';
// import 'package:marketky/constant/app_color.dart';
// import 'package:marketky/core/model/Review.dart';
import 'package:secondhand/utils/app_color.dart';
// import 'package:/smooth_star_rating/smooth_star_rating.dart';
import 'package:intl/intl.dart';

class ReviewTile extends StatelessWidget {
  // final Review review;
  // ReviewTile({@required this.review});
  final comment;

  const ReviewTile({super.key, required this.comment});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Photo
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProfilePage(
                  uid: comment['uid'],
                ),
              ),
            ),
            child: Container(
              width: 36,
              height: 36,
              margin: EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(100),
                image: DecorationImage(
                  image: NetworkImage(comment['profilePic']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Username - Rating - Comments
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Username - Rating
                  Container(
                    margin: EdgeInsets.only(bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 8,
                          child: Text(
                            comment['name'].toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColor.primary,
                                fontFamily: 'poppins'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Flexible(
                          flex: 4,
                          child: Text(
                            DateFormat.yMMMd()
                                .format(comment['datePublished'].toDate()),
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColor.primary,
                                fontFamily: 'poppins'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ),
                  // Comments
                  Text(
                    comment['text'].toString(),
                    style: TextStyle(
                        color: AppColor.secondary.withOpacity(0.7),
                        height: 150 / 100),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
