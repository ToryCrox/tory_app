import 'package:common/common.dart';
import 'package:flutter/material.dart';

class CustomTableLayout extends StatelessWidget {
  const CustomTableLayout({
    super.key,
    required this.titles,
    required this.cellHeight,
    required this.tableRows,
    required this.tailCells,
    required this.radius,
    required this.borderSide,
    required this.textStyle,
    required this.titleColor,
    required this.titleStyle,
  });

  final List<Widget> titles;

  final List<List<Widget>> tableRows;

  final List<TailCell> tailCells;

  final double cellHeight;

  final Radius radius;

  final BorderSide borderSide;

  final TextStyle textStyle;

  final Color titleColor;

  final TextStyle titleStyle;

  @override
  Widget build(BuildContext context) {
    final columnCount = tableRows.first.length;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: cellHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: radius),
            color: titleColor,
          ),
          child: DefaultTextStyle(
            style: titleStyle,
            child: Row(
              children: [
                for (var title in titles)
                  Expanded(
                    child: Center(child: title),
                  ),
              ],
            ),
          ),
        ),
        Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _TableBorderPainter(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: borderSide,
                  cellHeight: cellHeight,
                  rowCount: tableRows.length,
                  columnCount: columnCount,
                  tailCells: tailCells,
                ),
              ),
            ),
            DefaultTextStyle(
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
              ).merge(textStyle),
              child: Row(
                children: [
                  Expanded(
                    flex: columnCount,
                    child: _buildTable(),
                  ),
                  Expanded(
                    flex: 1,
                    child: _buildTail(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTable() {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        for (var row in tableRows)
          TableRow(
            children: [
              for (var cell in row)
                TableCell(
                  child: SizedBox(
                    height: cellHeight,
                    child: Center(child: cell),
                  ),
                ),
            ],
          ),
      ],
    );
  }

  Widget _buildTail() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (var tailCell in tailCells)
          SizedBox(
            height: cellHeight * (tailCell.end - tailCell.begin + 1),
            child: Center(child: tailCell.child),
          ),
      ],
    );
  }
}

class TailCell {
  final int begin;
  final int end;
  final Widget child;

  TailCell({
    required this.begin,
    required this.end,
    required this.child,
  });
}

class _TableBorderPainter extends CustomPainter {
  _TableBorderPainter({
    required this.borderRadius,
    required this.borderSide,
    required this.cellHeight,
    required this.rowCount,
    required this.columnCount,
    required this.tailCells,
  });

  final BorderRadius borderRadius;
  final BorderSide borderSide;
  final double cellHeight;
  final int rowCount;
  final int columnCount;
  final List<TailCell> tailCells;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = borderSide.color
      ..strokeWidth = borderSide.width
      ..style = PaintingStyle.stroke;
    final cellWidth = size.width / (columnCount + 1);
    final firstIndex = tailCells.first.begin;
    /// 1. 绘制横线, 不包括顶部和底部
    for (var i = 1; i < rowCount; i++) {
      final y = i * cellHeight;
      final matchEnd = tailCells.any((e) => e.end - firstIndex == i);
      canvas.drawLine(
        Offset(0, y),
        Offset(matchEnd ? size.width : size.width - cellWidth, y),
        paint,
      );
    }

    /// 2. 绘制竖线, 不包括左侧和右侧
    for(var i = 1; i < columnCount + 1; i++) {
      final x = i * cellWidth;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    /// 绘制边框， 不绘制顶部
    final borderHalf = borderSide.width / 2;
    final path = Path();
    path.moveTo(borderHalf, 0);
    path.lineTo(borderHalf, size.height - borderRadius.bottomLeft.y - borderHalf);
    // 绘制左下圆角
    path.arcToPoint(
      Offset(borderRadius.bottomLeft.x + borderHalf, size.height - borderHalf),
      radius: borderRadius.bottomLeft,
      clockwise: false,
    );
    path.lineTo(size.width - borderRadius.bottomRight.x - borderHalf, size.height - borderHalf);
    path.arcToPoint(
      Offset(size.width - borderHalf, size.height - borderRadius.bottomRight.y),
      radius: borderRadius.bottomRight,
      clockwise: false,
    );
    path.lineTo(size.width - borderHalf, 0);
    canvas.drawPath(path, paint);

  }

  @override
  bool shouldRepaint(covariant _TableBorderPainter oldDelegate) {
    return borderSide != oldDelegate.borderSide ||
        cellHeight != oldDelegate.cellHeight ||
        rowCount != oldDelegate.rowCount ||
        columnCount != oldDelegate.columnCount ||
        tailCells != oldDelegate.tailCells;
  }
}
