import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final Color color;
  final IconData icon;

  Category({
    String? id,
    required this.name,
    required this.color,
    required this.icon,
  }) : id = id ?? const Uuid().v4();

  Category copyWith({
    String? name,
    Color? color,
    IconData? icon,
  }) {
    return Category(
      id: this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color.value,
      'icon': icon.codePoint,
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      color: Color(json['color']),
      icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
    );
  }
} 