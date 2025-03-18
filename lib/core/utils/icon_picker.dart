import 'package:flutter/material.dart';

Future<IconData?> showIconPicker(BuildContext context) async {
  final IconData? selectedIcon = await showDialog<IconData>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Select Icon'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: _icons.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).pop(_icons[index]);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
                  ),
                  child: Icon(
                    _icons[index],
                    color: Colors.blue,
                    size: 32,
                  ),
                ),
              );
            },
          ),
        ),
      );
    },
  );

  return selectedIcon;
}

final List<IconData> _icons = [
  Icons.home,
  Icons.shopping_cart,
  Icons.restaurant,
  Icons.directions_car,
  Icons.movie,
  Icons.local_gas_station,
  Icons.train,
  Icons.flight,
  Icons.school,
  Icons.medical_services,
  Icons.sports_soccer,
  Icons.fitness_center,
  Icons.laptop,
  Icons.attach_money,
  Icons.work,
  Icons.card_giftcard,
  Icons.savings,
  Icons.wifi,
  Icons.phone,
  Icons.tv,
  Icons.shopping_bag,
  Icons.games,
  Icons.child_friendly,
  Icons.favorite,
  Icons.beach_access,
]; 