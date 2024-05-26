import 'package:chat_app/providers/agora_provider.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:provider/provider.dart';

class VideoCallScreen extends StatelessWidget {
  const VideoCallScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final agoraProvider = Provider.of<AgoraProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora Video Call'),
      ),
      body: Stack(
        children: [
          Center(
            child: _remoteVideo(agoraProvider),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 100,
              height: 150,
              child: Center(
                child: agoraProvider.localUserJoined
                    ? AgoraVideoView(
                        controller: VideoViewController(
                          rtcEngine: agoraProvider.engine,
                          canvas: const VideoCanvas(uid: 0),
                        ),
                      )
                    : const CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _remoteVideo(AgoraProvider agoraProvider) {
    if (agoraProvider.remoteId != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: agoraProvider.engine,
          canvas: VideoCanvas(uid: agoraProvider.remoteId),
          connection: const RtcConnection(channelId: channel),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }
}
