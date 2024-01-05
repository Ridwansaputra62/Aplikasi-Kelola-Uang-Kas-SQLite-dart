class Menu {
  String? name;
  String? icon;
  String? route;

  Menu({this.name, this.icon, this.route});

  Menu.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    icon = json['icon'];
    route = json['route'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['icon'] = icon;
    data['route'] = route;
    return data;
  }
}
