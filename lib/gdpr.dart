import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:test_tp21/lang/demo_localization.dart';

class GdprDialog extends StatelessWidget{
  GdprDialog({
    Key? key,
    this.radius = 8,
    required this.mdFileName,
  }) : assert(mdFileName.contains('.md')), super (key: key);
  final double radius;
  final String mdFileName;

  final style = MarkdownStyleSheet(
    h2Align: WrapAlignment.center,
  );

  @override
  Widget build(BuildContext context){
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      child: SizedBox(
        width: 750,
        child:  Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: rootBundle.loadString('assets/$mdFileName'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Markdown(
                    styleSheet: style,
                    data: snapshot.data.toString(),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: SizedBox(
                  height: 28,
                  width: 115,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("Close"),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      overlayColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                        if (states.contains(MaterialState.hovered)) {
                          return const Color.fromRGBO(62, 119, 182, 1);
                        }
                        return null;
                      }),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      ),
    );
  }
}
