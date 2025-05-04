import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../models/package_user_model.dart';
import '../../core/constants/constant.dart';

class JoinerPackageUsersList extends StatelessWidget {
  final List<PackageUser> joiners;
  final bool isLoading;

  const JoinerPackageUsersList({
    Key? key,
    required this.joiners,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(ColorConstants.PRIMARY_COLOR),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              height: 20,
              width: 5,
            ),
            SizedBox(width: 10),
            Text(
              'Joined Users',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 10),
        joiners.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('No users have joined this package yet.'),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: joiners.length,
                itemBuilder: (context, index) {
                  final joiner = joiners[index];
                  return _buildJoinerCard(joiner);
                },
              ),
      ],
    );
  }

  Widget _buildJoinerCard(PackageUser joiner) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor:
                  Color(ColorConstants.PRIMARY_COLOR).withOpacity(0.2),
              child: FaIcon(
                FontAwesomeIcons.user,
                color: Color(ColorConstants.PRIMARY_COLOR),
                size: 16,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    joiner.user.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Passengers: ${joiner.numberOfPassengers}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Joined',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Text(
                  DateFormat('MMM d, yyyy').format(joiner.joinedAt.toLocal()),
                  style: TextStyle(
                    color: Color(ColorConstants.PRIMARY_COLOR),
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(ColorConstants.PRIMARY_COLOR),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              height: 20,
              width: 5,
            ),
            SizedBox(width: 10),
            Text(
              'Joined Users',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 10),
        for (int i = 0; i < 3; i++)
          Card(
            color: Colors.white,
            margin: EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 120,
                          height: 16,
                          color: Colors.grey[300],
                        ),
                        SizedBox(height: 8),
                        Container(
                          width: 80,
                          height: 14,
                          color: Colors.grey[300],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 60,
                        height: 12,
                        color: Colors.grey[300],
                      ),
                      SizedBox(height: 4),
                      Container(
                        width: 80,
                        height: 12,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
