// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_details.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderDetailsAdapter extends TypeAdapter<OrderDetails> {
  @override
  final int typeId = 2;

  @override
  OrderDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderDetails(
      details: (fields[0] as Map).cast<dynamic, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, OrderDetails obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.details);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
