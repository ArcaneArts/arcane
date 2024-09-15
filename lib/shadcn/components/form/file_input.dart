import 'package:arcane/arcane.dart';

Widget _buildFileIcon(String extension) {
  switch (extension) {
    case 'pdf':
      return const Icon(Icons.file_pdf);
    case 'doc':
    case 'docx':
      return const Icon(Icons.file_doc);
    case 'xls':
    case 'xlsx':
      return const Icon(Icons.file_xls);
    case 'ppt':
    case 'pptx':
      return const Icon(Icons.file_ppt);
    case 'zip':
    case 'rar':
      return const Icon(Icons.file_zip);
    case 'jpg':
    case 'jpeg':
    case 'png':
    case 'gif':
      return const Icon(Icons.file_image);
    case 'mp3':
    case 'wav':
      return const Icon(Icons.file_audio);
    case 'mp4':
    case 'avi':
    case 'mkv':
      return const Icon(Icons.file_video);
    default:
      return const Icon(Icons.file);
  }
}

class SingleFileInput extends StatelessWidget {
  final XFile? file;
  final ValueChanged<XFile?>? onChanged;
  final bool acceptDrop;
  final bool enabled;

  const SingleFileInput({
    super.key,
    this.file,
    this.onChanged,
    this.acceptDrop = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
