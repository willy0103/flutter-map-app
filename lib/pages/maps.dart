import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:modernlogintute/components/map_button.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MapsPage extends StatefulWidget {
  const MapsPage({Key? key}) : super(key: key);
  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  // 初始位置設定為台灣南投
  late LatLng _currentPosition = const LatLng(23.5832, 120.5825);
  // ignore: unused_field
  File? _imageFile;
  // 創建 GlobalKey 對象
  final Map<String, Marker> _markers = {};
  late GoogleMapController _mapController;
  // ignore: unused_field
  late Timer _timer;
  late IO.Socket socket;

  @override
  void initState() {
    socket = IO.io(
        'http://192.168.0.108:4000',
        IO.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect()
            .build());
    socket.connect();
    super.initState();
    // 每秒獲取一次位置
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _getCurrentLocation();
    });
  }

  // 地圖建立完成時的回調
  // ignore: unused_element
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    // 将初始Marker添加到Map中
    addMarker('center', _currentPosition);
  }

  void _setImageFile(File? file) {
    setState(() {
      _imageFile = file;
    });
  }

  // 獲取當前位置的方法
  void _getCurrentLocation() async {
    // 檢查位置權限
    var status = await Permission.locationWhenInUse.request();
    if (status != PermissionStatus.granted) {
      print('位置權限被拒絕');
      return;
    }

    // 使用 geolocator 插件獲取當前位置
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // 檢查當前位置是否有改變
    if (_currentPosition != LatLng(position.latitude, position.longitude)) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        // 更新標記 Marker
        addMarker('center', _currentPosition);
      });
      var location = {
        "latitude": position.latitude,
        "longitude": position.longitude
      };
      // 發送位置數據到後端
      socket.emit("sendLocation", location);
    }
  }

  @override
  void dispose() {
    _timer.cancel(); // 停止計時器
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            // 初始鏡頭設定為當前位置
            initialCameraPosition: CameraPosition(
              target: _currentPosition,
              zoom: 15,
            ),
            // 地圖建立完成時的回調
            onMapCreated: _onMapCreated,
            // 標記 Marker
            markers: _markers.values.toSet(),

            zoomControlsEnabled: false,

            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.01,
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 35),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // google button
                      MapButton1(imagePath: 'lib/images/voice-mail.png'),

                      SizedBox(width: 70),

                      // apple button
                      MapButton2(imagePath: 'lib/images/snapchat.png'),

                      SizedBox(width: 70),

                      MapButton3(imagePath: 'lib/images/feedback.png'),
                    ],
                  ),
                ),
                Positioned(
                  top: 650,
                  child: MapButton4(
                    imagePath: 'lib/images/location.png',
                    onPressed: () {
                      _goToCurrentLocation();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _goToCurrentLocation() async {
    var currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    _mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(
          currentPosition.latitude,
          currentPosition.longitude,
        ),
        zoom: 15,
      ),
    ));
  }

  Uint8List _cachedImageData = Uint8List(0);
  Future<void> addMarker(String id, LatLng currentPosition) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    // 如果缓存中没有数据，则向后端请求图像数据
    if (_cachedImageData.isEmpty) {
      try {
        final response = await http.get(
          Uri.parse('http://192.168.0.108:3000/user/getImg'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          // 将图片数据转换为Uint8List对象并缓存起来
          _cachedImageData = response.bodyBytes;
        } else {
          print('Failed to load image');
        }
      } catch (e) {
        print('Error: $e');
        return;
      }
    }

    // 使用缓存中的数据来创建Marker
    final bitmapDescriptor = BitmapDescriptor.fromBytes(_cachedImageData);

    setState(() {
      _markers[id] = Marker(
          markerId: MarkerId(id),
          position: currentPosition,
          icon: bitmapDescriptor,
          onTap: () {
            // 當 Marker 被點擊時，先將地圖的攝像頭移動到 Marker 的位置，並縮放至 20 級
            _mapController
                .animateCamera(CameraUpdate.newLatLngZoom(currentPosition, 20));
            // 顯示 Marker 的信息視窗，並將攝像頭縮放至 20 級
            _mapController.showMarkerInfoWindow(MarkerId(id)).then(
                (value) => _mapController.moveCamera(CameraUpdate.zoomTo(20)));
            // 移動攝像頭到 Marker 的位置
            _mapController.showMarkerInfoWindow(MarkerId(id)).then((value) =>
                _mapController
                    .moveCamera(CameraUpdate.newLatLng(currentPosition)));
          });
    });
  }
}
