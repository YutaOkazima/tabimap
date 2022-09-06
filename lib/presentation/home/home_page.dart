import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spring_button/spring_button.dart';

import '../../provider/add_marker_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<dynamic> addMarker(BuildContext context, WidgetRef ref) {
    final titelControllerProvider =
        ref.watch(titleControllerStateProvider.state);
    final titelDetailControllerProvider =
        ref.watch(titleDescriptionControllerStateProvider.state);

    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) {
        return Container(
          height: 400,
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.only(top: 32, left: 24, right: 24),
            child: Column(
              children: [
                TextFormField(
                  controller: titelControllerProvider.state,
                  decoration: InputDecoration(
                    hintText: 'タイトル',
                    hintStyle:
                        const TextStyle(fontSize: 16, color: Colors.black),
                    fillColor: Colors.grey[300],
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 1.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Colors.blue[600]!,
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: titelDetailControllerProvider.state,
                  minLines: 3,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    hintText: '感想',
                    hintStyle:
                        const TextStyle(fontSize: 16, color: Colors.black),
                    fillColor: Colors.grey[300],
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 1.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Colors.blue[600]!,
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                RatingBar.builder(
                  initialRating: 0,
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    //rateが変わったら処理を走らす
                    ref.read(rateProvider.state).update((state) => rating);
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 40,
                  width: 200,
                  child: SpringButton(
                    SpringButtonType.WithOpacity,
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                      ),
                      child: const Center(
                        child: Text(
                          '投稿',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      // ignore: avoid_print
                      print(ref.read(titleControllerStateProvider).text);
                      // ignore: avoid_print
                      print(ref
                          .read(titleDescriptionControllerStateProvider)
                          .text);
                      // ignore: avoid_print
                      print(ref.read(rateProvider).toString());
                      Navigator.of(context).pop();
                    },
                    onLongPress: null,
                    onLongPressEnd: null,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TabiMap'),
      ),
      body: const MapSample(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add_location_alt,
        ),
        onPressed: () => addMarker(context, ref),
      ),
    );
  }
}

//riverpod理解できてないけどとりあえずconsumerStatefulwidgetにした
class MapSample extends ConsumerStatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MapSampleState();
}

class _MapSampleState extends ConsumerState<MapSample> {
  final Completer<GoogleMapController> _controller = Completer();

  late LatLng _initialPosition;
  late bool _loading;

  @override
  void initState() {
    super.initState();
    _loading = true;
    _getUserLocation();
  }

  void _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const CircularProgressIndicator()
        : GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 10,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            //TODO: マーカー立てる
            // markers: _createMarker(),
            myLocationEnabled: true,
            //TODO: 現在地に戻るボタン作成
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
            buildingsEnabled: true,
            onTap: (LatLng latLang) {},
          );
  }
}
