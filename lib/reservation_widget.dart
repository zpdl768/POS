import 'package:flutter/material.dart';
import 'models.dart';
import 'server_service.dart';

/// 예약 주문 위젯: 오른쪽 하단 "QuickOrder 주문" 영역을 담당
class ReservationWidget extends StatefulWidget {
  final Function(Order) onOrderAccepted; // 수락 시 호출될 콜백 함수

  const ReservationWidget({required this.onOrderAccepted, super.key});

  @override
  _ReservationWidgetState createState() => _ReservationWidgetState();
}

class _ReservationWidgetState extends State<ReservationWidget> {
  final serverService = ServerService();
  Order? currentOrder; // 수신된 주문 데이터

  

  /// 주기적으로 서버에서 주문 데이터를 가져오는 메서드
  void fetchOrderPeriodically() {
    fetchOrderFromServer(); // 초기 호출
    Future.delayed(const Duration(seconds: 20), fetchOrderPeriodically); // 5초마다 반복
  }

  /// 서버로부터 주문 데이터를 가져오는 메서드
  void fetchOrderFromServer() async {
    final order = await serverService.fetchCurrentOrder();
    if (order != null) {
      setState(() {
        currentOrder = order; // 서버에서 받은 주문 데이터를 상태로 저장
      });
    }
  }

  

  
  /// 예약 수락 처리
  void acceptOrder() {
    if (currentOrder != null) {
      serverService.sendReservationResponse(
        currentOrder!.userId,
        currentOrder!.restaurantId,
        'accepted',
      );
      widget.onOrderAccepted(currentOrder!); // 부모 위젯에 전달
      setState(() => currentOrder = null); // 주문 데이터 초기화
    }
  }
  

  /// 예약 거절 처리
  void rejectOrder() {
    if (currentOrder != null) {
      serverService.sendReservationResponse(
        currentOrder!.userId,
        currentOrder!.restaurantId,
        'denied',
      );
      setState(() => currentOrder = null); // 주문 데이터 초기화
    }
  }

  /*
  @override
  void initState() {
    super.initState();
    fetchOrderFromServer(); // 초기화 시 서버에서 주문 데이터를 가져옴
  }
  */
  @override
  void initState() {
    super.initState();
    fetchOrderPeriodically(); // 주기적으로 서버 데이터 가져오기
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // (1) "QuickOrder 주문" 제목 표시
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "QuickOrder 주문",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
        ),

        // (2) 주문 예약 데이터 표시
        if (currentOrder != null)
          Column(
            children: [
              Text(
                "총 인원: ${currentOrder!.headcount}",
                style: const TextStyle(fontSize: 20),
              ),

              // 수정된 메뉴 표시 로직
              ...currentOrder!.menus.map(
                (menu) => Text(
                  "${menu.name}: ${menu.quantity}개",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              /*
              if (currentOrder!.menu1 != null) Text("menu1: ${currentOrder!.menu1}"),
              if (currentOrder!.menu2 != null) Text("menu2: ${currentOrder!.menu2}"),
              if (currentOrder!.menu3 != null) Text("menu3: ${currentOrder!.menu3}"),
              if (currentOrder!.menu4 != null) Text("menu4: ${currentOrder!.menu4}"),
              if (currentOrder!.menu5 != null) Text("menu5: ${currentOrder!.menu5}"),
              */
              const SizedBox(height: 20),

              // (3) 수락/거절 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: acceptOrder,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(150, 60),
                      backgroundColor: Colors.green,
                    ),
                    child: const Text(
                      "수락",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: rejectOrder,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(150, 60),
                      backgroundColor: Colors.red,
                    ),
                    child: const Text(
                      "거절",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        // 데이터가 없는 경우 빈 상태 처리
        if (currentOrder == null)
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "예약된 주문이 없습니다.",
              style: TextStyle(fontSize: 18),
            ),
          ),
      ],
    );
  }
}





