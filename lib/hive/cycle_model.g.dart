// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cycle_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CycleDataAdapter extends TypeAdapter<CycleData> {
  @override
  final int typeId = 1;

  @override
  CycleData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CycleData(
      cycleStartDate: fields[0] as String,
      cycleEndDate: fields[1] as String,
      periodLength: fields[2] as int,
      cycleLength: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CycleData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.cycleStartDate)
      ..writeByte(1)
      ..write(obj.cycleEndDate)
      ..writeByte(2)
      ..write(obj.periodLength)
      ..writeByte(3)
      ..write(obj.cycleLength);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CycleDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
