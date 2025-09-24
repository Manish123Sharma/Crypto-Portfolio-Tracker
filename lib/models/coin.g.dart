// GENERATED CODE - MANUALLY CREATED

part of 'coin.dart';

class CoinAdapter extends TypeAdapter<Coin> {
  @override
  final int typeId = 0;

  @override
  Coin read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Coin(
      id: fields[0] as String,
      name: fields[1] as String,
      symbol: fields[2] as String,
      price: fields[3] as double,
      logoUrl: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Coin obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.symbol)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.logoUrl);
  }
}
