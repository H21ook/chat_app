import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:chat_app/utils/print.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

const appId = "17deeb6fb72d4db29de8d371183f1d16";
// const token =
//     "007eJxTYDBIbDVXCtGcWbHyU56p5KW9blJ3+KRV8lx+1yxqdlkVLqbAYGiekpqaZJaWZG6UYpKSZGSZkmqRYmxuaGhhnGaYYmjGvnJJakMgI4ON0jZWRgYIBPF5GEJSi0sUnDMS8/JScxgYAHVFH3s=";
// const channel = "Test Channel";

const token =
    "007eJxTYBCWmO5scUKlmGfit23c739c5HfbvOzW18ULm0yUa5vLBKcqMBiap6SmJpmlJZkbpZikJBlZpqRapBibGxpaGKcZphiayb1YkirAx8Dwh+0NKyMDBIL4zAwZGamsDIZGxkbGALMTHz8=";
const channel = "hhe";

class AgoraProvider with ChangeNotifier {
  late RtcEngine _engine;
  int? _remoteUid;
  bool _localUserJoined = false;

  RtcEngine get engine => _engine;
  bool get localUserJoined => _localUserJoined;
  int? get remoteId => _remoteUid;

  Future<void> init() async {
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          dPrint("local user ${connection.localUid} joined");
          _localUserJoined = true;
          notifyListeners();
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          dPrint("remote user $remoteUid joined");
          _remoteUid = remoteUid;
          notifyListeners();
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          dPrint("remote user $remoteUid left channel");
          _remoteUid = null;
          notifyListeners();
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();
    await _engine.startPreview();

    await _engine.joinChannel(
      token: token,
      channelId: channel,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  Future<void> unmount() async {
    await _engine.leaveChannel();
    await _engine.release();
  }
}
