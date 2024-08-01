import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import '../Model/job_portal_model.dart';


class JobPortalListController extends GetxController {
  var isLoading = true.obs;
  List<JobPortalModel> jobList=[];
  var isSearching = false.obs;
  var searchTextController = TextEditingController();

  var filteredList = <JobPortalModel>[].obs;


  @override
  void onInit() {
    fetchUser();  // Fetch user with id 1 for example
    filteredList.addAll(jobList);
    super.onInit();
  }

  Future<List<JobPortalModel>> fetchUser() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1/photos'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        jobList.addAll(data.map((json) => JobPortalModel.fromJson(json as Map<String, dynamic>)).toList());
        filteredList.addAll(jobList);
        return data.map((json) => JobPortalModel.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Failed to load user');
      }
    } finally {
      isLoading(false);
    }
  }

  void filterList(String query) {
    if (query.isEmpty) {
      filteredList.assignAll(jobList);
    } else {
      filteredList.assignAll(
        jobList.where((item) => item.title!.toLowerCase().contains(query.toLowerCase())).toList(),
      );
    }
  }

  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      searchTextController.clear();
      filterList('');
    }
  }

  void applyForJob(String jobId) {
    var job = filteredList.firstWhere((job) => job.id.toString() == jobId);
    job.isApplied = true;
    filteredList.refresh(); // Update the UI


  }

  /*void fetchUser() async {
    try {
      isLoading(true);
      var fetchedUser = await _apiService.fetchUser();
      jobList = fetchedUser;
    } finally {
      isLoading(false);
    }
  }*/
}