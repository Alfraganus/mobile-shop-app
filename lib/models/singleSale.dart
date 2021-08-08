class SingleSale {
  final String name;
  final int price;
  final int quantity;

  SingleSale({this.name, this.price,this.quantity});

  factory SingleSale.fromJson({Map<dynamic, dynamic> json}) {
    return SingleSale(
        name:json['productCategory']['name'].toString(),
        price:json['price'],
        quantity:json['quantity']
    );
  }

  static List<SingleSale> fetchData({List jsonList}) {
    List<SingleSale> list = [];

    for (int i = 0; i < jsonList.length; i++) {
      list.add(SingleSale.fromJson(json: jsonList[i]));
    }

    return list;
  }

}