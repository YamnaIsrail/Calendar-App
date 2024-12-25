// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimelineEntryAdapter extends TypeAdapter<TimelineEntry> {
  @override
  final int typeId = 4;

  @override
  TimelineEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimelineEntry(
      id: fields[0] as int,
      date: fields[1] as DateTime?,
      type: fields[2] as String,
      details: (fields[3] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, TimelineEntry obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.details);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimelineEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
