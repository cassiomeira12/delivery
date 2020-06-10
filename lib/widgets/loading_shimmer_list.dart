import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        child: ListView.builder(
            itemCount: 5,
            itemBuilder: (_, __) {
              return loadingItem(context);
            }
        ),
      ),
    );
  }

  Widget loadingItem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48.0,
            height: 48.0,
            margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                width: 1,
                color: Theme.of(context).hintColor,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 5,),
                Container(width: MediaQuery.of(context).size.width, height: 8.0, color: Colors.white,),
                SizedBox(height: 5,),
                Container(width: MediaQuery.of(context).size.width / 2, height: 8.0, color: Colors.white,),
                SizedBox(height: 5,),
                Container(width: MediaQuery.of(context).size.width / 5, height: 8.0, color: Colors.white,),
                SizedBox(height: 1,),
              ],
            ),
          )
        ],
      ),
    );
  }

}
