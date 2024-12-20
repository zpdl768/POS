import 'package:flutter/material.dart';
import 'models.dart'; // 테이블 데이터 모델 클래스

class TableWidget extends StatefulWidget {
  final List<TableModel> tables; // 테이블 목록 데이터
  final Function(TableModel) onTableSelected; // 테이블 선택 시 호출되는 콜백 함수

  const TableWidget({
    required this.tables,
    required this.onTableSelected,
    super.key,
  });

  @override
  _TableWidgetState createState() => _TableWidgetState();
}

class _TableWidgetState extends State<TableWidget> {
  // 테이블에 표시할 주문 내역을 저장하는 맵 (테이블 번호 -> 주문 내역)
  final Map<int, String> tableOrders = {};
  int? selectedTableNumber; // 현재 선택된 테이블 번호
  /// 테이블에 주문 내역을 추가하는 메서드
  void updateOrder(int tableNumber, String orderDetails) {
    setState(() {
      tableOrders[tableNumber] = orderDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 테이블 목록 (GridView)
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5, // (17) 가로에 5개 테이블 배치
              mainAxisSpacing: 8.0, // 세로 간격
              crossAxisSpacing: 8.0, // 가로 간격
              childAspectRatio: 1.0, // 정사각형 비율
            ),
            itemCount: widget.tables.length,
            itemBuilder: (context, index) {
              final table = widget.tables[index];
              final isSelected = selectedTableNumber == table.tableNumber;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTableNumber = table.tableNumber;
                  });
                  widget.onTableSelected(table);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: table.hasOrders
                        ? Colors.orangeAccent // 점유된 상태: 주황색 배경
                        : Colors.white, // 비어있는 상태: 흰색 배경
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.black, // 선택 여부에 따라 테두리 색상 변경
                      width: isSelected ? 5.0 : 1.0, // 선택된 테두리는 두껍게
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // (18) 테이블 번호와 좌석 수 (중앙 상단)
                      Text(
                        '${table.tableNumber}번 (${table.seats}인용)',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const Spacer(), // 위쪽과 아래를 구분하는 여백
                      // (19) 주문 내역 표시
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          table.orderDetails.isNotEmpty
                              ? table.orderDetails // 주문 내역 표시
                              : "", // 기본 메시지
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        
      ],
    );
  }
}







