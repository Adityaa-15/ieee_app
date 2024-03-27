import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DownloadingDialog extends StatefulWidget {
  final String downloadUrl;
  final String fileName;

  const DownloadingDialog({
    Key? key,
    required this.downloadUrl,
    required this.fileName,
  }) : super(key: key);

  @override
  _DownloadingDialogState createState() => _DownloadingDialogState();
}

class _DownloadingDialogState extends State<DownloadingDialog> {
  late Dio dio;
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    dio = Dio();
    startDownloading();
  }

  void startDownloading() async {
    try {
      String path = await _getFilePath(widget.fileName);

      await dio.download(
        widget.downloadUrl,
        path,
        onReceiveProgress: (receivedBytes, totalBytes) {
          setState(() {
            progress = receivedBytes / totalBytes;
          });
        },
        deleteOnError: true,
      ).then((_) {
        Navigator.pop(context);
      });
    } catch (e) {
      setState(() {
        progress = -1.0; // Indicates download error
      });
    }
  }

  Future<String> _getFilePath(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    return "${dir.path}/$filename";
  }

  @override
  Widget build(BuildContext context) {
    String downloadingProgress = progress == -1.0
        ? 'Failed to download'
        : (progress * 100).toInt().toString();

    return AlertDialog(
      backgroundColor: Colors.black,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator.adaptive(
            value: progress == -1.0 ? null : progress,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            progress == -1.0
                ? 'Failed to download'
                : "Downloading: $downloadingProgress%",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }
}

class MagazinePage extends StatelessWidget {
  const MagazinePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Magazines"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade100, Colors.blue.shade300],
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildDownloadItem(
                    context,
                    'https://firebasestorage.googleapis.com/v0/b/ieee-f1294.appspot.com/o/Files%2FINNOVATION20.pdf?alt=media&token=35944a1c-acba-47f0-af5d-c45cbb8043a7',
                    'IEEE_magazine_2020.pdf',
                    'assets/images/magazine2020.jpeg', // Path to image asset
                    'Innovation20',
                  ),
                  SizedBox(height: 40),
                  _buildDownloadItem(
                    context,
                    'https://firebasestorage.googleapis.com/v0/b/ieee-f1294.appspot.com/o/Files%2FInnovation21.pdf?alt=media&token=026ed889-de9e-4b7e-88a2-7bf3c0b5da36',
                    'Innovation21.pdf',
                    'assets/images/magazine2021.jpeg', // Path to image asset
                    'Innovation21',
                  ),
                  SizedBox(height: 40),
                  _buildDownloadItem(
                    context,
                    'https://firebasestorage.googleapis.com/v0/b/ieee-f1294.appspot.com/o/Files%2FINNOVATION22.pdf?alt=media&token=e0b86346-9d36-42ca-b737-f754f665f94c',
                    'Innovation22.pdf',
                    'assets/images/magazine2022.jpeg', // Path to image asset
                    'Innovation22',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDownloadItem(BuildContext context, String downloadUrl,
      String fileName, String imagePath, String buttonText) {
    return Column(
      children: [
        SizedBox(
          height: 40, // Increased spacing between each image and button
        ),
        Image.asset(
          imagePath,
          width: 300, // Increased image width
          height: 300, // Increased image height
          fit: BoxFit.cover,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => DownloadingDialog(
                downloadUrl: downloadUrl,
                fileName: fileName,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              buttonText,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 40, // Increased spacing between each image and button
        ),
      ],
    );
  }
}