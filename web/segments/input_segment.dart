import 'nodes.dart';
import '../render/render_util.dart';
import "../main.dart";
import "dart:html";

import 'label_segment.dart';

class InputSegment extends LabelSegment {
  Node? input;
  int index;

  InputSegment(this.index, [String? inputName]) : super("", deletable: true) {
    alignment = Alignment.left;
    super.text = "i$index : ${inputName ?? "input $index"}";
    leftPad = 10;
    // prevent "ix : " from being removed only right side should be modifiable
    minTextLength = 5;
  }

  @override
  render() {
    super.render();
    int color = clickedInputNode() ? 0xFF0000FF : 0xFFFFFFFF;
    if (uiManager.selectedNode != null && uiManager.selectedNode == this) {
      color = 0x00FF00FF;
    }
    drawCircle(x, y + height ~/ 2, 10, color);
    renderConnection();
    return super.render();
  }

  @override
  handleKeyboard(KeyboardEvent event) {
    var val = super.handleKeyboard(event);
    return val;
  }

  bool inRadius(int x, int y, int radius) {
    int xDif = x - uiManager.lastMouseX;
    int yDif = y - uiManager.getMouseY();
    // avoiding use sqrt
    int distanceSq = xDif * xDif + yDif * yDif;
    return distanceSq < radius * radius;
  }

  bool clickedInputNode() {
    return inRadius(x, y + height ~/ 2, 10);
  }

  void renderConnection() {
    if (input != null) {
      drawLine(x, y + height ~/ 2, input!.x + input!.width, input!.y + input!.height ~/ 2, 0xFF0000FF, lineWidth: 5);
    }
  }

  @override
  bool isOver() {
    return clickedInputNode();
  }

  String get indexName => text.substring(text.indexOf(":") + 2);

  static InputSegment fromMap(Map data) {
    InputSegment segment = InputSegment(data["index"], data["indexName"]);
    LabelSegment.applyMapData(segment, data);
    return segment;
  }

  @override
  Map toMap() {
    Map data = super.toMap();
    data["index"] = index;
    data["indexName"] = indexName;
    data["inputIndex"] = input == null ? -1 : uiManager.elements.indexOf(input!);
    return data;
  }
}