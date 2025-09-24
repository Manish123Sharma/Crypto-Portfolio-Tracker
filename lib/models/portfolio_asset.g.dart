// GENERATED CODE - MANUALLY CREATED (since build_runner not run)

part of 'portfolio_asset.dart';

class PortfolioAssetAdapter extends TypeAdapter<PortfolioAsset> {
  @override
  final int typeId = 1;

  @override
  PortfolioAsset read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PortfolioAsset(
      coinId: fields[0] as String,
      name: fields[1] as String,
      symbol: fields[2] as String,
      logoUrl: fields[3] as String,
      quantity: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, PortfolioAsset obj) {
    writer
      ..writeByte(5) // number of fields
      ..writeByte(0)
      ..write(obj.coinId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.symbol)
      ..writeByte(3)
      ..write(obj.logoUrl)
      ..writeByte(4)
      ..write(obj.quantity);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PortfolioAssetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;

  @override
  int get hashCode => typeId.hashCode;
}
