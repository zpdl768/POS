/// 데이터 모델을 정의하는 파일입니다.

/// 테이블 데이터를 관리하는 클래스


class TableModel {
  final int tableNumber; // 테이블 번호
  final int seats; // 좌석 수
  bool hasOrders; // 주문 여부
  String orderDetails; // 주문 내역 (추가됨)

  TableModel({
    required this.tableNumber,
    required this.seats,
    this.hasOrders = false,
    this.orderDetails = "", // 초기 주문 내역은 빈 문자열
  });

  void clearOrders() {
    hasOrders = false;
    orderDetails = ""; // 주문 내역 초기화
  }
}

/// 메뉴 주문 데이터를 관리하는 클래스
class OrderModel {
  final String menuName; // 메뉴 이름
  int quantity;          // 주문 수량

  /// 생성자를 통해 메뉴 이름과 수량을 초기화
  OrderModel({required this.menuName, this.quantity = 1});
}

class Order {
  final String userId;
  final String restaurantId;
  final int headcount;
  final List<Menu> menus; // 메뉴 리스트로 수정

  Order({
    required this.userId,
    required this.restaurantId,
    required this.headcount,
    required this.menus,
  });
  
  
  
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      userId: json['user_ID'] as String,
      restaurantId: json['restaurant_ID'] as String,
      headcount: json['headcount'] as int,
      menus: (json['menus'] as List<dynamic>)
          .map((menuJson) => Menu.fromJson(menuJson))
          .toList(),
    );
  }
  
}

class Menu {
  final String name;
  final int quantity;

  Menu({
    required this.name,
    required this.quantity,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      name: json['menu'] as String,
      quantity: json['quantity'] as int,
    );
  }
}









