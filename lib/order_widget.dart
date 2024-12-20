import 'package:flutter/material.dart'; // Flutter UI 위젯 라이브러리
import 'models.dart'; // TableModel 데이터를 가져오기 위해 사용

/// OrderWidget
/// 선택된 테이블의 정보를 표시하고 메뉴 주문 및 결제를 관리하는 위젯입니다.
class OrderWidget extends StatefulWidget {
  final TableModel table; // 선택된 테이블 정보
  final VoidCallback onClearOrders; // 주문 초기화(결제) 버튼 클릭 시 실행될 함수
  final Function(String orderDetails) onOrderPlaced; // 주문 버튼 클릭 시 실행될 함수
  final VoidCallback onOrderChanged; // 주문 상태 변경 시 호출될 함수

  const OrderWidget({
    required this.table,
    required this.onClearOrders,
    required this.onOrderPlaced,
    required this.onOrderChanged,
    super.key,
  });

  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  int steakCount = 0;
  int pastaCount = 0;
  int riceSteakCount = 0;
  int creamUdonCount = 0;
  int cokeCount = 0;

  void _incrementCount(Function(int) setter, int currentValue) {
    setState(() {
      setter(currentValue + 1);
    });
  }

  void _decrementCount(Function(int) setter, int currentValue) {
    if (currentValue > 0) {
      setState(() {
        setter(currentValue - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Text(
            '${widget.table.tableNumber}번 테이블',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 10),
        _buildMenuItem(
          menuName: "윤씨함박스테이크정식",
          count: steakCount,
          onIncrement: () => _incrementCount((value) => steakCount = value, steakCount),
          onDecrement: () => _decrementCount((value) => steakCount = value, steakCount),
        ),
        _buildMenuItem(
          menuName: "머쉬룸투움바파스타",
          count: pastaCount,
          onIncrement: () => _incrementCount((value) => pastaCount = value, pastaCount),
          onDecrement: () => _decrementCount((value) => pastaCount = value, pastaCount),
        ),
        _buildMenuItem(
          menuName: "함박스테이크와 계란볶음밥",
          count: riceSteakCount,
          onIncrement: () => _incrementCount((value) => riceSteakCount = value, riceSteakCount),
          onDecrement: () => _decrementCount((value) => riceSteakCount = value, riceSteakCount),
        ),
        _buildMenuItem(
          menuName: "명란크림우동과 계란볶음밥",
          count: creamUdonCount,
          onIncrement: () => _incrementCount((value) => creamUdonCount = value, creamUdonCount),
          onDecrement: () => _decrementCount((value) => creamUdonCount = value, creamUdonCount),
        ),
        _buildMenuItem(
          menuName: "코카콜라",
          count: cokeCount,
          onIncrement: () => _incrementCount((value) => cokeCount = value, cokeCount),
          onDecrement: () => _decrementCount((value) => cokeCount = value, cokeCount),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLargeButton(
              text: '주문',
              onPressed: () {
                // 1개 이상인 메뉴만 주문 내역에 포함
                final List<String> orderList = [];
                if (steakCount > 0) orderList.add("윤씨함박스테이크정식: $steakCount개");
                if (pastaCount > 0) orderList.add("머쉬룸투움바파스타: $pastaCount개");
                if (riceSteakCount > 0) orderList.add("함박스테이크와 계란볶음밥: $riceSteakCount개");
                if (creamUdonCount > 0) orderList.add("명란크림우동과 계란볶음밥: $creamUdonCount개");
                if (cokeCount > 0) orderList.add("코카콜라: $cokeCount개");

                final orderDetails = orderList.join(", ");

                if (orderDetails.isNotEmpty) {
                  widget.onOrderPlaced(orderDetails); // 주문 내역 전달
                  setState(() {
                    widget.table.hasOrders = true; // 테이블 점유 상태 설정
                    widget.table.orderDetails = orderDetails; // 주문 내역 저장
                  });
                  widget.onOrderChanged(); // 서버 업데이트
                }
              },
            ),
            const SizedBox(width: 10),
            _buildLargeButton(
              text: '결제',
              onPressed: () {
                final tableNumber = widget.table.tableNumber;
                widget.onClearOrders(); // 주문 초기화
                setState(() {
                  widget.table.hasOrders = false; // 테이블 점유 상태 초기화
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "$tableNumber번 테이블의 결제가 완료되었습니다.",
                        style: const TextStyle(
                          fontSize: 24, // 글씨 크기
                          fontWeight: FontWeight.bold, // 굵은 글씨
                        ),
                      ),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                });
                widget.onOrderChanged(); // 서버 업데이트
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required String menuName,
    required int count,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              menuName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Row(
            children: [
              _buildCountButton(icon: Icons.remove, onPressed: onDecrement),
              SizedBox(
                width: 50,
                child: Center(
                  child: Text(
                    "$count",
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              _buildCountButton(icon: Icons.add, onPressed: onIncrement),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCountButton({required IconData icon, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
        color: Colors.black,
      ),
    );
  }

  Widget _buildLargeButton({required String text, required VoidCallback onPressed}) {
    return SizedBox(
      width: 180,
      height: 80,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}









