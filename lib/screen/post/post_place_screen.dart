import 'dart:convert';
import 'package:disney_app/core/theme/app_color_style.dart';
import 'package:disney_app/core/theme/app_text_style.dart';
import 'package:disney_app/gen/l10n.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PostPlaceScreen extends StatefulWidget {
  const PostPlaceScreen({super.key});

  @override
  PostPlaceScreenState createState() => PostPlaceScreenState();
}

class PostPlaceScreenState extends State<PostPlaceScreen> {
  final _scrollController = ScrollController();
  List<String> attractions = [];
  String? nextPageToken;
  bool isLoading = false;
  bool isAdditionalLoading = false;
  bool initialLoadCompleted = false;

  @override
  void initState() {
    super.initState();
    _loadMore();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<String> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return '35.6895,139.6917';
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return '35.6895,139.6917';
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return '35.6895,139.6917';
    }
    final geolocator = await Geolocator.getCurrentPosition();
    final location = '${geolocator.latitude},${geolocator.longitude}';
    return location;
  }

  Future<void> _loadMore() async {
    if (!isLoading && nextPageToken != 'END') {
      setState(() {
        isLoading = true;
        if (initialLoadCompleted) {
          isAdditionalLoading = true;
        }
      });

      final newAttractions = await fetchDisneyAttractions(nextPageToken);

      if (newAttractions.isEmpty) {
        nextPageToken = 'END';
      }

      setState(() {
        attractions.addAll(newAttractions);
        isLoading = false;
        isAdditionalLoading = false;
        initialLoadCompleted = true;
      });
    }
  }

  Future<List<String>> fetchDisneyAttractions([String? pageToken]) async {
    const apiKey = 'AIzaSyBH0tg0LPhmEVp8LwIYnLTBHb19dZR84kY';
    var location = '35.6895,139.6917';
    const radius = '50000';
    const type = 'tourist_attraction';
    const keyword = 'テーマパーク';
    location = await _getCurrentLocation();
    final url = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/nearbysearch/json',
      {
        'location': location,
        'radius': radius,
        'type': type,
        'keyword': keyword,
        'language': 'ja',
        'key': apiKey,
        if (pageToken != null) 'pagetoken': pageToken,
      },
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      nextPageToken = data['next_page_token'];
      return data['results']
          .map<String>((result) => result['name'].toString())
          .toList();
    } else {
      throw Exception('Failed to fetch attractions');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          l10n.post_place_title,
          style: AppTextStyle.appBoldBlack20TextStyle,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
      ),
      body: initialLoadCompleted
          ? ListView.builder(
              controller: _scrollController,
              itemCount: attractions.length + (isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == attractions.length && isAdditionalLoading) {
                  return LoadingAnimationWidget.dotsTriangle(
                    color: AppColorStyle.appColor,
                    size: 50,
                  );
                }
                return ListTile(
                  onTap: () {
                    Navigator.pop(context, attractions[index]);
                  },
                  title: Text(
                    attractions[index],
                  ),
                );
              },
            )
          : Center(
              child: LoadingAnimationWidget.dotsTriangle(
                color: AppColorStyle.appColor,
                size: 50,
              ),
            ),
      bottomNavigationBar: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 50,
      ),
    );
  }
}
