import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:job_portal/constants.dart';

import '../AppColors.dart';
import '../Model/job_portal_model.dart';
import '../controller/job_portal_controller.dart';

class JobListScreen extends StatefulWidget{
  const JobListScreen({super.key});

  @override
  State<StatefulWidget> createState() {
  return JobListScreenState();
  }

}
class JobListScreenState extends State<JobListScreen>{
  final JobPortalListController jobController = Get.put(JobPortalListController());
  @override
  Widget build(BuildContext context) {
  //  final JobPortalListController jobController = Get.put(JobPortalListController());
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => jobController.isSearching.value
        ? TextFormField(
          controller: jobController.searchTextController,
          autofocus: true,
          onChanged: (query) => jobController.filterList(query),
          decoration: const InputDecoration(
            hintText: Constants.search,
            border: InputBorder.none,
            hintStyle: TextStyle(color: AppColors.black),
          ),
          style: const TextStyle(color: AppColors.black, fontSize: 16.0),
        ) : const Text('')),
        actions: <Widget>[
          IconButton(
            icon: Obx(() => Icon(jobController.isSearching.value ?  Icons.close : Icons.search)),
            onPressed: () {
              jobController.toggleSearch();
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.appColor,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                // Handle Home tap
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Handle Settings tap
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.contact_mail),
              title: Text('Contact Us'),
              onTap: () {
                // Handle Contact Us tap
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body:Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(Constants.findJobText,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
           SizedBox(height: 20,),
            Expanded(
              child: Obx(() {
                if (jobController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
               return ListView.builder(
                    itemCount: jobController.filteredList.length,
                    itemBuilder: (context, i){
                      return Card(
                        color: AppColors.white,
                          child: ListTile(
                            minVerticalPadding: 10,contentPadding: EdgeInsets.all(15),
                            //minTileHeight: 150,
                            onTap: jobController.filteredList[i].isApplied??false
                                ? null
                                : () {
                              detailBottomSheet(jobController.filteredList[i]);
                            },
                            dense: true,
                            leading: CircleAvatar(radius: 25,
                            backgroundColor: AppColors.grey,
                            foregroundColor: AppColors.grey,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),

                                child: Image.network(jobController.filteredList[i].thumbnailUrl??"")),
                            ),
                            title:Text( jobController.filteredList[i].title?.split(' ').take(2).join(' ')??"",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16), ),
                            subtitle: Text( jobController.filteredList[i].title??"",maxLines: 1,overflow: TextOverflow.ellipsis, ),
                        trailing:  CircleAvatar(radius: 20,
                      backgroundColor: jobController.filteredList[i].isApplied??false?AppColors.green:AppColors.appColor,
                      foregroundColor: jobController.filteredList[i].isApplied??false?AppColors.green:AppColors.appColor,
                      child:const Icon(Icons.square,color: AppColors.white,size: 10,)),

                          ));

                    });
              }),
            ),
          ],
        ),
      ),
    );
  }
  
  detailBottomSheet(JobPortalModel filteredList){
    return  showModalBottomSheet(
      elevation: 10,
      context: context,
      builder: (BuildContext context) {
        return Stack(clipBehavior: Clip.none, children: [
          Container(
            decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius:
                BorderRadius.vertical(top: Radius.circular(20))),
           width: MediaQuery.of(context).size.width,

            child:  Padding(padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: 50,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text( filteredList.title?.split(' ').take(2).join(' ')??"",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16), ),
                    const Icon(Icons.star,color: Colors.grey,)

                    ],
                  ),
                  const SizedBox(height: 10,),
                  Text( filteredList.title??"", ),
                  const SizedBox(height: 30,),
                  const Text(Constants.sDev,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                  const SizedBox(height: 30,),
                  const Text(Constants.dummyText,style: TextStyle(fontSize: 16),),
                  const SizedBox(height: 30,),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor:  AppColors.appColor,),
                      onPressed: filteredList.isApplied??false
                          ? null
                          : () async {
                        jobController.applyForJob(filteredList.id.toString());
                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
                          backgroundColor: AppColors.appColor,
                          content: Text(Constants.succSnackBarTxt),
                          duration: Duration(seconds: 2),));



                      }, child: const Text(Constants.applyBtn,style: TextStyle(color: AppColors.white),),),
                    ),
                  ),


                ],
              ),
            ),
          ),
          Positioned(
              top: -30,
              left: 30,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100)
                ),padding: EdgeInsets.all(15),
                child: FloatingActionButton(elevation: 0,

                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                  onPressed: () {},
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child:Image.network(filteredList.thumbnailUrl??"")),
                ),
              )),
        ]);
      },
    );
  }

}