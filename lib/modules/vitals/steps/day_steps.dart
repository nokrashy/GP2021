// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fristapp/modules/vitals/steps/cubit/cubit.dart';
// import 'package:fristapp/modules/vitals/steps/cubit/states.dart';
// import 'package:fristapp/shared/component/component.dart';

// class DaySteps extends StatelessWidget {
//   List<String> products = ["Test1", "Test2", "Test3"];
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<StepsCubit, StepsStates>(
//       listener: (context, state) {},
//       builder: (context, state) {
//         var cubit = StepsCubit.get(context);
//         return Scaffold(
//             body: Container(
//           child: ListView(
//             children: [
//               FutureBuilder(
//                 future: cubit.readData(
//                     from: cubit.getSelectedate(),
//                     to: cubit.getSelectedate().add(Duration(days: 1))),
//                 builder: ((context, AsyncSnapshot<List<Map>> snapshot) {
//                   if (snapshot.hasData) {
//                     return snapshot.data!.isEmpty
//                         ? Center(child: Text('There Is No Steps Yet'))
//                         : ListView.builder(
//                             physics: NeverScrollableScrollPhysics(),
//                             shrinkWrap: true,
//                             itemCount: snapshot.data!.length,
//                             itemBuilder: ((context, index) {
//                               return Column(
//                                 children: [
//                                   Card(
//                                     child: ListTile(
//                                       title: Text(
//                                           '${snapshot.data![index]['stepsvalue']}'),
//                                       leading: Text(
//                                           '${snapshot.data![index]['stepsdate']}'),
//                                     ),
//                                   ),
//                                 ],
//                               );
//                             }),
//                           );
//                   }
//                   return Center(child: CircularProgressIndicator());
//                 }),
//               ),
//             ],
//           ),
//         )

//             // Padding(
//             //   padding: const EdgeInsets.all(20.0),
//             //   child: Column(
//             //     children: <Widget>[
//             //       Expanded(
//             //         child: Container(
//             //           height: 500.0,
//             //           child: ListView.separated(
//             //               itemBuilder: (context, index) {
//             //                 return Container(
//             //                   height: 50,
//             //                   child: Column(
//             //                     children: [
//             //                       SizedBox(
//             //                         height: 10.0,
//             //                       ),
//             //                       Row(
//             //                         children: [
//             //                           Text('Date: '),
//             //                           Text('${cubit.date_selected[index]}'),
//             //                         ],
//             //                       ),
//             //                       Row(
//             //                         children: [
//             //                           Text('Value: '),
//             //                           Text(
//             //                               '${cubit.stepsValues_selected[index]}'),
//             //                         ],
//             //                       )
//             //                     ],
//             //                   ),
//             //                 );
//             //               },
//             //               itemCount: cubit.stepsValues_selected.length,
//             //               separatorBuilder: (context, index) => MyDivider()),
//             //         ),
//             //       ),
//             //     ],
//             //   ),
//             // ),

//             );
//       },
//     );
//   }
// }
