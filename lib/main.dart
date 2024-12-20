import 'package:flutter/material.dart';
import 'models.dart';
import 'table_widget.dart';
import 'order_widget.dart';
import 'reservation_widget.dart';
import 'server_service.dart';

void main() {
  runApp(const POSApp());
}

class POSApp extends StatelessWidget {
  const POSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POS System',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const POSHomePage(),
    );
  }
}

class POSHomePage extends StatefulWidget {
  const POSHomePage({super.key});

  @override
  _POSHomePageState createState() => _POSHomePageState();
}

class _POSHomePageState extends State<POSHomePage> {
  final ServerService serverService = ServerService(); // ServerService 초기화
  // 20개의 테이블 데이터 생성
  final List<TableModel> tables = List.generate(
    20,
    (index) => TableModel(
      tableNumber: index + 1,
      seats: 2, // 각 테이블은 2인용
      hasOrders: false,
    ),
  );

  TableModel? selectedTable; // 선택된 테이블

  /// 테이블 선택 시 호출되는 함수
  void selectTable(TableModel table) {
    setState(() {
      selectedTable = table;
    });
  }

  /// 주문 초기화 함수 (결제)
  void clearOrders() {
    setState(() {
      selectedTable?.clearOrders(); // 테이블의 주문 내역 초기화
    });
    updateServerWithCrowdLevel(); // 서버로 좌석 상태 업데이트
  }

  /// 테이블 박스에 주문 내역을 추가하는 함수
  void placeOrder(String orderDetails) {
    setState(() {
      if (selectedTable != null) {
        selectedTable!.orderDetails = orderDetails; // 주문 내역 추가
        selectedTable!.hasOrders = true; // 테이블에 주문 존재 여부 업데이트
      }
    });
    updateServerWithCrowdLevel(); // 서버로 좌석 상태 업데이트
  }

  /// 주문 상태 변경 시 서버로 업데이트를 수행하는 함수
  void onOrderChanged() {
    updateServerWithCrowdLevel(); // 주문 상태가 변경될 때마다 서버 업데이트
  }

  /// 서버로 혼잡도 정보를 업데이트하는 함수
  void updateServerWithCrowdLevel() {
    final occupiedSeats = getOccupiedSeats();
    final totalSeats = getTotalSeats();
    const restaurantId = 10;

    serverService.sendCrowdLevel(restaurantId, occupiedSeats, totalSeats).catchError((error) {
      print("서버 업데이트 실패: $error");
    });
  }

  /// 주문 내역이 있는 테이블의 좌석 수 합산
  int getOccupiedSeats() {
    return tables
        .where((table) => table.hasOrders) // 주문 내역이 있는 테이블만 필터링
        .fold(0, (sum, table) => sum + table.seats); // 좌석 수 합산
  }

  /// 전체 테이블의 좌석 수 합산
  int getTotalSeats() {
    return tables.fold(0, (sum, table) => sum + table.seats); // 좌석 수 합산
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // 왼쪽 영역: 테이블 목록
          Expanded(
            flex: 3,
            child: TableWidget(
              tables: tables, // 테이블 목록 데이터 전달
              onTableSelected: selectTable, // 테이블 선택 콜백 함수
            ),
          ),

          // 오른쪽 영역: 선택된 테이블의 주문 UI 및 예약 UI
          Expanded(
            flex: 2,
            child: Column(
              children: [
                // 선택된 테이블의 주문 UI
                if (selectedTable != null)
                  Expanded(
                    flex: 2, // OrderWidget 비율을 더 크게 설정
                    child: OrderWidget(
                      table: selectedTable!, // 선택된 테이블 정보 전달
                      onClearOrders: () {
                        clearOrders(); // 결제(주문 초기화) 함수
                        updateServerWithCrowdLevel(); // 좌석 정보를 서버로 동기화
                      },
                      onOrderPlaced: (orderDetails) {
                        placeOrder(orderDetails); // 주문 내역 추가 함수 호출
                        updateServerWithCrowdLevel(); // 좌석 정보를 서버로 동기화
                      },
                      onOrderChanged: updateServerWithCrowdLevel,
                    ),
                  ),

                const SizedBox(height: 15), // 여백 추가
                
                // 검은색 경계선 추가
                Container(
                  height: 2, // 경계선 두께
                  color: Colors.black, // 경계선 색상
                ),

                const SizedBox(height: 15), // 여백 추가

                // 오른쪽 하단 영역: ReservationWidget
                Expanded(
                  flex: 1, // ReservationWidget의 높이 비율을 조정
                  child: ReservationWidget(
                    onOrderAccepted: (reservation) {
                      // 수정된 구조 반영
                      print("주문 수락됨:");
                      for (var menu in reservation.menus) {
                        print("${menu.name}: ${menu.quantity}개");
                      }
                      // 예약 수락 시 추가적으로 처리할 작업
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}







