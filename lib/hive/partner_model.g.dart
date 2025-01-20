// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PartnerDataAdapter extends TypeAdapter<PartnerData> {
  @override
  final int typeId = 5;

  @override
  PartnerData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PartnerData(
      cycleStartDate: fields[0] as DateTime,
      cycleLength: fields[1] as int,
      periodLength: fields[2] as int,
      cycleEndDate: fields[3] as DateTime,
      pregnancyMode: fields[4] as bool,
      gestationStart: fields[5] as DateTime?,
      pastPeriods: (fields[6] as List)
          .map((dynamic e) => (e as Map).cast<String, String>())
          .toList(),
      dueDate: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, PartnerData obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.cycleStartDate)
      ..writeByte(1)
      ..write(obj.cycleLength)
      ..writeByte(2)
      ..write(obj.periodLength)
      ..writeByte(3)
      ..write(obj.cycleEndDate)
      ..writeByte(4)
      ..write(obj.pregnancyMode)
      ..writeByte(5)
      ..write(obj.gestationStart)
      ..writeByte(6)
      ..write(obj.pastPeriods)
      ..writeByte(7)
      ..write(obj.dueDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PartnerDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
