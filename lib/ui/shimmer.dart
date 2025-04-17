import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class AppShimmerWidget extends StatelessWidget {
  
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const AppShimmerWidget.rectangular({
     this.width = double.infinity,
     required this.height,
     this.shapeBorder = const RoundedRectangleBorder()
   });

  const AppShimmerWidget.circular({
     required this.width,
     required this.height,
     this.shapeBorder = const CircleBorder(),
  });

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
         baseColor: Theme.of(context).colorScheme.surfaceDim.withValues(alpha: 0.8),
         highlightColor: Theme.of(context).colorScheme.surface.withValues(alpha: 0.3),
         child: Container(
            width: width,
            height: height,
            decoration: ShapeDecoration(
               color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.6),
               shape: shapeBorder,
            ),
        ),
   );
}

class BlockShimmer extends StatelessWidget {

   @override 
    Widget build(BuildContext context) => Scaffold(
         body: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
               return buildBlockShimmer(context);
            }
         ),
      );

   Widget buildBlockShimmer(BuildContext context) => ListTile(
      leading: AppShimmerWidget.circular(height: 64, width: 64),
      trailing: AppShimmerWidget.circular(height: 20, width: 20,
                   shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3))
      ),
      title: Align(
         alignment: Alignment.centerLeft,
         child: AppShimmerWidget.rectangular(height: 20,
            width: MediaQuery.of(context).size.width * 0.3),
      ),
      subtitle: AppShimmerWidget.rectangular(height: 18),
   ); 
}


class AchievementShimmer extends StatelessWidget {
   @override 
    Widget build(BuildContext context) => Scaffold(
       body: Column(
         children: [ 
            SizedBox(height: 40),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: AppShimmerWidget.circular(height: 100, width: 100),
             ),
            ),
            SizedBox(height: 40),
            Container( 
                margin: EdgeInsets.symmetric(horizontal: 20), 
                child: AppShimmerWidget.rectangular(height: 30, 
                      shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                ),
            ),
            SizedBox(height: 40),
            Expanded(
             child: ListView.builder(
             itemCount: 5,
             itemBuilder: (context, index) {
                return buildBlockShimmer(context);
            }
          ),
         )
       ],
      ),
    );

   Widget buildBlockShimmer(BuildContext context) => ListTile(
         leading: AppShimmerWidget.circular(height: 64, width: 64),
         trailing: AppShimmerWidget.circular(height: 20, width: 20,
                  shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3))
         ),
         title: Align(
            alignment: Alignment.centerLeft,
            child: AppShimmerWidget.rectangular(height: 20,
                width: MediaQuery.of(context).size.width * 0.3),
         ),
         subtitle: AppShimmerWidget.rectangular(height: 18),
   ); 
}


class UsageShimmer extends StatelessWidget {
   @override 
   Widget build(BuildContext context) => Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12), 
        ),
        child: Wrap(
          spacing: 16.0,
          runSpacing: 16.0,
          children: [
            AppShimmerWidget.rectangular(
               width: 150, 
               height: 200,
               shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
            ),
            AppShimmerWidget.rectangular(
               width: 150, 
               height: 200,
               shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
            ),
            AppShimmerWidget.rectangular(
               width: 150, 
               height: 200,
               shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
            ),
          ]
        ),
     );
}

          
class GoalsShimmer extends StatelessWidget {
   @override 
   Widget build(BuildContext context) => Container(
       // padding: EdgeInsets.all(20),
       margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
       alignment: Alignment.center,
       decoration: BoxDecoration(
         color: Theme.of(context).colorScheme.surfaceContainerHigh,
         borderRadius: BorderRadius.circular(12), 
       ),
       child: Column(
         children: [ 
         Align(
           alignment: Alignment.centerRight,
           child: Container(
             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
             child: AppShimmerWidget.circular(height: 50, width: 50,
                shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
             ),
           ),
         ),
         Wrap(
           spacing: 16.0,
           runSpacing: 16.0,
           children: [
              AppShimmerWidget.rectangular(
               width: 150, 
               height: 200,
               shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
              ),
              AppShimmerWidget.rectangular(
               width: 150, 
               height: 200,
               shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
              ),
              AppShimmerWidget.rectangular(
               width: 150, 
               height: 200,
               shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
              ),
            ]
          ),
        ],
      ),
    );
}
          
class StatsShimmer extends StatelessWidget {

   final topWidget = Align(
       alignment: Alignment.centerLeft,
       child: Container(
         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
         child: AppShimmerWidget.circular(height: 20, width: 100,
            shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
        ),
      ),
   );

   final bottomWidget = AppShimmerWidget.rectangular(
        width: 350, 
        height: 250,
        shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
   );

   @override 
   Widget build(BuildContext context) => Container(
      // padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      alignment: Alignment.center,
      child: Wrap(
          spacing: 16.0,
          runSpacing: 16.0,
          children: [
            topWidget,
            bottomWidget,
        ],
      ),
    );
}



          
          
