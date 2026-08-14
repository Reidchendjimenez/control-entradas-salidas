// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CategoriasTable extends Categorias
    with TableInfo<$CategoriasTable, Categoria> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
      'nombre', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _descripcionMeta =
      const VerificationMeta('descripcion');
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
      'descripcion', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _imagenMeta = const VerificationMeta('imagen');
  @override
  late final GeneratedColumn<String> imagen = GeneratedColumn<String>(
      'imagen', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
      'color', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('#2196F3'));
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<int> activo = GeneratedColumn<int>(
      'activo', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _visibleEnPosMeta =
      const VerificationMeta('visibleEnPos');
  @override
  late final GeneratedColumn<int> visibleEnPos = GeneratedColumn<int>(
      'visible_en_pos', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        nombre,
        descripcion,
        imagen,
        color,
        activo,
        visibleEnPos,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categorias';
  @override
  VerificationContext validateIntegrity(Insertable<Categoria> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
          _descripcionMeta,
          descripcion.isAcceptableOrUnknown(
              data['descripcion']!, _descripcionMeta));
    }
    if (data.containsKey('imagen')) {
      context.handle(_imagenMeta,
          imagen.isAcceptableOrUnknown(data['imagen']!, _imagenMeta));
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    if (data.containsKey('activo')) {
      context.handle(_activoMeta,
          activo.isAcceptableOrUnknown(data['activo']!, _activoMeta));
    }
    if (data.containsKey('visible_en_pos')) {
      context.handle(
          _visibleEnPosMeta,
          visibleEnPos.isAcceptableOrUnknown(
              data['visible_en_pos']!, _visibleEnPosMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Categoria map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Categoria(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombre'])!,
      descripcion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}descripcion']),
      imagen: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}imagen']),
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color'])!,
      activo: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}activo'])!,
      visibleEnPos: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}visible_en_pos'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $CategoriasTable createAlias(String alias) {
    return $CategoriasTable(attachedDatabase, alias);
  }
}

class Categoria extends DataClass implements Insertable<Categoria> {
  final int id;
  final String nombre;
  final String? descripcion;
  final String? imagen;
  final String color;
  final int activo;
  final int visibleEnPos;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const Categoria(
      {required this.id,
      required this.nombre,
      this.descripcion,
      this.imagen,
      required this.color,
      required this.activo,
      required this.visibleEnPos,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || descripcion != null) {
      map['descripcion'] = Variable<String>(descripcion);
    }
    if (!nullToAbsent || imagen != null) {
      map['imagen'] = Variable<String>(imagen);
    }
    map['color'] = Variable<String>(color);
    map['activo'] = Variable<int>(activo);
    map['visible_en_pos'] = Variable<int>(visibleEnPos);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  CategoriasCompanion toCompanion(bool nullToAbsent) {
    return CategoriasCompanion(
      id: Value(id),
      nombre: Value(nombre),
      descripcion: descripcion == null && nullToAbsent
          ? const Value.absent()
          : Value(descripcion),
      imagen:
          imagen == null && nullToAbsent ? const Value.absent() : Value(imagen),
      color: Value(color),
      activo: Value(activo),
      visibleEnPos: Value(visibleEnPos),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Categoria.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Categoria(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      descripcion: serializer.fromJson<String?>(json['descripcion']),
      imagen: serializer.fromJson<String?>(json['imagen']),
      color: serializer.fromJson<String>(json['color']),
      activo: serializer.fromJson<int>(json['activo']),
      visibleEnPos: serializer.fromJson<int>(json['visibleEnPos']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'descripcion': serializer.toJson<String?>(descripcion),
      'imagen': serializer.toJson<String?>(imagen),
      'color': serializer.toJson<String>(color),
      'activo': serializer.toJson<int>(activo),
      'visibleEnPos': serializer.toJson<int>(visibleEnPos),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Categoria copyWith(
          {int? id,
          String? nombre,
          Value<String?> descripcion = const Value.absent(),
          Value<String?> imagen = const Value.absent(),
          String? color,
          int? activo,
          int? visibleEnPos,
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      Categoria(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        descripcion: descripcion.present ? descripcion.value : this.descripcion,
        imagen: imagen.present ? imagen.value : this.imagen,
        color: color ?? this.color,
        activo: activo ?? this.activo,
        visibleEnPos: visibleEnPos ?? this.visibleEnPos,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  Categoria copyWithCompanion(CategoriasCompanion data) {
    return Categoria(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      descripcion:
          data.descripcion.present ? data.descripcion.value : this.descripcion,
      imagen: data.imagen.present ? data.imagen.value : this.imagen,
      color: data.color.present ? data.color.value : this.color,
      activo: data.activo.present ? data.activo.value : this.activo,
      visibleEnPos: data.visibleEnPos.present
          ? data.visibleEnPos.value
          : this.visibleEnPos,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Categoria(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('imagen: $imagen, ')
          ..write('color: $color, ')
          ..write('activo: $activo, ')
          ..write('visibleEnPos: $visibleEnPos, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, descripcion, imagen, color,
      activo, visibleEnPos, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Categoria &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.descripcion == this.descripcion &&
          other.imagen == this.imagen &&
          other.color == this.color &&
          other.activo == this.activo &&
          other.visibleEnPos == this.visibleEnPos &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CategoriasCompanion extends UpdateCompanion<Categoria> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String?> descripcion;
  final Value<String?> imagen;
  final Value<String> color;
  final Value<int> activo;
  final Value<int> visibleEnPos;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  const CategoriasCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.imagen = const Value.absent(),
    this.color = const Value.absent(),
    this.activo = const Value.absent(),
    this.visibleEnPos = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CategoriasCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    this.descripcion = const Value.absent(),
    this.imagen = const Value.absent(),
    this.color = const Value.absent(),
    this.activo = const Value.absent(),
    this.visibleEnPos = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : nombre = Value(nombre);
  static Insertable<Categoria> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? descripcion,
    Expression<String>? imagen,
    Expression<String>? color,
    Expression<int>? activo,
    Expression<int>? visibleEnPos,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (descripcion != null) 'descripcion': descripcion,
      if (imagen != null) 'imagen': imagen,
      if (color != null) 'color': color,
      if (activo != null) 'activo': activo,
      if (visibleEnPos != null) 'visible_en_pos': visibleEnPos,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CategoriasCompanion copyWith(
      {Value<int>? id,
      Value<String>? nombre,
      Value<String?>? descripcion,
      Value<String?>? imagen,
      Value<String>? color,
      Value<int>? activo,
      Value<int>? visibleEnPos,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt}) {
    return CategoriasCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      imagen: imagen ?? this.imagen,
      color: color ?? this.color,
      activo: activo ?? this.activo,
      visibleEnPos: visibleEnPos ?? this.visibleEnPos,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (imagen.present) {
      map['imagen'] = Variable<String>(imagen.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (activo.present) {
      map['activo'] = Variable<int>(activo.value);
    }
    if (visibleEnPos.present) {
      map['visible_en_pos'] = Variable<int>(visibleEnPos.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriasCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('imagen: $imagen, ')
          ..write('color: $color, ')
          ..write('activo: $activo, ')
          ..write('visibleEnPos: $visibleEnPos, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ProductosTable extends Productos
    with TableInfo<$ProductosTable, Producto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
      'nombre', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
      'codigo', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _descripcionMeta =
      const VerificationMeta('descripcion');
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
      'descripcion', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoriaIdMeta =
      const VerificationMeta('categoriaId');
  @override
  late final GeneratedColumn<int> categoriaId = GeneratedColumn<int>(
      'categoria_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _esPesableMeta =
      const VerificationMeta('esPesable');
  @override
  late final GeneratedColumn<int> esPesable = GeneratedColumn<int>(
      'es_pesable', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _requiereFotoPesoMeta =
      const VerificationMeta('requiereFotoPeso');
  @override
  late final GeneratedColumn<int> requiereFotoPeso = GeneratedColumn<int>(
      'requiere_foto_peso', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _pesoUnitarioMeta =
      const VerificationMeta('pesoUnitario');
  @override
  late final GeneratedColumn<double> pesoUnitario = GeneratedColumn<double>(
      'peso_unitario', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _precioVentaMeta =
      const VerificationMeta('precioVenta');
  @override
  late final GeneratedColumn<double> precioVenta = GeneratedColumn<double>(
      'precio_venta', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _unidadMedidaMeta =
      const VerificationMeta('unidadMedida');
  @override
  late final GeneratedColumn<String> unidadMedida = GeneratedColumn<String>(
      'unidad_medida', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('unidad'));
  static const VerificationMeta _stockActualMeta =
      const VerificationMeta('stockActual');
  @override
  late final GeneratedColumn<double> stockActual = GeneratedColumn<double>(
      'stock_actual', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _stockMinimoMeta =
      const VerificationMeta('stockMinimo');
  @override
  late final GeneratedColumn<double> stockMinimo = GeneratedColumn<double>(
      'stock_minimo', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<int> activo = GeneratedColumn<int>(
      'activo', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
      'tipo', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('ninguno'));
  static const VerificationMeta _almacenPredeterminadoMeta =
      const VerificationMeta('almacenPredeterminado');
  @override
  late final GeneratedColumn<String> almacenPredeterminado =
      GeneratedColumn<String>('almacen_predeterminado', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('principal'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        nombre,
        codigo,
        descripcion,
        categoriaId,
        esPesable,
        requiereFotoPeso,
        pesoUnitario,
        precioVenta,
        unidadMedida,
        stockActual,
        stockMinimo,
        activo,
        tipo,
        almacenPredeterminado,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'productos';
  @override
  VerificationContext validateIntegrity(Insertable<Producto> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('codigo')) {
      context.handle(_codigoMeta,
          codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta));
    }
    if (data.containsKey('descripcion')) {
      context.handle(
          _descripcionMeta,
          descripcion.isAcceptableOrUnknown(
              data['descripcion']!, _descripcionMeta));
    }
    if (data.containsKey('categoria_id')) {
      context.handle(
          _categoriaIdMeta,
          categoriaId.isAcceptableOrUnknown(
              data['categoria_id']!, _categoriaIdMeta));
    }
    if (data.containsKey('es_pesable')) {
      context.handle(_esPesableMeta,
          esPesable.isAcceptableOrUnknown(data['es_pesable']!, _esPesableMeta));
    }
    if (data.containsKey('requiere_foto_peso')) {
      context.handle(
          _requiereFotoPesoMeta,
          requiereFotoPeso.isAcceptableOrUnknown(
              data['requiere_foto_peso']!, _requiereFotoPesoMeta));
    }
    if (data.containsKey('peso_unitario')) {
      context.handle(
          _pesoUnitarioMeta,
          pesoUnitario.isAcceptableOrUnknown(
              data['peso_unitario']!, _pesoUnitarioMeta));
    }
    if (data.containsKey('precio_venta')) {
      context.handle(
          _precioVentaMeta,
          precioVenta.isAcceptableOrUnknown(
              data['precio_venta']!, _precioVentaMeta));
    }
    if (data.containsKey('unidad_medida')) {
      context.handle(
          _unidadMedidaMeta,
          unidadMedida.isAcceptableOrUnknown(
              data['unidad_medida']!, _unidadMedidaMeta));
    }
    if (data.containsKey('stock_actual')) {
      context.handle(
          _stockActualMeta,
          stockActual.isAcceptableOrUnknown(
              data['stock_actual']!, _stockActualMeta));
    }
    if (data.containsKey('stock_minimo')) {
      context.handle(
          _stockMinimoMeta,
          stockMinimo.isAcceptableOrUnknown(
              data['stock_minimo']!, _stockMinimoMeta));
    }
    if (data.containsKey('activo')) {
      context.handle(_activoMeta,
          activo.isAcceptableOrUnknown(data['activo']!, _activoMeta));
    }
    if (data.containsKey('tipo')) {
      context.handle(
          _tipoMeta, tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta));
    }
    if (data.containsKey('almacen_predeterminado')) {
      context.handle(
          _almacenPredeterminadoMeta,
          almacenPredeterminado.isAcceptableOrUnknown(
              data['almacen_predeterminado']!, _almacenPredeterminadoMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Producto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Producto(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombre'])!,
      codigo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}codigo']),
      descripcion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}descripcion']),
      categoriaId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}categoria_id']),
      esPesable: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}es_pesable'])!,
      requiereFotoPeso: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}requiere_foto_peso'])!,
      pesoUnitario: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}peso_unitario']),
      precioVenta: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}precio_venta'])!,
      unidadMedida: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unidad_medida'])!,
      stockActual: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}stock_actual'])!,
      stockMinimo: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}stock_minimo'])!,
      activo: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}activo'])!,
      tipo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tipo'])!,
      almacenPredeterminado: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}almacen_predeterminado'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $ProductosTable createAlias(String alias) {
    return $ProductosTable(attachedDatabase, alias);
  }
}

class Producto extends DataClass implements Insertable<Producto> {
  final int id;
  final String nombre;
  final String? codigo;
  final String? descripcion;
  final int? categoriaId;
  final int esPesable;
  final int requiereFotoPeso;
  final double? pesoUnitario;
  final double precioVenta;
  final String unidadMedida;
  final double stockActual;
  final double stockMinimo;
  final int activo;
  final String tipo;
  final String almacenPredeterminado;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const Producto(
      {required this.id,
      required this.nombre,
      this.codigo,
      this.descripcion,
      this.categoriaId,
      required this.esPesable,
      required this.requiereFotoPeso,
      this.pesoUnitario,
      required this.precioVenta,
      required this.unidadMedida,
      required this.stockActual,
      required this.stockMinimo,
      required this.activo,
      required this.tipo,
      required this.almacenPredeterminado,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || codigo != null) {
      map['codigo'] = Variable<String>(codigo);
    }
    if (!nullToAbsent || descripcion != null) {
      map['descripcion'] = Variable<String>(descripcion);
    }
    if (!nullToAbsent || categoriaId != null) {
      map['categoria_id'] = Variable<int>(categoriaId);
    }
    map['es_pesable'] = Variable<int>(esPesable);
    map['requiere_foto_peso'] = Variable<int>(requiereFotoPeso);
    if (!nullToAbsent || pesoUnitario != null) {
      map['peso_unitario'] = Variable<double>(pesoUnitario);
    }
    map['precio_venta'] = Variable<double>(precioVenta);
    map['unidad_medida'] = Variable<String>(unidadMedida);
    map['stock_actual'] = Variable<double>(stockActual);
    map['stock_minimo'] = Variable<double>(stockMinimo);
    map['activo'] = Variable<int>(activo);
    map['tipo'] = Variable<String>(tipo);
    map['almacen_predeterminado'] = Variable<String>(almacenPredeterminado);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  ProductosCompanion toCompanion(bool nullToAbsent) {
    return ProductosCompanion(
      id: Value(id),
      nombre: Value(nombre),
      codigo:
          codigo == null && nullToAbsent ? const Value.absent() : Value(codigo),
      descripcion: descripcion == null && nullToAbsent
          ? const Value.absent()
          : Value(descripcion),
      categoriaId: categoriaId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoriaId),
      esPesable: Value(esPesable),
      requiereFotoPeso: Value(requiereFotoPeso),
      pesoUnitario: pesoUnitario == null && nullToAbsent
          ? const Value.absent()
          : Value(pesoUnitario),
      precioVenta: Value(precioVenta),
      unidadMedida: Value(unidadMedida),
      stockActual: Value(stockActual),
      stockMinimo: Value(stockMinimo),
      activo: Value(activo),
      tipo: Value(tipo),
      almacenPredeterminado: Value(almacenPredeterminado),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Producto.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Producto(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      codigo: serializer.fromJson<String?>(json['codigo']),
      descripcion: serializer.fromJson<String?>(json['descripcion']),
      categoriaId: serializer.fromJson<int?>(json['categoriaId']),
      esPesable: serializer.fromJson<int>(json['esPesable']),
      requiereFotoPeso: serializer.fromJson<int>(json['requiereFotoPeso']),
      pesoUnitario: serializer.fromJson<double?>(json['pesoUnitario']),
      precioVenta: serializer.fromJson<double>(json['precioVenta']),
      unidadMedida: serializer.fromJson<String>(json['unidadMedida']),
      stockActual: serializer.fromJson<double>(json['stockActual']),
      stockMinimo: serializer.fromJson<double>(json['stockMinimo']),
      activo: serializer.fromJson<int>(json['activo']),
      tipo: serializer.fromJson<String>(json['tipo']),
      almacenPredeterminado:
          serializer.fromJson<String>(json['almacenPredeterminado']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'codigo': serializer.toJson<String?>(codigo),
      'descripcion': serializer.toJson<String?>(descripcion),
      'categoriaId': serializer.toJson<int?>(categoriaId),
      'esPesable': serializer.toJson<int>(esPesable),
      'requiereFotoPeso': serializer.toJson<int>(requiereFotoPeso),
      'pesoUnitario': serializer.toJson<double?>(pesoUnitario),
      'precioVenta': serializer.toJson<double>(precioVenta),
      'unidadMedida': serializer.toJson<String>(unidadMedida),
      'stockActual': serializer.toJson<double>(stockActual),
      'stockMinimo': serializer.toJson<double>(stockMinimo),
      'activo': serializer.toJson<int>(activo),
      'tipo': serializer.toJson<String>(tipo),
      'almacenPredeterminado': serializer.toJson<String>(almacenPredeterminado),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Producto copyWith(
          {int? id,
          String? nombre,
          Value<String?> codigo = const Value.absent(),
          Value<String?> descripcion = const Value.absent(),
          Value<int?> categoriaId = const Value.absent(),
          int? esPesable,
          int? requiereFotoPeso,
          Value<double?> pesoUnitario = const Value.absent(),
          double? precioVenta,
          String? unidadMedida,
          double? stockActual,
          double? stockMinimo,
          int? activo,
          String? tipo,
          String? almacenPredeterminado,
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      Producto(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        codigo: codigo.present ? codigo.value : this.codigo,
        descripcion: descripcion.present ? descripcion.value : this.descripcion,
        categoriaId: categoriaId.present ? categoriaId.value : this.categoriaId,
        esPesable: esPesable ?? this.esPesable,
        requiereFotoPeso: requiereFotoPeso ?? this.requiereFotoPeso,
        pesoUnitario:
            pesoUnitario.present ? pesoUnitario.value : this.pesoUnitario,
        precioVenta: precioVenta ?? this.precioVenta,
        unidadMedida: unidadMedida ?? this.unidadMedida,
        stockActual: stockActual ?? this.stockActual,
        stockMinimo: stockMinimo ?? this.stockMinimo,
        activo: activo ?? this.activo,
        tipo: tipo ?? this.tipo,
        almacenPredeterminado:
            almacenPredeterminado ?? this.almacenPredeterminado,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  Producto copyWithCompanion(ProductosCompanion data) {
    return Producto(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      descripcion:
          data.descripcion.present ? data.descripcion.value : this.descripcion,
      categoriaId:
          data.categoriaId.present ? data.categoriaId.value : this.categoriaId,
      esPesable: data.esPesable.present ? data.esPesable.value : this.esPesable,
      requiereFotoPeso: data.requiereFotoPeso.present
          ? data.requiereFotoPeso.value
          : this.requiereFotoPeso,
      pesoUnitario: data.pesoUnitario.present
          ? data.pesoUnitario.value
          : this.pesoUnitario,
      precioVenta:
          data.precioVenta.present ? data.precioVenta.value : this.precioVenta,
      unidadMedida: data.unidadMedida.present
          ? data.unidadMedida.value
          : this.unidadMedida,
      stockActual:
          data.stockActual.present ? data.stockActual.value : this.stockActual,
      stockMinimo:
          data.stockMinimo.present ? data.stockMinimo.value : this.stockMinimo,
      activo: data.activo.present ? data.activo.value : this.activo,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      almacenPredeterminado: data.almacenPredeterminado.present
          ? data.almacenPredeterminado.value
          : this.almacenPredeterminado,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Producto(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('codigo: $codigo, ')
          ..write('descripcion: $descripcion, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('esPesable: $esPesable, ')
          ..write('requiereFotoPeso: $requiereFotoPeso, ')
          ..write('pesoUnitario: $pesoUnitario, ')
          ..write('precioVenta: $precioVenta, ')
          ..write('unidadMedida: $unidadMedida, ')
          ..write('stockActual: $stockActual, ')
          ..write('stockMinimo: $stockMinimo, ')
          ..write('activo: $activo, ')
          ..write('tipo: $tipo, ')
          ..write('almacenPredeterminado: $almacenPredeterminado, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      nombre,
      codigo,
      descripcion,
      categoriaId,
      esPesable,
      requiereFotoPeso,
      pesoUnitario,
      precioVenta,
      unidadMedida,
      stockActual,
      stockMinimo,
      activo,
      tipo,
      almacenPredeterminado,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Producto &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.codigo == this.codigo &&
          other.descripcion == this.descripcion &&
          other.categoriaId == this.categoriaId &&
          other.esPesable == this.esPesable &&
          other.requiereFotoPeso == this.requiereFotoPeso &&
          other.pesoUnitario == this.pesoUnitario &&
          other.precioVenta == this.precioVenta &&
          other.unidadMedida == this.unidadMedida &&
          other.stockActual == this.stockActual &&
          other.stockMinimo == this.stockMinimo &&
          other.activo == this.activo &&
          other.tipo == this.tipo &&
          other.almacenPredeterminado == this.almacenPredeterminado &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProductosCompanion extends UpdateCompanion<Producto> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String?> codigo;
  final Value<String?> descripcion;
  final Value<int?> categoriaId;
  final Value<int> esPesable;
  final Value<int> requiereFotoPeso;
  final Value<double?> pesoUnitario;
  final Value<double> precioVenta;
  final Value<String> unidadMedida;
  final Value<double> stockActual;
  final Value<double> stockMinimo;
  final Value<int> activo;
  final Value<String> tipo;
  final Value<String> almacenPredeterminado;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  const ProductosCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.codigo = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.categoriaId = const Value.absent(),
    this.esPesable = const Value.absent(),
    this.requiereFotoPeso = const Value.absent(),
    this.pesoUnitario = const Value.absent(),
    this.precioVenta = const Value.absent(),
    this.unidadMedida = const Value.absent(),
    this.stockActual = const Value.absent(),
    this.stockMinimo = const Value.absent(),
    this.activo = const Value.absent(),
    this.tipo = const Value.absent(),
    this.almacenPredeterminado = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ProductosCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    this.codigo = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.categoriaId = const Value.absent(),
    this.esPesable = const Value.absent(),
    this.requiereFotoPeso = const Value.absent(),
    this.pesoUnitario = const Value.absent(),
    this.precioVenta = const Value.absent(),
    this.unidadMedida = const Value.absent(),
    this.stockActual = const Value.absent(),
    this.stockMinimo = const Value.absent(),
    this.activo = const Value.absent(),
    this.tipo = const Value.absent(),
    this.almacenPredeterminado = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : nombre = Value(nombre);
  static Insertable<Producto> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? codigo,
    Expression<String>? descripcion,
    Expression<int>? categoriaId,
    Expression<int>? esPesable,
    Expression<int>? requiereFotoPeso,
    Expression<double>? pesoUnitario,
    Expression<double>? precioVenta,
    Expression<String>? unidadMedida,
    Expression<double>? stockActual,
    Expression<double>? stockMinimo,
    Expression<int>? activo,
    Expression<String>? tipo,
    Expression<String>? almacenPredeterminado,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (codigo != null) 'codigo': codigo,
      if (descripcion != null) 'descripcion': descripcion,
      if (categoriaId != null) 'categoria_id': categoriaId,
      if (esPesable != null) 'es_pesable': esPesable,
      if (requiereFotoPeso != null) 'requiere_foto_peso': requiereFotoPeso,
      if (pesoUnitario != null) 'peso_unitario': pesoUnitario,
      if (precioVenta != null) 'precio_venta': precioVenta,
      if (unidadMedida != null) 'unidad_medida': unidadMedida,
      if (stockActual != null) 'stock_actual': stockActual,
      if (stockMinimo != null) 'stock_minimo': stockMinimo,
      if (activo != null) 'activo': activo,
      if (tipo != null) 'tipo': tipo,
      if (almacenPredeterminado != null)
        'almacen_predeterminado': almacenPredeterminado,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ProductosCompanion copyWith(
      {Value<int>? id,
      Value<String>? nombre,
      Value<String?>? codigo,
      Value<String?>? descripcion,
      Value<int?>? categoriaId,
      Value<int>? esPesable,
      Value<int>? requiereFotoPeso,
      Value<double?>? pesoUnitario,
      Value<double>? precioVenta,
      Value<String>? unidadMedida,
      Value<double>? stockActual,
      Value<double>? stockMinimo,
      Value<int>? activo,
      Value<String>? tipo,
      Value<String>? almacenPredeterminado,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt}) {
    return ProductosCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      codigo: codigo ?? this.codigo,
      descripcion: descripcion ?? this.descripcion,
      categoriaId: categoriaId ?? this.categoriaId,
      esPesable: esPesable ?? this.esPesable,
      requiereFotoPeso: requiereFotoPeso ?? this.requiereFotoPeso,
      pesoUnitario: pesoUnitario ?? this.pesoUnitario,
      precioVenta: precioVenta ?? this.precioVenta,
      unidadMedida: unidadMedida ?? this.unidadMedida,
      stockActual: stockActual ?? this.stockActual,
      stockMinimo: stockMinimo ?? this.stockMinimo,
      activo: activo ?? this.activo,
      tipo: tipo ?? this.tipo,
      almacenPredeterminado:
          almacenPredeterminado ?? this.almacenPredeterminado,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (categoriaId.present) {
      map['categoria_id'] = Variable<int>(categoriaId.value);
    }
    if (esPesable.present) {
      map['es_pesable'] = Variable<int>(esPesable.value);
    }
    if (requiereFotoPeso.present) {
      map['requiere_foto_peso'] = Variable<int>(requiereFotoPeso.value);
    }
    if (pesoUnitario.present) {
      map['peso_unitario'] = Variable<double>(pesoUnitario.value);
    }
    if (precioVenta.present) {
      map['precio_venta'] = Variable<double>(precioVenta.value);
    }
    if (unidadMedida.present) {
      map['unidad_medida'] = Variable<String>(unidadMedida.value);
    }
    if (stockActual.present) {
      map['stock_actual'] = Variable<double>(stockActual.value);
    }
    if (stockMinimo.present) {
      map['stock_minimo'] = Variable<double>(stockMinimo.value);
    }
    if (activo.present) {
      map['activo'] = Variable<int>(activo.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (almacenPredeterminado.present) {
      map['almacen_predeterminado'] =
          Variable<String>(almacenPredeterminado.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductosCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('codigo: $codigo, ')
          ..write('descripcion: $descripcion, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('esPesable: $esPesable, ')
          ..write('requiereFotoPeso: $requiereFotoPeso, ')
          ..write('pesoUnitario: $pesoUnitario, ')
          ..write('precioVenta: $precioVenta, ')
          ..write('unidadMedida: $unidadMedida, ')
          ..write('stockActual: $stockActual, ')
          ..write('stockMinimo: $stockMinimo, ')
          ..write('activo: $activo, ')
          ..write('tipo: $tipo, ')
          ..write('almacenPredeterminado: $almacenPredeterminado, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ProveedoresTable extends Proveedores
    with TableInfo<$ProveedoresTable, Proveedore> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProveedoresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
      'nombre', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _rifMeta = const VerificationMeta('rif');
  @override
  late final GeneratedColumn<String> rif = GeneratedColumn<String>(
      'rif', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _telefonoMeta =
      const VerificationMeta('telefono');
  @override
  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
      'telefono', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _direccionMeta =
      const VerificationMeta('direccion');
  @override
  late final GeneratedColumn<String> direccion = GeneratedColumn<String>(
      'direccion', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _contactoMeta =
      const VerificationMeta('contacto');
  @override
  late final GeneratedColumn<String> contacto = GeneratedColumn<String>(
      'contacto', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _observacionesMeta =
      const VerificationMeta('observaciones');
  @override
  late final GeneratedColumn<String> observaciones = GeneratedColumn<String>(
      'observaciones', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
      'estado', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Activo'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        nombre,
        rif,
        telefono,
        email,
        direccion,
        contacto,
        observaciones,
        estado,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'proveedores';
  @override
  VerificationContext validateIntegrity(Insertable<Proveedore> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('rif')) {
      context.handle(
          _rifMeta, rif.isAcceptableOrUnknown(data['rif']!, _rifMeta));
    }
    if (data.containsKey('telefono')) {
      context.handle(_telefonoMeta,
          telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('direccion')) {
      context.handle(_direccionMeta,
          direccion.isAcceptableOrUnknown(data['direccion']!, _direccionMeta));
    }
    if (data.containsKey('contacto')) {
      context.handle(_contactoMeta,
          contacto.isAcceptableOrUnknown(data['contacto']!, _contactoMeta));
    }
    if (data.containsKey('observaciones')) {
      context.handle(
          _observacionesMeta,
          observaciones.isAcceptableOrUnknown(
              data['observaciones']!, _observacionesMeta));
    }
    if (data.containsKey('estado')) {
      context.handle(_estadoMeta,
          estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Proveedore map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Proveedore(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombre'])!,
      rif: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rif']),
      telefono: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}telefono']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      direccion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}direccion']),
      contacto: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}contacto']),
      observaciones: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}observaciones']),
      estado: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}estado'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
    );
  }

  @override
  $ProveedoresTable createAlias(String alias) {
    return $ProveedoresTable(attachedDatabase, alias);
  }
}

class Proveedore extends DataClass implements Insertable<Proveedore> {
  final int id;
  final String nombre;
  final String? rif;
  final String? telefono;
  final String? email;
  final String? direccion;
  final String? contacto;
  final String? observaciones;
  final String estado;
  final DateTime? createdAt;
  const Proveedore(
      {required this.id,
      required this.nombre,
      this.rif,
      this.telefono,
      this.email,
      this.direccion,
      this.contacto,
      this.observaciones,
      required this.estado,
      this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || rif != null) {
      map['rif'] = Variable<String>(rif);
    }
    if (!nullToAbsent || telefono != null) {
      map['telefono'] = Variable<String>(telefono);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || direccion != null) {
      map['direccion'] = Variable<String>(direccion);
    }
    if (!nullToAbsent || contacto != null) {
      map['contacto'] = Variable<String>(contacto);
    }
    if (!nullToAbsent || observaciones != null) {
      map['observaciones'] = Variable<String>(observaciones);
    }
    map['estado'] = Variable<String>(estado);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  ProveedoresCompanion toCompanion(bool nullToAbsent) {
    return ProveedoresCompanion(
      id: Value(id),
      nombre: Value(nombre),
      rif: rif == null && nullToAbsent ? const Value.absent() : Value(rif),
      telefono: telefono == null && nullToAbsent
          ? const Value.absent()
          : Value(telefono),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      direccion: direccion == null && nullToAbsent
          ? const Value.absent()
          : Value(direccion),
      contacto: contacto == null && nullToAbsent
          ? const Value.absent()
          : Value(contacto),
      observaciones: observaciones == null && nullToAbsent
          ? const Value.absent()
          : Value(observaciones),
      estado: Value(estado),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory Proveedore.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Proveedore(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      rif: serializer.fromJson<String?>(json['rif']),
      telefono: serializer.fromJson<String?>(json['telefono']),
      email: serializer.fromJson<String?>(json['email']),
      direccion: serializer.fromJson<String?>(json['direccion']),
      contacto: serializer.fromJson<String?>(json['contacto']),
      observaciones: serializer.fromJson<String?>(json['observaciones']),
      estado: serializer.fromJson<String>(json['estado']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'rif': serializer.toJson<String?>(rif),
      'telefono': serializer.toJson<String?>(telefono),
      'email': serializer.toJson<String?>(email),
      'direccion': serializer.toJson<String?>(direccion),
      'contacto': serializer.toJson<String?>(contacto),
      'observaciones': serializer.toJson<String?>(observaciones),
      'estado': serializer.toJson<String>(estado),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  Proveedore copyWith(
          {int? id,
          String? nombre,
          Value<String?> rif = const Value.absent(),
          Value<String?> telefono = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> direccion = const Value.absent(),
          Value<String?> contacto = const Value.absent(),
          Value<String?> observaciones = const Value.absent(),
          String? estado,
          Value<DateTime?> createdAt = const Value.absent()}) =>
      Proveedore(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        rif: rif.present ? rif.value : this.rif,
        telefono: telefono.present ? telefono.value : this.telefono,
        email: email.present ? email.value : this.email,
        direccion: direccion.present ? direccion.value : this.direccion,
        contacto: contacto.present ? contacto.value : this.contacto,
        observaciones:
            observaciones.present ? observaciones.value : this.observaciones,
        estado: estado ?? this.estado,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
      );
  Proveedore copyWithCompanion(ProveedoresCompanion data) {
    return Proveedore(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      rif: data.rif.present ? data.rif.value : this.rif,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
      email: data.email.present ? data.email.value : this.email,
      direccion: data.direccion.present ? data.direccion.value : this.direccion,
      contacto: data.contacto.present ? data.contacto.value : this.contacto,
      observaciones: data.observaciones.present
          ? data.observaciones.value
          : this.observaciones,
      estado: data.estado.present ? data.estado.value : this.estado,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Proveedore(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('rif: $rif, ')
          ..write('telefono: $telefono, ')
          ..write('email: $email, ')
          ..write('direccion: $direccion, ')
          ..write('contacto: $contacto, ')
          ..write('observaciones: $observaciones, ')
          ..write('estado: $estado, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, rif, telefono, email, direccion,
      contacto, observaciones, estado, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Proveedore &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.rif == this.rif &&
          other.telefono == this.telefono &&
          other.email == this.email &&
          other.direccion == this.direccion &&
          other.contacto == this.contacto &&
          other.observaciones == this.observaciones &&
          other.estado == this.estado &&
          other.createdAt == this.createdAt);
}

class ProveedoresCompanion extends UpdateCompanion<Proveedore> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String?> rif;
  final Value<String?> telefono;
  final Value<String?> email;
  final Value<String?> direccion;
  final Value<String?> contacto;
  final Value<String?> observaciones;
  final Value<String> estado;
  final Value<DateTime?> createdAt;
  const ProveedoresCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.rif = const Value.absent(),
    this.telefono = const Value.absent(),
    this.email = const Value.absent(),
    this.direccion = const Value.absent(),
    this.contacto = const Value.absent(),
    this.observaciones = const Value.absent(),
    this.estado = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ProveedoresCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    this.rif = const Value.absent(),
    this.telefono = const Value.absent(),
    this.email = const Value.absent(),
    this.direccion = const Value.absent(),
    this.contacto = const Value.absent(),
    this.observaciones = const Value.absent(),
    this.estado = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : nombre = Value(nombre);
  static Insertable<Proveedore> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? rif,
    Expression<String>? telefono,
    Expression<String>? email,
    Expression<String>? direccion,
    Expression<String>? contacto,
    Expression<String>? observaciones,
    Expression<String>? estado,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (rif != null) 'rif': rif,
      if (telefono != null) 'telefono': telefono,
      if (email != null) 'email': email,
      if (direccion != null) 'direccion': direccion,
      if (contacto != null) 'contacto': contacto,
      if (observaciones != null) 'observaciones': observaciones,
      if (estado != null) 'estado': estado,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ProveedoresCompanion copyWith(
      {Value<int>? id,
      Value<String>? nombre,
      Value<String?>? rif,
      Value<String?>? telefono,
      Value<String?>? email,
      Value<String?>? direccion,
      Value<String?>? contacto,
      Value<String?>? observaciones,
      Value<String>? estado,
      Value<DateTime?>? createdAt}) {
    return ProveedoresCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      rif: rif ?? this.rif,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      direccion: direccion ?? this.direccion,
      contacto: contacto ?? this.contacto,
      observaciones: observaciones ?? this.observaciones,
      estado: estado ?? this.estado,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (rif.present) {
      map['rif'] = Variable<String>(rif.value);
    }
    if (telefono.present) {
      map['telefono'] = Variable<String>(telefono.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (direccion.present) {
      map['direccion'] = Variable<String>(direccion.value);
    }
    if (contacto.present) {
      map['contacto'] = Variable<String>(contacto.value);
    }
    if (observaciones.present) {
      map['observaciones'] = Variable<String>(observaciones.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProveedoresCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('rif: $rif, ')
          ..write('telefono: $telefono, ')
          ..write('email: $email, ')
          ..write('direccion: $direccion, ')
          ..write('contacto: $contacto, ')
          ..write('observaciones: $observaciones, ')
          ..write('estado: $estado, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ExistenciasTable extends Existencias
    with TableInfo<$ExistenciasTable, Existencia> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExistenciasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _productoIdMeta =
      const VerificationMeta('productoId');
  @override
  late final GeneratedColumn<int> productoId = GeneratedColumn<int>(
      'producto_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _almacenMeta =
      const VerificationMeta('almacen');
  @override
  late final GeneratedColumn<String> almacen = GeneratedColumn<String>(
      'almacen', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cantidadMeta =
      const VerificationMeta('cantidad');
  @override
  late final GeneratedColumn<double> cantidad = GeneratedColumn<double>(
      'cantidad', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _unidadMeta = const VerificationMeta('unidad');
  @override
  late final GeneratedColumn<String> unidad = GeneratedColumn<String>(
      'unidad', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('unidad'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, productoId, almacen, cantidad, unidad];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'existencias';
  @override
  VerificationContext validateIntegrity(Insertable<Existencia> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('producto_id')) {
      context.handle(
          _productoIdMeta,
          productoId.isAcceptableOrUnknown(
              data['producto_id']!, _productoIdMeta));
    }
    if (data.containsKey('almacen')) {
      context.handle(_almacenMeta,
          almacen.isAcceptableOrUnknown(data['almacen']!, _almacenMeta));
    } else if (isInserting) {
      context.missing(_almacenMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(_cantidadMeta,
          cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta));
    }
    if (data.containsKey('unidad')) {
      context.handle(_unidadMeta,
          unidad.isAcceptableOrUnknown(data['unidad']!, _unidadMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Existencia map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Existencia(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      productoId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}producto_id']),
      almacen: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}almacen'])!,
      cantidad: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cantidad'])!,
      unidad: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unidad'])!,
    );
  }

  @override
  $ExistenciasTable createAlias(String alias) {
    return $ExistenciasTable(attachedDatabase, alias);
  }
}

class Existencia extends DataClass implements Insertable<Existencia> {
  final int id;
  final int? productoId;
  final String almacen;
  final double cantidad;
  final String unidad;
  const Existencia(
      {required this.id,
      this.productoId,
      required this.almacen,
      required this.cantidad,
      required this.unidad});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || productoId != null) {
      map['producto_id'] = Variable<int>(productoId);
    }
    map['almacen'] = Variable<String>(almacen);
    map['cantidad'] = Variable<double>(cantidad);
    map['unidad'] = Variable<String>(unidad);
    return map;
  }

  ExistenciasCompanion toCompanion(bool nullToAbsent) {
    return ExistenciasCompanion(
      id: Value(id),
      productoId: productoId == null && nullToAbsent
          ? const Value.absent()
          : Value(productoId),
      almacen: Value(almacen),
      cantidad: Value(cantidad),
      unidad: Value(unidad),
    );
  }

  factory Existencia.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Existencia(
      id: serializer.fromJson<int>(json['id']),
      productoId: serializer.fromJson<int?>(json['productoId']),
      almacen: serializer.fromJson<String>(json['almacen']),
      cantidad: serializer.fromJson<double>(json['cantidad']),
      unidad: serializer.fromJson<String>(json['unidad']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productoId': serializer.toJson<int?>(productoId),
      'almacen': serializer.toJson<String>(almacen),
      'cantidad': serializer.toJson<double>(cantidad),
      'unidad': serializer.toJson<String>(unidad),
    };
  }

  Existencia copyWith(
          {int? id,
          Value<int?> productoId = const Value.absent(),
          String? almacen,
          double? cantidad,
          String? unidad}) =>
      Existencia(
        id: id ?? this.id,
        productoId: productoId.present ? productoId.value : this.productoId,
        almacen: almacen ?? this.almacen,
        cantidad: cantidad ?? this.cantidad,
        unidad: unidad ?? this.unidad,
      );
  Existencia copyWithCompanion(ExistenciasCompanion data) {
    return Existencia(
      id: data.id.present ? data.id.value : this.id,
      productoId:
          data.productoId.present ? data.productoId.value : this.productoId,
      almacen: data.almacen.present ? data.almacen.value : this.almacen,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      unidad: data.unidad.present ? data.unidad.value : this.unidad,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Existencia(')
          ..write('id: $id, ')
          ..write('productoId: $productoId, ')
          ..write('almacen: $almacen, ')
          ..write('cantidad: $cantidad, ')
          ..write('unidad: $unidad')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, productoId, almacen, cantidad, unidad);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Existencia &&
          other.id == this.id &&
          other.productoId == this.productoId &&
          other.almacen == this.almacen &&
          other.cantidad == this.cantidad &&
          other.unidad == this.unidad);
}

class ExistenciasCompanion extends UpdateCompanion<Existencia> {
  final Value<int> id;
  final Value<int?> productoId;
  final Value<String> almacen;
  final Value<double> cantidad;
  final Value<String> unidad;
  const ExistenciasCompanion({
    this.id = const Value.absent(),
    this.productoId = const Value.absent(),
    this.almacen = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.unidad = const Value.absent(),
  });
  ExistenciasCompanion.insert({
    this.id = const Value.absent(),
    this.productoId = const Value.absent(),
    required String almacen,
    this.cantidad = const Value.absent(),
    this.unidad = const Value.absent(),
  }) : almacen = Value(almacen);
  static Insertable<Existencia> custom({
    Expression<int>? id,
    Expression<int>? productoId,
    Expression<String>? almacen,
    Expression<double>? cantidad,
    Expression<String>? unidad,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productoId != null) 'producto_id': productoId,
      if (almacen != null) 'almacen': almacen,
      if (cantidad != null) 'cantidad': cantidad,
      if (unidad != null) 'unidad': unidad,
    });
  }

  ExistenciasCompanion copyWith(
      {Value<int>? id,
      Value<int?>? productoId,
      Value<String>? almacen,
      Value<double>? cantidad,
      Value<String>? unidad}) {
    return ExistenciasCompanion(
      id: id ?? this.id,
      productoId: productoId ?? this.productoId,
      almacen: almacen ?? this.almacen,
      cantidad: cantidad ?? this.cantidad,
      unidad: unidad ?? this.unidad,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productoId.present) {
      map['producto_id'] = Variable<int>(productoId.value);
    }
    if (almacen.present) {
      map['almacen'] = Variable<String>(almacen.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<double>(cantidad.value);
    }
    if (unidad.present) {
      map['unidad'] = Variable<String>(unidad.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExistenciasCompanion(')
          ..write('id: $id, ')
          ..write('productoId: $productoId, ')
          ..write('almacen: $almacen, ')
          ..write('cantidad: $cantidad, ')
          ..write('unidad: $unidad')
          ..write(')'))
        .toString();
  }
}

class $MovimientosTable extends Movimientos
    with TableInfo<$MovimientosTable, Movimiento> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MovimientosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _productoIdMeta =
      const VerificationMeta('productoId');
  @override
  late final GeneratedColumn<int> productoId = GeneratedColumn<int>(
      'producto_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _facturaIdMeta =
      const VerificationMeta('facturaId');
  @override
  late final GeneratedColumn<int> facturaId = GeneratedColumn<int>(
      'factura_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _requisicionIdMeta =
      const VerificationMeta('requisicionId');
  @override
  late final GeneratedColumn<int> requisicionId = GeneratedColumn<int>(
      'requisicion_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _ventaIdMeta =
      const VerificationMeta('ventaId');
  @override
  late final GeneratedColumn<int> ventaId = GeneratedColumn<int>(
      'venta_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _ventaSyncUuidMeta =
      const VerificationMeta('ventaSyncUuid');
  @override
  late final GeneratedColumn<String> ventaSyncUuid = GeneratedColumn<String>(
      'venta_sync_uuid', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
      'tipo', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 30),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _cantidadMeta =
      const VerificationMeta('cantidad');
  @override
  late final GeneratedColumn<double> cantidad = GeneratedColumn<double>(
      'cantidad', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _cantidadAnteriorMeta =
      const VerificationMeta('cantidadAnterior');
  @override
  late final GeneratedColumn<double> cantidadAnterior = GeneratedColumn<double>(
      'cantidad_anterior', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _cantidadNuevaMeta =
      const VerificationMeta('cantidadNueva');
  @override
  late final GeneratedColumn<double> cantidadNueva = GeneratedColumn<double>(
      'cantidad_nueva', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _pesoTotalMeta =
      const VerificationMeta('pesoTotal');
  @override
  late final GeneratedColumn<double> pesoTotal = GeneratedColumn<double>(
      'peso_total', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _registradoPorMeta =
      const VerificationMeta('registradoPor');
  @override
  late final GeneratedColumn<String> registradoPor = GeneratedColumn<String>(
      'registrado_por', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _observacionesMeta =
      const VerificationMeta('observaciones');
  @override
  late final GeneratedColumn<String> observaciones = GeneratedColumn<String>(
      'observaciones', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _almacenMeta =
      const VerificationMeta('almacen');
  @override
  late final GeneratedColumn<String> almacen = GeneratedColumn<String>(
      'almacen', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fechaMovimientoMeta =
      const VerificationMeta('fechaMovimiento');
  @override
  late final GeneratedColumn<DateTime> fechaMovimiento =
      GeneratedColumn<DateTime>('fecha_movimiento', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _sincronizadoMeta =
      const VerificationMeta('sincronizado');
  @override
  late final GeneratedColumn<int> sincronizado = GeneratedColumn<int>(
      'sincronizado', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        productoId,
        facturaId,
        requisicionId,
        ventaId,
        ventaSyncUuid,
        tipo,
        cantidad,
        cantidadAnterior,
        cantidadNueva,
        pesoTotal,
        registradoPor,
        observaciones,
        almacen,
        fechaMovimiento,
        createdAt,
        sincronizado
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'movimientos';
  @override
  VerificationContext validateIntegrity(Insertable<Movimiento> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('producto_id')) {
      context.handle(
          _productoIdMeta,
          productoId.isAcceptableOrUnknown(
              data['producto_id']!, _productoIdMeta));
    } else if (isInserting) {
      context.missing(_productoIdMeta);
    }
    if (data.containsKey('factura_id')) {
      context.handle(_facturaIdMeta,
          facturaId.isAcceptableOrUnknown(data['factura_id']!, _facturaIdMeta));
    }
    if (data.containsKey('requisicion_id')) {
      context.handle(
          _requisicionIdMeta,
          requisicionId.isAcceptableOrUnknown(
              data['requisicion_id']!, _requisicionIdMeta));
    }
    if (data.containsKey('venta_id')) {
      context.handle(_ventaIdMeta,
          ventaId.isAcceptableOrUnknown(data['venta_id']!, _ventaIdMeta));
    }
    if (data.containsKey('venta_sync_uuid')) {
      context.handle(
          _ventaSyncUuidMeta,
          ventaSyncUuid.isAcceptableOrUnknown(
              data['venta_sync_uuid']!, _ventaSyncUuidMeta));
    }
    if (data.containsKey('tipo')) {
      context.handle(
          _tipoMeta, tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta));
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(_cantidadMeta,
          cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta));
    } else if (isInserting) {
      context.missing(_cantidadMeta);
    }
    if (data.containsKey('cantidad_anterior')) {
      context.handle(
          _cantidadAnteriorMeta,
          cantidadAnterior.isAcceptableOrUnknown(
              data['cantidad_anterior']!, _cantidadAnteriorMeta));
    }
    if (data.containsKey('cantidad_nueva')) {
      context.handle(
          _cantidadNuevaMeta,
          cantidadNueva.isAcceptableOrUnknown(
              data['cantidad_nueva']!, _cantidadNuevaMeta));
    }
    if (data.containsKey('peso_total')) {
      context.handle(_pesoTotalMeta,
          pesoTotal.isAcceptableOrUnknown(data['peso_total']!, _pesoTotalMeta));
    }
    if (data.containsKey('registrado_por')) {
      context.handle(
          _registradoPorMeta,
          registradoPor.isAcceptableOrUnknown(
              data['registrado_por']!, _registradoPorMeta));
    }
    if (data.containsKey('observaciones')) {
      context.handle(
          _observacionesMeta,
          observaciones.isAcceptableOrUnknown(
              data['observaciones']!, _observacionesMeta));
    }
    if (data.containsKey('almacen')) {
      context.handle(_almacenMeta,
          almacen.isAcceptableOrUnknown(data['almacen']!, _almacenMeta));
    }
    if (data.containsKey('fecha_movimiento')) {
      context.handle(
          _fechaMovimientoMeta,
          fechaMovimiento.isAcceptableOrUnknown(
              data['fecha_movimiento']!, _fechaMovimientoMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('sincronizado')) {
      context.handle(
          _sincronizadoMeta,
          sincronizado.isAcceptableOrUnknown(
              data['sincronizado']!, _sincronizadoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Movimiento map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Movimiento(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      productoId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}producto_id'])!,
      facturaId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}factura_id']),
      requisicionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}requisicion_id']),
      ventaId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}venta_id']),
      ventaSyncUuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}venta_sync_uuid']),
      tipo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tipo'])!,
      cantidad: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cantidad'])!,
      cantidadAnterior: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}cantidad_anterior'])!,
      cantidadNueva: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cantidad_nueva'])!,
      pesoTotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}peso_total'])!,
      registradoPor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}registrado_por']),
      observaciones: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}observaciones']),
      almacen: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}almacen']),
      fechaMovimiento: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}fecha_movimiento']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      sincronizado: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sincronizado'])!,
    );
  }

  @override
  $MovimientosTable createAlias(String alias) {
    return $MovimientosTable(attachedDatabase, alias);
  }
}

class Movimiento extends DataClass implements Insertable<Movimiento> {
  final int id;
  final int productoId;
  final int? facturaId;
  final int? requisicionId;
  final int? ventaId;
  final String? ventaSyncUuid;
  final String tipo;
  final double cantidad;
  final double cantidadAnterior;
  final double cantidadNueva;
  final double pesoTotal;
  final String? registradoPor;
  final String? observaciones;
  final String? almacen;
  final DateTime? fechaMovimiento;
  final DateTime? createdAt;
  final int sincronizado;
  const Movimiento(
      {required this.id,
      required this.productoId,
      this.facturaId,
      this.requisicionId,
      this.ventaId,
      this.ventaSyncUuid,
      required this.tipo,
      required this.cantidad,
      required this.cantidadAnterior,
      required this.cantidadNueva,
      required this.pesoTotal,
      this.registradoPor,
      this.observaciones,
      this.almacen,
      this.fechaMovimiento,
      this.createdAt,
      required this.sincronizado});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['producto_id'] = Variable<int>(productoId);
    if (!nullToAbsent || facturaId != null) {
      map['factura_id'] = Variable<int>(facturaId);
    }
    if (!nullToAbsent || requisicionId != null) {
      map['requisicion_id'] = Variable<int>(requisicionId);
    }
    if (!nullToAbsent || ventaId != null) {
      map['venta_id'] = Variable<int>(ventaId);
    }
    if (!nullToAbsent || ventaSyncUuid != null) {
      map['venta_sync_uuid'] = Variable<String>(ventaSyncUuid);
    }
    map['tipo'] = Variable<String>(tipo);
    map['cantidad'] = Variable<double>(cantidad);
    map['cantidad_anterior'] = Variable<double>(cantidadAnterior);
    map['cantidad_nueva'] = Variable<double>(cantidadNueva);
    map['peso_total'] = Variable<double>(pesoTotal);
    if (!nullToAbsent || registradoPor != null) {
      map['registrado_por'] = Variable<String>(registradoPor);
    }
    if (!nullToAbsent || observaciones != null) {
      map['observaciones'] = Variable<String>(observaciones);
    }
    if (!nullToAbsent || almacen != null) {
      map['almacen'] = Variable<String>(almacen);
    }
    if (!nullToAbsent || fechaMovimiento != null) {
      map['fecha_movimiento'] = Variable<DateTime>(fechaMovimiento);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    map['sincronizado'] = Variable<int>(sincronizado);
    return map;
  }

  MovimientosCompanion toCompanion(bool nullToAbsent) {
    return MovimientosCompanion(
      id: Value(id),
      productoId: Value(productoId),
      facturaId: facturaId == null && nullToAbsent
          ? const Value.absent()
          : Value(facturaId),
      requisicionId: requisicionId == null && nullToAbsent
          ? const Value.absent()
          : Value(requisicionId),
      ventaId: ventaId == null && nullToAbsent
          ? const Value.absent()
          : Value(ventaId),
      ventaSyncUuid: ventaSyncUuid == null && nullToAbsent
          ? const Value.absent()
          : Value(ventaSyncUuid),
      tipo: Value(tipo),
      cantidad: Value(cantidad),
      cantidadAnterior: Value(cantidadAnterior),
      cantidadNueva: Value(cantidadNueva),
      pesoTotal: Value(pesoTotal),
      registradoPor: registradoPor == null && nullToAbsent
          ? const Value.absent()
          : Value(registradoPor),
      observaciones: observaciones == null && nullToAbsent
          ? const Value.absent()
          : Value(observaciones),
      almacen: almacen == null && nullToAbsent
          ? const Value.absent()
          : Value(almacen),
      fechaMovimiento: fechaMovimiento == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaMovimiento),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      sincronizado: Value(sincronizado),
    );
  }

  factory Movimiento.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Movimiento(
      id: serializer.fromJson<int>(json['id']),
      productoId: serializer.fromJson<int>(json['productoId']),
      facturaId: serializer.fromJson<int?>(json['facturaId']),
      requisicionId: serializer.fromJson<int?>(json['requisicionId']),
      ventaId: serializer.fromJson<int?>(json['ventaId']),
      ventaSyncUuid: serializer.fromJson<String?>(json['ventaSyncUuid']),
      tipo: serializer.fromJson<String>(json['tipo']),
      cantidad: serializer.fromJson<double>(json['cantidad']),
      cantidadAnterior: serializer.fromJson<double>(json['cantidadAnterior']),
      cantidadNueva: serializer.fromJson<double>(json['cantidadNueva']),
      pesoTotal: serializer.fromJson<double>(json['pesoTotal']),
      registradoPor: serializer.fromJson<String?>(json['registradoPor']),
      observaciones: serializer.fromJson<String?>(json['observaciones']),
      almacen: serializer.fromJson<String?>(json['almacen']),
      fechaMovimiento: serializer.fromJson<DateTime?>(json['fechaMovimiento']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      sincronizado: serializer.fromJson<int>(json['sincronizado']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productoId': serializer.toJson<int>(productoId),
      'facturaId': serializer.toJson<int?>(facturaId),
      'requisicionId': serializer.toJson<int?>(requisicionId),
      'ventaId': serializer.toJson<int?>(ventaId),
      'ventaSyncUuid': serializer.toJson<String?>(ventaSyncUuid),
      'tipo': serializer.toJson<String>(tipo),
      'cantidad': serializer.toJson<double>(cantidad),
      'cantidadAnterior': serializer.toJson<double>(cantidadAnterior),
      'cantidadNueva': serializer.toJson<double>(cantidadNueva),
      'pesoTotal': serializer.toJson<double>(pesoTotal),
      'registradoPor': serializer.toJson<String?>(registradoPor),
      'observaciones': serializer.toJson<String?>(observaciones),
      'almacen': serializer.toJson<String?>(almacen),
      'fechaMovimiento': serializer.toJson<DateTime?>(fechaMovimiento),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'sincronizado': serializer.toJson<int>(sincronizado),
    };
  }

  Movimiento copyWith(
          {int? id,
          int? productoId,
          Value<int?> facturaId = const Value.absent(),
          Value<int?> requisicionId = const Value.absent(),
          Value<int?> ventaId = const Value.absent(),
          Value<String?> ventaSyncUuid = const Value.absent(),
          String? tipo,
          double? cantidad,
          double? cantidadAnterior,
          double? cantidadNueva,
          double? pesoTotal,
          Value<String?> registradoPor = const Value.absent(),
          Value<String?> observaciones = const Value.absent(),
          Value<String?> almacen = const Value.absent(),
          Value<DateTime?> fechaMovimiento = const Value.absent(),
          Value<DateTime?> createdAt = const Value.absent(),
          int? sincronizado}) =>
      Movimiento(
        id: id ?? this.id,
        productoId: productoId ?? this.productoId,
        facturaId: facturaId.present ? facturaId.value : this.facturaId,
        requisicionId:
            requisicionId.present ? requisicionId.value : this.requisicionId,
        ventaId: ventaId.present ? ventaId.value : this.ventaId,
        ventaSyncUuid:
            ventaSyncUuid.present ? ventaSyncUuid.value : this.ventaSyncUuid,
        tipo: tipo ?? this.tipo,
        cantidad: cantidad ?? this.cantidad,
        cantidadAnterior: cantidadAnterior ?? this.cantidadAnterior,
        cantidadNueva: cantidadNueva ?? this.cantidadNueva,
        pesoTotal: pesoTotal ?? this.pesoTotal,
        registradoPor:
            registradoPor.present ? registradoPor.value : this.registradoPor,
        observaciones:
            observaciones.present ? observaciones.value : this.observaciones,
        almacen: almacen.present ? almacen.value : this.almacen,
        fechaMovimiento: fechaMovimiento.present
            ? fechaMovimiento.value
            : this.fechaMovimiento,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        sincronizado: sincronizado ?? this.sincronizado,
      );
  Movimiento copyWithCompanion(MovimientosCompanion data) {
    return Movimiento(
      id: data.id.present ? data.id.value : this.id,
      productoId:
          data.productoId.present ? data.productoId.value : this.productoId,
      facturaId: data.facturaId.present ? data.facturaId.value : this.facturaId,
      requisicionId: data.requisicionId.present
          ? data.requisicionId.value
          : this.requisicionId,
      ventaId: data.ventaId.present ? data.ventaId.value : this.ventaId,
      ventaSyncUuid: data.ventaSyncUuid.present
          ? data.ventaSyncUuid.value
          : this.ventaSyncUuid,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      cantidadAnterior: data.cantidadAnterior.present
          ? data.cantidadAnterior.value
          : this.cantidadAnterior,
      cantidadNueva: data.cantidadNueva.present
          ? data.cantidadNueva.value
          : this.cantidadNueva,
      pesoTotal: data.pesoTotal.present ? data.pesoTotal.value : this.pesoTotal,
      registradoPor: data.registradoPor.present
          ? data.registradoPor.value
          : this.registradoPor,
      observaciones: data.observaciones.present
          ? data.observaciones.value
          : this.observaciones,
      almacen: data.almacen.present ? data.almacen.value : this.almacen,
      fechaMovimiento: data.fechaMovimiento.present
          ? data.fechaMovimiento.value
          : this.fechaMovimiento,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      sincronizado: data.sincronizado.present
          ? data.sincronizado.value
          : this.sincronizado,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Movimiento(')
          ..write('id: $id, ')
          ..write('productoId: $productoId, ')
          ..write('facturaId: $facturaId, ')
          ..write('requisicionId: $requisicionId, ')
          ..write('ventaId: $ventaId, ')
          ..write('ventaSyncUuid: $ventaSyncUuid, ')
          ..write('tipo: $tipo, ')
          ..write('cantidad: $cantidad, ')
          ..write('cantidadAnterior: $cantidadAnterior, ')
          ..write('cantidadNueva: $cantidadNueva, ')
          ..write('pesoTotal: $pesoTotal, ')
          ..write('registradoPor: $registradoPor, ')
          ..write('observaciones: $observaciones, ')
          ..write('almacen: $almacen, ')
          ..write('fechaMovimiento: $fechaMovimiento, ')
          ..write('createdAt: $createdAt, ')
          ..write('sincronizado: $sincronizado')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      productoId,
      facturaId,
      requisicionId,
      ventaId,
      ventaSyncUuid,
      tipo,
      cantidad,
      cantidadAnterior,
      cantidadNueva,
      pesoTotal,
      registradoPor,
      observaciones,
      almacen,
      fechaMovimiento,
      createdAt,
      sincronizado);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Movimiento &&
          other.id == this.id &&
          other.productoId == this.productoId &&
          other.facturaId == this.facturaId &&
          other.requisicionId == this.requisicionId &&
          other.ventaId == this.ventaId &&
          other.ventaSyncUuid == this.ventaSyncUuid &&
          other.tipo == this.tipo &&
          other.cantidad == this.cantidad &&
          other.cantidadAnterior == this.cantidadAnterior &&
          other.cantidadNueva == this.cantidadNueva &&
          other.pesoTotal == this.pesoTotal &&
          other.registradoPor == this.registradoPor &&
          other.observaciones == this.observaciones &&
          other.almacen == this.almacen &&
          other.fechaMovimiento == this.fechaMovimiento &&
          other.createdAt == this.createdAt &&
          other.sincronizado == this.sincronizado);
}

class MovimientosCompanion extends UpdateCompanion<Movimiento> {
  final Value<int> id;
  final Value<int> productoId;
  final Value<int?> facturaId;
  final Value<int?> requisicionId;
  final Value<int?> ventaId;
  final Value<String?> ventaSyncUuid;
  final Value<String> tipo;
  final Value<double> cantidad;
  final Value<double> cantidadAnterior;
  final Value<double> cantidadNueva;
  final Value<double> pesoTotal;
  final Value<String?> registradoPor;
  final Value<String?> observaciones;
  final Value<String?> almacen;
  final Value<DateTime?> fechaMovimiento;
  final Value<DateTime?> createdAt;
  final Value<int> sincronizado;
  const MovimientosCompanion({
    this.id = const Value.absent(),
    this.productoId = const Value.absent(),
    this.facturaId = const Value.absent(),
    this.requisicionId = const Value.absent(),
    this.ventaId = const Value.absent(),
    this.ventaSyncUuid = const Value.absent(),
    this.tipo = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.cantidadAnterior = const Value.absent(),
    this.cantidadNueva = const Value.absent(),
    this.pesoTotal = const Value.absent(),
    this.registradoPor = const Value.absent(),
    this.observaciones = const Value.absent(),
    this.almacen = const Value.absent(),
    this.fechaMovimiento = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.sincronizado = const Value.absent(),
  });
  MovimientosCompanion.insert({
    this.id = const Value.absent(),
    required int productoId,
    this.facturaId = const Value.absent(),
    this.requisicionId = const Value.absent(),
    this.ventaId = const Value.absent(),
    this.ventaSyncUuid = const Value.absent(),
    required String tipo,
    required double cantidad,
    this.cantidadAnterior = const Value.absent(),
    this.cantidadNueva = const Value.absent(),
    this.pesoTotal = const Value.absent(),
    this.registradoPor = const Value.absent(),
    this.observaciones = const Value.absent(),
    this.almacen = const Value.absent(),
    this.fechaMovimiento = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.sincronizado = const Value.absent(),
  })  : productoId = Value(productoId),
        tipo = Value(tipo),
        cantidad = Value(cantidad);
  static Insertable<Movimiento> custom({
    Expression<int>? id,
    Expression<int>? productoId,
    Expression<int>? facturaId,
    Expression<int>? requisicionId,
    Expression<int>? ventaId,
    Expression<String>? ventaSyncUuid,
    Expression<String>? tipo,
    Expression<double>? cantidad,
    Expression<double>? cantidadAnterior,
    Expression<double>? cantidadNueva,
    Expression<double>? pesoTotal,
    Expression<String>? registradoPor,
    Expression<String>? observaciones,
    Expression<String>? almacen,
    Expression<DateTime>? fechaMovimiento,
    Expression<DateTime>? createdAt,
    Expression<int>? sincronizado,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productoId != null) 'producto_id': productoId,
      if (facturaId != null) 'factura_id': facturaId,
      if (requisicionId != null) 'requisicion_id': requisicionId,
      if (ventaId != null) 'venta_id': ventaId,
      if (ventaSyncUuid != null) 'venta_sync_uuid': ventaSyncUuid,
      if (tipo != null) 'tipo': tipo,
      if (cantidad != null) 'cantidad': cantidad,
      if (cantidadAnterior != null) 'cantidad_anterior': cantidadAnterior,
      if (cantidadNueva != null) 'cantidad_nueva': cantidadNueva,
      if (pesoTotal != null) 'peso_total': pesoTotal,
      if (registradoPor != null) 'registrado_por': registradoPor,
      if (observaciones != null) 'observaciones': observaciones,
      if (almacen != null) 'almacen': almacen,
      if (fechaMovimiento != null) 'fecha_movimiento': fechaMovimiento,
      if (createdAt != null) 'created_at': createdAt,
      if (sincronizado != null) 'sincronizado': sincronizado,
    });
  }

  MovimientosCompanion copyWith(
      {Value<int>? id,
      Value<int>? productoId,
      Value<int?>? facturaId,
      Value<int?>? requisicionId,
      Value<int?>? ventaId,
      Value<String?>? ventaSyncUuid,
      Value<String>? tipo,
      Value<double>? cantidad,
      Value<double>? cantidadAnterior,
      Value<double>? cantidadNueva,
      Value<double>? pesoTotal,
      Value<String?>? registradoPor,
      Value<String?>? observaciones,
      Value<String?>? almacen,
      Value<DateTime?>? fechaMovimiento,
      Value<DateTime?>? createdAt,
      Value<int>? sincronizado}) {
    return MovimientosCompanion(
      id: id ?? this.id,
      productoId: productoId ?? this.productoId,
      facturaId: facturaId ?? this.facturaId,
      requisicionId: requisicionId ?? this.requisicionId,
      ventaId: ventaId ?? this.ventaId,
      ventaSyncUuid: ventaSyncUuid ?? this.ventaSyncUuid,
      tipo: tipo ?? this.tipo,
      cantidad: cantidad ?? this.cantidad,
      cantidadAnterior: cantidadAnterior ?? this.cantidadAnterior,
      cantidadNueva: cantidadNueva ?? this.cantidadNueva,
      pesoTotal: pesoTotal ?? this.pesoTotal,
      registradoPor: registradoPor ?? this.registradoPor,
      observaciones: observaciones ?? this.observaciones,
      almacen: almacen ?? this.almacen,
      fechaMovimiento: fechaMovimiento ?? this.fechaMovimiento,
      createdAt: createdAt ?? this.createdAt,
      sincronizado: sincronizado ?? this.sincronizado,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productoId.present) {
      map['producto_id'] = Variable<int>(productoId.value);
    }
    if (facturaId.present) {
      map['factura_id'] = Variable<int>(facturaId.value);
    }
    if (requisicionId.present) {
      map['requisicion_id'] = Variable<int>(requisicionId.value);
    }
    if (ventaId.present) {
      map['venta_id'] = Variable<int>(ventaId.value);
    }
    if (ventaSyncUuid.present) {
      map['venta_sync_uuid'] = Variable<String>(ventaSyncUuid.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<double>(cantidad.value);
    }
    if (cantidadAnterior.present) {
      map['cantidad_anterior'] = Variable<double>(cantidadAnterior.value);
    }
    if (cantidadNueva.present) {
      map['cantidad_nueva'] = Variable<double>(cantidadNueva.value);
    }
    if (pesoTotal.present) {
      map['peso_total'] = Variable<double>(pesoTotal.value);
    }
    if (registradoPor.present) {
      map['registrado_por'] = Variable<String>(registradoPor.value);
    }
    if (observaciones.present) {
      map['observaciones'] = Variable<String>(observaciones.value);
    }
    if (almacen.present) {
      map['almacen'] = Variable<String>(almacen.value);
    }
    if (fechaMovimiento.present) {
      map['fecha_movimiento'] = Variable<DateTime>(fechaMovimiento.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (sincronizado.present) {
      map['sincronizado'] = Variable<int>(sincronizado.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MovimientosCompanion(')
          ..write('id: $id, ')
          ..write('productoId: $productoId, ')
          ..write('facturaId: $facturaId, ')
          ..write('requisicionId: $requisicionId, ')
          ..write('ventaId: $ventaId, ')
          ..write('ventaSyncUuid: $ventaSyncUuid, ')
          ..write('tipo: $tipo, ')
          ..write('cantidad: $cantidad, ')
          ..write('cantidadAnterior: $cantidadAnterior, ')
          ..write('cantidadNueva: $cantidadNueva, ')
          ..write('pesoTotal: $pesoTotal, ')
          ..write('registradoPor: $registradoPor, ')
          ..write('observaciones: $observaciones, ')
          ..write('almacen: $almacen, ')
          ..write('fechaMovimiento: $fechaMovimiento, ')
          ..write('createdAt: $createdAt, ')
          ..write('sincronizado: $sincronizado')
          ..write(')'))
        .toString();
  }
}

class $MovimientosArchivoTable extends MovimientosArchivo
    with TableInfo<$MovimientosArchivoTable, MovimientosArchivoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MovimientosArchivoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _productoIdMeta =
      const VerificationMeta('productoId');
  @override
  late final GeneratedColumn<int> productoId = GeneratedColumn<int>(
      'producto_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _facturaIdMeta =
      const VerificationMeta('facturaId');
  @override
  late final GeneratedColumn<int> facturaId = GeneratedColumn<int>(
      'factura_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _requisicionIdMeta =
      const VerificationMeta('requisicionId');
  @override
  late final GeneratedColumn<int> requisicionId = GeneratedColumn<int>(
      'requisicion_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
      'tipo', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 30),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _cantidadMeta =
      const VerificationMeta('cantidad');
  @override
  late final GeneratedColumn<double> cantidad = GeneratedColumn<double>(
      'cantidad', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _cantidadAnteriorMeta =
      const VerificationMeta('cantidadAnterior');
  @override
  late final GeneratedColumn<double> cantidadAnterior = GeneratedColumn<double>(
      'cantidad_anterior', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _cantidadNuevaMeta =
      const VerificationMeta('cantidadNueva');
  @override
  late final GeneratedColumn<double> cantidadNueva = GeneratedColumn<double>(
      'cantidad_nueva', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _pesoTotalMeta =
      const VerificationMeta('pesoTotal');
  @override
  late final GeneratedColumn<double> pesoTotal = GeneratedColumn<double>(
      'peso_total', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _registradoPorMeta =
      const VerificationMeta('registradoPor');
  @override
  late final GeneratedColumn<String> registradoPor = GeneratedColumn<String>(
      'registrado_por', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _observacionesMeta =
      const VerificationMeta('observaciones');
  @override
  late final GeneratedColumn<String> observaciones = GeneratedColumn<String>(
      'observaciones', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _almacenMeta =
      const VerificationMeta('almacen');
  @override
  late final GeneratedColumn<String> almacen = GeneratedColumn<String>(
      'almacen', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fechaMovimientoMeta =
      const VerificationMeta('fechaMovimiento');
  @override
  late final GeneratedColumn<DateTime> fechaMovimiento =
      GeneratedColumn<DateTime>('fecha_movimiento', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        productoId,
        facturaId,
        requisicionId,
        tipo,
        cantidad,
        cantidadAnterior,
        cantidadNueva,
        pesoTotal,
        registradoPor,
        observaciones,
        almacen,
        fechaMovimiento,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'movimientos_archivo';
  @override
  VerificationContext validateIntegrity(
      Insertable<MovimientosArchivoData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('producto_id')) {
      context.handle(
          _productoIdMeta,
          productoId.isAcceptableOrUnknown(
              data['producto_id']!, _productoIdMeta));
    } else if (isInserting) {
      context.missing(_productoIdMeta);
    }
    if (data.containsKey('factura_id')) {
      context.handle(_facturaIdMeta,
          facturaId.isAcceptableOrUnknown(data['factura_id']!, _facturaIdMeta));
    }
    if (data.containsKey('requisicion_id')) {
      context.handle(
          _requisicionIdMeta,
          requisicionId.isAcceptableOrUnknown(
              data['requisicion_id']!, _requisicionIdMeta));
    }
    if (data.containsKey('tipo')) {
      context.handle(
          _tipoMeta, tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta));
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(_cantidadMeta,
          cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta));
    } else if (isInserting) {
      context.missing(_cantidadMeta);
    }
    if (data.containsKey('cantidad_anterior')) {
      context.handle(
          _cantidadAnteriorMeta,
          cantidadAnterior.isAcceptableOrUnknown(
              data['cantidad_anterior']!, _cantidadAnteriorMeta));
    }
    if (data.containsKey('cantidad_nueva')) {
      context.handle(
          _cantidadNuevaMeta,
          cantidadNueva.isAcceptableOrUnknown(
              data['cantidad_nueva']!, _cantidadNuevaMeta));
    }
    if (data.containsKey('peso_total')) {
      context.handle(_pesoTotalMeta,
          pesoTotal.isAcceptableOrUnknown(data['peso_total']!, _pesoTotalMeta));
    }
    if (data.containsKey('registrado_por')) {
      context.handle(
          _registradoPorMeta,
          registradoPor.isAcceptableOrUnknown(
              data['registrado_por']!, _registradoPorMeta));
    }
    if (data.containsKey('observaciones')) {
      context.handle(
          _observacionesMeta,
          observaciones.isAcceptableOrUnknown(
              data['observaciones']!, _observacionesMeta));
    }
    if (data.containsKey('almacen')) {
      context.handle(_almacenMeta,
          almacen.isAcceptableOrUnknown(data['almacen']!, _almacenMeta));
    }
    if (data.containsKey('fecha_movimiento')) {
      context.handle(
          _fechaMovimientoMeta,
          fechaMovimiento.isAcceptableOrUnknown(
              data['fecha_movimiento']!, _fechaMovimientoMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MovimientosArchivoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MovimientosArchivoData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      productoId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}producto_id'])!,
      facturaId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}factura_id']),
      requisicionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}requisicion_id']),
      tipo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tipo'])!,
      cantidad: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cantidad'])!,
      cantidadAnterior: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}cantidad_anterior'])!,
      cantidadNueva: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cantidad_nueva'])!,
      pesoTotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}peso_total'])!,
      registradoPor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}registrado_por']),
      observaciones: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}observaciones']),
      almacen: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}almacen']),
      fechaMovimiento: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}fecha_movimiento']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
    );
  }

  @override
  $MovimientosArchivoTable createAlias(String alias) {
    return $MovimientosArchivoTable(attachedDatabase, alias);
  }
}

class MovimientosArchivoData extends DataClass
    implements Insertable<MovimientosArchivoData> {
  final int id;
  final int productoId;
  final int? facturaId;
  final int? requisicionId;
  final String tipo;
  final double cantidad;
  final double cantidadAnterior;
  final double cantidadNueva;
  final double pesoTotal;
  final String? registradoPor;
  final String? observaciones;
  final String? almacen;
  final DateTime? fechaMovimiento;
  final DateTime? createdAt;
  const MovimientosArchivoData(
      {required this.id,
      required this.productoId,
      this.facturaId,
      this.requisicionId,
      required this.tipo,
      required this.cantidad,
      required this.cantidadAnterior,
      required this.cantidadNueva,
      required this.pesoTotal,
      this.registradoPor,
      this.observaciones,
      this.almacen,
      this.fechaMovimiento,
      this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['producto_id'] = Variable<int>(productoId);
    if (!nullToAbsent || facturaId != null) {
      map['factura_id'] = Variable<int>(facturaId);
    }
    if (!nullToAbsent || requisicionId != null) {
      map['requisicion_id'] = Variable<int>(requisicionId);
    }
    map['tipo'] = Variable<String>(tipo);
    map['cantidad'] = Variable<double>(cantidad);
    map['cantidad_anterior'] = Variable<double>(cantidadAnterior);
    map['cantidad_nueva'] = Variable<double>(cantidadNueva);
    map['peso_total'] = Variable<double>(pesoTotal);
    if (!nullToAbsent || registradoPor != null) {
      map['registrado_por'] = Variable<String>(registradoPor);
    }
    if (!nullToAbsent || observaciones != null) {
      map['observaciones'] = Variable<String>(observaciones);
    }
    if (!nullToAbsent || almacen != null) {
      map['almacen'] = Variable<String>(almacen);
    }
    if (!nullToAbsent || fechaMovimiento != null) {
      map['fecha_movimiento'] = Variable<DateTime>(fechaMovimiento);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  MovimientosArchivoCompanion toCompanion(bool nullToAbsent) {
    return MovimientosArchivoCompanion(
      id: Value(id),
      productoId: Value(productoId),
      facturaId: facturaId == null && nullToAbsent
          ? const Value.absent()
          : Value(facturaId),
      requisicionId: requisicionId == null && nullToAbsent
          ? const Value.absent()
          : Value(requisicionId),
      tipo: Value(tipo),
      cantidad: Value(cantidad),
      cantidadAnterior: Value(cantidadAnterior),
      cantidadNueva: Value(cantidadNueva),
      pesoTotal: Value(pesoTotal),
      registradoPor: registradoPor == null && nullToAbsent
          ? const Value.absent()
          : Value(registradoPor),
      observaciones: observaciones == null && nullToAbsent
          ? const Value.absent()
          : Value(observaciones),
      almacen: almacen == null && nullToAbsent
          ? const Value.absent()
          : Value(almacen),
      fechaMovimiento: fechaMovimiento == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaMovimiento),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory MovimientosArchivoData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MovimientosArchivoData(
      id: serializer.fromJson<int>(json['id']),
      productoId: serializer.fromJson<int>(json['productoId']),
      facturaId: serializer.fromJson<int?>(json['facturaId']),
      requisicionId: serializer.fromJson<int?>(json['requisicionId']),
      tipo: serializer.fromJson<String>(json['tipo']),
      cantidad: serializer.fromJson<double>(json['cantidad']),
      cantidadAnterior: serializer.fromJson<double>(json['cantidadAnterior']),
      cantidadNueva: serializer.fromJson<double>(json['cantidadNueva']),
      pesoTotal: serializer.fromJson<double>(json['pesoTotal']),
      registradoPor: serializer.fromJson<String?>(json['registradoPor']),
      observaciones: serializer.fromJson<String?>(json['observaciones']),
      almacen: serializer.fromJson<String?>(json['almacen']),
      fechaMovimiento: serializer.fromJson<DateTime?>(json['fechaMovimiento']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productoId': serializer.toJson<int>(productoId),
      'facturaId': serializer.toJson<int?>(facturaId),
      'requisicionId': serializer.toJson<int?>(requisicionId),
      'tipo': serializer.toJson<String>(tipo),
      'cantidad': serializer.toJson<double>(cantidad),
      'cantidadAnterior': serializer.toJson<double>(cantidadAnterior),
      'cantidadNueva': serializer.toJson<double>(cantidadNueva),
      'pesoTotal': serializer.toJson<double>(pesoTotal),
      'registradoPor': serializer.toJson<String?>(registradoPor),
      'observaciones': serializer.toJson<String?>(observaciones),
      'almacen': serializer.toJson<String?>(almacen),
      'fechaMovimiento': serializer.toJson<DateTime?>(fechaMovimiento),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  MovimientosArchivoData copyWith(
          {int? id,
          int? productoId,
          Value<int?> facturaId = const Value.absent(),
          Value<int?> requisicionId = const Value.absent(),
          String? tipo,
          double? cantidad,
          double? cantidadAnterior,
          double? cantidadNueva,
          double? pesoTotal,
          Value<String?> registradoPor = const Value.absent(),
          Value<String?> observaciones = const Value.absent(),
          Value<String?> almacen = const Value.absent(),
          Value<DateTime?> fechaMovimiento = const Value.absent(),
          Value<DateTime?> createdAt = const Value.absent()}) =>
      MovimientosArchivoData(
        id: id ?? this.id,
        productoId: productoId ?? this.productoId,
        facturaId: facturaId.present ? facturaId.value : this.facturaId,
        requisicionId:
            requisicionId.present ? requisicionId.value : this.requisicionId,
        tipo: tipo ?? this.tipo,
        cantidad: cantidad ?? this.cantidad,
        cantidadAnterior: cantidadAnterior ?? this.cantidadAnterior,
        cantidadNueva: cantidadNueva ?? this.cantidadNueva,
        pesoTotal: pesoTotal ?? this.pesoTotal,
        registradoPor:
            registradoPor.present ? registradoPor.value : this.registradoPor,
        observaciones:
            observaciones.present ? observaciones.value : this.observaciones,
        almacen: almacen.present ? almacen.value : this.almacen,
        fechaMovimiento: fechaMovimiento.present
            ? fechaMovimiento.value
            : this.fechaMovimiento,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
      );
  MovimientosArchivoData copyWithCompanion(MovimientosArchivoCompanion data) {
    return MovimientosArchivoData(
      id: data.id.present ? data.id.value : this.id,
      productoId:
          data.productoId.present ? data.productoId.value : this.productoId,
      facturaId: data.facturaId.present ? data.facturaId.value : this.facturaId,
      requisicionId: data.requisicionId.present
          ? data.requisicionId.value
          : this.requisicionId,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      cantidadAnterior: data.cantidadAnterior.present
          ? data.cantidadAnterior.value
          : this.cantidadAnterior,
      cantidadNueva: data.cantidadNueva.present
          ? data.cantidadNueva.value
          : this.cantidadNueva,
      pesoTotal: data.pesoTotal.present ? data.pesoTotal.value : this.pesoTotal,
      registradoPor: data.registradoPor.present
          ? data.registradoPor.value
          : this.registradoPor,
      observaciones: data.observaciones.present
          ? data.observaciones.value
          : this.observaciones,
      almacen: data.almacen.present ? data.almacen.value : this.almacen,
      fechaMovimiento: data.fechaMovimiento.present
          ? data.fechaMovimiento.value
          : this.fechaMovimiento,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MovimientosArchivoData(')
          ..write('id: $id, ')
          ..write('productoId: $productoId, ')
          ..write('facturaId: $facturaId, ')
          ..write('requisicionId: $requisicionId, ')
          ..write('tipo: $tipo, ')
          ..write('cantidad: $cantidad, ')
          ..write('cantidadAnterior: $cantidadAnterior, ')
          ..write('cantidadNueva: $cantidadNueva, ')
          ..write('pesoTotal: $pesoTotal, ')
          ..write('registradoPor: $registradoPor, ')
          ..write('observaciones: $observaciones, ')
          ..write('almacen: $almacen, ')
          ..write('fechaMovimiento: $fechaMovimiento, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      productoId,
      facturaId,
      requisicionId,
      tipo,
      cantidad,
      cantidadAnterior,
      cantidadNueva,
      pesoTotal,
      registradoPor,
      observaciones,
      almacen,
      fechaMovimiento,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MovimientosArchivoData &&
          other.id == this.id &&
          other.productoId == this.productoId &&
          other.facturaId == this.facturaId &&
          other.requisicionId == this.requisicionId &&
          other.tipo == this.tipo &&
          other.cantidad == this.cantidad &&
          other.cantidadAnterior == this.cantidadAnterior &&
          other.cantidadNueva == this.cantidadNueva &&
          other.pesoTotal == this.pesoTotal &&
          other.registradoPor == this.registradoPor &&
          other.observaciones == this.observaciones &&
          other.almacen == this.almacen &&
          other.fechaMovimiento == this.fechaMovimiento &&
          other.createdAt == this.createdAt);
}

class MovimientosArchivoCompanion
    extends UpdateCompanion<MovimientosArchivoData> {
  final Value<int> id;
  final Value<int> productoId;
  final Value<int?> facturaId;
  final Value<int?> requisicionId;
  final Value<String> tipo;
  final Value<double> cantidad;
  final Value<double> cantidadAnterior;
  final Value<double> cantidadNueva;
  final Value<double> pesoTotal;
  final Value<String?> registradoPor;
  final Value<String?> observaciones;
  final Value<String?> almacen;
  final Value<DateTime?> fechaMovimiento;
  final Value<DateTime?> createdAt;
  const MovimientosArchivoCompanion({
    this.id = const Value.absent(),
    this.productoId = const Value.absent(),
    this.facturaId = const Value.absent(),
    this.requisicionId = const Value.absent(),
    this.tipo = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.cantidadAnterior = const Value.absent(),
    this.cantidadNueva = const Value.absent(),
    this.pesoTotal = const Value.absent(),
    this.registradoPor = const Value.absent(),
    this.observaciones = const Value.absent(),
    this.almacen = const Value.absent(),
    this.fechaMovimiento = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MovimientosArchivoCompanion.insert({
    this.id = const Value.absent(),
    required int productoId,
    this.facturaId = const Value.absent(),
    this.requisicionId = const Value.absent(),
    required String tipo,
    required double cantidad,
    this.cantidadAnterior = const Value.absent(),
    this.cantidadNueva = const Value.absent(),
    this.pesoTotal = const Value.absent(),
    this.registradoPor = const Value.absent(),
    this.observaciones = const Value.absent(),
    this.almacen = const Value.absent(),
    this.fechaMovimiento = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : productoId = Value(productoId),
        tipo = Value(tipo),
        cantidad = Value(cantidad);
  static Insertable<MovimientosArchivoData> custom({
    Expression<int>? id,
    Expression<int>? productoId,
    Expression<int>? facturaId,
    Expression<int>? requisicionId,
    Expression<String>? tipo,
    Expression<double>? cantidad,
    Expression<double>? cantidadAnterior,
    Expression<double>? cantidadNueva,
    Expression<double>? pesoTotal,
    Expression<String>? registradoPor,
    Expression<String>? observaciones,
    Expression<String>? almacen,
    Expression<DateTime>? fechaMovimiento,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productoId != null) 'producto_id': productoId,
      if (facturaId != null) 'factura_id': facturaId,
      if (requisicionId != null) 'requisicion_id': requisicionId,
      if (tipo != null) 'tipo': tipo,
      if (cantidad != null) 'cantidad': cantidad,
      if (cantidadAnterior != null) 'cantidad_anterior': cantidadAnterior,
      if (cantidadNueva != null) 'cantidad_nueva': cantidadNueva,
      if (pesoTotal != null) 'peso_total': pesoTotal,
      if (registradoPor != null) 'registrado_por': registradoPor,
      if (observaciones != null) 'observaciones': observaciones,
      if (almacen != null) 'almacen': almacen,
      if (fechaMovimiento != null) 'fecha_movimiento': fechaMovimiento,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MovimientosArchivoCompanion copyWith(
      {Value<int>? id,
      Value<int>? productoId,
      Value<int?>? facturaId,
      Value<int?>? requisicionId,
      Value<String>? tipo,
      Value<double>? cantidad,
      Value<double>? cantidadAnterior,
      Value<double>? cantidadNueva,
      Value<double>? pesoTotal,
      Value<String?>? registradoPor,
      Value<String?>? observaciones,
      Value<String?>? almacen,
      Value<DateTime?>? fechaMovimiento,
      Value<DateTime?>? createdAt}) {
    return MovimientosArchivoCompanion(
      id: id ?? this.id,
      productoId: productoId ?? this.productoId,
      facturaId: facturaId ?? this.facturaId,
      requisicionId: requisicionId ?? this.requisicionId,
      tipo: tipo ?? this.tipo,
      cantidad: cantidad ?? this.cantidad,
      cantidadAnterior: cantidadAnterior ?? this.cantidadAnterior,
      cantidadNueva: cantidadNueva ?? this.cantidadNueva,
      pesoTotal: pesoTotal ?? this.pesoTotal,
      registradoPor: registradoPor ?? this.registradoPor,
      observaciones: observaciones ?? this.observaciones,
      almacen: almacen ?? this.almacen,
      fechaMovimiento: fechaMovimiento ?? this.fechaMovimiento,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productoId.present) {
      map['producto_id'] = Variable<int>(productoId.value);
    }
    if (facturaId.present) {
      map['factura_id'] = Variable<int>(facturaId.value);
    }
    if (requisicionId.present) {
      map['requisicion_id'] = Variable<int>(requisicionId.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<double>(cantidad.value);
    }
    if (cantidadAnterior.present) {
      map['cantidad_anterior'] = Variable<double>(cantidadAnterior.value);
    }
    if (cantidadNueva.present) {
      map['cantidad_nueva'] = Variable<double>(cantidadNueva.value);
    }
    if (pesoTotal.present) {
      map['peso_total'] = Variable<double>(pesoTotal.value);
    }
    if (registradoPor.present) {
      map['registrado_por'] = Variable<String>(registradoPor.value);
    }
    if (observaciones.present) {
      map['observaciones'] = Variable<String>(observaciones.value);
    }
    if (almacen.present) {
      map['almacen'] = Variable<String>(almacen.value);
    }
    if (fechaMovimiento.present) {
      map['fecha_movimiento'] = Variable<DateTime>(fechaMovimiento.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MovimientosArchivoCompanion(')
          ..write('id: $id, ')
          ..write('productoId: $productoId, ')
          ..write('facturaId: $facturaId, ')
          ..write('requisicionId: $requisicionId, ')
          ..write('tipo: $tipo, ')
          ..write('cantidad: $cantidad, ')
          ..write('cantidadAnterior: $cantidadAnterior, ')
          ..write('cantidadNueva: $cantidadNueva, ')
          ..write('pesoTotal: $pesoTotal, ')
          ..write('registradoPor: $registradoPor, ')
          ..write('observaciones: $observaciones, ')
          ..write('almacen: $almacen, ')
          ..write('fechaMovimiento: $fechaMovimiento, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $FacturasTable extends Facturas with TableInfo<$FacturasTable, Factura> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FacturasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _numeroFacturaMeta =
      const VerificationMeta('numeroFactura');
  @override
  late final GeneratedColumn<String> numeroFactura = GeneratedColumn<String>(
      'numero_factura', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _tipoDocumentoMeta =
      const VerificationMeta('tipoDocumento');
  @override
  late final GeneratedColumn<String> tipoDocumento = GeneratedColumn<String>(
      'tipo_documento', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Factura'));
  static const VerificationMeta _proveedorMeta =
      const VerificationMeta('proveedor');
  @override
  late final GeneratedColumn<String> proveedor = GeneratedColumn<String>(
      'proveedor', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _fechaFacturaMeta =
      const VerificationMeta('fechaFactura');
  @override
  late final GeneratedColumn<DateTime> fechaFactura = GeneratedColumn<DateTime>(
      'fecha_factura', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _fechaRecepcionMeta =
      const VerificationMeta('fechaRecepcion');
  @override
  late final GeneratedColumn<DateTime> fechaRecepcion =
      GeneratedColumn<DateTime>('fecha_recepcion', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _totalBrutoMeta =
      const VerificationMeta('totalBruto');
  @override
  late final GeneratedColumn<double> totalBruto = GeneratedColumn<double>(
      'total_bruto', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _totalImpuestosMeta =
      const VerificationMeta('totalImpuestos');
  @override
  late final GeneratedColumn<double> totalImpuestos = GeneratedColumn<double>(
      'total_impuestos', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _totalNetoMeta =
      const VerificationMeta('totalNeto');
  @override
  late final GeneratedColumn<double> totalNeto = GeneratedColumn<double>(
      'total_neto', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
      'estado', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Pendiente'));
  static const VerificationMeta _observacionesMeta =
      const VerificationMeta('observaciones');
  @override
  late final GeneratedColumn<String> observaciones = GeneratedColumn<String>(
      'observaciones', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _validadaPorMeta =
      const VerificationMeta('validadaPor');
  @override
  late final GeneratedColumn<String> validadaPor = GeneratedColumn<String>(
      'validada_por', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fechaValidacionMeta =
      const VerificationMeta('fechaValidacion');
  @override
  late final GeneratedColumn<DateTime> fechaValidacion =
      GeneratedColumn<DateTime>('fecha_validacion', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        numeroFactura,
        tipoDocumento,
        proveedor,
        fechaFactura,
        fechaRecepcion,
        totalBruto,
        totalImpuestos,
        totalNeto,
        estado,
        observaciones,
        validadaPor,
        fechaValidacion,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'facturas';
  @override
  VerificationContext validateIntegrity(Insertable<Factura> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('numero_factura')) {
      context.handle(
          _numeroFacturaMeta,
          numeroFactura.isAcceptableOrUnknown(
              data['numero_factura']!, _numeroFacturaMeta));
    }
    if (data.containsKey('tipo_documento')) {
      context.handle(
          _tipoDocumentoMeta,
          tipoDocumento.isAcceptableOrUnknown(
              data['tipo_documento']!, _tipoDocumentoMeta));
    }
    if (data.containsKey('proveedor')) {
      context.handle(_proveedorMeta,
          proveedor.isAcceptableOrUnknown(data['proveedor']!, _proveedorMeta));
    }
    if (data.containsKey('fecha_factura')) {
      context.handle(
          _fechaFacturaMeta,
          fechaFactura.isAcceptableOrUnknown(
              data['fecha_factura']!, _fechaFacturaMeta));
    }
    if (data.containsKey('fecha_recepcion')) {
      context.handle(
          _fechaRecepcionMeta,
          fechaRecepcion.isAcceptableOrUnknown(
              data['fecha_recepcion']!, _fechaRecepcionMeta));
    }
    if (data.containsKey('total_bruto')) {
      context.handle(
          _totalBrutoMeta,
          totalBruto.isAcceptableOrUnknown(
              data['total_bruto']!, _totalBrutoMeta));
    }
    if (data.containsKey('total_impuestos')) {
      context.handle(
          _totalImpuestosMeta,
          totalImpuestos.isAcceptableOrUnknown(
              data['total_impuestos']!, _totalImpuestosMeta));
    }
    if (data.containsKey('total_neto')) {
      context.handle(_totalNetoMeta,
          totalNeto.isAcceptableOrUnknown(data['total_neto']!, _totalNetoMeta));
    }
    if (data.containsKey('estado')) {
      context.handle(_estadoMeta,
          estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta));
    }
    if (data.containsKey('observaciones')) {
      context.handle(
          _observacionesMeta,
          observaciones.isAcceptableOrUnknown(
              data['observaciones']!, _observacionesMeta));
    }
    if (data.containsKey('validada_por')) {
      context.handle(
          _validadaPorMeta,
          validadaPor.isAcceptableOrUnknown(
              data['validada_por']!, _validadaPorMeta));
    }
    if (data.containsKey('fecha_validacion')) {
      context.handle(
          _fechaValidacionMeta,
          fechaValidacion.isAcceptableOrUnknown(
              data['fecha_validacion']!, _fechaValidacionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Factura map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Factura(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      numeroFactura: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}numero_factura']),
      tipoDocumento: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tipo_documento'])!,
      proveedor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}proveedor']),
      fechaFactura: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}fecha_factura']),
      fechaRecepcion: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}fecha_recepcion']),
      totalBruto: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_bruto'])!,
      totalImpuestos: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}total_impuestos'])!,
      totalNeto: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_neto'])!,
      estado: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}estado'])!,
      observaciones: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}observaciones']),
      validadaPor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}validada_por']),
      fechaValidacion: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}fecha_validacion']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $FacturasTable createAlias(String alias) {
    return $FacturasTable(attachedDatabase, alias);
  }
}

class Factura extends DataClass implements Insertable<Factura> {
  final int id;
  final String? numeroFactura;
  final String tipoDocumento;
  final String? proveedor;
  final DateTime? fechaFactura;
  final DateTime? fechaRecepcion;
  final double totalBruto;
  final double totalImpuestos;
  final double totalNeto;
  final String estado;
  final String? observaciones;
  final String? validadaPor;
  final DateTime? fechaValidacion;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const Factura(
      {required this.id,
      this.numeroFactura,
      required this.tipoDocumento,
      this.proveedor,
      this.fechaFactura,
      this.fechaRecepcion,
      required this.totalBruto,
      required this.totalImpuestos,
      required this.totalNeto,
      required this.estado,
      this.observaciones,
      this.validadaPor,
      this.fechaValidacion,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || numeroFactura != null) {
      map['numero_factura'] = Variable<String>(numeroFactura);
    }
    map['tipo_documento'] = Variable<String>(tipoDocumento);
    if (!nullToAbsent || proveedor != null) {
      map['proveedor'] = Variable<String>(proveedor);
    }
    if (!nullToAbsent || fechaFactura != null) {
      map['fecha_factura'] = Variable<DateTime>(fechaFactura);
    }
    if (!nullToAbsent || fechaRecepcion != null) {
      map['fecha_recepcion'] = Variable<DateTime>(fechaRecepcion);
    }
    map['total_bruto'] = Variable<double>(totalBruto);
    map['total_impuestos'] = Variable<double>(totalImpuestos);
    map['total_neto'] = Variable<double>(totalNeto);
    map['estado'] = Variable<String>(estado);
    if (!nullToAbsent || observaciones != null) {
      map['observaciones'] = Variable<String>(observaciones);
    }
    if (!nullToAbsent || validadaPor != null) {
      map['validada_por'] = Variable<String>(validadaPor);
    }
    if (!nullToAbsent || fechaValidacion != null) {
      map['fecha_validacion'] = Variable<DateTime>(fechaValidacion);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  FacturasCompanion toCompanion(bool nullToAbsent) {
    return FacturasCompanion(
      id: Value(id),
      numeroFactura: numeroFactura == null && nullToAbsent
          ? const Value.absent()
          : Value(numeroFactura),
      tipoDocumento: Value(tipoDocumento),
      proveedor: proveedor == null && nullToAbsent
          ? const Value.absent()
          : Value(proveedor),
      fechaFactura: fechaFactura == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaFactura),
      fechaRecepcion: fechaRecepcion == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaRecepcion),
      totalBruto: Value(totalBruto),
      totalImpuestos: Value(totalImpuestos),
      totalNeto: Value(totalNeto),
      estado: Value(estado),
      observaciones: observaciones == null && nullToAbsent
          ? const Value.absent()
          : Value(observaciones),
      validadaPor: validadaPor == null && nullToAbsent
          ? const Value.absent()
          : Value(validadaPor),
      fechaValidacion: fechaValidacion == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaValidacion),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Factura.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Factura(
      id: serializer.fromJson<int>(json['id']),
      numeroFactura: serializer.fromJson<String?>(json['numeroFactura']),
      tipoDocumento: serializer.fromJson<String>(json['tipoDocumento']),
      proveedor: serializer.fromJson<String?>(json['proveedor']),
      fechaFactura: serializer.fromJson<DateTime?>(json['fechaFactura']),
      fechaRecepcion: serializer.fromJson<DateTime?>(json['fechaRecepcion']),
      totalBruto: serializer.fromJson<double>(json['totalBruto']),
      totalImpuestos: serializer.fromJson<double>(json['totalImpuestos']),
      totalNeto: serializer.fromJson<double>(json['totalNeto']),
      estado: serializer.fromJson<String>(json['estado']),
      observaciones: serializer.fromJson<String?>(json['observaciones']),
      validadaPor: serializer.fromJson<String?>(json['validadaPor']),
      fechaValidacion: serializer.fromJson<DateTime?>(json['fechaValidacion']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'numeroFactura': serializer.toJson<String?>(numeroFactura),
      'tipoDocumento': serializer.toJson<String>(tipoDocumento),
      'proveedor': serializer.toJson<String?>(proveedor),
      'fechaFactura': serializer.toJson<DateTime?>(fechaFactura),
      'fechaRecepcion': serializer.toJson<DateTime?>(fechaRecepcion),
      'totalBruto': serializer.toJson<double>(totalBruto),
      'totalImpuestos': serializer.toJson<double>(totalImpuestos),
      'totalNeto': serializer.toJson<double>(totalNeto),
      'estado': serializer.toJson<String>(estado),
      'observaciones': serializer.toJson<String?>(observaciones),
      'validadaPor': serializer.toJson<String?>(validadaPor),
      'fechaValidacion': serializer.toJson<DateTime?>(fechaValidacion),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Factura copyWith(
          {int? id,
          Value<String?> numeroFactura = const Value.absent(),
          String? tipoDocumento,
          Value<String?> proveedor = const Value.absent(),
          Value<DateTime?> fechaFactura = const Value.absent(),
          Value<DateTime?> fechaRecepcion = const Value.absent(),
          double? totalBruto,
          double? totalImpuestos,
          double? totalNeto,
          String? estado,
          Value<String?> observaciones = const Value.absent(),
          Value<String?> validadaPor = const Value.absent(),
          Value<DateTime?> fechaValidacion = const Value.absent(),
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      Factura(
        id: id ?? this.id,
        numeroFactura:
            numeroFactura.present ? numeroFactura.value : this.numeroFactura,
        tipoDocumento: tipoDocumento ?? this.tipoDocumento,
        proveedor: proveedor.present ? proveedor.value : this.proveedor,
        fechaFactura:
            fechaFactura.present ? fechaFactura.value : this.fechaFactura,
        fechaRecepcion:
            fechaRecepcion.present ? fechaRecepcion.value : this.fechaRecepcion,
        totalBruto: totalBruto ?? this.totalBruto,
        totalImpuestos: totalImpuestos ?? this.totalImpuestos,
        totalNeto: totalNeto ?? this.totalNeto,
        estado: estado ?? this.estado,
        observaciones:
            observaciones.present ? observaciones.value : this.observaciones,
        validadaPor: validadaPor.present ? validadaPor.value : this.validadaPor,
        fechaValidacion: fechaValidacion.present
            ? fechaValidacion.value
            : this.fechaValidacion,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  Factura copyWithCompanion(FacturasCompanion data) {
    return Factura(
      id: data.id.present ? data.id.value : this.id,
      numeroFactura: data.numeroFactura.present
          ? data.numeroFactura.value
          : this.numeroFactura,
      tipoDocumento: data.tipoDocumento.present
          ? data.tipoDocumento.value
          : this.tipoDocumento,
      proveedor: data.proveedor.present ? data.proveedor.value : this.proveedor,
      fechaFactura: data.fechaFactura.present
          ? data.fechaFactura.value
          : this.fechaFactura,
      fechaRecepcion: data.fechaRecepcion.present
          ? data.fechaRecepcion.value
          : this.fechaRecepcion,
      totalBruto:
          data.totalBruto.present ? data.totalBruto.value : this.totalBruto,
      totalImpuestos: data.totalImpuestos.present
          ? data.totalImpuestos.value
          : this.totalImpuestos,
      totalNeto: data.totalNeto.present ? data.totalNeto.value : this.totalNeto,
      estado: data.estado.present ? data.estado.value : this.estado,
      observaciones: data.observaciones.present
          ? data.observaciones.value
          : this.observaciones,
      validadaPor:
          data.validadaPor.present ? data.validadaPor.value : this.validadaPor,
      fechaValidacion: data.fechaValidacion.present
          ? data.fechaValidacion.value
          : this.fechaValidacion,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Factura(')
          ..write('id: $id, ')
          ..write('numeroFactura: $numeroFactura, ')
          ..write('tipoDocumento: $tipoDocumento, ')
          ..write('proveedor: $proveedor, ')
          ..write('fechaFactura: $fechaFactura, ')
          ..write('fechaRecepcion: $fechaRecepcion, ')
          ..write('totalBruto: $totalBruto, ')
          ..write('totalImpuestos: $totalImpuestos, ')
          ..write('totalNeto: $totalNeto, ')
          ..write('estado: $estado, ')
          ..write('observaciones: $observaciones, ')
          ..write('validadaPor: $validadaPor, ')
          ..write('fechaValidacion: $fechaValidacion, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      numeroFactura,
      tipoDocumento,
      proveedor,
      fechaFactura,
      fechaRecepcion,
      totalBruto,
      totalImpuestos,
      totalNeto,
      estado,
      observaciones,
      validadaPor,
      fechaValidacion,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Factura &&
          other.id == this.id &&
          other.numeroFactura == this.numeroFactura &&
          other.tipoDocumento == this.tipoDocumento &&
          other.proveedor == this.proveedor &&
          other.fechaFactura == this.fechaFactura &&
          other.fechaRecepcion == this.fechaRecepcion &&
          other.totalBruto == this.totalBruto &&
          other.totalImpuestos == this.totalImpuestos &&
          other.totalNeto == this.totalNeto &&
          other.estado == this.estado &&
          other.observaciones == this.observaciones &&
          other.validadaPor == this.validadaPor &&
          other.fechaValidacion == this.fechaValidacion &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class FacturasCompanion extends UpdateCompanion<Factura> {
  final Value<int> id;
  final Value<String?> numeroFactura;
  final Value<String> tipoDocumento;
  final Value<String?> proveedor;
  final Value<DateTime?> fechaFactura;
  final Value<DateTime?> fechaRecepcion;
  final Value<double> totalBruto;
  final Value<double> totalImpuestos;
  final Value<double> totalNeto;
  final Value<String> estado;
  final Value<String?> observaciones;
  final Value<String?> validadaPor;
  final Value<DateTime?> fechaValidacion;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  const FacturasCompanion({
    this.id = const Value.absent(),
    this.numeroFactura = const Value.absent(),
    this.tipoDocumento = const Value.absent(),
    this.proveedor = const Value.absent(),
    this.fechaFactura = const Value.absent(),
    this.fechaRecepcion = const Value.absent(),
    this.totalBruto = const Value.absent(),
    this.totalImpuestos = const Value.absent(),
    this.totalNeto = const Value.absent(),
    this.estado = const Value.absent(),
    this.observaciones = const Value.absent(),
    this.validadaPor = const Value.absent(),
    this.fechaValidacion = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  FacturasCompanion.insert({
    this.id = const Value.absent(),
    this.numeroFactura = const Value.absent(),
    this.tipoDocumento = const Value.absent(),
    this.proveedor = const Value.absent(),
    this.fechaFactura = const Value.absent(),
    this.fechaRecepcion = const Value.absent(),
    this.totalBruto = const Value.absent(),
    this.totalImpuestos = const Value.absent(),
    this.totalNeto = const Value.absent(),
    this.estado = const Value.absent(),
    this.observaciones = const Value.absent(),
    this.validadaPor = const Value.absent(),
    this.fechaValidacion = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<Factura> custom({
    Expression<int>? id,
    Expression<String>? numeroFactura,
    Expression<String>? tipoDocumento,
    Expression<String>? proveedor,
    Expression<DateTime>? fechaFactura,
    Expression<DateTime>? fechaRecepcion,
    Expression<double>? totalBruto,
    Expression<double>? totalImpuestos,
    Expression<double>? totalNeto,
    Expression<String>? estado,
    Expression<String>? observaciones,
    Expression<String>? validadaPor,
    Expression<DateTime>? fechaValidacion,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (numeroFactura != null) 'numero_factura': numeroFactura,
      if (tipoDocumento != null) 'tipo_documento': tipoDocumento,
      if (proveedor != null) 'proveedor': proveedor,
      if (fechaFactura != null) 'fecha_factura': fechaFactura,
      if (fechaRecepcion != null) 'fecha_recepcion': fechaRecepcion,
      if (totalBruto != null) 'total_bruto': totalBruto,
      if (totalImpuestos != null) 'total_impuestos': totalImpuestos,
      if (totalNeto != null) 'total_neto': totalNeto,
      if (estado != null) 'estado': estado,
      if (observaciones != null) 'observaciones': observaciones,
      if (validadaPor != null) 'validada_por': validadaPor,
      if (fechaValidacion != null) 'fecha_validacion': fechaValidacion,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  FacturasCompanion copyWith(
      {Value<int>? id,
      Value<String?>? numeroFactura,
      Value<String>? tipoDocumento,
      Value<String?>? proveedor,
      Value<DateTime?>? fechaFactura,
      Value<DateTime?>? fechaRecepcion,
      Value<double>? totalBruto,
      Value<double>? totalImpuestos,
      Value<double>? totalNeto,
      Value<String>? estado,
      Value<String?>? observaciones,
      Value<String?>? validadaPor,
      Value<DateTime?>? fechaValidacion,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt}) {
    return FacturasCompanion(
      id: id ?? this.id,
      numeroFactura: numeroFactura ?? this.numeroFactura,
      tipoDocumento: tipoDocumento ?? this.tipoDocumento,
      proveedor: proveedor ?? this.proveedor,
      fechaFactura: fechaFactura ?? this.fechaFactura,
      fechaRecepcion: fechaRecepcion ?? this.fechaRecepcion,
      totalBruto: totalBruto ?? this.totalBruto,
      totalImpuestos: totalImpuestos ?? this.totalImpuestos,
      totalNeto: totalNeto ?? this.totalNeto,
      estado: estado ?? this.estado,
      observaciones: observaciones ?? this.observaciones,
      validadaPor: validadaPor ?? this.validadaPor,
      fechaValidacion: fechaValidacion ?? this.fechaValidacion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (numeroFactura.present) {
      map['numero_factura'] = Variable<String>(numeroFactura.value);
    }
    if (tipoDocumento.present) {
      map['tipo_documento'] = Variable<String>(tipoDocumento.value);
    }
    if (proveedor.present) {
      map['proveedor'] = Variable<String>(proveedor.value);
    }
    if (fechaFactura.present) {
      map['fecha_factura'] = Variable<DateTime>(fechaFactura.value);
    }
    if (fechaRecepcion.present) {
      map['fecha_recepcion'] = Variable<DateTime>(fechaRecepcion.value);
    }
    if (totalBruto.present) {
      map['total_bruto'] = Variable<double>(totalBruto.value);
    }
    if (totalImpuestos.present) {
      map['total_impuestos'] = Variable<double>(totalImpuestos.value);
    }
    if (totalNeto.present) {
      map['total_neto'] = Variable<double>(totalNeto.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (observaciones.present) {
      map['observaciones'] = Variable<String>(observaciones.value);
    }
    if (validadaPor.present) {
      map['validada_por'] = Variable<String>(validadaPor.value);
    }
    if (fechaValidacion.present) {
      map['fecha_validacion'] = Variable<DateTime>(fechaValidacion.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FacturasCompanion(')
          ..write('id: $id, ')
          ..write('numeroFactura: $numeroFactura, ')
          ..write('tipoDocumento: $tipoDocumento, ')
          ..write('proveedor: $proveedor, ')
          ..write('fechaFactura: $fechaFactura, ')
          ..write('fechaRecepcion: $fechaRecepcion, ')
          ..write('totalBruto: $totalBruto, ')
          ..write('totalImpuestos: $totalImpuestos, ')
          ..write('totalNeto: $totalNeto, ')
          ..write('estado: $estado, ')
          ..write('observaciones: $observaciones, ')
          ..write('validadaPor: $validadaPor, ')
          ..write('fechaValidacion: $fechaValidacion, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $FacturaPagosTable extends FacturaPagos
    with TableInfo<$FacturaPagosTable, FacturaPago> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FacturaPagosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _facturaIdMeta =
      const VerificationMeta('facturaId');
  @override
  late final GeneratedColumn<int> facturaId = GeneratedColumn<int>(
      'factura_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _tipoPagoMeta =
      const VerificationMeta('tipoPago');
  @override
  late final GeneratedColumn<String> tipoPago = GeneratedColumn<String>(
      'tipo_pago', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _montoMeta = const VerificationMeta('monto');
  @override
  late final GeneratedColumn<double> monto = GeneratedColumn<double>(
      'monto', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _referenciaMeta =
      const VerificationMeta('referencia');
  @override
  late final GeneratedColumn<String> referencia = GeneratedColumn<String>(
      'referencia', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _tasaCambioMeta =
      const VerificationMeta('tasaCambio');
  @override
  late final GeneratedColumn<double> tasaCambio = GeneratedColumn<double>(
      'tasa_cambio', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _fechaPagoMeta =
      const VerificationMeta('fechaPago');
  @override
  late final GeneratedColumn<DateTime> fechaPago = GeneratedColumn<DateTime>(
      'fecha_pago', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, facturaId, tipoPago, monto, referencia, tasaCambio, fechaPago];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'factura_pagos';
  @override
  VerificationContext validateIntegrity(Insertable<FacturaPago> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('factura_id')) {
      context.handle(_facturaIdMeta,
          facturaId.isAcceptableOrUnknown(data['factura_id']!, _facturaIdMeta));
    } else if (isInserting) {
      context.missing(_facturaIdMeta);
    }
    if (data.containsKey('tipo_pago')) {
      context.handle(_tipoPagoMeta,
          tipoPago.isAcceptableOrUnknown(data['tipo_pago']!, _tipoPagoMeta));
    } else if (isInserting) {
      context.missing(_tipoPagoMeta);
    }
    if (data.containsKey('monto')) {
      context.handle(
          _montoMeta, monto.isAcceptableOrUnknown(data['monto']!, _montoMeta));
    } else if (isInserting) {
      context.missing(_montoMeta);
    }
    if (data.containsKey('referencia')) {
      context.handle(
          _referenciaMeta,
          referencia.isAcceptableOrUnknown(
              data['referencia']!, _referenciaMeta));
    }
    if (data.containsKey('tasa_cambio')) {
      context.handle(
          _tasaCambioMeta,
          tasaCambio.isAcceptableOrUnknown(
              data['tasa_cambio']!, _tasaCambioMeta));
    }
    if (data.containsKey('fecha_pago')) {
      context.handle(_fechaPagoMeta,
          fechaPago.isAcceptableOrUnknown(data['fecha_pago']!, _fechaPagoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FacturaPago map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FacturaPago(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      facturaId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}factura_id'])!,
      tipoPago: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tipo_pago'])!,
      monto: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}monto'])!,
      referencia: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}referencia']),
      tasaCambio: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}tasa_cambio']),
      fechaPago: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}fecha_pago']),
    );
  }

  @override
  $FacturaPagosTable createAlias(String alias) {
    return $FacturaPagosTable(attachedDatabase, alias);
  }
}

class FacturaPago extends DataClass implements Insertable<FacturaPago> {
  final int id;
  final int facturaId;
  final String tipoPago;
  final double monto;
  final String? referencia;
  final double? tasaCambio;
  final DateTime? fechaPago;
  const FacturaPago(
      {required this.id,
      required this.facturaId,
      required this.tipoPago,
      required this.monto,
      this.referencia,
      this.tasaCambio,
      this.fechaPago});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['factura_id'] = Variable<int>(facturaId);
    map['tipo_pago'] = Variable<String>(tipoPago);
    map['monto'] = Variable<double>(monto);
    if (!nullToAbsent || referencia != null) {
      map['referencia'] = Variable<String>(referencia);
    }
    if (!nullToAbsent || tasaCambio != null) {
      map['tasa_cambio'] = Variable<double>(tasaCambio);
    }
    if (!nullToAbsent || fechaPago != null) {
      map['fecha_pago'] = Variable<DateTime>(fechaPago);
    }
    return map;
  }

  FacturaPagosCompanion toCompanion(bool nullToAbsent) {
    return FacturaPagosCompanion(
      id: Value(id),
      facturaId: Value(facturaId),
      tipoPago: Value(tipoPago),
      monto: Value(monto),
      referencia: referencia == null && nullToAbsent
          ? const Value.absent()
          : Value(referencia),
      tasaCambio: tasaCambio == null && nullToAbsent
          ? const Value.absent()
          : Value(tasaCambio),
      fechaPago: fechaPago == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaPago),
    );
  }

  factory FacturaPago.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FacturaPago(
      id: serializer.fromJson<int>(json['id']),
      facturaId: serializer.fromJson<int>(json['facturaId']),
      tipoPago: serializer.fromJson<String>(json['tipoPago']),
      monto: serializer.fromJson<double>(json['monto']),
      referencia: serializer.fromJson<String?>(json['referencia']),
      tasaCambio: serializer.fromJson<double?>(json['tasaCambio']),
      fechaPago: serializer.fromJson<DateTime?>(json['fechaPago']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'facturaId': serializer.toJson<int>(facturaId),
      'tipoPago': serializer.toJson<String>(tipoPago),
      'monto': serializer.toJson<double>(monto),
      'referencia': serializer.toJson<String?>(referencia),
      'tasaCambio': serializer.toJson<double?>(tasaCambio),
      'fechaPago': serializer.toJson<DateTime?>(fechaPago),
    };
  }

  FacturaPago copyWith(
          {int? id,
          int? facturaId,
          String? tipoPago,
          double? monto,
          Value<String?> referencia = const Value.absent(),
          Value<double?> tasaCambio = const Value.absent(),
          Value<DateTime?> fechaPago = const Value.absent()}) =>
      FacturaPago(
        id: id ?? this.id,
        facturaId: facturaId ?? this.facturaId,
        tipoPago: tipoPago ?? this.tipoPago,
        monto: monto ?? this.monto,
        referencia: referencia.present ? referencia.value : this.referencia,
        tasaCambio: tasaCambio.present ? tasaCambio.value : this.tasaCambio,
        fechaPago: fechaPago.present ? fechaPago.value : this.fechaPago,
      );
  FacturaPago copyWithCompanion(FacturaPagosCompanion data) {
    return FacturaPago(
      id: data.id.present ? data.id.value : this.id,
      facturaId: data.facturaId.present ? data.facturaId.value : this.facturaId,
      tipoPago: data.tipoPago.present ? data.tipoPago.value : this.tipoPago,
      monto: data.monto.present ? data.monto.value : this.monto,
      referencia:
          data.referencia.present ? data.referencia.value : this.referencia,
      tasaCambio:
          data.tasaCambio.present ? data.tasaCambio.value : this.tasaCambio,
      fechaPago: data.fechaPago.present ? data.fechaPago.value : this.fechaPago,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FacturaPago(')
          ..write('id: $id, ')
          ..write('facturaId: $facturaId, ')
          ..write('tipoPago: $tipoPago, ')
          ..write('monto: $monto, ')
          ..write('referencia: $referencia, ')
          ..write('tasaCambio: $tasaCambio, ')
          ..write('fechaPago: $fechaPago')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, facturaId, tipoPago, monto, referencia, tasaCambio, fechaPago);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FacturaPago &&
          other.id == this.id &&
          other.facturaId == this.facturaId &&
          other.tipoPago == this.tipoPago &&
          other.monto == this.monto &&
          other.referencia == this.referencia &&
          other.tasaCambio == this.tasaCambio &&
          other.fechaPago == this.fechaPago);
}

class FacturaPagosCompanion extends UpdateCompanion<FacturaPago> {
  final Value<int> id;
  final Value<int> facturaId;
  final Value<String> tipoPago;
  final Value<double> monto;
  final Value<String?> referencia;
  final Value<double?> tasaCambio;
  final Value<DateTime?> fechaPago;
  const FacturaPagosCompanion({
    this.id = const Value.absent(),
    this.facturaId = const Value.absent(),
    this.tipoPago = const Value.absent(),
    this.monto = const Value.absent(),
    this.referencia = const Value.absent(),
    this.tasaCambio = const Value.absent(),
    this.fechaPago = const Value.absent(),
  });
  FacturaPagosCompanion.insert({
    this.id = const Value.absent(),
    required int facturaId,
    required String tipoPago,
    required double monto,
    this.referencia = const Value.absent(),
    this.tasaCambio = const Value.absent(),
    this.fechaPago = const Value.absent(),
  })  : facturaId = Value(facturaId),
        tipoPago = Value(tipoPago),
        monto = Value(monto);
  static Insertable<FacturaPago> custom({
    Expression<int>? id,
    Expression<int>? facturaId,
    Expression<String>? tipoPago,
    Expression<double>? monto,
    Expression<String>? referencia,
    Expression<double>? tasaCambio,
    Expression<DateTime>? fechaPago,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (facturaId != null) 'factura_id': facturaId,
      if (tipoPago != null) 'tipo_pago': tipoPago,
      if (monto != null) 'monto': monto,
      if (referencia != null) 'referencia': referencia,
      if (tasaCambio != null) 'tasa_cambio': tasaCambio,
      if (fechaPago != null) 'fecha_pago': fechaPago,
    });
  }

  FacturaPagosCompanion copyWith(
      {Value<int>? id,
      Value<int>? facturaId,
      Value<String>? tipoPago,
      Value<double>? monto,
      Value<String?>? referencia,
      Value<double?>? tasaCambio,
      Value<DateTime?>? fechaPago}) {
    return FacturaPagosCompanion(
      id: id ?? this.id,
      facturaId: facturaId ?? this.facturaId,
      tipoPago: tipoPago ?? this.tipoPago,
      monto: monto ?? this.monto,
      referencia: referencia ?? this.referencia,
      tasaCambio: tasaCambio ?? this.tasaCambio,
      fechaPago: fechaPago ?? this.fechaPago,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (facturaId.present) {
      map['factura_id'] = Variable<int>(facturaId.value);
    }
    if (tipoPago.present) {
      map['tipo_pago'] = Variable<String>(tipoPago.value);
    }
    if (monto.present) {
      map['monto'] = Variable<double>(monto.value);
    }
    if (referencia.present) {
      map['referencia'] = Variable<String>(referencia.value);
    }
    if (tasaCambio.present) {
      map['tasa_cambio'] = Variable<double>(tasaCambio.value);
    }
    if (fechaPago.present) {
      map['fecha_pago'] = Variable<DateTime>(fechaPago.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FacturaPagosCompanion(')
          ..write('id: $id, ')
          ..write('facturaId: $facturaId, ')
          ..write('tipoPago: $tipoPago, ')
          ..write('monto: $monto, ')
          ..write('referencia: $referencia, ')
          ..write('tasaCambio: $tasaCambio, ')
          ..write('fechaPago: $fechaPago')
          ..write(')'))
        .toString();
  }
}

class $RequisicionesTable extends Requisiciones
    with TableInfo<$RequisicionesTable, Requisicione> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RequisicionesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _numeroMeta = const VerificationMeta('numero');
  @override
  late final GeneratedColumn<String> numero = GeneratedColumn<String>(
      'numero', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _numeroSecuencialMeta =
      const VerificationMeta('numeroSecuencial');
  @override
  late final GeneratedColumn<int> numeroSecuencial = GeneratedColumn<int>(
      'numero_secuencial', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _origenMeta = const VerificationMeta('origen');
  @override
  late final GeneratedColumn<String> origen = GeneratedColumn<String>(
      'origen', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _destinoMeta =
      const VerificationMeta('destino');
  @override
  late final GeneratedColumn<String> destino = GeneratedColumn<String>(
      'destino', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
      'estado', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pendiente'));
  static const VerificationMeta _observacionesMeta =
      const VerificationMeta('observaciones');
  @override
  late final GeneratedColumn<String> observaciones = GeneratedColumn<String>(
      'observaciones', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _creadaPorMeta =
      const VerificationMeta('creadaPor');
  @override
  late final GeneratedColumn<String> creadaPor = GeneratedColumn<String>(
      'creada_por', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _procesadaPorMeta =
      const VerificationMeta('procesadaPor');
  @override
  late final GeneratedColumn<String> procesadaPor = GeneratedColumn<String>(
      'procesada_por', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fechaProcesamientoMeta =
      const VerificationMeta('fechaProcesamiento');
  @override
  late final GeneratedColumn<DateTime> fechaProcesamiento =
      GeneratedColumn<DateTime>('fecha_procesamiento', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _fechaCreacionMeta =
      const VerificationMeta('fechaCreacion');
  @override
  late final GeneratedColumn<DateTime> fechaCreacion =
      GeneratedColumn<DateTime>('fecha_creacion', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _actualizadaMeta =
      const VerificationMeta('actualizada');
  @override
  late final GeneratedColumn<DateTime> actualizada = GeneratedColumn<DateTime>(
      'actualizada', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        numero,
        numeroSecuencial,
        origen,
        destino,
        estado,
        observaciones,
        creadaPor,
        procesadaPor,
        fechaProcesamiento,
        fechaCreacion,
        actualizada
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'requisiciones';
  @override
  VerificationContext validateIntegrity(Insertable<Requisicione> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('numero')) {
      context.handle(_numeroMeta,
          numero.isAcceptableOrUnknown(data['numero']!, _numeroMeta));
    } else if (isInserting) {
      context.missing(_numeroMeta);
    }
    if (data.containsKey('numero_secuencial')) {
      context.handle(
          _numeroSecuencialMeta,
          numeroSecuencial.isAcceptableOrUnknown(
              data['numero_secuencial']!, _numeroSecuencialMeta));
    } else if (isInserting) {
      context.missing(_numeroSecuencialMeta);
    }
    if (data.containsKey('origen')) {
      context.handle(_origenMeta,
          origen.isAcceptableOrUnknown(data['origen']!, _origenMeta));
    } else if (isInserting) {
      context.missing(_origenMeta);
    }
    if (data.containsKey('destino')) {
      context.handle(_destinoMeta,
          destino.isAcceptableOrUnknown(data['destino']!, _destinoMeta));
    } else if (isInserting) {
      context.missing(_destinoMeta);
    }
    if (data.containsKey('estado')) {
      context.handle(_estadoMeta,
          estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta));
    }
    if (data.containsKey('observaciones')) {
      context.handle(
          _observacionesMeta,
          observaciones.isAcceptableOrUnknown(
              data['observaciones']!, _observacionesMeta));
    }
    if (data.containsKey('creada_por')) {
      context.handle(_creadaPorMeta,
          creadaPor.isAcceptableOrUnknown(data['creada_por']!, _creadaPorMeta));
    }
    if (data.containsKey('procesada_por')) {
      context.handle(
          _procesadaPorMeta,
          procesadaPor.isAcceptableOrUnknown(
              data['procesada_por']!, _procesadaPorMeta));
    }
    if (data.containsKey('fecha_procesamiento')) {
      context.handle(
          _fechaProcesamientoMeta,
          fechaProcesamiento.isAcceptableOrUnknown(
              data['fecha_procesamiento']!, _fechaProcesamientoMeta));
    }
    if (data.containsKey('fecha_creacion')) {
      context.handle(
          _fechaCreacionMeta,
          fechaCreacion.isAcceptableOrUnknown(
              data['fecha_creacion']!, _fechaCreacionMeta));
    }
    if (data.containsKey('actualizada')) {
      context.handle(
          _actualizadaMeta,
          actualizada.isAcceptableOrUnknown(
              data['actualizada']!, _actualizadaMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Requisicione map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Requisicione(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      numero: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}numero'])!,
      numeroSecuencial: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}numero_secuencial'])!,
      origen: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}origen'])!,
      destino: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}destino'])!,
      estado: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}estado'])!,
      observaciones: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}observaciones']),
      creadaPor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}creada_por']),
      procesadaPor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}procesada_por']),
      fechaProcesamiento: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}fecha_procesamiento']),
      fechaCreacion: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}fecha_creacion']),
      actualizada: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}actualizada']),
    );
  }

  @override
  $RequisicionesTable createAlias(String alias) {
    return $RequisicionesTable(attachedDatabase, alias);
  }
}

class Requisicione extends DataClass implements Insertable<Requisicione> {
  final int id;
  final String numero;
  final int numeroSecuencial;
  final String origen;
  final String destino;
  final String estado;
  final String? observaciones;
  final String? creadaPor;
  final String? procesadaPor;
  final DateTime? fechaProcesamiento;
  final DateTime? fechaCreacion;
  final DateTime? actualizada;
  const Requisicione(
      {required this.id,
      required this.numero,
      required this.numeroSecuencial,
      required this.origen,
      required this.destino,
      required this.estado,
      this.observaciones,
      this.creadaPor,
      this.procesadaPor,
      this.fechaProcesamiento,
      this.fechaCreacion,
      this.actualizada});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['numero'] = Variable<String>(numero);
    map['numero_secuencial'] = Variable<int>(numeroSecuencial);
    map['origen'] = Variable<String>(origen);
    map['destino'] = Variable<String>(destino);
    map['estado'] = Variable<String>(estado);
    if (!nullToAbsent || observaciones != null) {
      map['observaciones'] = Variable<String>(observaciones);
    }
    if (!nullToAbsent || creadaPor != null) {
      map['creada_por'] = Variable<String>(creadaPor);
    }
    if (!nullToAbsent || procesadaPor != null) {
      map['procesada_por'] = Variable<String>(procesadaPor);
    }
    if (!nullToAbsent || fechaProcesamiento != null) {
      map['fecha_procesamiento'] = Variable<DateTime>(fechaProcesamiento);
    }
    if (!nullToAbsent || fechaCreacion != null) {
      map['fecha_creacion'] = Variable<DateTime>(fechaCreacion);
    }
    if (!nullToAbsent || actualizada != null) {
      map['actualizada'] = Variable<DateTime>(actualizada);
    }
    return map;
  }

  RequisicionesCompanion toCompanion(bool nullToAbsent) {
    return RequisicionesCompanion(
      id: Value(id),
      numero: Value(numero),
      numeroSecuencial: Value(numeroSecuencial),
      origen: Value(origen),
      destino: Value(destino),
      estado: Value(estado),
      observaciones: observaciones == null && nullToAbsent
          ? const Value.absent()
          : Value(observaciones),
      creadaPor: creadaPor == null && nullToAbsent
          ? const Value.absent()
          : Value(creadaPor),
      procesadaPor: procesadaPor == null && nullToAbsent
          ? const Value.absent()
          : Value(procesadaPor),
      fechaProcesamiento: fechaProcesamiento == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaProcesamiento),
      fechaCreacion: fechaCreacion == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaCreacion),
      actualizada: actualizada == null && nullToAbsent
          ? const Value.absent()
          : Value(actualizada),
    );
  }

  factory Requisicione.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Requisicione(
      id: serializer.fromJson<int>(json['id']),
      numero: serializer.fromJson<String>(json['numero']),
      numeroSecuencial: serializer.fromJson<int>(json['numeroSecuencial']),
      origen: serializer.fromJson<String>(json['origen']),
      destino: serializer.fromJson<String>(json['destino']),
      estado: serializer.fromJson<String>(json['estado']),
      observaciones: serializer.fromJson<String?>(json['observaciones']),
      creadaPor: serializer.fromJson<String?>(json['creadaPor']),
      procesadaPor: serializer.fromJson<String?>(json['procesadaPor']),
      fechaProcesamiento:
          serializer.fromJson<DateTime?>(json['fechaProcesamiento']),
      fechaCreacion: serializer.fromJson<DateTime?>(json['fechaCreacion']),
      actualizada: serializer.fromJson<DateTime?>(json['actualizada']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'numero': serializer.toJson<String>(numero),
      'numeroSecuencial': serializer.toJson<int>(numeroSecuencial),
      'origen': serializer.toJson<String>(origen),
      'destino': serializer.toJson<String>(destino),
      'estado': serializer.toJson<String>(estado),
      'observaciones': serializer.toJson<String?>(observaciones),
      'creadaPor': serializer.toJson<String?>(creadaPor),
      'procesadaPor': serializer.toJson<String?>(procesadaPor),
      'fechaProcesamiento': serializer.toJson<DateTime?>(fechaProcesamiento),
      'fechaCreacion': serializer.toJson<DateTime?>(fechaCreacion),
      'actualizada': serializer.toJson<DateTime?>(actualizada),
    };
  }

  Requisicione copyWith(
          {int? id,
          String? numero,
          int? numeroSecuencial,
          String? origen,
          String? destino,
          String? estado,
          Value<String?> observaciones = const Value.absent(),
          Value<String?> creadaPor = const Value.absent(),
          Value<String?> procesadaPor = const Value.absent(),
          Value<DateTime?> fechaProcesamiento = const Value.absent(),
          Value<DateTime?> fechaCreacion = const Value.absent(),
          Value<DateTime?> actualizada = const Value.absent()}) =>
      Requisicione(
        id: id ?? this.id,
        numero: numero ?? this.numero,
        numeroSecuencial: numeroSecuencial ?? this.numeroSecuencial,
        origen: origen ?? this.origen,
        destino: destino ?? this.destino,
        estado: estado ?? this.estado,
        observaciones:
            observaciones.present ? observaciones.value : this.observaciones,
        creadaPor: creadaPor.present ? creadaPor.value : this.creadaPor,
        procesadaPor:
            procesadaPor.present ? procesadaPor.value : this.procesadaPor,
        fechaProcesamiento: fechaProcesamiento.present
            ? fechaProcesamiento.value
            : this.fechaProcesamiento,
        fechaCreacion:
            fechaCreacion.present ? fechaCreacion.value : this.fechaCreacion,
        actualizada: actualizada.present ? actualizada.value : this.actualizada,
      );
  Requisicione copyWithCompanion(RequisicionesCompanion data) {
    return Requisicione(
      id: data.id.present ? data.id.value : this.id,
      numero: data.numero.present ? data.numero.value : this.numero,
      numeroSecuencial: data.numeroSecuencial.present
          ? data.numeroSecuencial.value
          : this.numeroSecuencial,
      origen: data.origen.present ? data.origen.value : this.origen,
      destino: data.destino.present ? data.destino.value : this.destino,
      estado: data.estado.present ? data.estado.value : this.estado,
      observaciones: data.observaciones.present
          ? data.observaciones.value
          : this.observaciones,
      creadaPor: data.creadaPor.present ? data.creadaPor.value : this.creadaPor,
      procesadaPor: data.procesadaPor.present
          ? data.procesadaPor.value
          : this.procesadaPor,
      fechaProcesamiento: data.fechaProcesamiento.present
          ? data.fechaProcesamiento.value
          : this.fechaProcesamiento,
      fechaCreacion: data.fechaCreacion.present
          ? data.fechaCreacion.value
          : this.fechaCreacion,
      actualizada:
          data.actualizada.present ? data.actualizada.value : this.actualizada,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Requisicione(')
          ..write('id: $id, ')
          ..write('numero: $numero, ')
          ..write('numeroSecuencial: $numeroSecuencial, ')
          ..write('origen: $origen, ')
          ..write('destino: $destino, ')
          ..write('estado: $estado, ')
          ..write('observaciones: $observaciones, ')
          ..write('creadaPor: $creadaPor, ')
          ..write('procesadaPor: $procesadaPor, ')
          ..write('fechaProcesamiento: $fechaProcesamiento, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('actualizada: $actualizada')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      numero,
      numeroSecuencial,
      origen,
      destino,
      estado,
      observaciones,
      creadaPor,
      procesadaPor,
      fechaProcesamiento,
      fechaCreacion,
      actualizada);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Requisicione &&
          other.id == this.id &&
          other.numero == this.numero &&
          other.numeroSecuencial == this.numeroSecuencial &&
          other.origen == this.origen &&
          other.destino == this.destino &&
          other.estado == this.estado &&
          other.observaciones == this.observaciones &&
          other.creadaPor == this.creadaPor &&
          other.procesadaPor == this.procesadaPor &&
          other.fechaProcesamiento == this.fechaProcesamiento &&
          other.fechaCreacion == this.fechaCreacion &&
          other.actualizada == this.actualizada);
}

class RequisicionesCompanion extends UpdateCompanion<Requisicione> {
  final Value<int> id;
  final Value<String> numero;
  final Value<int> numeroSecuencial;
  final Value<String> origen;
  final Value<String> destino;
  final Value<String> estado;
  final Value<String?> observaciones;
  final Value<String?> creadaPor;
  final Value<String?> procesadaPor;
  final Value<DateTime?> fechaProcesamiento;
  final Value<DateTime?> fechaCreacion;
  final Value<DateTime?> actualizada;
  const RequisicionesCompanion({
    this.id = const Value.absent(),
    this.numero = const Value.absent(),
    this.numeroSecuencial = const Value.absent(),
    this.origen = const Value.absent(),
    this.destino = const Value.absent(),
    this.estado = const Value.absent(),
    this.observaciones = const Value.absent(),
    this.creadaPor = const Value.absent(),
    this.procesadaPor = const Value.absent(),
    this.fechaProcesamiento = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.actualizada = const Value.absent(),
  });
  RequisicionesCompanion.insert({
    this.id = const Value.absent(),
    required String numero,
    required int numeroSecuencial,
    required String origen,
    required String destino,
    this.estado = const Value.absent(),
    this.observaciones = const Value.absent(),
    this.creadaPor = const Value.absent(),
    this.procesadaPor = const Value.absent(),
    this.fechaProcesamiento = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.actualizada = const Value.absent(),
  })  : numero = Value(numero),
        numeroSecuencial = Value(numeroSecuencial),
        origen = Value(origen),
        destino = Value(destino);
  static Insertable<Requisicione> custom({
    Expression<int>? id,
    Expression<String>? numero,
    Expression<int>? numeroSecuencial,
    Expression<String>? origen,
    Expression<String>? destino,
    Expression<String>? estado,
    Expression<String>? observaciones,
    Expression<String>? creadaPor,
    Expression<String>? procesadaPor,
    Expression<DateTime>? fechaProcesamiento,
    Expression<DateTime>? fechaCreacion,
    Expression<DateTime>? actualizada,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (numero != null) 'numero': numero,
      if (numeroSecuencial != null) 'numero_secuencial': numeroSecuencial,
      if (origen != null) 'origen': origen,
      if (destino != null) 'destino': destino,
      if (estado != null) 'estado': estado,
      if (observaciones != null) 'observaciones': observaciones,
      if (creadaPor != null) 'creada_por': creadaPor,
      if (procesadaPor != null) 'procesada_por': procesadaPor,
      if (fechaProcesamiento != null) 'fecha_procesamiento': fechaProcesamiento,
      if (fechaCreacion != null) 'fecha_creacion': fechaCreacion,
      if (actualizada != null) 'actualizada': actualizada,
    });
  }

  RequisicionesCompanion copyWith(
      {Value<int>? id,
      Value<String>? numero,
      Value<int>? numeroSecuencial,
      Value<String>? origen,
      Value<String>? destino,
      Value<String>? estado,
      Value<String?>? observaciones,
      Value<String?>? creadaPor,
      Value<String?>? procesadaPor,
      Value<DateTime?>? fechaProcesamiento,
      Value<DateTime?>? fechaCreacion,
      Value<DateTime?>? actualizada}) {
    return RequisicionesCompanion(
      id: id ?? this.id,
      numero: numero ?? this.numero,
      numeroSecuencial: numeroSecuencial ?? this.numeroSecuencial,
      origen: origen ?? this.origen,
      destino: destino ?? this.destino,
      estado: estado ?? this.estado,
      observaciones: observaciones ?? this.observaciones,
      creadaPor: creadaPor ?? this.creadaPor,
      procesadaPor: procesadaPor ?? this.procesadaPor,
      fechaProcesamiento: fechaProcesamiento ?? this.fechaProcesamiento,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      actualizada: actualizada ?? this.actualizada,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (numero.present) {
      map['numero'] = Variable<String>(numero.value);
    }
    if (numeroSecuencial.present) {
      map['numero_secuencial'] = Variable<int>(numeroSecuencial.value);
    }
    if (origen.present) {
      map['origen'] = Variable<String>(origen.value);
    }
    if (destino.present) {
      map['destino'] = Variable<String>(destino.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (observaciones.present) {
      map['observaciones'] = Variable<String>(observaciones.value);
    }
    if (creadaPor.present) {
      map['creada_por'] = Variable<String>(creadaPor.value);
    }
    if (procesadaPor.present) {
      map['procesada_por'] = Variable<String>(procesadaPor.value);
    }
    if (fechaProcesamiento.present) {
      map['fecha_procesamiento'] = Variable<DateTime>(fechaProcesamiento.value);
    }
    if (fechaCreacion.present) {
      map['fecha_creacion'] = Variable<DateTime>(fechaCreacion.value);
    }
    if (actualizada.present) {
      map['actualizada'] = Variable<DateTime>(actualizada.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RequisicionesCompanion(')
          ..write('id: $id, ')
          ..write('numero: $numero, ')
          ..write('numeroSecuencial: $numeroSecuencial, ')
          ..write('origen: $origen, ')
          ..write('destino: $destino, ')
          ..write('estado: $estado, ')
          ..write('observaciones: $observaciones, ')
          ..write('creadaPor: $creadaPor, ')
          ..write('procesadaPor: $procesadaPor, ')
          ..write('fechaProcesamiento: $fechaProcesamiento, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('actualizada: $actualizada')
          ..write(')'))
        .toString();
  }
}

class $RequisicionDetallesTable extends RequisicionDetalles
    with TableInfo<$RequisicionDetallesTable, RequisicionDetalle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RequisicionDetallesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _requisicionIdMeta =
      const VerificationMeta('requisicionId');
  @override
  late final GeneratedColumn<int> requisicionId = GeneratedColumn<int>(
      'requisicion_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _productoIdMeta =
      const VerificationMeta('productoId');
  @override
  late final GeneratedColumn<int> productoId = GeneratedColumn<int>(
      'producto_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _ingredienteMeta =
      const VerificationMeta('ingrediente');
  @override
  late final GeneratedColumn<String> ingrediente = GeneratedColumn<String>(
      'ingrediente', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _cantidadMeta =
      const VerificationMeta('cantidad');
  @override
  late final GeneratedColumn<double> cantidad = GeneratedColumn<double>(
      'cantidad', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _unidadMeta = const VerificationMeta('unidad');
  @override
  late final GeneratedColumn<String> unidad = GeneratedColumn<String>(
      'unidad', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('unidad'));
  static const VerificationMeta _cantidadSurtidaMeta =
      const VerificationMeta('cantidadSurtida');
  @override
  late final GeneratedColumn<double> cantidadSurtida = GeneratedColumn<double>(
      'cantidad_surtida', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _verificadoMeta =
      const VerificationMeta('verificado');
  @override
  late final GeneratedColumn<int> verificado = GeneratedColumn<int>(
      'verificado', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        requisicionId,
        productoId,
        ingrediente,
        cantidad,
        unidad,
        cantidadSurtida,
        verificado
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'requisicion_detalles';
  @override
  VerificationContext validateIntegrity(Insertable<RequisicionDetalle> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('requisicion_id')) {
      context.handle(
          _requisicionIdMeta,
          requisicionId.isAcceptableOrUnknown(
              data['requisicion_id']!, _requisicionIdMeta));
    } else if (isInserting) {
      context.missing(_requisicionIdMeta);
    }
    if (data.containsKey('producto_id')) {
      context.handle(
          _productoIdMeta,
          productoId.isAcceptableOrUnknown(
              data['producto_id']!, _productoIdMeta));
    }
    if (data.containsKey('ingrediente')) {
      context.handle(
          _ingredienteMeta,
          ingrediente.isAcceptableOrUnknown(
              data['ingrediente']!, _ingredienteMeta));
    } else if (isInserting) {
      context.missing(_ingredienteMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(_cantidadMeta,
          cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta));
    } else if (isInserting) {
      context.missing(_cantidadMeta);
    }
    if (data.containsKey('unidad')) {
      context.handle(_unidadMeta,
          unidad.isAcceptableOrUnknown(data['unidad']!, _unidadMeta));
    }
    if (data.containsKey('cantidad_surtida')) {
      context.handle(
          _cantidadSurtidaMeta,
          cantidadSurtida.isAcceptableOrUnknown(
              data['cantidad_surtida']!, _cantidadSurtidaMeta));
    }
    if (data.containsKey('verificado')) {
      context.handle(
          _verificadoMeta,
          verificado.isAcceptableOrUnknown(
              data['verificado']!, _verificadoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RequisicionDetalle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RequisicionDetalle(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      requisicionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}requisicion_id'])!,
      productoId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}producto_id']),
      ingrediente: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ingrediente'])!,
      cantidad: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cantidad'])!,
      unidad: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unidad'])!,
      cantidadSurtida: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}cantidad_surtida'])!,
      verificado: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}verificado'])!,
    );
  }

  @override
  $RequisicionDetallesTable createAlias(String alias) {
    return $RequisicionDetallesTable(attachedDatabase, alias);
  }
}

class RequisicionDetalle extends DataClass
    implements Insertable<RequisicionDetalle> {
  final int id;
  final int requisicionId;
  final int? productoId;
  final String ingrediente;
  final double cantidad;
  final String unidad;
  final double cantidadSurtida;
  final int verificado;
  const RequisicionDetalle(
      {required this.id,
      required this.requisicionId,
      this.productoId,
      required this.ingrediente,
      required this.cantidad,
      required this.unidad,
      required this.cantidadSurtida,
      required this.verificado});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['requisicion_id'] = Variable<int>(requisicionId);
    if (!nullToAbsent || productoId != null) {
      map['producto_id'] = Variable<int>(productoId);
    }
    map['ingrediente'] = Variable<String>(ingrediente);
    map['cantidad'] = Variable<double>(cantidad);
    map['unidad'] = Variable<String>(unidad);
    map['cantidad_surtida'] = Variable<double>(cantidadSurtida);
    map['verificado'] = Variable<int>(verificado);
    return map;
  }

  RequisicionDetallesCompanion toCompanion(bool nullToAbsent) {
    return RequisicionDetallesCompanion(
      id: Value(id),
      requisicionId: Value(requisicionId),
      productoId: productoId == null && nullToAbsent
          ? const Value.absent()
          : Value(productoId),
      ingrediente: Value(ingrediente),
      cantidad: Value(cantidad),
      unidad: Value(unidad),
      cantidadSurtida: Value(cantidadSurtida),
      verificado: Value(verificado),
    );
  }

  factory RequisicionDetalle.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RequisicionDetalle(
      id: serializer.fromJson<int>(json['id']),
      requisicionId: serializer.fromJson<int>(json['requisicionId']),
      productoId: serializer.fromJson<int?>(json['productoId']),
      ingrediente: serializer.fromJson<String>(json['ingrediente']),
      cantidad: serializer.fromJson<double>(json['cantidad']),
      unidad: serializer.fromJson<String>(json['unidad']),
      cantidadSurtida: serializer.fromJson<double>(json['cantidadSurtida']),
      verificado: serializer.fromJson<int>(json['verificado']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'requisicionId': serializer.toJson<int>(requisicionId),
      'productoId': serializer.toJson<int?>(productoId),
      'ingrediente': serializer.toJson<String>(ingrediente),
      'cantidad': serializer.toJson<double>(cantidad),
      'unidad': serializer.toJson<String>(unidad),
      'cantidadSurtida': serializer.toJson<double>(cantidadSurtida),
      'verificado': serializer.toJson<int>(verificado),
    };
  }

  RequisicionDetalle copyWith(
          {int? id,
          int? requisicionId,
          Value<int?> productoId = const Value.absent(),
          String? ingrediente,
          double? cantidad,
          String? unidad,
          double? cantidadSurtida,
          int? verificado}) =>
      RequisicionDetalle(
        id: id ?? this.id,
        requisicionId: requisicionId ?? this.requisicionId,
        productoId: productoId.present ? productoId.value : this.productoId,
        ingrediente: ingrediente ?? this.ingrediente,
        cantidad: cantidad ?? this.cantidad,
        unidad: unidad ?? this.unidad,
        cantidadSurtida: cantidadSurtida ?? this.cantidadSurtida,
        verificado: verificado ?? this.verificado,
      );
  RequisicionDetalle copyWithCompanion(RequisicionDetallesCompanion data) {
    return RequisicionDetalle(
      id: data.id.present ? data.id.value : this.id,
      requisicionId: data.requisicionId.present
          ? data.requisicionId.value
          : this.requisicionId,
      productoId:
          data.productoId.present ? data.productoId.value : this.productoId,
      ingrediente:
          data.ingrediente.present ? data.ingrediente.value : this.ingrediente,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      unidad: data.unidad.present ? data.unidad.value : this.unidad,
      cantidadSurtida: data.cantidadSurtida.present
          ? data.cantidadSurtida.value
          : this.cantidadSurtida,
      verificado:
          data.verificado.present ? data.verificado.value : this.verificado,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RequisicionDetalle(')
          ..write('id: $id, ')
          ..write('requisicionId: $requisicionId, ')
          ..write('productoId: $productoId, ')
          ..write('ingrediente: $ingrediente, ')
          ..write('cantidad: $cantidad, ')
          ..write('unidad: $unidad, ')
          ..write('cantidadSurtida: $cantidadSurtida, ')
          ..write('verificado: $verificado')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, requisicionId, productoId, ingrediente,
      cantidad, unidad, cantidadSurtida, verificado);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RequisicionDetalle &&
          other.id == this.id &&
          other.requisicionId == this.requisicionId &&
          other.productoId == this.productoId &&
          other.ingrediente == this.ingrediente &&
          other.cantidad == this.cantidad &&
          other.unidad == this.unidad &&
          other.cantidadSurtida == this.cantidadSurtida &&
          other.verificado == this.verificado);
}

class RequisicionDetallesCompanion extends UpdateCompanion<RequisicionDetalle> {
  final Value<int> id;
  final Value<int> requisicionId;
  final Value<int?> productoId;
  final Value<String> ingrediente;
  final Value<double> cantidad;
  final Value<String> unidad;
  final Value<double> cantidadSurtida;
  final Value<int> verificado;
  const RequisicionDetallesCompanion({
    this.id = const Value.absent(),
    this.requisicionId = const Value.absent(),
    this.productoId = const Value.absent(),
    this.ingrediente = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.unidad = const Value.absent(),
    this.cantidadSurtida = const Value.absent(),
    this.verificado = const Value.absent(),
  });
  RequisicionDetallesCompanion.insert({
    this.id = const Value.absent(),
    required int requisicionId,
    this.productoId = const Value.absent(),
    required String ingrediente,
    required double cantidad,
    this.unidad = const Value.absent(),
    this.cantidadSurtida = const Value.absent(),
    this.verificado = const Value.absent(),
  })  : requisicionId = Value(requisicionId),
        ingrediente = Value(ingrediente),
        cantidad = Value(cantidad);
  static Insertable<RequisicionDetalle> custom({
    Expression<int>? id,
    Expression<int>? requisicionId,
    Expression<int>? productoId,
    Expression<String>? ingrediente,
    Expression<double>? cantidad,
    Expression<String>? unidad,
    Expression<double>? cantidadSurtida,
    Expression<int>? verificado,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (requisicionId != null) 'requisicion_id': requisicionId,
      if (productoId != null) 'producto_id': productoId,
      if (ingrediente != null) 'ingrediente': ingrediente,
      if (cantidad != null) 'cantidad': cantidad,
      if (unidad != null) 'unidad': unidad,
      if (cantidadSurtida != null) 'cantidad_surtida': cantidadSurtida,
      if (verificado != null) 'verificado': verificado,
    });
  }

  RequisicionDetallesCompanion copyWith(
      {Value<int>? id,
      Value<int>? requisicionId,
      Value<int?>? productoId,
      Value<String>? ingrediente,
      Value<double>? cantidad,
      Value<String>? unidad,
      Value<double>? cantidadSurtida,
      Value<int>? verificado}) {
    return RequisicionDetallesCompanion(
      id: id ?? this.id,
      requisicionId: requisicionId ?? this.requisicionId,
      productoId: productoId ?? this.productoId,
      ingrediente: ingrediente ?? this.ingrediente,
      cantidad: cantidad ?? this.cantidad,
      unidad: unidad ?? this.unidad,
      cantidadSurtida: cantidadSurtida ?? this.cantidadSurtida,
      verificado: verificado ?? this.verificado,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (requisicionId.present) {
      map['requisicion_id'] = Variable<int>(requisicionId.value);
    }
    if (productoId.present) {
      map['producto_id'] = Variable<int>(productoId.value);
    }
    if (ingrediente.present) {
      map['ingrediente'] = Variable<String>(ingrediente.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<double>(cantidad.value);
    }
    if (unidad.present) {
      map['unidad'] = Variable<String>(unidad.value);
    }
    if (cantidadSurtida.present) {
      map['cantidad_surtida'] = Variable<double>(cantidadSurtida.value);
    }
    if (verificado.present) {
      map['verificado'] = Variable<int>(verificado.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RequisicionDetallesCompanion(')
          ..write('id: $id, ')
          ..write('requisicionId: $requisicionId, ')
          ..write('productoId: $productoId, ')
          ..write('ingrediente: $ingrediente, ')
          ..write('cantidad: $cantidad, ')
          ..write('unidad: $unidad, ')
          ..write('cantidadSurtida: $cantidadSurtida, ')
          ..write('verificado: $verificado')
          ..write(')'))
        .toString();
  }
}

class $StockCheckpointTable extends StockCheckpoint
    with TableInfo<$StockCheckpointTable, StockCheckpointData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockCheckpointTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _productoIdMeta =
      const VerificationMeta('productoId');
  @override
  late final GeneratedColumn<int> productoId = GeneratedColumn<int>(
      'producto_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _almacenMeta =
      const VerificationMeta('almacen');
  @override
  late final GeneratedColumn<String> almacen = GeneratedColumn<String>(
      'almacen', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cantidadMeta =
      const VerificationMeta('cantidad');
  @override
  late final GeneratedColumn<double> cantidad = GeneratedColumn<double>(
      'cantidad', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [productoId, almacen, cantidad];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_checkpoint';
  @override
  VerificationContext validateIntegrity(
      Insertable<StockCheckpointData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('producto_id')) {
      context.handle(
          _productoIdMeta,
          productoId.isAcceptableOrUnknown(
              data['producto_id']!, _productoIdMeta));
    } else if (isInserting) {
      context.missing(_productoIdMeta);
    }
    if (data.containsKey('almacen')) {
      context.handle(_almacenMeta,
          almacen.isAcceptableOrUnknown(data['almacen']!, _almacenMeta));
    } else if (isInserting) {
      context.missing(_almacenMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(_cantidadMeta,
          cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {productoId, almacen};
  @override
  StockCheckpointData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockCheckpointData(
      productoId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}producto_id'])!,
      almacen: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}almacen'])!,
      cantidad: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cantidad'])!,
    );
  }

  @override
  $StockCheckpointTable createAlias(String alias) {
    return $StockCheckpointTable(attachedDatabase, alias);
  }
}

class StockCheckpointData extends DataClass
    implements Insertable<StockCheckpointData> {
  final int productoId;
  final String almacen;
  final double cantidad;
  const StockCheckpointData(
      {required this.productoId,
      required this.almacen,
      required this.cantidad});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['producto_id'] = Variable<int>(productoId);
    map['almacen'] = Variable<String>(almacen);
    map['cantidad'] = Variable<double>(cantidad);
    return map;
  }

  StockCheckpointCompanion toCompanion(bool nullToAbsent) {
    return StockCheckpointCompanion(
      productoId: Value(productoId),
      almacen: Value(almacen),
      cantidad: Value(cantidad),
    );
  }

  factory StockCheckpointData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockCheckpointData(
      productoId: serializer.fromJson<int>(json['productoId']),
      almacen: serializer.fromJson<String>(json['almacen']),
      cantidad: serializer.fromJson<double>(json['cantidad']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'productoId': serializer.toJson<int>(productoId),
      'almacen': serializer.toJson<String>(almacen),
      'cantidad': serializer.toJson<double>(cantidad),
    };
  }

  StockCheckpointData copyWith(
          {int? productoId, String? almacen, double? cantidad}) =>
      StockCheckpointData(
        productoId: productoId ?? this.productoId,
        almacen: almacen ?? this.almacen,
        cantidad: cantidad ?? this.cantidad,
      );
  StockCheckpointData copyWithCompanion(StockCheckpointCompanion data) {
    return StockCheckpointData(
      productoId:
          data.productoId.present ? data.productoId.value : this.productoId,
      almacen: data.almacen.present ? data.almacen.value : this.almacen,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockCheckpointData(')
          ..write('productoId: $productoId, ')
          ..write('almacen: $almacen, ')
          ..write('cantidad: $cantidad')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(productoId, almacen, cantidad);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockCheckpointData &&
          other.productoId == this.productoId &&
          other.almacen == this.almacen &&
          other.cantidad == this.cantidad);
}

class StockCheckpointCompanion extends UpdateCompanion<StockCheckpointData> {
  final Value<int> productoId;
  final Value<String> almacen;
  final Value<double> cantidad;
  final Value<int> rowid;
  const StockCheckpointCompanion({
    this.productoId = const Value.absent(),
    this.almacen = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StockCheckpointCompanion.insert({
    required int productoId,
    required String almacen,
    this.cantidad = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : productoId = Value(productoId),
        almacen = Value(almacen);
  static Insertable<StockCheckpointData> custom({
    Expression<int>? productoId,
    Expression<String>? almacen,
    Expression<double>? cantidad,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (productoId != null) 'producto_id': productoId,
      if (almacen != null) 'almacen': almacen,
      if (cantidad != null) 'cantidad': cantidad,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StockCheckpointCompanion copyWith(
      {Value<int>? productoId,
      Value<String>? almacen,
      Value<double>? cantidad,
      Value<int>? rowid}) {
    return StockCheckpointCompanion(
      productoId: productoId ?? this.productoId,
      almacen: almacen ?? this.almacen,
      cantidad: cantidad ?? this.cantidad,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (productoId.present) {
      map['producto_id'] = Variable<int>(productoId.value);
    }
    if (almacen.present) {
      map['almacen'] = Variable<String>(almacen.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<double>(cantidad.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockCheckpointCompanion(')
          ..write('productoId: $productoId, ')
          ..write('almacen: $almacen, ')
          ..write('cantidad: $cantidad, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PeriodosTable extends Periodos with TableInfo<$PeriodosTable, Periodo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PeriodosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _periodoMeta =
      const VerificationMeta('periodo');
  @override
  late final GeneratedColumn<String> periodo = GeneratedColumn<String>(
      'periodo', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _fechaAperturaMeta =
      const VerificationMeta('fechaApertura');
  @override
  late final GeneratedColumn<String> fechaApertura = GeneratedColumn<String>(
      'fecha_apertura', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _registradoPorMeta =
      const VerificationMeta('registradoPor');
  @override
  late final GeneratedColumn<String> registradoPor = GeneratedColumn<String>(
      'registrado_por', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, periodo, fechaApertura, registradoPor];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'periodos';
  @override
  VerificationContext validateIntegrity(Insertable<Periodo> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('periodo')) {
      context.handle(_periodoMeta,
          periodo.isAcceptableOrUnknown(data['periodo']!, _periodoMeta));
    } else if (isInserting) {
      context.missing(_periodoMeta);
    }
    if (data.containsKey('fecha_apertura')) {
      context.handle(
          _fechaAperturaMeta,
          fechaApertura.isAcceptableOrUnknown(
              data['fecha_apertura']!, _fechaAperturaMeta));
    } else if (isInserting) {
      context.missing(_fechaAperturaMeta);
    }
    if (data.containsKey('registrado_por')) {
      context.handle(
          _registradoPorMeta,
          registradoPor.isAcceptableOrUnknown(
              data['registrado_por']!, _registradoPorMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Periodo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Periodo(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      periodo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}periodo'])!,
      fechaApertura: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fecha_apertura'])!,
      registradoPor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}registrado_por']),
    );
  }

  @override
  $PeriodosTable createAlias(String alias) {
    return $PeriodosTable(attachedDatabase, alias);
  }
}

class Periodo extends DataClass implements Insertable<Periodo> {
  final int id;
  final String periodo;
  final String fechaApertura;
  final String? registradoPor;
  const Periodo(
      {required this.id,
      required this.periodo,
      required this.fechaApertura,
      this.registradoPor});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['periodo'] = Variable<String>(periodo);
    map['fecha_apertura'] = Variable<String>(fechaApertura);
    if (!nullToAbsent || registradoPor != null) {
      map['registrado_por'] = Variable<String>(registradoPor);
    }
    return map;
  }

  PeriodosCompanion toCompanion(bool nullToAbsent) {
    return PeriodosCompanion(
      id: Value(id),
      periodo: Value(periodo),
      fechaApertura: Value(fechaApertura),
      registradoPor: registradoPor == null && nullToAbsent
          ? const Value.absent()
          : Value(registradoPor),
    );
  }

  factory Periodo.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Periodo(
      id: serializer.fromJson<int>(json['id']),
      periodo: serializer.fromJson<String>(json['periodo']),
      fechaApertura: serializer.fromJson<String>(json['fechaApertura']),
      registradoPor: serializer.fromJson<String?>(json['registradoPor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'periodo': serializer.toJson<String>(periodo),
      'fechaApertura': serializer.toJson<String>(fechaApertura),
      'registradoPor': serializer.toJson<String?>(registradoPor),
    };
  }

  Periodo copyWith(
          {int? id,
          String? periodo,
          String? fechaApertura,
          Value<String?> registradoPor = const Value.absent()}) =>
      Periodo(
        id: id ?? this.id,
        periodo: periodo ?? this.periodo,
        fechaApertura: fechaApertura ?? this.fechaApertura,
        registradoPor:
            registradoPor.present ? registradoPor.value : this.registradoPor,
      );
  Periodo copyWithCompanion(PeriodosCompanion data) {
    return Periodo(
      id: data.id.present ? data.id.value : this.id,
      periodo: data.periodo.present ? data.periodo.value : this.periodo,
      fechaApertura: data.fechaApertura.present
          ? data.fechaApertura.value
          : this.fechaApertura,
      registradoPor: data.registradoPor.present
          ? data.registradoPor.value
          : this.registradoPor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Periodo(')
          ..write('id: $id, ')
          ..write('periodo: $periodo, ')
          ..write('fechaApertura: $fechaApertura, ')
          ..write('registradoPor: $registradoPor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, periodo, fechaApertura, registradoPor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Periodo &&
          other.id == this.id &&
          other.periodo == this.periodo &&
          other.fechaApertura == this.fechaApertura &&
          other.registradoPor == this.registradoPor);
}

class PeriodosCompanion extends UpdateCompanion<Periodo> {
  final Value<int> id;
  final Value<String> periodo;
  final Value<String> fechaApertura;
  final Value<String?> registradoPor;
  const PeriodosCompanion({
    this.id = const Value.absent(),
    this.periodo = const Value.absent(),
    this.fechaApertura = const Value.absent(),
    this.registradoPor = const Value.absent(),
  });
  PeriodosCompanion.insert({
    this.id = const Value.absent(),
    required String periodo,
    required String fechaApertura,
    this.registradoPor = const Value.absent(),
  })  : periodo = Value(periodo),
        fechaApertura = Value(fechaApertura);
  static Insertable<Periodo> custom({
    Expression<int>? id,
    Expression<String>? periodo,
    Expression<String>? fechaApertura,
    Expression<String>? registradoPor,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (periodo != null) 'periodo': periodo,
      if (fechaApertura != null) 'fecha_apertura': fechaApertura,
      if (registradoPor != null) 'registrado_por': registradoPor,
    });
  }

  PeriodosCompanion copyWith(
      {Value<int>? id,
      Value<String>? periodo,
      Value<String>? fechaApertura,
      Value<String?>? registradoPor}) {
    return PeriodosCompanion(
      id: id ?? this.id,
      periodo: periodo ?? this.periodo,
      fechaApertura: fechaApertura ?? this.fechaApertura,
      registradoPor: registradoPor ?? this.registradoPor,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (periodo.present) {
      map['periodo'] = Variable<String>(periodo.value);
    }
    if (fechaApertura.present) {
      map['fecha_apertura'] = Variable<String>(fechaApertura.value);
    }
    if (registradoPor.present) {
      map['registrado_por'] = Variable<String>(registradoPor.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PeriodosCompanion(')
          ..write('id: $id, ')
          ..write('periodo: $periodo, ')
          ..write('fechaApertura: $fechaApertura, ')
          ..write('registradoPor: $registradoPor')
          ..write(')'))
        .toString();
  }
}

class $RecetasTable extends Recetas with TableInfo<$RecetasTable, Receta> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecetasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
      'nombre', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
      'tipo', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _productoBaseIdMeta =
      const VerificationMeta('productoBaseId');
  @override
  late final GeneratedColumn<int> productoBaseId = GeneratedColumn<int>(
      'producto_base_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _productoFinalIdMeta =
      const VerificationMeta('productoFinalId');
  @override
  late final GeneratedColumn<int> productoFinalId = GeneratedColumn<int>(
      'producto_final_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _cantidadProducidaMeta =
      const VerificationMeta('cantidadProducida');
  @override
  late final GeneratedColumn<double> cantidadProducida =
      GeneratedColumn<double>('cantidad_producida', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(1));
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<int> activo = GeneratedColumn<int>(
      'activo', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        nombre,
        tipo,
        productoBaseId,
        productoFinalId,
        cantidadProducida,
        activo,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recetas';
  @override
  VerificationContext validateIntegrity(Insertable<Receta> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
          _tipoMeta, tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta));
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('producto_base_id')) {
      context.handle(
          _productoBaseIdMeta,
          productoBaseId.isAcceptableOrUnknown(
              data['producto_base_id']!, _productoBaseIdMeta));
    }
    if (data.containsKey('producto_final_id')) {
      context.handle(
          _productoFinalIdMeta,
          productoFinalId.isAcceptableOrUnknown(
              data['producto_final_id']!, _productoFinalIdMeta));
    }
    if (data.containsKey('cantidad_producida')) {
      context.handle(
          _cantidadProducidaMeta,
          cantidadProducida.isAcceptableOrUnknown(
              data['cantidad_producida']!, _cantidadProducidaMeta));
    }
    if (data.containsKey('activo')) {
      context.handle(_activoMeta,
          activo.isAcceptableOrUnknown(data['activo']!, _activoMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Receta map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Receta(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombre'])!,
      tipo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tipo'])!,
      productoBaseId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}producto_base_id']),
      productoFinalId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}producto_final_id']),
      cantidadProducida: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}cantidad_producida'])!,
      activo: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}activo'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $RecetasTable createAlias(String alias) {
    return $RecetasTable(attachedDatabase, alias);
  }
}

class Receta extends DataClass implements Insertable<Receta> {
  final int id;
  final String nombre;
  final String tipo;
  final int? productoBaseId;
  final int? productoFinalId;
  final double cantidadProducida;
  final int activo;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const Receta(
      {required this.id,
      required this.nombre,
      required this.tipo,
      this.productoBaseId,
      this.productoFinalId,
      required this.cantidadProducida,
      required this.activo,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['tipo'] = Variable<String>(tipo);
    if (!nullToAbsent || productoBaseId != null) {
      map['producto_base_id'] = Variable<int>(productoBaseId);
    }
    if (!nullToAbsent || productoFinalId != null) {
      map['producto_final_id'] = Variable<int>(productoFinalId);
    }
    map['cantidad_producida'] = Variable<double>(cantidadProducida);
    map['activo'] = Variable<int>(activo);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  RecetasCompanion toCompanion(bool nullToAbsent) {
    return RecetasCompanion(
      id: Value(id),
      nombre: Value(nombre),
      tipo: Value(tipo),
      productoBaseId: productoBaseId == null && nullToAbsent
          ? const Value.absent()
          : Value(productoBaseId),
      productoFinalId: productoFinalId == null && nullToAbsent
          ? const Value.absent()
          : Value(productoFinalId),
      cantidadProducida: Value(cantidadProducida),
      activo: Value(activo),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Receta.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Receta(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      tipo: serializer.fromJson<String>(json['tipo']),
      productoBaseId: serializer.fromJson<int?>(json['productoBaseId']),
      productoFinalId: serializer.fromJson<int?>(json['productoFinalId']),
      cantidadProducida: serializer.fromJson<double>(json['cantidadProducida']),
      activo: serializer.fromJson<int>(json['activo']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'tipo': serializer.toJson<String>(tipo),
      'productoBaseId': serializer.toJson<int?>(productoBaseId),
      'productoFinalId': serializer.toJson<int?>(productoFinalId),
      'cantidadProducida': serializer.toJson<double>(cantidadProducida),
      'activo': serializer.toJson<int>(activo),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Receta copyWith(
          {int? id,
          String? nombre,
          String? tipo,
          Value<int?> productoBaseId = const Value.absent(),
          Value<int?> productoFinalId = const Value.absent(),
          double? cantidadProducida,
          int? activo,
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      Receta(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        tipo: tipo ?? this.tipo,
        productoBaseId:
            productoBaseId.present ? productoBaseId.value : this.productoBaseId,
        productoFinalId: productoFinalId.present
            ? productoFinalId.value
            : this.productoFinalId,
        cantidadProducida: cantidadProducida ?? this.cantidadProducida,
        activo: activo ?? this.activo,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  Receta copyWithCompanion(RecetasCompanion data) {
    return Receta(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      productoBaseId: data.productoBaseId.present
          ? data.productoBaseId.value
          : this.productoBaseId,
      productoFinalId: data.productoFinalId.present
          ? data.productoFinalId.value
          : this.productoFinalId,
      cantidadProducida: data.cantidadProducida.present
          ? data.cantidadProducida.value
          : this.cantidadProducida,
      activo: data.activo.present ? data.activo.value : this.activo,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Receta(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('tipo: $tipo, ')
          ..write('productoBaseId: $productoBaseId, ')
          ..write('productoFinalId: $productoFinalId, ')
          ..write('cantidadProducida: $cantidadProducida, ')
          ..write('activo: $activo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, tipo, productoBaseId,
      productoFinalId, cantidadProducida, activo, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Receta &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.tipo == this.tipo &&
          other.productoBaseId == this.productoBaseId &&
          other.productoFinalId == this.productoFinalId &&
          other.cantidadProducida == this.cantidadProducida &&
          other.activo == this.activo &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RecetasCompanion extends UpdateCompanion<Receta> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String> tipo;
  final Value<int?> productoBaseId;
  final Value<int?> productoFinalId;
  final Value<double> cantidadProducida;
  final Value<int> activo;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  const RecetasCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.tipo = const Value.absent(),
    this.productoBaseId = const Value.absent(),
    this.productoFinalId = const Value.absent(),
    this.cantidadProducida = const Value.absent(),
    this.activo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  RecetasCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required String tipo,
    this.productoBaseId = const Value.absent(),
    this.productoFinalId = const Value.absent(),
    this.cantidadProducida = const Value.absent(),
    this.activo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : nombre = Value(nombre),
        tipo = Value(tipo);
  static Insertable<Receta> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? tipo,
    Expression<int>? productoBaseId,
    Expression<int>? productoFinalId,
    Expression<double>? cantidadProducida,
    Expression<int>? activo,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (tipo != null) 'tipo': tipo,
      if (productoBaseId != null) 'producto_base_id': productoBaseId,
      if (productoFinalId != null) 'producto_final_id': productoFinalId,
      if (cantidadProducida != null) 'cantidad_producida': cantidadProducida,
      if (activo != null) 'activo': activo,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  RecetasCompanion copyWith(
      {Value<int>? id,
      Value<String>? nombre,
      Value<String>? tipo,
      Value<int?>? productoBaseId,
      Value<int?>? productoFinalId,
      Value<double>? cantidadProducida,
      Value<int>? activo,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt}) {
    return RecetasCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      tipo: tipo ?? this.tipo,
      productoBaseId: productoBaseId ?? this.productoBaseId,
      productoFinalId: productoFinalId ?? this.productoFinalId,
      cantidadProducida: cantidadProducida ?? this.cantidadProducida,
      activo: activo ?? this.activo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (productoBaseId.present) {
      map['producto_base_id'] = Variable<int>(productoBaseId.value);
    }
    if (productoFinalId.present) {
      map['producto_final_id'] = Variable<int>(productoFinalId.value);
    }
    if (cantidadProducida.present) {
      map['cantidad_producida'] = Variable<double>(cantidadProducida.value);
    }
    if (activo.present) {
      map['activo'] = Variable<int>(activo.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecetasCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('tipo: $tipo, ')
          ..write('productoBaseId: $productoBaseId, ')
          ..write('productoFinalId: $productoFinalId, ')
          ..write('cantidadProducida: $cantidadProducida, ')
          ..write('activo: $activo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $RecetaComponentesTable extends RecetaComponentes
    with TableInfo<$RecetaComponentesTable, RecetaComponente> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecetaComponentesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _recetaIdMeta =
      const VerificationMeta('recetaId');
  @override
  late final GeneratedColumn<int> recetaId = GeneratedColumn<int>(
      'receta_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _productoIdMeta =
      const VerificationMeta('productoId');
  @override
  late final GeneratedColumn<int> productoId = GeneratedColumn<int>(
      'producto_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _cantidadMeta =
      const VerificationMeta('cantidad');
  @override
  late final GeneratedColumn<double> cantidad = GeneratedColumn<double>(
      'cantidad', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _unidadMeta = const VerificationMeta('unidad');
  @override
  late final GeneratedColumn<String> unidad = GeneratedColumn<String>(
      'unidad', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('unidad'));
  static const VerificationMeta _tipoComponenteMeta =
      const VerificationMeta('tipoComponente');
  @override
  late final GeneratedColumn<String> tipoComponente = GeneratedColumn<String>(
      'tipo_componente', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _pesoVariableMeta =
      const VerificationMeta('pesoVariable');
  @override
  late final GeneratedColumn<int> pesoVariable = GeneratedColumn<int>(
      'peso_variable', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        recetaId,
        productoId,
        cantidad,
        unidad,
        tipoComponente,
        pesoVariable
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'receta_componentes';
  @override
  VerificationContext validateIntegrity(Insertable<RecetaComponente> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('receta_id')) {
      context.handle(_recetaIdMeta,
          recetaId.isAcceptableOrUnknown(data['receta_id']!, _recetaIdMeta));
    } else if (isInserting) {
      context.missing(_recetaIdMeta);
    }
    if (data.containsKey('producto_id')) {
      context.handle(
          _productoIdMeta,
          productoId.isAcceptableOrUnknown(
              data['producto_id']!, _productoIdMeta));
    } else if (isInserting) {
      context.missing(_productoIdMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(_cantidadMeta,
          cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta));
    } else if (isInserting) {
      context.missing(_cantidadMeta);
    }
    if (data.containsKey('unidad')) {
      context.handle(_unidadMeta,
          unidad.isAcceptableOrUnknown(data['unidad']!, _unidadMeta));
    }
    if (data.containsKey('tipo_componente')) {
      context.handle(
          _tipoComponenteMeta,
          tipoComponente.isAcceptableOrUnknown(
              data['tipo_componente']!, _tipoComponenteMeta));
    } else if (isInserting) {
      context.missing(_tipoComponenteMeta);
    }
    if (data.containsKey('peso_variable')) {
      context.handle(
          _pesoVariableMeta,
          pesoVariable.isAcceptableOrUnknown(
              data['peso_variable']!, _pesoVariableMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecetaComponente map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecetaComponente(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      recetaId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}receta_id'])!,
      productoId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}producto_id'])!,
      cantidad: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cantidad'])!,
      unidad: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unidad'])!,
      tipoComponente: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}tipo_componente'])!,
      pesoVariable: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}peso_variable'])!,
    );
  }

  @override
  $RecetaComponentesTable createAlias(String alias) {
    return $RecetaComponentesTable(attachedDatabase, alias);
  }
}

class RecetaComponente extends DataClass
    implements Insertable<RecetaComponente> {
  final int id;
  final int recetaId;
  final int productoId;
  final double cantidad;
  final String unidad;
  final String tipoComponente;
  final int pesoVariable;
  const RecetaComponente(
      {required this.id,
      required this.recetaId,
      required this.productoId,
      required this.cantidad,
      required this.unidad,
      required this.tipoComponente,
      required this.pesoVariable});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['receta_id'] = Variable<int>(recetaId);
    map['producto_id'] = Variable<int>(productoId);
    map['cantidad'] = Variable<double>(cantidad);
    map['unidad'] = Variable<String>(unidad);
    map['tipo_componente'] = Variable<String>(tipoComponente);
    map['peso_variable'] = Variable<int>(pesoVariable);
    return map;
  }

  RecetaComponentesCompanion toCompanion(bool nullToAbsent) {
    return RecetaComponentesCompanion(
      id: Value(id),
      recetaId: Value(recetaId),
      productoId: Value(productoId),
      cantidad: Value(cantidad),
      unidad: Value(unidad),
      tipoComponente: Value(tipoComponente),
      pesoVariable: Value(pesoVariable),
    );
  }

  factory RecetaComponente.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecetaComponente(
      id: serializer.fromJson<int>(json['id']),
      recetaId: serializer.fromJson<int>(json['recetaId']),
      productoId: serializer.fromJson<int>(json['productoId']),
      cantidad: serializer.fromJson<double>(json['cantidad']),
      unidad: serializer.fromJson<String>(json['unidad']),
      tipoComponente: serializer.fromJson<String>(json['tipoComponente']),
      pesoVariable: serializer.fromJson<int>(json['pesoVariable']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recetaId': serializer.toJson<int>(recetaId),
      'productoId': serializer.toJson<int>(productoId),
      'cantidad': serializer.toJson<double>(cantidad),
      'unidad': serializer.toJson<String>(unidad),
      'tipoComponente': serializer.toJson<String>(tipoComponente),
      'pesoVariable': serializer.toJson<int>(pesoVariable),
    };
  }

  RecetaComponente copyWith(
          {int? id,
          int? recetaId,
          int? productoId,
          double? cantidad,
          String? unidad,
          String? tipoComponente,
          int? pesoVariable}) =>
      RecetaComponente(
        id: id ?? this.id,
        recetaId: recetaId ?? this.recetaId,
        productoId: productoId ?? this.productoId,
        cantidad: cantidad ?? this.cantidad,
        unidad: unidad ?? this.unidad,
        tipoComponente: tipoComponente ?? this.tipoComponente,
        pesoVariable: pesoVariable ?? this.pesoVariable,
      );
  RecetaComponente copyWithCompanion(RecetaComponentesCompanion data) {
    return RecetaComponente(
      id: data.id.present ? data.id.value : this.id,
      recetaId: data.recetaId.present ? data.recetaId.value : this.recetaId,
      productoId:
          data.productoId.present ? data.productoId.value : this.productoId,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      unidad: data.unidad.present ? data.unidad.value : this.unidad,
      tipoComponente: data.tipoComponente.present
          ? data.tipoComponente.value
          : this.tipoComponente,
      pesoVariable: data.pesoVariable.present
          ? data.pesoVariable.value
          : this.pesoVariable,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecetaComponente(')
          ..write('id: $id, ')
          ..write('recetaId: $recetaId, ')
          ..write('productoId: $productoId, ')
          ..write('cantidad: $cantidad, ')
          ..write('unidad: $unidad, ')
          ..write('tipoComponente: $tipoComponente, ')
          ..write('pesoVariable: $pesoVariable')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, recetaId, productoId, cantidad, unidad, tipoComponente, pesoVariable);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecetaComponente &&
          other.id == this.id &&
          other.recetaId == this.recetaId &&
          other.productoId == this.productoId &&
          other.cantidad == this.cantidad &&
          other.unidad == this.unidad &&
          other.tipoComponente == this.tipoComponente &&
          other.pesoVariable == this.pesoVariable);
}

class RecetaComponentesCompanion extends UpdateCompanion<RecetaComponente> {
  final Value<int> id;
  final Value<int> recetaId;
  final Value<int> productoId;
  final Value<double> cantidad;
  final Value<String> unidad;
  final Value<String> tipoComponente;
  final Value<int> pesoVariable;
  const RecetaComponentesCompanion({
    this.id = const Value.absent(),
    this.recetaId = const Value.absent(),
    this.productoId = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.unidad = const Value.absent(),
    this.tipoComponente = const Value.absent(),
    this.pesoVariable = const Value.absent(),
  });
  RecetaComponentesCompanion.insert({
    this.id = const Value.absent(),
    required int recetaId,
    required int productoId,
    required double cantidad,
    this.unidad = const Value.absent(),
    required String tipoComponente,
    this.pesoVariable = const Value.absent(),
  })  : recetaId = Value(recetaId),
        productoId = Value(productoId),
        cantidad = Value(cantidad),
        tipoComponente = Value(tipoComponente);
  static Insertable<RecetaComponente> custom({
    Expression<int>? id,
    Expression<int>? recetaId,
    Expression<int>? productoId,
    Expression<double>? cantidad,
    Expression<String>? unidad,
    Expression<String>? tipoComponente,
    Expression<int>? pesoVariable,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recetaId != null) 'receta_id': recetaId,
      if (productoId != null) 'producto_id': productoId,
      if (cantidad != null) 'cantidad': cantidad,
      if (unidad != null) 'unidad': unidad,
      if (tipoComponente != null) 'tipo_componente': tipoComponente,
      if (pesoVariable != null) 'peso_variable': pesoVariable,
    });
  }

  RecetaComponentesCompanion copyWith(
      {Value<int>? id,
      Value<int>? recetaId,
      Value<int>? productoId,
      Value<double>? cantidad,
      Value<String>? unidad,
      Value<String>? tipoComponente,
      Value<int>? pesoVariable}) {
    return RecetaComponentesCompanion(
      id: id ?? this.id,
      recetaId: recetaId ?? this.recetaId,
      productoId: productoId ?? this.productoId,
      cantidad: cantidad ?? this.cantidad,
      unidad: unidad ?? this.unidad,
      tipoComponente: tipoComponente ?? this.tipoComponente,
      pesoVariable: pesoVariable ?? this.pesoVariable,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recetaId.present) {
      map['receta_id'] = Variable<int>(recetaId.value);
    }
    if (productoId.present) {
      map['producto_id'] = Variable<int>(productoId.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<double>(cantidad.value);
    }
    if (unidad.present) {
      map['unidad'] = Variable<String>(unidad.value);
    }
    if (tipoComponente.present) {
      map['tipo_componente'] = Variable<String>(tipoComponente.value);
    }
    if (pesoVariable.present) {
      map['peso_variable'] = Variable<int>(pesoVariable.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecetaComponentesCompanion(')
          ..write('id: $id, ')
          ..write('recetaId: $recetaId, ')
          ..write('productoId: $productoId, ')
          ..write('cantidad: $cantidad, ')
          ..write('unidad: $unidad, ')
          ..write('tipoComponente: $tipoComponente, ')
          ..write('pesoVariable: $pesoVariable')
          ..write(')'))
        .toString();
  }
}

class $ProduccionesTable extends Producciones
    with TableInfo<$ProduccionesTable, Produccione> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProduccionesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _recetaIdMeta =
      const VerificationMeta('recetaId');
  @override
  late final GeneratedColumn<int> recetaId = GeneratedColumn<int>(
      'receta_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _cantidadMeta =
      const VerificationMeta('cantidad');
  @override
  late final GeneratedColumn<double> cantidad = GeneratedColumn<double>(
      'cantidad', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
      'estado', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('completado'));
  static const VerificationMeta _usuarioMeta =
      const VerificationMeta('usuario');
  @override
  late final GeneratedColumn<String> usuario = GeneratedColumn<String>(
      'usuario', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _observacionesMeta =
      const VerificationMeta('observaciones');
  @override
  late final GeneratedColumn<String> observaciones = GeneratedColumn<String>(
      'observaciones', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fechaProduccionMeta =
      const VerificationMeta('fechaProduccion');
  @override
  late final GeneratedColumn<DateTime> fechaProduccion =
      GeneratedColumn<DateTime>('fecha_produccion', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _cocinerosMeta =
      const VerificationMeta('cocineros');
  @override
  late final GeneratedColumn<String> cocineros = GeneratedColumn<String>(
      'cocineros', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        recetaId,
        cantidad,
        estado,
        usuario,
        observaciones,
        fechaProduccion,
        cocineros,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'producciones';
  @override
  VerificationContext validateIntegrity(Insertable<Produccione> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('receta_id')) {
      context.handle(_recetaIdMeta,
          recetaId.isAcceptableOrUnknown(data['receta_id']!, _recetaIdMeta));
    } else if (isInserting) {
      context.missing(_recetaIdMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(_cantidadMeta,
          cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta));
    } else if (isInserting) {
      context.missing(_cantidadMeta);
    }
    if (data.containsKey('estado')) {
      context.handle(_estadoMeta,
          estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta));
    }
    if (data.containsKey('usuario')) {
      context.handle(_usuarioMeta,
          usuario.isAcceptableOrUnknown(data['usuario']!, _usuarioMeta));
    }
    if (data.containsKey('observaciones')) {
      context.handle(
          _observacionesMeta,
          observaciones.isAcceptableOrUnknown(
              data['observaciones']!, _observacionesMeta));
    }
    if (data.containsKey('fecha_produccion')) {
      context.handle(
          _fechaProduccionMeta,
          fechaProduccion.isAcceptableOrUnknown(
              data['fecha_produccion']!, _fechaProduccionMeta));
    }
    if (data.containsKey('cocineros')) {
      context.handle(_cocinerosMeta,
          cocineros.isAcceptableOrUnknown(data['cocineros']!, _cocinerosMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Produccione map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Produccione(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      recetaId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}receta_id'])!,
      cantidad: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cantidad'])!,
      estado: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}estado'])!,
      usuario: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}usuario']),
      observaciones: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}observaciones']),
      fechaProduccion: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}fecha_produccion']),
      cocineros: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cocineros']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
    );
  }

  @override
  $ProduccionesTable createAlias(String alias) {
    return $ProduccionesTable(attachedDatabase, alias);
  }
}

class Produccione extends DataClass implements Insertable<Produccione> {
  final int id;
  final int recetaId;
  final double cantidad;
  final String estado;
  final String? usuario;
  final String? observaciones;
  final DateTime? fechaProduccion;
  final String? cocineros;
  final DateTime? createdAt;
  const Produccione(
      {required this.id,
      required this.recetaId,
      required this.cantidad,
      required this.estado,
      this.usuario,
      this.observaciones,
      this.fechaProduccion,
      this.cocineros,
      this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['receta_id'] = Variable<int>(recetaId);
    map['cantidad'] = Variable<double>(cantidad);
    map['estado'] = Variable<String>(estado);
    if (!nullToAbsent || usuario != null) {
      map['usuario'] = Variable<String>(usuario);
    }
    if (!nullToAbsent || observaciones != null) {
      map['observaciones'] = Variable<String>(observaciones);
    }
    if (!nullToAbsent || fechaProduccion != null) {
      map['fecha_produccion'] = Variable<DateTime>(fechaProduccion);
    }
    if (!nullToAbsent || cocineros != null) {
      map['cocineros'] = Variable<String>(cocineros);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  ProduccionesCompanion toCompanion(bool nullToAbsent) {
    return ProduccionesCompanion(
      id: Value(id),
      recetaId: Value(recetaId),
      cantidad: Value(cantidad),
      estado: Value(estado),
      usuario: usuario == null && nullToAbsent
          ? const Value.absent()
          : Value(usuario),
      observaciones: observaciones == null && nullToAbsent
          ? const Value.absent()
          : Value(observaciones),
      fechaProduccion: fechaProduccion == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaProduccion),
      cocineros: cocineros == null && nullToAbsent
          ? const Value.absent()
          : Value(cocineros),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory Produccione.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Produccione(
      id: serializer.fromJson<int>(json['id']),
      recetaId: serializer.fromJson<int>(json['recetaId']),
      cantidad: serializer.fromJson<double>(json['cantidad']),
      estado: serializer.fromJson<String>(json['estado']),
      usuario: serializer.fromJson<String?>(json['usuario']),
      observaciones: serializer.fromJson<String?>(json['observaciones']),
      fechaProduccion: serializer.fromJson<DateTime?>(json['fechaProduccion']),
      cocineros: serializer.fromJson<String?>(json['cocineros']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recetaId': serializer.toJson<int>(recetaId),
      'cantidad': serializer.toJson<double>(cantidad),
      'estado': serializer.toJson<String>(estado),
      'usuario': serializer.toJson<String?>(usuario),
      'observaciones': serializer.toJson<String?>(observaciones),
      'fechaProduccion': serializer.toJson<DateTime?>(fechaProduccion),
      'cocineros': serializer.toJson<String?>(cocineros),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  Produccione copyWith(
          {int? id,
          int? recetaId,
          double? cantidad,
          String? estado,
          Value<String?> usuario = const Value.absent(),
          Value<String?> observaciones = const Value.absent(),
          Value<DateTime?> fechaProduccion = const Value.absent(),
          Value<String?> cocineros = const Value.absent(),
          Value<DateTime?> createdAt = const Value.absent()}) =>
      Produccione(
        id: id ?? this.id,
        recetaId: recetaId ?? this.recetaId,
        cantidad: cantidad ?? this.cantidad,
        estado: estado ?? this.estado,
        usuario: usuario.present ? usuario.value : this.usuario,
        observaciones:
            observaciones.present ? observaciones.value : this.observaciones,
        fechaProduccion: fechaProduccion.present
            ? fechaProduccion.value
            : this.fechaProduccion,
        cocineros: cocineros.present ? cocineros.value : this.cocineros,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
      );
  Produccione copyWithCompanion(ProduccionesCompanion data) {
    return Produccione(
      id: data.id.present ? data.id.value : this.id,
      recetaId: data.recetaId.present ? data.recetaId.value : this.recetaId,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      estado: data.estado.present ? data.estado.value : this.estado,
      usuario: data.usuario.present ? data.usuario.value : this.usuario,
      observaciones: data.observaciones.present
          ? data.observaciones.value
          : this.observaciones,
      fechaProduccion: data.fechaProduccion.present
          ? data.fechaProduccion.value
          : this.fechaProduccion,
      cocineros: data.cocineros.present ? data.cocineros.value : this.cocineros,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Produccione(')
          ..write('id: $id, ')
          ..write('recetaId: $recetaId, ')
          ..write('cantidad: $cantidad, ')
          ..write('estado: $estado, ')
          ..write('usuario: $usuario, ')
          ..write('observaciones: $observaciones, ')
          ..write('fechaProduccion: $fechaProduccion, ')
          ..write('cocineros: $cocineros, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, recetaId, cantidad, estado, usuario,
      observaciones, fechaProduccion, cocineros, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Produccione &&
          other.id == this.id &&
          other.recetaId == this.recetaId &&
          other.cantidad == this.cantidad &&
          other.estado == this.estado &&
          other.usuario == this.usuario &&
          other.observaciones == this.observaciones &&
          other.fechaProduccion == this.fechaProduccion &&
          other.cocineros == this.cocineros &&
          other.createdAt == this.createdAt);
}

class ProduccionesCompanion extends UpdateCompanion<Produccione> {
  final Value<int> id;
  final Value<int> recetaId;
  final Value<double> cantidad;
  final Value<String> estado;
  final Value<String?> usuario;
  final Value<String?> observaciones;
  final Value<DateTime?> fechaProduccion;
  final Value<String?> cocineros;
  final Value<DateTime?> createdAt;
  const ProduccionesCompanion({
    this.id = const Value.absent(),
    this.recetaId = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.estado = const Value.absent(),
    this.usuario = const Value.absent(),
    this.observaciones = const Value.absent(),
    this.fechaProduccion = const Value.absent(),
    this.cocineros = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ProduccionesCompanion.insert({
    this.id = const Value.absent(),
    required int recetaId,
    required double cantidad,
    this.estado = const Value.absent(),
    this.usuario = const Value.absent(),
    this.observaciones = const Value.absent(),
    this.fechaProduccion = const Value.absent(),
    this.cocineros = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : recetaId = Value(recetaId),
        cantidad = Value(cantidad);
  static Insertable<Produccione> custom({
    Expression<int>? id,
    Expression<int>? recetaId,
    Expression<double>? cantidad,
    Expression<String>? estado,
    Expression<String>? usuario,
    Expression<String>? observaciones,
    Expression<DateTime>? fechaProduccion,
    Expression<String>? cocineros,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recetaId != null) 'receta_id': recetaId,
      if (cantidad != null) 'cantidad': cantidad,
      if (estado != null) 'estado': estado,
      if (usuario != null) 'usuario': usuario,
      if (observaciones != null) 'observaciones': observaciones,
      if (fechaProduccion != null) 'fecha_produccion': fechaProduccion,
      if (cocineros != null) 'cocineros': cocineros,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ProduccionesCompanion copyWith(
      {Value<int>? id,
      Value<int>? recetaId,
      Value<double>? cantidad,
      Value<String>? estado,
      Value<String?>? usuario,
      Value<String?>? observaciones,
      Value<DateTime?>? fechaProduccion,
      Value<String?>? cocineros,
      Value<DateTime?>? createdAt}) {
    return ProduccionesCompanion(
      id: id ?? this.id,
      recetaId: recetaId ?? this.recetaId,
      cantidad: cantidad ?? this.cantidad,
      estado: estado ?? this.estado,
      usuario: usuario ?? this.usuario,
      observaciones: observaciones ?? this.observaciones,
      fechaProduccion: fechaProduccion ?? this.fechaProduccion,
      cocineros: cocineros ?? this.cocineros,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recetaId.present) {
      map['receta_id'] = Variable<int>(recetaId.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<double>(cantidad.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (usuario.present) {
      map['usuario'] = Variable<String>(usuario.value);
    }
    if (observaciones.present) {
      map['observaciones'] = Variable<String>(observaciones.value);
    }
    if (fechaProduccion.present) {
      map['fecha_produccion'] = Variable<DateTime>(fechaProduccion.value);
    }
    if (cocineros.present) {
      map['cocineros'] = Variable<String>(cocineros.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProduccionesCompanion(')
          ..write('id: $id, ')
          ..write('recetaId: $recetaId, ')
          ..write('cantidad: $cantidad, ')
          ..write('estado: $estado, ')
          ..write('usuario: $usuario, ')
          ..write('observaciones: $observaciones, ')
          ..write('fechaProduccion: $fechaProduccion, ')
          ..write('cocineros: $cocineros, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ProduccionDetallesTable extends ProduccionDetalles
    with TableInfo<$ProduccionDetallesTable, ProduccionDetalle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProduccionDetallesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _produccionIdMeta =
      const VerificationMeta('produccionId');
  @override
  late final GeneratedColumn<int> produccionId = GeneratedColumn<int>(
      'produccion_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _productoIdMeta =
      const VerificationMeta('productoId');
  @override
  late final GeneratedColumn<int> productoId = GeneratedColumn<int>(
      'producto_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
      'tipo', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _cantidadMeta =
      const VerificationMeta('cantidad');
  @override
  late final GeneratedColumn<double> cantidad = GeneratedColumn<double>(
      'cantidad', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _unidadMeta = const VerificationMeta('unidad');
  @override
  late final GeneratedColumn<String> unidad = GeneratedColumn<String>(
      'unidad', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('unidad'));
  static const VerificationMeta _movimientoIdMeta =
      const VerificationMeta('movimientoId');
  @override
  late final GeneratedColumn<int> movimientoId = GeneratedColumn<int>(
      'movimiento_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, produccionId, productoId, tipo, cantidad, unidad, movimientoId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'produccion_detalles';
  @override
  VerificationContext validateIntegrity(Insertable<ProduccionDetalle> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('produccion_id')) {
      context.handle(
          _produccionIdMeta,
          produccionId.isAcceptableOrUnknown(
              data['produccion_id']!, _produccionIdMeta));
    } else if (isInserting) {
      context.missing(_produccionIdMeta);
    }
    if (data.containsKey('producto_id')) {
      context.handle(
          _productoIdMeta,
          productoId.isAcceptableOrUnknown(
              data['producto_id']!, _productoIdMeta));
    } else if (isInserting) {
      context.missing(_productoIdMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
          _tipoMeta, tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta));
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(_cantidadMeta,
          cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta));
    } else if (isInserting) {
      context.missing(_cantidadMeta);
    }
    if (data.containsKey('unidad')) {
      context.handle(_unidadMeta,
          unidad.isAcceptableOrUnknown(data['unidad']!, _unidadMeta));
    }
    if (data.containsKey('movimiento_id')) {
      context.handle(
          _movimientoIdMeta,
          movimientoId.isAcceptableOrUnknown(
              data['movimiento_id']!, _movimientoIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProduccionDetalle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProduccionDetalle(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      produccionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}produccion_id'])!,
      productoId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}producto_id'])!,
      tipo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tipo'])!,
      cantidad: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cantidad'])!,
      unidad: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unidad'])!,
      movimientoId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}movimiento_id']),
    );
  }

  @override
  $ProduccionDetallesTable createAlias(String alias) {
    return $ProduccionDetallesTable(attachedDatabase, alias);
  }
}

class ProduccionDetalle extends DataClass
    implements Insertable<ProduccionDetalle> {
  final int id;
  final int produccionId;
  final int productoId;
  final String tipo;
  final double cantidad;
  final String unidad;
  final int? movimientoId;
  const ProduccionDetalle(
      {required this.id,
      required this.produccionId,
      required this.productoId,
      required this.tipo,
      required this.cantidad,
      required this.unidad,
      this.movimientoId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['produccion_id'] = Variable<int>(produccionId);
    map['producto_id'] = Variable<int>(productoId);
    map['tipo'] = Variable<String>(tipo);
    map['cantidad'] = Variable<double>(cantidad);
    map['unidad'] = Variable<String>(unidad);
    if (!nullToAbsent || movimientoId != null) {
      map['movimiento_id'] = Variable<int>(movimientoId);
    }
    return map;
  }

  ProduccionDetallesCompanion toCompanion(bool nullToAbsent) {
    return ProduccionDetallesCompanion(
      id: Value(id),
      produccionId: Value(produccionId),
      productoId: Value(productoId),
      tipo: Value(tipo),
      cantidad: Value(cantidad),
      unidad: Value(unidad),
      movimientoId: movimientoId == null && nullToAbsent
          ? const Value.absent()
          : Value(movimientoId),
    );
  }

  factory ProduccionDetalle.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProduccionDetalle(
      id: serializer.fromJson<int>(json['id']),
      produccionId: serializer.fromJson<int>(json['produccionId']),
      productoId: serializer.fromJson<int>(json['productoId']),
      tipo: serializer.fromJson<String>(json['tipo']),
      cantidad: serializer.fromJson<double>(json['cantidad']),
      unidad: serializer.fromJson<String>(json['unidad']),
      movimientoId: serializer.fromJson<int?>(json['movimientoId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'produccionId': serializer.toJson<int>(produccionId),
      'productoId': serializer.toJson<int>(productoId),
      'tipo': serializer.toJson<String>(tipo),
      'cantidad': serializer.toJson<double>(cantidad),
      'unidad': serializer.toJson<String>(unidad),
      'movimientoId': serializer.toJson<int?>(movimientoId),
    };
  }

  ProduccionDetalle copyWith(
          {int? id,
          int? produccionId,
          int? productoId,
          String? tipo,
          double? cantidad,
          String? unidad,
          Value<int?> movimientoId = const Value.absent()}) =>
      ProduccionDetalle(
        id: id ?? this.id,
        produccionId: produccionId ?? this.produccionId,
        productoId: productoId ?? this.productoId,
        tipo: tipo ?? this.tipo,
        cantidad: cantidad ?? this.cantidad,
        unidad: unidad ?? this.unidad,
        movimientoId:
            movimientoId.present ? movimientoId.value : this.movimientoId,
      );
  ProduccionDetalle copyWithCompanion(ProduccionDetallesCompanion data) {
    return ProduccionDetalle(
      id: data.id.present ? data.id.value : this.id,
      produccionId: data.produccionId.present
          ? data.produccionId.value
          : this.produccionId,
      productoId:
          data.productoId.present ? data.productoId.value : this.productoId,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      unidad: data.unidad.present ? data.unidad.value : this.unidad,
      movimientoId: data.movimientoId.present
          ? data.movimientoId.value
          : this.movimientoId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProduccionDetalle(')
          ..write('id: $id, ')
          ..write('produccionId: $produccionId, ')
          ..write('productoId: $productoId, ')
          ..write('tipo: $tipo, ')
          ..write('cantidad: $cantidad, ')
          ..write('unidad: $unidad, ')
          ..write('movimientoId: $movimientoId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, produccionId, productoId, tipo, cantidad, unidad, movimientoId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProduccionDetalle &&
          other.id == this.id &&
          other.produccionId == this.produccionId &&
          other.productoId == this.productoId &&
          other.tipo == this.tipo &&
          other.cantidad == this.cantidad &&
          other.unidad == this.unidad &&
          other.movimientoId == this.movimientoId);
}

class ProduccionDetallesCompanion extends UpdateCompanion<ProduccionDetalle> {
  final Value<int> id;
  final Value<int> produccionId;
  final Value<int> productoId;
  final Value<String> tipo;
  final Value<double> cantidad;
  final Value<String> unidad;
  final Value<int?> movimientoId;
  const ProduccionDetallesCompanion({
    this.id = const Value.absent(),
    this.produccionId = const Value.absent(),
    this.productoId = const Value.absent(),
    this.tipo = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.unidad = const Value.absent(),
    this.movimientoId = const Value.absent(),
  });
  ProduccionDetallesCompanion.insert({
    this.id = const Value.absent(),
    required int produccionId,
    required int productoId,
    required String tipo,
    required double cantidad,
    this.unidad = const Value.absent(),
    this.movimientoId = const Value.absent(),
  })  : produccionId = Value(produccionId),
        productoId = Value(productoId),
        tipo = Value(tipo),
        cantidad = Value(cantidad);
  static Insertable<ProduccionDetalle> custom({
    Expression<int>? id,
    Expression<int>? produccionId,
    Expression<int>? productoId,
    Expression<String>? tipo,
    Expression<double>? cantidad,
    Expression<String>? unidad,
    Expression<int>? movimientoId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (produccionId != null) 'produccion_id': produccionId,
      if (productoId != null) 'producto_id': productoId,
      if (tipo != null) 'tipo': tipo,
      if (cantidad != null) 'cantidad': cantidad,
      if (unidad != null) 'unidad': unidad,
      if (movimientoId != null) 'movimiento_id': movimientoId,
    });
  }

  ProduccionDetallesCompanion copyWith(
      {Value<int>? id,
      Value<int>? produccionId,
      Value<int>? productoId,
      Value<String>? tipo,
      Value<double>? cantidad,
      Value<String>? unidad,
      Value<int?>? movimientoId}) {
    return ProduccionDetallesCompanion(
      id: id ?? this.id,
      produccionId: produccionId ?? this.produccionId,
      productoId: productoId ?? this.productoId,
      tipo: tipo ?? this.tipo,
      cantidad: cantidad ?? this.cantidad,
      unidad: unidad ?? this.unidad,
      movimientoId: movimientoId ?? this.movimientoId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (produccionId.present) {
      map['produccion_id'] = Variable<int>(produccionId.value);
    }
    if (productoId.present) {
      map['producto_id'] = Variable<int>(productoId.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<double>(cantidad.value);
    }
    if (unidad.present) {
      map['unidad'] = Variable<String>(unidad.value);
    }
    if (movimientoId.present) {
      map['movimiento_id'] = Variable<int>(movimientoId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProduccionDetallesCompanion(')
          ..write('id: $id, ')
          ..write('produccionId: $produccionId, ')
          ..write('productoId: $productoId, ')
          ..write('tipo: $tipo, ')
          ..write('cantidad: $cantidad, ')
          ..write('unidad: $unidad, ')
          ..write('movimientoId: $movimientoId')
          ..write(')'))
        .toString();
  }
}

class $ComprasListaTable extends ComprasLista
    with TableInfo<$ComprasListaTable, ComprasListaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ComprasListaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _productoIdMeta =
      const VerificationMeta('productoId');
  @override
  late final GeneratedColumn<int> productoId = GeneratedColumn<int>(
      'producto_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, productoId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'compras_lista';
  @override
  VerificationContext validateIntegrity(Insertable<ComprasListaData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('producto_id')) {
      context.handle(
          _productoIdMeta,
          productoId.isAcceptableOrUnknown(
              data['producto_id']!, _productoIdMeta));
    } else if (isInserting) {
      context.missing(_productoIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ComprasListaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ComprasListaData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      productoId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}producto_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
    );
  }

  @override
  $ComprasListaTable createAlias(String alias) {
    return $ComprasListaTable(attachedDatabase, alias);
  }
}

class ComprasListaData extends DataClass
    implements Insertable<ComprasListaData> {
  final int id;
  final int productoId;
  final DateTime? createdAt;
  const ComprasListaData(
      {required this.id, required this.productoId, this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['producto_id'] = Variable<int>(productoId);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  ComprasListaCompanion toCompanion(bool nullToAbsent) {
    return ComprasListaCompanion(
      id: Value(id),
      productoId: Value(productoId),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory ComprasListaData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ComprasListaData(
      id: serializer.fromJson<int>(json['id']),
      productoId: serializer.fromJson<int>(json['productoId']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productoId': serializer.toJson<int>(productoId),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  ComprasListaData copyWith(
          {int? id,
          int? productoId,
          Value<DateTime?> createdAt = const Value.absent()}) =>
      ComprasListaData(
        id: id ?? this.id,
        productoId: productoId ?? this.productoId,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
      );
  ComprasListaData copyWithCompanion(ComprasListaCompanion data) {
    return ComprasListaData(
      id: data.id.present ? data.id.value : this.id,
      productoId:
          data.productoId.present ? data.productoId.value : this.productoId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ComprasListaData(')
          ..write('id: $id, ')
          ..write('productoId: $productoId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, productoId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ComprasListaData &&
          other.id == this.id &&
          other.productoId == this.productoId &&
          other.createdAt == this.createdAt);
}

class ComprasListaCompanion extends UpdateCompanion<ComprasListaData> {
  final Value<int> id;
  final Value<int> productoId;
  final Value<DateTime?> createdAt;
  const ComprasListaCompanion({
    this.id = const Value.absent(),
    this.productoId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ComprasListaCompanion.insert({
    this.id = const Value.absent(),
    required int productoId,
    this.createdAt = const Value.absent(),
  }) : productoId = Value(productoId);
  static Insertable<ComprasListaData> custom({
    Expression<int>? id,
    Expression<int>? productoId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productoId != null) 'producto_id': productoId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ComprasListaCompanion copyWith(
      {Value<int>? id, Value<int>? productoId, Value<DateTime?>? createdAt}) {
    return ComprasListaCompanion(
      id: id ?? this.id,
      productoId: productoId ?? this.productoId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productoId.present) {
      map['producto_id'] = Variable<int>(productoId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ComprasListaCompanion(')
          ..write('id: $id, ')
          ..write('productoId: $productoId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _targetTableMeta =
      const VerificationMeta('targetTable');
  @override
  late final GeneratedColumn<String> targetTable = GeneratedColumn<String>(
      'table_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _operationMeta =
      const VerificationMeta('operation');
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
      'operation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
      'data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _retriesMeta =
      const VerificationMeta('retries');
  @override
  late final GeneratedColumn<int> retries = GeneratedColumn<int>(
      'retries', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastErrorMeta =
      const VerificationMeta('lastError');
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
      'last_error', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, targetTable, operation, data, createdAt, retries, lastError, status];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(Insertable<SyncQueueData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('table_name')) {
      context.handle(
          _targetTableMeta,
          targetTable.isAcceptableOrUnknown(
              data['table_name']!, _targetTableMeta));
    } else if (isInserting) {
      context.missing(_targetTableMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(_operationMeta,
          operation.isAcceptableOrUnknown(data['operation']!, _operationMeta));
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
          _dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('retries')) {
      context.handle(_retriesMeta,
          retries.isAcceptableOrUnknown(data['retries']!, _retriesMeta));
    }
    if (data.containsKey('last_error')) {
      context.handle(_lastErrorMeta,
          lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      targetTable: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}table_name'])!,
      operation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}operation'])!,
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      retries: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}retries'])!,
      lastError: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_error']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final int id;
  final String targetTable;
  final String operation;
  final String data;
  final DateTime createdAt;
  final int retries;
  final String? lastError;
  final String status;
  const SyncQueueData(
      {required this.id,
      required this.targetTable,
      required this.operation,
      required this.data,
      required this.createdAt,
      required this.retries,
      this.lastError,
      required this.status});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['table_name'] = Variable<String>(targetTable);
    map['operation'] = Variable<String>(operation);
    map['data'] = Variable<String>(data);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['retries'] = Variable<int>(retries);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['status'] = Variable<String>(status);
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      targetTable: Value(targetTable),
      operation: Value(operation),
      data: Value(data),
      createdAt: Value(createdAt),
      retries: Value(retries),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      status: Value(status),
    );
  }

  factory SyncQueueData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      id: serializer.fromJson<int>(json['id']),
      targetTable: serializer.fromJson<String>(json['targetTable']),
      operation: serializer.fromJson<String>(json['operation']),
      data: serializer.fromJson<String>(json['data']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      retries: serializer.fromJson<int>(json['retries']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'targetTable': serializer.toJson<String>(targetTable),
      'operation': serializer.toJson<String>(operation),
      'data': serializer.toJson<String>(data),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'retries': serializer.toJson<int>(retries),
      'lastError': serializer.toJson<String?>(lastError),
      'status': serializer.toJson<String>(status),
    };
  }

  SyncQueueData copyWith(
          {int? id,
          String? targetTable,
          String? operation,
          String? data,
          DateTime? createdAt,
          int? retries,
          Value<String?> lastError = const Value.absent(),
          String? status}) =>
      SyncQueueData(
        id: id ?? this.id,
        targetTable: targetTable ?? this.targetTable,
        operation: operation ?? this.operation,
        data: data ?? this.data,
        createdAt: createdAt ?? this.createdAt,
        retries: retries ?? this.retries,
        lastError: lastError.present ? lastError.value : this.lastError,
        status: status ?? this.status,
      );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      targetTable:
          data.targetTable.present ? data.targetTable.value : this.targetTable,
      operation: data.operation.present ? data.operation.value : this.operation,
      data: data.data.present ? data.data.value : this.data,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      retries: data.retries.present ? data.retries.value : this.retries,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('id: $id, ')
          ..write('targetTable: $targetTable, ')
          ..write('operation: $operation, ')
          ..write('data: $data, ')
          ..write('createdAt: $createdAt, ')
          ..write('retries: $retries, ')
          ..write('lastError: $lastError, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, targetTable, operation, data, createdAt, retries, lastError, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.id == this.id &&
          other.targetTable == this.targetTable &&
          other.operation == this.operation &&
          other.data == this.data &&
          other.createdAt == this.createdAt &&
          other.retries == this.retries &&
          other.lastError == this.lastError &&
          other.status == this.status);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<int> id;
  final Value<String> targetTable;
  final Value<String> operation;
  final Value<String> data;
  final Value<DateTime> createdAt;
  final Value<int> retries;
  final Value<String?> lastError;
  final Value<String> status;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.targetTable = const Value.absent(),
    this.operation = const Value.absent(),
    this.data = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.retries = const Value.absent(),
    this.lastError = const Value.absent(),
    this.status = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    this.id = const Value.absent(),
    required String targetTable,
    required String operation,
    required String data,
    required DateTime createdAt,
    this.retries = const Value.absent(),
    this.lastError = const Value.absent(),
    this.status = const Value.absent(),
  })  : targetTable = Value(targetTable),
        operation = Value(operation),
        data = Value(data),
        createdAt = Value(createdAt);
  static Insertable<SyncQueueData> custom({
    Expression<int>? id,
    Expression<String>? targetTable,
    Expression<String>? operation,
    Expression<String>? data,
    Expression<DateTime>? createdAt,
    Expression<int>? retries,
    Expression<String>? lastError,
    Expression<String>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (targetTable != null) 'table_name': targetTable,
      if (operation != null) 'operation': operation,
      if (data != null) 'data': data,
      if (createdAt != null) 'created_at': createdAt,
      if (retries != null) 'retries': retries,
      if (lastError != null) 'last_error': lastError,
      if (status != null) 'status': status,
    });
  }

  SyncQueueCompanion copyWith(
      {Value<int>? id,
      Value<String>? targetTable,
      Value<String>? operation,
      Value<String>? data,
      Value<DateTime>? createdAt,
      Value<int>? retries,
      Value<String?>? lastError,
      Value<String>? status}) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      targetTable: targetTable ?? this.targetTable,
      operation: operation ?? this.operation,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      retries: retries ?? this.retries,
      lastError: lastError ?? this.lastError,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (targetTable.present) {
      map['table_name'] = Variable<String>(targetTable.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (retries.present) {
      map['retries'] = Variable<int>(retries.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('targetTable: $targetTable, ')
          ..write('operation: $operation, ')
          ..write('data: $data, ')
          ..write('createdAt: $createdAt, ')
          ..write('retries: $retries, ')
          ..write('lastError: $lastError, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class $SyncMetadataTable extends SyncMetadata
    with TableInfo<$SyncMetadataTable, SyncMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_metadata';
  @override
  VerificationContext validateIntegrity(Insertable<SyncMetadataData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SyncMetadataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncMetadataData(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $SyncMetadataTable createAlias(String alias) {
    return $SyncMetadataTable(attachedDatabase, alias);
  }
}

class SyncMetadataData extends DataClass
    implements Insertable<SyncMetadataData> {
  final String key;
  final String? value;
  final DateTime? updatedAt;
  const SyncMetadataData({required this.key, this.value, this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<String>(value);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  SyncMetadataCompanion toCompanion(bool nullToAbsent) {
    return SyncMetadataCompanion(
      key: Value(key),
      value:
          value == null && nullToAbsent ? const Value.absent() : Value(value),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory SyncMetadataData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncMetadataData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String?>(json['value']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String?>(value),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  SyncMetadataData copyWith(
          {String? key,
          Value<String?> value = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      SyncMetadataData(
        key: key ?? this.key,
        value: value.present ? value.value : this.value,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  SyncMetadataData copyWithCompanion(SyncMetadataCompanion data) {
    return SyncMetadataData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataData(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncMetadataData &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class SyncMetadataCompanion extends UpdateCompanion<SyncMetadataData> {
  final Value<String> key;
  final Value<String?> value;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const SyncMetadataCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncMetadataCompanion.insert({
    required String key,
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key);
  static Insertable<SyncMetadataData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncMetadataCompanion copyWith(
      {Value<String>? key,
      Value<String?>? value,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return SyncMetadataCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DispositivoUsuarioTable extends DispositivoUsuario
    with TableInfo<$DispositivoUsuarioTable, DispositivoUsuarioData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DispositivoUsuarioTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
      'nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pinHashMeta =
      const VerificationMeta('pinHash');
  @override
  late final GeneratedColumn<String> pinHash = GeneratedColumn<String>(
      'pin_hash', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _configuradoEnMeta =
      const VerificationMeta('configuradoEn');
  @override
  late final GeneratedColumn<DateTime> configuradoEn =
      GeneratedColumn<DateTime>('configurado_en', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, nombre, pinHash, configuradoEn];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dispositivo_usuario';
  @override
  VerificationContext validateIntegrity(
      Insertable<DispositivoUsuarioData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('pin_hash')) {
      context.handle(_pinHashMeta,
          pinHash.isAcceptableOrUnknown(data['pin_hash']!, _pinHashMeta));
    }
    if (data.containsKey('configurado_en')) {
      context.handle(
          _configuradoEnMeta,
          configuradoEn.isAcceptableOrUnknown(
              data['configurado_en']!, _configuradoEnMeta));
    } else if (isInserting) {
      context.missing(_configuradoEnMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DispositivoUsuarioData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DispositivoUsuarioData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombre'])!,
      pinHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pin_hash']),
      configuradoEn: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}configurado_en'])!,
    );
  }

  @override
  $DispositivoUsuarioTable createAlias(String alias) {
    return $DispositivoUsuarioTable(attachedDatabase, alias);
  }
}

class DispositivoUsuarioData extends DataClass
    implements Insertable<DispositivoUsuarioData> {
  final int id;
  final String nombre;
  final String? pinHash;
  final DateTime configuradoEn;
  const DispositivoUsuarioData(
      {required this.id,
      required this.nombre,
      this.pinHash,
      required this.configuradoEn});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || pinHash != null) {
      map['pin_hash'] = Variable<String>(pinHash);
    }
    map['configurado_en'] = Variable<DateTime>(configuradoEn);
    return map;
  }

  DispositivoUsuarioCompanion toCompanion(bool nullToAbsent) {
    return DispositivoUsuarioCompanion(
      id: Value(id),
      nombre: Value(nombre),
      pinHash: pinHash == null && nullToAbsent
          ? const Value.absent()
          : Value(pinHash),
      configuradoEn: Value(configuradoEn),
    );
  }

  factory DispositivoUsuarioData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DispositivoUsuarioData(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      pinHash: serializer.fromJson<String?>(json['pinHash']),
      configuradoEn: serializer.fromJson<DateTime>(json['configuradoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'pinHash': serializer.toJson<String?>(pinHash),
      'configuradoEn': serializer.toJson<DateTime>(configuradoEn),
    };
  }

  DispositivoUsuarioData copyWith(
          {int? id,
          String? nombre,
          Value<String?> pinHash = const Value.absent(),
          DateTime? configuradoEn}) =>
      DispositivoUsuarioData(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        pinHash: pinHash.present ? pinHash.value : this.pinHash,
        configuradoEn: configuradoEn ?? this.configuradoEn,
      );
  DispositivoUsuarioData copyWithCompanion(DispositivoUsuarioCompanion data) {
    return DispositivoUsuarioData(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      pinHash: data.pinHash.present ? data.pinHash.value : this.pinHash,
      configuradoEn: data.configuradoEn.present
          ? data.configuradoEn.value
          : this.configuradoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DispositivoUsuarioData(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('pinHash: $pinHash, ')
          ..write('configuradoEn: $configuradoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, pinHash, configuradoEn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DispositivoUsuarioData &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.pinHash == this.pinHash &&
          other.configuradoEn == this.configuradoEn);
}

class DispositivoUsuarioCompanion
    extends UpdateCompanion<DispositivoUsuarioData> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String?> pinHash;
  final Value<DateTime> configuradoEn;
  const DispositivoUsuarioCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.pinHash = const Value.absent(),
    this.configuradoEn = const Value.absent(),
  });
  DispositivoUsuarioCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    this.pinHash = const Value.absent(),
    required DateTime configuradoEn,
  })  : nombre = Value(nombre),
        configuradoEn = Value(configuradoEn);
  static Insertable<DispositivoUsuarioData> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? pinHash,
    Expression<DateTime>? configuradoEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (pinHash != null) 'pin_hash': pinHash,
      if (configuradoEn != null) 'configurado_en': configuradoEn,
    });
  }

  DispositivoUsuarioCompanion copyWith(
      {Value<int>? id,
      Value<String>? nombre,
      Value<String?>? pinHash,
      Value<DateTime>? configuradoEn}) {
    return DispositivoUsuarioCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      pinHash: pinHash ?? this.pinHash,
      configuradoEn: configuradoEn ?? this.configuradoEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (pinHash.present) {
      map['pin_hash'] = Variable<String>(pinHash.value);
    }
    if (configuradoEn.present) {
      map['configurado_en'] = Variable<DateTime>(configuradoEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DispositivoUsuarioCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('pinHash: $pinHash, ')
          ..write('configuradoEn: $configuradoEn')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoriasTable categorias = $CategoriasTable(this);
  late final $ProductosTable productos = $ProductosTable(this);
  late final $ProveedoresTable proveedores = $ProveedoresTable(this);
  late final $ExistenciasTable existencias = $ExistenciasTable(this);
  late final $MovimientosTable movimientos = $MovimientosTable(this);
  late final $MovimientosArchivoTable movimientosArchivo =
      $MovimientosArchivoTable(this);
  late final $FacturasTable facturas = $FacturasTable(this);
  late final $FacturaPagosTable facturaPagos = $FacturaPagosTable(this);
  late final $RequisicionesTable requisiciones = $RequisicionesTable(this);
  late final $RequisicionDetallesTable requisicionDetalles =
      $RequisicionDetallesTable(this);
  late final $StockCheckpointTable stockCheckpoint =
      $StockCheckpointTable(this);
  late final $PeriodosTable periodos = $PeriodosTable(this);
  late final $RecetasTable recetas = $RecetasTable(this);
  late final $RecetaComponentesTable recetaComponentes =
      $RecetaComponentesTable(this);
  late final $ProduccionesTable producciones = $ProduccionesTable(this);
  late final $ProduccionDetallesTable produccionDetalles =
      $ProduccionDetallesTable(this);
  late final $ComprasListaTable comprasLista = $ComprasListaTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  late final $SyncMetadataTable syncMetadata = $SyncMetadataTable(this);
  late final $DispositivoUsuarioTable dispositivoUsuario =
      $DispositivoUsuarioTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        categorias,
        productos,
        proveedores,
        existencias,
        movimientos,
        movimientosArchivo,
        facturas,
        facturaPagos,
        requisiciones,
        requisicionDetalles,
        stockCheckpoint,
        periodos,
        recetas,
        recetaComponentes,
        producciones,
        produccionDetalles,
        comprasLista,
        syncQueue,
        syncMetadata,
        dispositivoUsuario
      ];
}

typedef $$CategoriasTableCreateCompanionBuilder = CategoriasCompanion Function({
  Value<int> id,
  required String nombre,
  Value<String?> descripcion,
  Value<String?> imagen,
  Value<String> color,
  Value<int> activo,
  Value<int> visibleEnPos,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
});
typedef $$CategoriasTableUpdateCompanionBuilder = CategoriasCompanion Function({
  Value<int> id,
  Value<String> nombre,
  Value<String?> descripcion,
  Value<String?> imagen,
  Value<String> color,
  Value<int> activo,
  Value<int> visibleEnPos,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
});

class $$CategoriasTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriasTable> {
  $$CategoriasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get descripcion => $composableBuilder(
      column: $table.descripcion, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imagen => $composableBuilder(
      column: $table.imagen, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get activo => $composableBuilder(
      column: $table.activo, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get visibleEnPos => $composableBuilder(
      column: $table.visibleEnPos, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$CategoriasTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriasTable> {
  $$CategoriasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get descripcion => $composableBuilder(
      column: $table.descripcion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imagen => $composableBuilder(
      column: $table.imagen, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get activo => $composableBuilder(
      column: $table.activo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get visibleEnPos => $composableBuilder(
      column: $table.visibleEnPos,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$CategoriasTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriasTable> {
  $$CategoriasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
      column: $table.descripcion, builder: (column) => column);

  GeneratedColumn<String> get imagen =>
      $composableBuilder(column: $table.imagen, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<int> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  GeneratedColumn<int> get visibleEnPos => $composableBuilder(
      column: $table.visibleEnPos, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CategoriasTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoriasTable,
    Categoria,
    $$CategoriasTableFilterComposer,
    $$CategoriasTableOrderingComposer,
    $$CategoriasTableAnnotationComposer,
    $$CategoriasTableCreateCompanionBuilder,
    $$CategoriasTableUpdateCompanionBuilder,
    (Categoria, BaseReferences<_$AppDatabase, $CategoriasTable, Categoria>),
    Categoria,
    PrefetchHooks Function()> {
  $$CategoriasTableTableManager(_$AppDatabase db, $CategoriasTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nombre = const Value.absent(),
            Value<String?> descripcion = const Value.absent(),
            Value<String?> imagen = const Value.absent(),
            Value<String> color = const Value.absent(),
            Value<int> activo = const Value.absent(),
            Value<int> visibleEnPos = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              CategoriasCompanion(
            id: id,
            nombre: nombre,
            descripcion: descripcion,
            imagen: imagen,
            color: color,
            activo: activo,
            visibleEnPos: visibleEnPos,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nombre,
            Value<String?> descripcion = const Value.absent(),
            Value<String?> imagen = const Value.absent(),
            Value<String> color = const Value.absent(),
            Value<int> activo = const Value.absent(),
            Value<int> visibleEnPos = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              CategoriasCompanion.insert(
            id: id,
            nombre: nombre,
            descripcion: descripcion,
            imagen: imagen,
            color: color,
            activo: activo,
            visibleEnPos: visibleEnPos,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CategoriasTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CategoriasTable,
    Categoria,
    $$CategoriasTableFilterComposer,
    $$CategoriasTableOrderingComposer,
    $$CategoriasTableAnnotationComposer,
    $$CategoriasTableCreateCompanionBuilder,
    $$CategoriasTableUpdateCompanionBuilder,
    (Categoria, BaseReferences<_$AppDatabase, $CategoriasTable, Categoria>),
    Categoria,
    PrefetchHooks Function()>;
typedef $$ProductosTableCreateCompanionBuilder = ProductosCompanion Function({
  Value<int> id,
  required String nombre,
  Value<String?> codigo,
  Value<String?> descripcion,
  Value<int?> categoriaId,
  Value<int> esPesable,
  Value<int> requiereFotoPeso,
  Value<double?> pesoUnitario,
  Value<double> precioVenta,
  Value<String> unidadMedida,
  Value<double> stockActual,
  Value<double> stockMinimo,
  Value<int> activo,
  Value<String> tipo,
  Value<String> almacenPredeterminado,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
});
typedef $$ProductosTableUpdateCompanionBuilder = ProductosCompanion Function({
  Value<int> id,
  Value<String> nombre,
  Value<String?> codigo,
  Value<String?> descripcion,
  Value<int?> categoriaId,
  Value<int> esPesable,
  Value<int> requiereFotoPeso,
  Value<double?> pesoUnitario,
  Value<double> precioVenta,
  Value<String> unidadMedida,
  Value<double> stockActual,
  Value<double> stockMinimo,
  Value<int> activo,
  Value<String> tipo,
  Value<String> almacenPredeterminado,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
});

class $$ProductosTableFilterComposer
    extends Composer<_$AppDatabase, $ProductosTable> {
  $$ProductosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get codigo => $composableBuilder(
      column: $table.codigo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get descripcion => $composableBuilder(
      column: $table.descripcion, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get categoriaId => $composableBuilder(
      column: $table.categoriaId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get esPesable => $composableBuilder(
      column: $table.esPesable, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get requiereFotoPeso => $composableBuilder(
      column: $table.requiereFotoPeso,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get pesoUnitario => $composableBuilder(
      column: $table.pesoUnitario, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get precioVenta => $composableBuilder(
      column: $table.precioVenta, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unidadMedida => $composableBuilder(
      column: $table.unidadMedida, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get stockActual => $composableBuilder(
      column: $table.stockActual, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get stockMinimo => $composableBuilder(
      column: $table.stockMinimo, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get activo => $composableBuilder(
      column: $table.activo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tipo => $composableBuilder(
      column: $table.tipo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get almacenPredeterminado => $composableBuilder(
      column: $table.almacenPredeterminado,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$ProductosTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductosTable> {
  $$ProductosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get codigo => $composableBuilder(
      column: $table.codigo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get descripcion => $composableBuilder(
      column: $table.descripcion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get categoriaId => $composableBuilder(
      column: $table.categoriaId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get esPesable => $composableBuilder(
      column: $table.esPesable, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get requiereFotoPeso => $composableBuilder(
      column: $table.requiereFotoPeso,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get pesoUnitario => $composableBuilder(
      column: $table.pesoUnitario,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get precioVenta => $composableBuilder(
      column: $table.precioVenta, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unidadMedida => $composableBuilder(
      column: $table.unidadMedida,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get stockActual => $composableBuilder(
      column: $table.stockActual, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get stockMinimo => $composableBuilder(
      column: $table.stockMinimo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get activo => $composableBuilder(
      column: $table.activo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tipo => $composableBuilder(
      column: $table.tipo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get almacenPredeterminado => $composableBuilder(
      column: $table.almacenPredeterminado,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ProductosTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductosTable> {
  $$ProductosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
      column: $table.descripcion, builder: (column) => column);

  GeneratedColumn<int> get categoriaId => $composableBuilder(
      column: $table.categoriaId, builder: (column) => column);

  GeneratedColumn<int> get esPesable =>
      $composableBuilder(column: $table.esPesable, builder: (column) => column);

  GeneratedColumn<int> get requiereFotoPeso => $composableBuilder(
      column: $table.requiereFotoPeso, builder: (column) => column);

  GeneratedColumn<double> get pesoUnitario => $composableBuilder(
      column: $table.pesoUnitario, builder: (column) => column);

  GeneratedColumn<double> get precioVenta => $composableBuilder(
      column: $table.precioVenta, builder: (column) => column);

  GeneratedColumn<String> get unidadMedida => $composableBuilder(
      column: $table.unidadMedida, builder: (column) => column);

  GeneratedColumn<double> get stockActual => $composableBuilder(
      column: $table.stockActual, builder: (column) => column);

  GeneratedColumn<double> get stockMinimo => $composableBuilder(
      column: $table.stockMinimo, builder: (column) => column);

  GeneratedColumn<int> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get almacenPredeterminado => $composableBuilder(
      column: $table.almacenPredeterminado, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ProductosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductosTable,
    Producto,
    $$ProductosTableFilterComposer,
    $$ProductosTableOrderingComposer,
    $$ProductosTableAnnotationComposer,
    $$ProductosTableCreateCompanionBuilder,
    $$ProductosTableUpdateCompanionBuilder,
    (Producto, BaseReferences<_$AppDatabase, $ProductosTable, Producto>),
    Producto,
    PrefetchHooks Function()> {
  $$ProductosTableTableManager(_$AppDatabase db, $ProductosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nombre = const Value.absent(),
            Value<String?> codigo = const Value.absent(),
            Value<String?> descripcion = const Value.absent(),
            Value<int?> categoriaId = const Value.absent(),
            Value<int> esPesable = const Value.absent(),
            Value<int> requiereFotoPeso = const Value.absent(),
            Value<double?> pesoUnitario = const Value.absent(),
            Value<double> precioVenta = const Value.absent(),
            Value<String> unidadMedida = const Value.absent(),
            Value<double> stockActual = const Value.absent(),
            Value<double> stockMinimo = const Value.absent(),
            Value<int> activo = const Value.absent(),
            Value<String> tipo = const Value.absent(),
            Value<String> almacenPredeterminado = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              ProductosCompanion(
            id: id,
            nombre: nombre,
            codigo: codigo,
            descripcion: descripcion,
            categoriaId: categoriaId,
            esPesable: esPesable,
            requiereFotoPeso: requiereFotoPeso,
            pesoUnitario: pesoUnitario,
            precioVenta: precioVenta,
            unidadMedida: unidadMedida,
            stockActual: stockActual,
            stockMinimo: stockMinimo,
            activo: activo,
            tipo: tipo,
            almacenPredeterminado: almacenPredeterminado,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nombre,
            Value<String?> codigo = const Value.absent(),
            Value<String?> descripcion = const Value.absent(),
            Value<int?> categoriaId = const Value.absent(),
            Value<int> esPesable = const Value.absent(),
            Value<int> requiereFotoPeso = const Value.absent(),
            Value<double?> pesoUnitario = const Value.absent(),
            Value<double> precioVenta = const Value.absent(),
            Value<String> unidadMedida = const Value.absent(),
            Value<double> stockActual = const Value.absent(),
            Value<double> stockMinimo = const Value.absent(),
            Value<int> activo = const Value.absent(),
            Value<String> tipo = const Value.absent(),
            Value<String> almacenPredeterminado = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              ProductosCompanion.insert(
            id: id,
            nombre: nombre,
            codigo: codigo,
            descripcion: descripcion,
            categoriaId: categoriaId,
            esPesable: esPesable,
            requiereFotoPeso: requiereFotoPeso,
            pesoUnitario: pesoUnitario,
            precioVenta: precioVenta,
            unidadMedida: unidadMedida,
            stockActual: stockActual,
            stockMinimo: stockMinimo,
            activo: activo,
            tipo: tipo,
            almacenPredeterminado: almacenPredeterminado,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProductosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProductosTable,
    Producto,
    $$ProductosTableFilterComposer,
    $$ProductosTableOrderingComposer,
    $$ProductosTableAnnotationComposer,
    $$ProductosTableCreateCompanionBuilder,
    $$ProductosTableUpdateCompanionBuilder,
    (Producto, BaseReferences<_$AppDatabase, $ProductosTable, Producto>),
    Producto,
    PrefetchHooks Function()>;
typedef $$ProveedoresTableCreateCompanionBuilder = ProveedoresCompanion
    Function({
  Value<int> id,
  required String nombre,
  Value<String?> rif,
  Value<String?> telefono,
  Value<String?> email,
  Value<String?> direccion,
  Value<String?> contacto,
  Value<String?> observaciones,
  Value<String> estado,
  Value<DateTime?> createdAt,
});
typedef $$ProveedoresTableUpdateCompanionBuilder = ProveedoresCompanion
    Function({
  Value<int> id,
  Value<String> nombre,
  Value<String?> rif,
  Value<String?> telefono,
  Value<String?> email,
  Value<String?> direccion,
  Value<String?> contacto,
  Value<String?> observaciones,
  Value<String> estado,
  Value<DateTime?> createdAt,
});

class $$ProveedoresTableFilterComposer
    extends Composer<_$AppDatabase, $ProveedoresTable> {
  $$ProveedoresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rif => $composableBuilder(
      column: $table.rif, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get telefono => $composableBuilder(
      column: $table.telefono, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get direccion => $composableBuilder(
      column: $table.direccion, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contacto => $composableBuilder(
      column: $table.contacto, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get observaciones => $composableBuilder(
      column: $table.observaciones, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get estado => $composableBuilder(
      column: $table.estado, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$ProveedoresTableOrderingComposer
    extends Composer<_$AppDatabase, $ProveedoresTable> {
  $$ProveedoresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rif => $composableBuilder(
      column: $table.rif, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get telefono => $composableBuilder(
      column: $table.telefono, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get direccion => $composableBuilder(
      column: $table.direccion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contacto => $composableBuilder(
      column: $table.contacto, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get observaciones => $composableBuilder(
      column: $table.observaciones,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get estado => $composableBuilder(
      column: $table.estado, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ProveedoresTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProveedoresTable> {
  $$ProveedoresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get rif =>
      $composableBuilder(column: $table.rif, builder: (column) => column);

  GeneratedColumn<String> get telefono =>
      $composableBuilder(column: $table.telefono, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get direccion =>
      $composableBuilder(column: $table.direccion, builder: (column) => column);

  GeneratedColumn<String> get contacto =>
      $composableBuilder(column: $table.contacto, builder: (column) => column);

  GeneratedColumn<String> get observaciones => $composableBuilder(
      column: $table.observaciones, builder: (column) => column);

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ProveedoresTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProveedoresTable,
    Proveedore,
    $$ProveedoresTableFilterComposer,
    $$ProveedoresTableOrderingComposer,
    $$ProveedoresTableAnnotationComposer,
    $$ProveedoresTableCreateCompanionBuilder,
    $$ProveedoresTableUpdateCompanionBuilder,
    (Proveedore, BaseReferences<_$AppDatabase, $ProveedoresTable, Proveedore>),
    Proveedore,
    PrefetchHooks Function()> {
  $$ProveedoresTableTableManager(_$AppDatabase db, $ProveedoresTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProveedoresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProveedoresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProveedoresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nombre = const Value.absent(),
            Value<String?> rif = const Value.absent(),
            Value<String?> telefono = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> direccion = const Value.absent(),
            Value<String?> contacto = const Value.absent(),
            Value<String?> observaciones = const Value.absent(),
            Value<String> estado = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              ProveedoresCompanion(
            id: id,
            nombre: nombre,
            rif: rif,
            telefono: telefono,
            email: email,
            direccion: direccion,
            contacto: contacto,
            observaciones: observaciones,
            estado: estado,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nombre,
            Value<String?> rif = const Value.absent(),
            Value<String?> telefono = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> direccion = const Value.absent(),
            Value<String?> contacto = const Value.absent(),
            Value<String?> observaciones = const Value.absent(),
            Value<String> estado = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              ProveedoresCompanion.insert(
            id: id,
            nombre: nombre,
            rif: rif,
            telefono: telefono,
            email: email,
            direccion: direccion,
            contacto: contacto,
            observaciones: observaciones,
            estado: estado,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProveedoresTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProveedoresTable,
    Proveedore,
    $$ProveedoresTableFilterComposer,
    $$ProveedoresTableOrderingComposer,
    $$ProveedoresTableAnnotationComposer,
    $$ProveedoresTableCreateCompanionBuilder,
    $$ProveedoresTableUpdateCompanionBuilder,
    (Proveedore, BaseReferences<_$AppDatabase, $ProveedoresTable, Proveedore>),
    Proveedore,
    PrefetchHooks Function()>;
typedef $$ExistenciasTableCreateCompanionBuilder = ExistenciasCompanion
    Function({
  Value<int> id,
  Value<int?> productoId,
  required String almacen,
  Value<double> cantidad,
  Value<String> unidad,
});
typedef $$ExistenciasTableUpdateCompanionBuilder = ExistenciasCompanion
    Function({
  Value<int> id,
  Value<int?> productoId,
  Value<String> almacen,
  Value<double> cantidad,
  Value<String> unidad,
});

class $$ExistenciasTableFilterComposer
    extends Composer<_$AppDatabase, $ExistenciasTable> {
  $$ExistenciasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get productoId => $composableBuilder(
      column: $table.productoId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get almacen => $composableBuilder(
      column: $table.almacen, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cantidad => $composableBuilder(
      column: $table.cantidad, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unidad => $composableBuilder(
      column: $table.unidad, builder: (column) => ColumnFilters(column));
}

class $$ExistenciasTableOrderingComposer
    extends Composer<_$AppDatabase, $ExistenciasTable> {
  $$ExistenciasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get productoId => $composableBuilder(
      column: $table.productoId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get almacen => $composableBuilder(
      column: $table.almacen, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cantidad => $composableBuilder(
      column: $table.cantidad, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unidad => $composableBuilder(
      column: $table.unidad, builder: (column) => ColumnOrderings(column));
}

class $$ExistenciasTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExistenciasTable> {
  $$ExistenciasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get productoId => $composableBuilder(
      column: $table.productoId, builder: (column) => column);

  GeneratedColumn<String> get almacen =>
      $composableBuilder(column: $table.almacen, builder: (column) => column);

  GeneratedColumn<double> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<String> get unidad =>
      $composableBuilder(column: $table.unidad, builder: (column) => column);
}

class $$ExistenciasTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExistenciasTable,
    Existencia,
    $$ExistenciasTableFilterComposer,
    $$ExistenciasTableOrderingComposer,
    $$ExistenciasTableAnnotationComposer,
    $$ExistenciasTableCreateCompanionBuilder,
    $$ExistenciasTableUpdateCompanionBuilder,
    (Existencia, BaseReferences<_$AppDatabase, $ExistenciasTable, Existencia>),
    Existencia,
    PrefetchHooks Function()> {
  $$ExistenciasTableTableManager(_$AppDatabase db, $ExistenciasTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExistenciasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExistenciasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExistenciasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> productoId = const Value.absent(),
            Value<String> almacen = const Value.absent(),
            Value<double> cantidad = const Value.absent(),
            Value<String> unidad = const Value.absent(),
          }) =>
              ExistenciasCompanion(
            id: id,
            productoId: productoId,
            almacen: almacen,
            cantidad: cantidad,
            unidad: unidad,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> productoId = const Value.absent(),
            required String almacen,
            Value<double> cantidad = const Value.absent(),
            Value<String> unidad = const Value.absent(),
          }) =>
              ExistenciasCompanion.insert(
            id: id,
            productoId: productoId,
            almacen: almacen,
            cantidad: cantidad,
            unidad: unidad,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ExistenciasTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExistenciasTable,
    Existencia,
    $$ExistenciasTableFilterComposer,
    $$ExistenciasTableOrderingComposer,
    $$ExistenciasTableAnnotationComposer,
    $$ExistenciasTableCreateCompanionBuilder,
    $$ExistenciasTableUpdateCompanionBuilder,
    (Existencia, BaseReferences<_$AppDatabase, $ExistenciasTable, Existencia>),
    Existencia,
    PrefetchHooks Function()>;
typedef $$MovimientosTableCreateCompanionBuilder = MovimientosCompanion
    Function({
  Value<int> id,
  required int productoId,
  Value<int?> facturaId,
  Value<int?> requisicionId,
  Value<int?> ventaId,
  Value<String?> ventaSyncUuid,
  required String tipo,
  required double cantidad,
  Value<double> cantidadAnterior,
  Value<double> cantidadNueva,
  Value<double> pesoTotal,
  Value<String?> registradoPor,
  Value<String?> observaciones,
  Value<String?> almacen,
  Value<DateTime?> fechaMovimiento,
  Value<DateTime?> createdAt,
  Value<int> sincronizado,
});
typedef $$MovimientosTableUpdateCompanionBuilder = MovimientosCompanion
    Function({
  Value<int> id,
  Value<int> productoId,
  Value<int?> facturaId,
  Value<int?> requisicionId,
  Value<int?> ventaId,
  Value<String?> ventaSyncUuid,
  Value<String> tipo,
  Value<double> cantidad,
  Value<double> cantidadAnterior,
  Value<double> cantidadNueva,
  Value<double> pesoTotal,
  Value<String?> registradoPor,
  Value<String?> observaciones,
  Value<String?> almacen,
  Value<DateTime?> fechaMovimiento,
  Value<DateTime?> createdAt,
  Value<int> sincronizado,
});

class $$MovimientosTableFilterComposer
    extends Composer<_$AppDatabase, $MovimientosTable> {
  $$MovimientosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get productoId => $composableBuilder(
      column: $table.productoId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get facturaId => $composableBuilder(
      column: $table.facturaId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get requisicionId => $composableBuilder(
      column: $table.requisicionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ventaId => $composableBuilder(
      column: $table.ventaId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ventaSyncUuid => $composableBuilder(
      column: $table.ventaSyncUuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tipo => $composableBuilder(
      column: $table.tipo, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cantidad => $composableBuilder(
      column: $table.cantidad, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cantidadAnterior => $composableBuilder(
      column: $table.cantidadAnterior,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cantidadNueva => $composableBuilder(
      column: $table.cantidadNueva, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get pesoTotal => $composableBuilder(
      column: $table.pesoTotal, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get registradoPor => $composableBuilder(
      column: $table.registradoPor, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get observaciones => $composableBuilder(
      column: $table.observaciones, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get almacen => $composableBuilder(
      column: $table.almacen, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fechaMovimiento => $composableBuilder(
      column: $table.fechaMovimiento,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sincronizado => $composableBuilder(
      column: $table.sincronizado, builder: (column) => ColumnFilters(column));
}

class $$MovimientosTableOrderingComposer
    extends Composer<_$AppDatabase, $MovimientosTable> {
  $$MovimientosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get productoId => $composableBuilder(
      column: $table.productoId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get facturaId => $composableBuilder(
      column: $table.facturaId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get requisicionId => $composableBuilder(
      column: $table.requisicionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ventaId => $composableBuilder(
      column: $table.ventaId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ventaSyncUuid => $composableBuilder(
      column: $table.ventaSyncUuid,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tipo => $composableBuilder(
      column: $table.tipo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cantidad => $composableBuilder(
      column: $table.cantidad, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cantidadAnterior => $composableBuilder(
      column: $table.cantidadAnterior,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cantidadNueva => $composableBuilder(
      column: $table.cantidadNueva,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get pesoTotal => $composableBuilder(
      column: $table.pesoTotal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get registradoPor => $composableBuilder(
      column: $table.registradoPor,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get observaciones => $composableBuilder(
      column: $table.observaciones,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get almacen => $composableBuilder(
      column: $table.almacen, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fechaMovimiento => $composableBuilder(
      column: $table.fechaMovimiento,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sincronizado => $composableBuilder(
      column: $table.sincronizado,
      builder: (column) => ColumnOrderings(column));
}

class $$MovimientosTableAnnotationComposer
    extends Composer<_$AppDatabase, $MovimientosTable> {
  $$MovimientosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get productoId => $composableBuilder(
      column: $table.productoId, builder: (column) => column);

  GeneratedColumn<int> get facturaId =>
      $composableBuilder(column: $table.facturaId, builder: (column) => column);

  GeneratedColumn<int> get requisicionId => $composableBuilder(
      column: $table.requisicionId, builder: (column) => column);

  GeneratedColumn<int> get ventaId =>
      $composableBuilder(column: $table.ventaId, builder: (column) => column);

  GeneratedColumn<String> get ventaSyncUuid => $composableBuilder(
      column: $table.ventaSyncUuid, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<double> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<double> get cantidadAnterior => $composableBuilder(
      column: $table.cantidadAnterior, builder: (column) => column);

  GeneratedColumn<double> get cantidadNueva => $composableBuilder(
      column: $table.cantidadNueva, builder: (column) => column);

  GeneratedColumn<double> get pesoTotal =>
      $composableBuilder(column: $table.pesoTotal, builder: (column) => column);

  GeneratedColumn<String> get registradoPor => $composableBuilder(
      column: $table.registradoPor, builder: (column) => column);

  GeneratedColumn<String> get observaciones => $composableBuilder(
      column: $table.observaciones, builder: (column) => column);

  GeneratedColumn<String> get almacen =>
      $composableBuilder(column: $table.almacen, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaMovimiento => $composableBuilder(
      column: $table.fechaMovimiento, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get sincronizado => $composableBuilder(
      column: $table.sincronizado, builder: (column) => column);
}

class $$MovimientosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MovimientosTable,
    Movimiento,
    $$MovimientosTableFilterComposer,
    $$MovimientosTableOrderingComposer,
    $$MovimientosTableAnnotationComposer,
    $$MovimientosTableCreateCompanionBuilder,
    $$MovimientosTableUpdateCompanionBuilder,
    (Movimiento, BaseReferences<_$AppDatabase, $MovimientosTable, Movimiento>),
    Movimiento,
    PrefetchHooks Function()> {
  $$MovimientosTableTableManager(_$AppDatabase db, $MovimientosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MovimientosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MovimientosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MovimientosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> productoId = const Value.absent(),
            Value<int?> facturaId = const Value.absent(),
            Value<int?> requisicionId = const Value.absent(),
            Value<int?> ventaId = const Value.absent(),
            Value<String?> ventaSyncUuid = const Value.absent(),
            Value<String> tipo = const Value.absent(),
            Value<double> cantidad = const Value.absent(),
            Value<double> cantidadAnterior = const Value.absent(),
            Value<double> cantidadNueva = const Value.absent(),
            Value<double> pesoTotal = const Value.absent(),
            Value<String?> registradoPor = const Value.absent(),
            Value<String?> observaciones = const Value.absent(),
            Value<String?> almacen = const Value.absent(),
            Value<DateTime?> fechaMovimiento = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<int> sincronizado = const Value.absent(),
          }) =>
              MovimientosCompanion(
            id: id,
            productoId: productoId,
            facturaId: facturaId,
            requisicionId: requisicionId,
            ventaId: ventaId,
            ventaSyncUuid: ventaSyncUuid,
            tipo: tipo,
            cantidad: cantidad,
            cantidadAnterior: cantidadAnterior,
            cantidadNueva: cantidadNueva,
            pesoTotal: pesoTotal,
            registradoPor: registradoPor,
            observaciones: observaciones,
            almacen: almacen,
            fechaMovimiento: fechaMovimiento,
            createdAt: createdAt,
            sincronizado: sincronizado,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int productoId,
            Value<int?> facturaId = const Value.absent(),
            Value<int?> requisicionId = const Value.absent(),
            Value<int?> ventaId = const Value.absent(),
            Value<String?> ventaSyncUuid = const Value.absent(),
            required String tipo,
            required double cantidad,
            Value<double> cantidadAnterior = const Value.absent(),
            Value<double> cantidadNueva = const Value.absent(),
            Value<double> pesoTotal = const Value.absent(),
            Value<String?> registradoPor = const Value.absent(),
            Value<String?> observaciones = const Value.absent(),
            Value<String?> almacen = const Value.absent(),
            Value<DateTime?> fechaMovimiento = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<int> sincronizado = const Value.absent(),
          }) =>
              MovimientosCompanion.insert(
            id: id,
            productoId: productoId,
            facturaId: facturaId,
            requisicionId: requisicionId,
            ventaId: ventaId,
            ventaSyncUuid: ventaSyncUuid,
            tipo: tipo,
            cantidad: cantidad,
            cantidadAnterior: cantidadAnterior,
            cantidadNueva: cantidadNueva,
            pesoTotal: pesoTotal,
            registradoPor: registradoPor,
            observaciones: observaciones,
            almacen: almacen,
            fechaMovimiento: fechaMovimiento,
            createdAt: createdAt,
            sincronizado: sincronizado,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MovimientosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MovimientosTable,
    Movimiento,
    $$MovimientosTableFilterComposer,
    $$MovimientosTableOrderingComposer,
    $$MovimientosTableAnnotationComposer,
    $$MovimientosTableCreateCompanionBuilder,
    $$MovimientosTableUpdateCompanionBuilder,
    (Movimiento, BaseReferences<_$AppDatabase, $MovimientosTable, Movimiento>),
    Movimiento,
    PrefetchHooks Function()>;
typedef $$MovimientosArchivoTableCreateCompanionBuilder
    = MovimientosArchivoCompanion Function({
  Value<int> id,
  required int productoId,
  Value<int?> facturaId,
  Value<int?> requisicionId,
  required String tipo,
  required double cantidad,
  Value<double> cantidadAnterior,
  Value<double> cantidadNueva,
  Value<double> pesoTotal,
  Value<String?> registradoPor,
  Value<String?> observaciones,
  Value<String?> almacen,
  Value<DateTime?> fechaMovimiento,
  Value<DateTime?> createdAt,
});
typedef $$MovimientosArchivoTableUpdateCompanionBuilder
    = MovimientosArchivoCompanion Function({
  Value<int> id,
  Value<int> productoId,
  Value<int?> facturaId,
  Value<int?> requisicionId,
  Value<String> tipo,
  Value<double> cantidad,
  Value<double> cantidadAnterior,
  Value<double> cantidadNueva,
  Value<double> pesoTotal,
  Value<String?> registradoPor,
  Value<String?> observaciones,
  Value<String?> almacen,
  Value<DateTime?> fechaMovimiento,
  Value<DateTime?> createdAt,
});

class $$MovimientosArchivoTableFilterComposer
    extends Composer<_$AppDatabase, $MovimientosArchivoTable> {
  $$MovimientosArchivoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get productoId => $composableBuilder(
      column: $table.productoId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get facturaId => $composableBuilder(
      column: $table.facturaId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get requisicionId => $composableBuilder(
      column: $table.requisicionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tipo => $composableBuilder(
      column: $table.tipo, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cantidad => $composableBuilder(
      column: $table.cantidad, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cantidadAnterior => $composableBuilder(
      column: $table.cantidadAnterior,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cantidadNueva => $composableBuilder(
      column: $table.cantidadNueva, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get pesoTotal => $composableBuilder(
      column: $table.pesoTotal, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get registradoPor => $composableBuilder(
      column: $table.registradoPor, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get observaciones => $composableBuilder(
      column: $table.observaciones, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get almacen => $composableBuilder(
      column: $table.almacen, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fechaMovimiento => $composableBuilder(
      column: $table.fechaMovimiento,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$MovimientosArchivoTableOrderingComposer
    extends Composer<_$AppDatabase, $MovimientosArchivoTable> {
  $$MovimientosArchivoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get productoId => $composableBuilder(
      column: $table.productoId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get facturaId => $composableBuilder(
      column: $table.facturaId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get requisicionId => $composableBuilder(
      column: $table.requisicionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tipo => $composableBuilder(
      column: $table.tipo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cantidad => $composableBuilder(
      column: $table.cantidad, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cantidadAnterior => $composableBuilder(
      column: $table.cantidadAnterior,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cantidadNueva => $composableBuilder(
      column: $table.cantidadNueva,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get pesoTotal => $composableBuilder(
      column: $table.pesoTotal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get registradoPor => $composableBuilder(
      column: $table.registradoPor,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get observaciones => $composableBuilder(
      column: $table.observaciones,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get almacen => $composableBuilder(
      column: $table.almacen, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fechaMovimiento => $composableBuilder(
      column: $table.fechaMovimiento,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$MovimientosArchivoTableAnnotationComposer
    extends Composer<_$AppDatabase, $MovimientosArchivoTable> {
  $$MovimientosArchivoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get productoId => $composableBuilder(
      column: $table.productoId, builder: (column) => column);

  GeneratedColumn<int> get facturaId =>
      $composableBuilder(column: $table.facturaId, builder: (column) => column);

  GeneratedColumn<int> get requisicionId => $composableBuilder(
      column: $table.requisicionId, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<double> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<double> get cantidadAnterior => $composableBuilder(
      column: $table.cantidadAnterior, builder: (column) => column);

  GeneratedColumn<double> get cantidadNueva => $composableBuilder(
      column: $table.cantidadNueva, builder: (column) => column);

  GeneratedColumn<double> get pesoTotal =>
      $composableBuilder(column: $table.pesoTotal, builder: (column) => column);

  GeneratedColumn<String> get registradoPor => $composableBuilder(
      column: $table.registradoPor, builder: (column) => column);

  GeneratedColumn<String> get observaciones => $composableBuilder(
      column: $table.observaciones, builder: (column) => column);

  GeneratedColumn<String> get almacen =>
      $composableBuilder(column: $table.almacen, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaMovimiento => $composableBuilder(
      column: $table.fechaMovimiento, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$MovimientosArchivoTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MovimientosArchivoTable,
    MovimientosArchivoData,
    $$MovimientosArchivoTableFilterComposer,
    $$MovimientosArchivoTableOrderingComposer,
    $$MovimientosArchivoTableAnnotationComposer,
    $$MovimientosArchivoTableCreateCompanionBuilder,
    $$MovimientosArchivoTableUpdateCompanionBuilder,
    (
      MovimientosArchivoData,
      BaseReferences<_$AppDatabase, $MovimientosArchivoTable,
          MovimientosArchivoData>
    ),
    MovimientosArchivoData,
    PrefetchHooks Function()> {
  $$MovimientosArchivoTableTableManager(
      _$AppDatabase db, $MovimientosArchivoTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MovimientosArchivoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MovimientosArchivoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MovimientosArchivoTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> productoId = const Value.absent(),
            Value<int?> facturaId = const Value.absent(),
            Value<int?> requisicionId = const Value.absent(),
            Value<String> tipo = const Value.absent(),
            Value<double> cantidad = const Value.absent(),
            Value<double> cantidadAnterior = const Value.absent(),
            Value<double> cantidadNueva = const Value.absent(),
            Value<double> pesoTotal = const Value.absent(),
            Value<String?> registradoPor = const Value.absent(),
            Value<String?> observaciones = const Value.absent(),
            Value<String?> almacen = const Value.absent(),
            Value<DateTime?> fechaMovimiento = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              MovimientosArchivoCompanion(
            id: id,
            productoId: productoId,
            facturaId: facturaId,
            requisicionId: requisicionId,
            tipo: tipo,
            cantidad: cantidad,
            cantidadAnterior: cantidadAnterior,
            cantidadNueva: cantidadNueva,
            pesoTotal: pesoTotal,
            registradoPor: registradoPor,
            observaciones: observaciones,
            almacen: almacen,
            fechaMovimiento: fechaMovimiento,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int productoId,
            Value<int?> facturaId = const Value.absent(),
            Value<int?> requisicionId = const Value.absent(),
            required String tipo,
            required double cantidad,
            Value<double> cantidadAnterior = const Value.absent(),
            Value<double> cantidadNueva = const Value.absent(),
            Value<double> pesoTotal = const Value.absent(),
            Value<String?> registradoPor = const Value.absent(),
            Value<String?> observaciones = const Value.absent(),
            Value<String?> almacen = const Value.absent(),
            Value<DateTime?> fechaMovimiento = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              MovimientosArchivoCompanion.insert(
            id: id,
            productoId: productoId,
            facturaId: facturaId,
            requisicionId: requisicionId,
            tipo: tipo,
            cantidad: cantidad,
            cantidadAnterior: cantidadAnterior,
            cantidadNueva: cantidadNueva,
            pesoTotal: pesoTotal,
            registradoPor: registradoPor,
            observaciones: observaciones,
            almacen: almacen,
            fechaMovimiento: fechaMovimiento,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MovimientosArchivoTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MovimientosArchivoTable,
    MovimientosArchivoData,
    $$MovimientosArchivoTableFilterComposer,
    $$MovimientosArchivoTableOrderingComposer,
    $$MovimientosArchivoTableAnnotationComposer,
    $$MovimientosArchivoTableCreateCompanionBuilder,
    $$MovimientosArchivoTableUpdateCompanionBuilder,
    (
      MovimientosArchivoData,
      BaseReferences<_$AppDatabase, $MovimientosArchivoTable,
          MovimientosArchivoData>
    ),
    MovimientosArchivoData,
    PrefetchHooks Function()>;
typedef $$FacturasTableCreateCompanionBuilder = FacturasCompanion Function({
  Value<int> id,
  Value<String?> numeroFactura,
  Value<String> tipoDocumento,
  Value<String?> proveedor,
  Value<DateTime?> fechaFactura,
  Value<DateTime?> fechaRecepcion,
  Value<double> totalBruto,
  Value<double> totalImpuestos,
  Value<double> totalNeto,
  Value<String> estado,
  Value<String?> observaciones,
  Value<String?> validadaPor,
  Value<DateTime?> fechaValidacion,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
});
typedef $$FacturasTableUpdateCompanionBuilder = FacturasCompanion Function({
  Value<int> id,
  Value<String?> numeroFactura,
  Value<String> tipoDocumento,
  Value<String?> proveedor,
  Value<DateTime?> fechaFactura,
  Value<DateTime?> fechaRecepcion,
  Value<double> totalBruto,
  Value<double> totalImpuestos,
  Value<double> totalNeto,
  Value<String> estado,
  Value<String?> observaciones,
  Value<String?> validadaPor,
  Value<DateTime?> fechaValidacion,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
});

class $$FacturasTableFilterComposer
    extends Composer<_$AppDatabase, $FacturasTable> {
  $$FacturasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get numeroFactura => $composableBuilder(
      column: $table.numeroFactura, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tipoDocumento => $composableBuilder(
      column: $table.tipoDocumento, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get proveedor => $composableBuilder(
      column: $table.proveedor, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fechaFactura => $composableBuilder(
      column: $table.fechaFactura, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fechaRecepcion => $composableBuilder(
      column: $table.fechaRecepcion,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalBruto => $composableBuilder(
      column: $table.totalBruto, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalImpuestos => $composableBuilder(
      column: $table.totalImpuestos,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalNeto => $composableBuilder(
      column: $table.totalNeto, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get estado => $composableBuilder(
      column: $table.estado, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get observaciones => $composableBuilder(
      column: $table.observaciones, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get validadaPor => $composableBuilder(
      column: $table.validadaPor, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fechaValidacion => $composableBuilder(
      column: $table.fechaValidacion,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$FacturasTableOrderingComposer
    extends Composer<_$AppDatabase, $FacturasTable> {
  $$FacturasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get numeroFactura => $composableBuilder(
      column: $table.numeroFactura,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tipoDocumento => $composableBuilder(
      column: $table.tipoDocumento,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get proveedor => $composableBuilder(
      column: $table.proveedor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fechaFactura => $composableBuilder(
      column: $table.fechaFactura,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fechaRecepcion => $composableBuilder(
      column: $table.fechaRecepcion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalBruto => $composableBuilder(
      column: $table.totalBruto, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalImpuestos => $composableBuilder(
      column: $table.totalImpuestos,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalNeto => $composableBuilder(
      column: $table.totalNeto, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get estado => $composableBuilder(
      column: $table.estado, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get observaciones => $composableBuilder(
      column: $table.observaciones,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get validadaPor => $composableBuilder(
      column: $table.validadaPor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fechaValidacion => $composableBuilder(
      column: $table.fechaValidacion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$FacturasTableAnnotationComposer
    extends Composer<_$AppDatabase, $FacturasTable> {
  $$FacturasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get numeroFactura => $composableBuilder(
      column: $table.numeroFactura, builder: (column) => column);

  GeneratedColumn<String> get tipoDocumento => $composableBuilder(
      column: $table.tipoDocumento, builder: (column) => column);

  GeneratedColumn<String> get proveedor =>
      $composableBuilder(column: $table.proveedor, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaFactura => $composableBuilder(
      column: $table.fechaFactura, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaRecepcion => $composableBuilder(
      column: $table.fechaRecepcion, builder: (column) => column);

  GeneratedColumn<double> get totalBruto => $composableBuilder(
      column: $table.totalBruto, builder: (column) => column);

  GeneratedColumn<double> get totalImpuestos => $composableBuilder(
      column: $table.totalImpuestos, builder: (column) => column);

  GeneratedColumn<double> get totalNeto =>
      $composableBuilder(column: $table.totalNeto, builder: (column) => column);

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<String> get observaciones => $composableBuilder(
      column: $table.observaciones, builder: (column) => column);

  GeneratedColumn<String> get validadaPor => $composableBuilder(
      column: $table.validadaPor, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaValidacion => $composableBuilder(
      column: $table.fechaValidacion, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$FacturasTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FacturasTable,
    Factura,
    $$FacturasTableFilterComposer,
    $$FacturasTableOrderingComposer,
    $$FacturasTableAnnotationComposer,
    $$FacturasTableCreateCompanionBuilder,
    $$FacturasTableUpdateCompanionBuilder,
    (Factura, BaseReferences<_$AppDatabase, $FacturasTable, Factura>),
    Factura,
    PrefetchHooks Function()> {
  $$FacturasTableTableManager(_$AppDatabase db, $FacturasTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FacturasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FacturasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FacturasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> numeroFactura = const Value.absent(),
            Value<String> tipoDocumento = const Value.absent(),
            Value<String?> proveedor = const Value.absent(),
            Value<DateTime?> fechaFactura = const Value.absent(),
            Value<DateTime?> fechaRecepcion = const Value.absent(),
            Value<double> totalBruto = const Value.absent(),
            Value<double> totalImpuestos = const Value.absent(),
            Value<double> totalNeto = const Value.absent(),
            Value<String> estado = const Value.absent(),
            Value<String?> observaciones = const Value.absent(),
            Value<String?> validadaPor = const Value.absent(),
            Value<DateTime?> fechaValidacion = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              FacturasCompanion(
            id: id,
            numeroFactura: numeroFactura,
            tipoDocumento: tipoDocumento,
            proveedor: proveedor,
            fechaFactura: fechaFactura,
            fechaRecepcion: fechaRecepcion,
            totalBruto: totalBruto,
            totalImpuestos: totalImpuestos,
            totalNeto: totalNeto,
            estado: estado,
            observaciones: observaciones,
            validadaPor: validadaPor,
            fechaValidacion: fechaValidacion,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> numeroFactura = const Value.absent(),
            Value<String> tipoDocumento = const Value.absent(),
            Value<String?> proveedor = const Value.absent(),
            Value<DateTime?> fechaFactura = const Value.absent(),
            Value<DateTime?> fechaRecepcion = const Value.absent(),
            Value<double> totalBruto = const Value.absent(),
            Value<double> totalImpuestos = const Value.absent(),
            Value<double> totalNeto = const Value.absent(),
            Value<String> estado = const Value.absent(),
            Value<String?> observaciones = const Value.absent(),
            Value<String?> validadaPor = const Value.absent(),
            Value<DateTime?> fechaValidacion = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              FacturasCompanion.insert(
            id: id,
            numeroFactura: numeroFactura,
            tipoDocumento: tipoDocumento,
            proveedor: proveedor,
            fechaFactura: fechaFactura,
            fechaRecepcion: fechaRecepcion,
            totalBruto: totalBruto,
            totalImpuestos: totalImpuestos,
            totalNeto: totalNeto,
            estado: estado,
            observaciones: observaciones,
            validadaPor: validadaPor,
            fechaValidacion: fechaValidacion,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FacturasTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FacturasTable,
    Factura,
    $$FacturasTableFilterComposer,
    $$FacturasTableOrderingComposer,
    $$FacturasTableAnnotationComposer,
    $$FacturasTableCreateCompanionBuilder,
    $$FacturasTableUpdateCompanionBuilder,
    (Factura, BaseReferences<_$AppDatabase, $FacturasTable, Factura>),
    Factura,
    PrefetchHooks Function()>;
typedef $$FacturaPagosTableCreateCompanionBuilder = FacturaPagosCompanion
    Function({
  Value<int> id,
  required int facturaId,
  required String tipoPago,
  required double monto,
  Value<String?> referencia,
  Value<double?> tasaCambio,
  Value<DateTime?> fechaPago,
});
typedef $$FacturaPagosTableUpdateCompanionBuilder = FacturaPagosCompanion
    Function({
  Value<int> id,
  Value<int> facturaId,
  Value<String> tipoPago,
  Value<double> monto,
  Value<String?> referencia,
  Value<double?> tasaCambio,
  Value<DateTime?> fechaPago,
});

class $$FacturaPagosTableFilterComposer
    extends Composer<_$AppDatabase, $FacturaPagosTable> {
  $$FacturaPagosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get facturaId => $composableBuilder(
      column: $table.facturaId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tipoPago => $composableBuilder(
      column: $table.tipoPago, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get monto => $composableBuilder(
      column: $table.monto, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get referencia => $composableBuilder(
      column: $table.referencia, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get tasaCambio => $composableBuilder(
      column: $table.tasaCambio, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fechaPago => $composableBuilder(
      column: $table.fechaPago, builder: (column) => ColumnFilters(column));
}

class $$FacturaPagosTableOrderingComposer
    extends Composer<_$AppDatabase, $FacturaPagosTable> {
  $$FacturaPagosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get facturaId => $composableBuilder(
      column: $table.facturaId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tipoPago => $composableBuilder(
      column: $table.tipoPago, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get monto => $composableBuilder(
      column: $table.monto, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get referencia => $composableBuilder(
      column: $table.referencia, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get tasaCambio => $composableBuilder(
      column: $table.tasaCambio, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fechaPago => $composableBuilder(
      column: $table.fechaPago, builder: (column) => ColumnOrderings(column));
}

class $$FacturaPagosTableAnnotationComposer
    extends Composer<_$AppDatabase, $FacturaPagosTable> {
  $$FacturaPagosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get facturaId =>
      $composableBuilder(column: $table.facturaId, builder: (column) => column);

  GeneratedColumn<String> get tipoPago =>
      $composableBuilder(column: $table.tipoPago, builder: (column) => column);

  GeneratedColumn<double> get monto =>
      $composableBuilder(column: $table.monto, builder: (column) => column);

  GeneratedColumn<String> get referencia => $composableBuilder(
      column: $table.referencia, builder: (column) => column);

  GeneratedColumn<double> get tasaCambio => $composableBuilder(
      column: $table.tasaCambio, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaPago =>
      $composableBuilder(column: $table.fechaPago, builder: (column) => column);
}

class $$FacturaPagosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FacturaPagosTable,
    FacturaPago,
    $$FacturaPagosTableFilterComposer,
    $$FacturaPagosTableOrderingComposer,
    $$FacturaPagosTableAnnotationComposer,
    $$FacturaPagosTableCreateCompanionBuilder,
    $$FacturaPagosTableUpdateCompanionBuilder,
    (
      FacturaPago,
      BaseReferences<_$AppDatabase, $FacturaPagosTable, FacturaPago>
    ),
    FacturaPago,
    PrefetchHooks Function()> {
  $$FacturaPagosTableTableManager(_$AppDatabase db, $FacturaPagosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FacturaPagosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FacturaPagosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FacturaPagosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> facturaId = const Value.absent(),
            Value<String> tipoPago = const Value.absent(),
            Value<double> monto = const Value.absent(),
            Value<String?> referencia = const Value.absent(),
            Value<double?> tasaCambio = const Value.absent(),
            Value<DateTime?> fechaPago = const Value.absent(),
          }) =>
              FacturaPagosCompanion(
            id: id,
            facturaId: facturaId,
            tipoPago: tipoPago,
            monto: monto,
            referencia: referencia,
            tasaCambio: tasaCambio,
            fechaPago: fechaPago,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int facturaId,
            required String tipoPago,
            required double monto,
            Value<String?> referencia = const Value.absent(),
            Value<double?> tasaCambio = const Value.absent(),
            Value<DateTime?> fechaPago = const Value.absent(),
          }) =>
              FacturaPagosCompanion.insert(
            id: id,
            facturaId: facturaId,
            tipoPago: tipoPago,
            monto: monto,
            referencia: referencia,
            tasaCambio: tasaCambio,
            fechaPago: fechaPago,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FacturaPagosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FacturaPagosTable,
    FacturaPago,
    $$FacturaPagosTableFilterComposer,
    $$FacturaPagosTableOrderingComposer,
    $$FacturaPagosTableAnnotationComposer,
    $$FacturaPagosTableCreateCompanionBuilder,
    $$FacturaPagosTableUpdateCompanionBuilder,
    (
      FacturaPago,
      BaseReferences<_$AppDatabase, $FacturaPagosTable, FacturaPago>
    ),
    FacturaPago,
    PrefetchHooks Function()>;
typedef $$RequisicionesTableCreateCompanionBuilder = RequisicionesCompanion
    Function({
  Value<int> id,
  required String numero,
  required int numeroSecuencial,
  required String origen,
  required String destino,
  Value<String> estado,
  Value<String?> observaciones,
  Value<String?> creadaPor,
  Value<String?> procesadaPor,
  Value<DateTime?> fechaProcesamiento,
  Value<DateTime?> fechaCreacion,
  Value<DateTime?> actualizada,
});
typedef $$RequisicionesTableUpdateCompanionBuilder = RequisicionesCompanion
    Function({
  Value<int> id,
  Value<String> numero,
  Value<int> numeroSecuencial,
  Value<String> origen,
  Value<String> destino,
  Value<String> estado,
  Value<String?> observaciones,
  Value<String?> creadaPor,
  Value<String?> procesadaPor,
  Value<DateTime?> fechaProcesamiento,
  Value<DateTime?> fechaCreacion,
  Value<DateTime?> actualizada,
});

class $$RequisicionesTableFilterComposer
    extends Composer<_$AppDatabase, $RequisicionesTable> {
  $$RequisicionesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get numero => $composableBuilder(
      column: $table.numero, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get numeroSecuencial => $composableBuilder(
      column: $table.numeroSecuencial,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get origen => $composableBuilder(
      column: $table.origen, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get destino => $composableBuilder(
      column: $table.destino, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get estado => $composableBuilder(
      column: $table.estado, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get observaciones => $composableBuilder(
      column: $table.observaciones, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get creadaPor => $composableBuilder(
      column: $table.creadaPor, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get procesadaPor => $composableBuilder(
      column: $table.procesadaPor, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fechaProcesamiento => $composableBuilder(
      column: $table.fechaProcesamiento,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fechaCreacion => $composableBuilder(
      column: $table.fechaCreacion, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get actualizada => $composableBuilder(
      column: $table.actualizada, builder: (column) => ColumnFilters(column));
}

class $$RequisicionesTableOrderingComposer
    extends Composer<_$AppDatabase, $RequisicionesTable> {
  $$RequisicionesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get numero => $composableBuilder(
      column: $table.numero, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get numeroSecuencial => $composableBuilder(
      column: $table.numeroSecuencial,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get origen => $composableBuilder(
      column: $table.origen, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get destino => $composableBuilder(
      column: $table.destino, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get estado => $composableBuilder(
      column: $table.estado, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get observaciones => $composableBuilder(
      column: $table.observaciones,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get creadaPor => $composableBuilder(
      column: $table.creadaPor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get procesadaPor => $composableBuilder(
      column: $table.procesadaPor,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fechaProcesamiento => $composableBuilder(
      column: $table.fechaProcesamiento,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fechaCreacion => $composableBuilder(
      column: $table.fechaCreacion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get actualizada => $composableBuilder(
      column: $table.actualizada, builder: (column) => ColumnOrderings(column));
}

class $$RequisicionesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RequisicionesTable> {
  $$RequisicionesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get numero =>
      $composableBuilder(column: $table.numero, builder: (column) => column);

  GeneratedColumn<int> get numeroSecuencial => $composableBuilder(
      column: $table.numeroSecuencial, builder: (column) => column);

  GeneratedColumn<String> get origen =>
      $composableBuilder(column: $table.origen, builder: (column) => column);

  GeneratedColumn<String> get destino =>
      $composableBuilder(column: $table.destino, builder: (column) => column);

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<String> get observaciones => $composableBuilder(
      column: $table.observaciones, builder: (column) => column);

  GeneratedColumn<String> get creadaPor =>
      $composableBuilder(column: $table.creadaPor, builder: (column) => column);

  GeneratedColumn<String> get procesadaPor => $composableBuilder(
      column: $table.procesadaPor, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaProcesamiento => $composableBuilder(
      column: $table.fechaProcesamiento, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaCreacion => $composableBuilder(
      column: $table.fechaCreacion, builder: (column) => column);

  GeneratedColumn<DateTime> get actualizada => $composableBuilder(
      column: $table.actualizada, builder: (column) => column);
}

class $$RequisicionesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RequisicionesTable,
    Requisicione,
    $$RequisicionesTableFilterComposer,
    $$RequisicionesTableOrderingComposer,
    $$RequisicionesTableAnnotationComposer,
    $$RequisicionesTableCreateCompanionBuilder,
    $$RequisicionesTableUpdateCompanionBuilder,
    (
      Requisicione,
      BaseReferences<_$AppDatabase, $RequisicionesTable, Requisicione>
    ),
    Requisicione,
    PrefetchHooks Function()> {
  $$RequisicionesTableTableManager(_$AppDatabase db, $RequisicionesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RequisicionesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RequisicionesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RequisicionesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> numero = const Value.absent(),
            Value<int> numeroSecuencial = const Value.absent(),
            Value<String> origen = const Value.absent(),
            Value<String> destino = const Value.absent(),
            Value<String> estado = const Value.absent(),
            Value<String?> observaciones = const Value.absent(),
            Value<String?> creadaPor = const Value.absent(),
            Value<String?> procesadaPor = const Value.absent(),
            Value<DateTime?> fechaProcesamiento = const Value.absent(),
            Value<DateTime?> fechaCreacion = const Value.absent(),
            Value<DateTime?> actualizada = const Value.absent(),
          }) =>
              RequisicionesCompanion(
            id: id,
            numero: numero,
            numeroSecuencial: numeroSecuencial,
            origen: origen,
            destino: destino,
            estado: estado,
            observaciones: observaciones,
            creadaPor: creadaPor,
            procesadaPor: procesadaPor,
            fechaProcesamiento: fechaProcesamiento,
            fechaCreacion: fechaCreacion,
            actualizada: actualizada,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String numero,
            required int numeroSecuencial,
            required String origen,
            required String destino,
            Value<String> estado = const Value.absent(),
            Value<String?> observaciones = const Value.absent(),
            Value<String?> creadaPor = const Value.absent(),
            Value<String?> procesadaPor = const Value.absent(),
            Value<DateTime?> fechaProcesamiento = const Value.absent(),
            Value<DateTime?> fechaCreacion = const Value.absent(),
            Value<DateTime?> actualizada = const Value.absent(),
          }) =>
              RequisicionesCompanion.insert(
            id: id,
            numero: numero,
            numeroSecuencial: numeroSecuencial,
            origen: origen,
            destino: destino,
            estado: estado,
            observaciones: observaciones,
            creadaPor: creadaPor,
            procesadaPor: procesadaPor,
            fechaProcesamiento: fechaProcesamiento,
            fechaCreacion: fechaCreacion,
            actualizada: actualizada,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RequisicionesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RequisicionesTable,
    Requisicione,
    $$RequisicionesTableFilterComposer,
    $$RequisicionesTableOrderingComposer,
    $$RequisicionesTableAnnotationComposer,
    $$RequisicionesTableCreateCompanionBuilder,
    $$RequisicionesTableUpdateCompanionBuilder,
    (
      Requisicione,
      BaseReferences<_$AppDatabase, $RequisicionesTable, Requisicione>
    ),
    Requisicione,
    PrefetchHooks Function()>;
typedef $$RequisicionDetallesTableCreateCompanionBuilder
    = RequisicionDetallesCompanion Function({
  Value<int> id,
  required int requisicionId,
  Value<int?> productoId,
  required String ingrediente,
  required double cantidad,
  Value<String> unidad,
  Value<double> cantidadSurtida,
  Value<int> verificado,
});
typedef $$RequisicionDetallesTableUpdateCompanionBuilder
    = RequisicionDetallesCompanion Function({
  Value<int> id,
  Value<int> requisicionId,
  Value<int?> productoId,
  Value<String> ingrediente,
  Value<double> cantidad,
  Value<String> unidad,
  Value<double> cantidadSurtida,
  Value<int> verificado,
});

class $$RequisicionDetallesTableFilterComposer
    extends Composer<_$AppDatabase, $RequisicionDetallesTable> {
  $$RequisicionDetallesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get requisicionId => $composableBuilder(
      column: $table.requisicionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get productoId => $composableBuilder(
      column: $table.productoId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ingrediente => $composableBuilder(
      column: $table.ingrediente, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cantidad => $composableBuilder(
      column: $table.cantidad, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unidad => $composableBuilder(
      column: $table.unidad, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cantidadSurtida => $composableBuilder(
      column: $table.cantidadSurtida,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get verificado => $composableBuilder(
      column: $table.verificado, builder: (column) => ColumnFilters(column));
}

class $$RequisicionDetallesTableOrderingComposer
    extends Composer<_$AppDatabase, $RequisicionDetallesTable> {
  $$RequisicionDetallesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get requisicionId => $composableBuilder(
      column: $table.requisicionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get productoId => $composableBuilder(
      column: $table.productoId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ingrediente => $composableBuilder(
      column: $table.ingrediente, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cantidad => $composableBuilder(
      column: $table.cantidad, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unidad => $composableBuilder(
      column: $table.unidad, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cantidadSurtida => $composableBuilder(
      column: $table.cantidadSurtida,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get verificado => $composableBuilder(
      column: $table.verificado, builder: (column) => ColumnOrderings(column));
}

class $$RequisicionDetallesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RequisicionDetallesTable> {
  $$RequisicionDetallesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get requisicionId => $composableBuilder(
      column: $table.requisicionId, builder: (column) => column);

  GeneratedColumn<int> get productoId => $composableBuilder(
      column: $table.productoId, builder: (column) => column);

  GeneratedColumn<String> get ingrediente => $composableBuilder(
      column: $table.ingrediente, builder: (column) => column);

  GeneratedColumn<double> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<String> get unidad =>
      $composableBuilder(column: $table.unidad, builder: (column) => column);

  GeneratedColumn<double> get cantidadSurtida => $composableBuilder(
      column: $table.cantidadSurtida, builder: (column) => column);

  GeneratedColumn<int> get verificado => $composableBuilder(
      column: $table.verificado, builder: (column) => column);
}

class $$RequisicionDetallesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RequisicionDetallesTable,
    RequisicionDetalle,
    $$RequisicionDetallesTableFilterComposer,
    $$RequisicionDetallesTableOrderingComposer,
    $$RequisicionDetallesTableAnnotationComposer,
    $$RequisicionDetallesTableCreateCompanionBuilder,
    $$RequisicionDetallesTableUpdateCompanionBuilder,
    (
      RequisicionDetalle,
      BaseReferences<_$AppDatabase, $RequisicionDetallesTable,
          RequisicionDetalle>
    ),
    RequisicionDetalle,
    PrefetchHooks Function()> {
  $$RequisicionDetallesTableTableManager(
      _$AppDatabase db, $RequisicionDetallesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RequisicionDetallesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RequisicionDetallesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RequisicionDetallesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> requisicionId = const Value.absent(),
            Value<int?> productoId = const Value.absent(),
            Value<String> ingrediente = const Value.absent(),
            Value<double> cantidad = const Value.absent(),
            Value<String> unidad = const Value.absent(),
            Value<double> cantidadSurtida = const Value.absent(),
            Value<int> verificado = const Value.absent(),
          }) =>
              RequisicionDetallesCompanion(
            id: id,
            requisicionId: requisicionId,
            productoId: productoId,
            ingrediente: ingrediente,
            cantidad: cantidad,
            unidad: unidad,
            cantidadSurtida: cantidadSurtida,
            verificado: verificado,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int requisicionId,
            Value<int?> productoId = const Value.absent(),
            required String ingrediente,
            required double cantidad,
            Value<String> unidad = const Value.absent(),
            Value<double> cantidadSurtida = const Value.absent(),
            Value<int> verificado = const Value.absent(),
          }) =>
              RequisicionDetallesCompanion.insert(
            id: id,
            requisicionId: requisicionId,
            productoId: productoId,
            ingrediente: ingrediente,
            cantidad: cantidad,
            unidad: unidad,
            cantidadSurtida: cantidadSurtida,
            verificado: verificado,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RequisicionDetallesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RequisicionDetallesTable,
    RequisicionDetalle,
    $$RequisicionDetallesTableFilterComposer,
    $$RequisicionDetallesTableOrderingComposer,
    $$RequisicionDetallesTableAnnotationComposer,
    $$RequisicionDetallesTableCreateCompanionBuilder,
    $$RequisicionDetallesTableUpdateCompanionBuilder,
    (
      RequisicionDetalle,
      BaseReferences<_$AppDatabase, $RequisicionDetallesTable,
          RequisicionDetalle>
    ),
    RequisicionDetalle,
    PrefetchHooks Function()>;
typedef $$StockCheckpointTableCreateCompanionBuilder = StockCheckpointCompanion
    Function({
  required int productoId,
  required String almacen,
  Value<double> cantidad,
  Value<int> rowid,
});
typedef $$StockCheckpointTableUpdateCompanionBuilder = StockCheckpointCompanion
    Function({
  Value<int> productoId,
  Value<String> almacen,
  Value<double> cantidad,
  Value<int> rowid,
});

class $$StockCheckpointTableFilterComposer
    extends Composer<_$AppDatabase, $StockCheckpointTable> {
  $$StockCheckpointTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get productoId => $composableBuilder(
      column: $table.productoId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get almacen => $composableBuilder(
      column: $table.almacen, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cantidad => $composableBuilder(
      column: $table.cantidad, builder: (column) => ColumnFilters(column));
}

class $$StockCheckpointTableOrderingComposer
    extends Composer<_$AppDatabase, $StockCheckpointTable> {
  $$StockCheckpointTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get productoId => $composableBuilder(
      column: $table.productoId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get almacen => $composableBuilder(
      column: $table.almacen, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cantidad => $composableBuilder(
      column: $table.cantidad, builder: (column) => ColumnOrderings(column));
}

class $$StockCheckpointTableAnnotationComposer
    extends Composer<_$AppDatabase, $StockCheckpointTable> {
  $$StockCheckpointTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get productoId => $composableBuilder(
      column: $table.productoId, builder: (column) => column);

  GeneratedColumn<String> get almacen =>
      $composableBuilder(column: $table.almacen, builder: (column) => column);

  GeneratedColumn<double> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);
}

class $$StockCheckpointTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StockCheckpointTable,
    StockCheckpointData,
    $$StockCheckpointTableFilterComposer,
    $$StockCheckpointTableOrderingComposer,
    $$StockCheckpointTableAnnotationComposer,
    $$StockCheckpointTableCreateCompanionBuilder,
    $$StockCheckpointTableUpdateCompanionBuilder,
    (
      StockCheckpointData,
      BaseReferences<_$AppDatabase, $StockCheckpointTable, StockCheckpointData>
    ),
    StockCheckpointData,
    PrefetchHooks Function()> {
  $$StockCheckpointTableTableManager(
      _$AppDatabase db, $StockCheckpointTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StockCheckpointTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StockCheckpointTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StockCheckpointTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> productoId = const Value.absent(),
            Value<String> almacen = const Value.absent(),
            Value<double> cantidad = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StockCheckpointCompanion(
            productoId: productoId,
            almacen: almacen,
            cantidad: cantidad,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int productoId,
            required String almacen,
            Value<double> cantidad = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StockCheckpointCompanion.insert(
            productoId: productoId,
            almacen: almacen,
            cantidad: cantidad,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$StockCheckpointTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StockCheckpointTable,
    StockCheckpointData,
    $$StockCheckpointTableFilterComposer,
    $$StockCheckpointTableOrderingComposer,
    $$StockCheckpointTableAnnotationComposer,
    $$StockCheckpointTableCreateCompanionBuilder,
    $$StockCheckpointTableUpdateCompanionBuilder,
    (
      StockCheckpointData,
      BaseReferences<_$AppDatabase, $StockCheckpointTable, StockCheckpointData>
    ),
    StockCheckpointData,
    PrefetchHooks Function()>;
typedef $$PeriodosTableCreateCompanionBuilder = PeriodosCompanion Function({
  Value<int> id,
  required String periodo,
  required String fechaApertura,
  Value<String?> registradoPor,
});
typedef $$PeriodosTableUpdateCompanionBuilder = PeriodosCompanion Function({
  Value<int> id,
  Value<String> periodo,
  Value<String> fechaApertura,
  Value<String?> registradoPor,
});

class $$PeriodosTableFilterComposer
    extends Composer<_$AppDatabase, $PeriodosTable> {
  $$PeriodosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get periodo => $composableBuilder(
      column: $table.periodo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fechaApertura => $composableBuilder(
      column: $table.fechaApertura, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get registradoPor => $composableBuilder(
      column: $table.registradoPor, builder: (column) => ColumnFilters(column));
}

class $$PeriodosTableOrderingComposer
    extends Composer<_$AppDatabase, $PeriodosTable> {
  $$PeriodosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get periodo => $composableBuilder(
      column: $table.periodo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fechaApertura => $composableBuilder(
      column: $table.fechaApertura,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get registradoPor => $composableBuilder(
      column: $table.registradoPor,
      builder: (column) => ColumnOrderings(column));
}

class $$PeriodosTableAnnotationComposer
    extends Composer<_$AppDatabase, $PeriodosTable> {
  $$PeriodosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get periodo =>
      $composableBuilder(column: $table.periodo, builder: (column) => column);

  GeneratedColumn<String> get fechaApertura => $composableBuilder(
      column: $table.fechaApertura, builder: (column) => column);

  GeneratedColumn<String> get registradoPor => $composableBuilder(
      column: $table.registradoPor, builder: (column) => column);
}

class $$PeriodosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PeriodosTable,
    Periodo,
    $$PeriodosTableFilterComposer,
    $$PeriodosTableOrderingComposer,
    $$PeriodosTableAnnotationComposer,
    $$PeriodosTableCreateCompanionBuilder,
    $$PeriodosTableUpdateCompanionBuilder,
    (Periodo, BaseReferences<_$AppDatabase, $PeriodosTable, Periodo>),
    Periodo,
    PrefetchHooks Function()> {
  $$PeriodosTableTableManager(_$AppDatabase db, $PeriodosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PeriodosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PeriodosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PeriodosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> periodo = const Value.absent(),
            Value<String> fechaApertura = const Value.absent(),
            Value<String?> registradoPor = const Value.absent(),
          }) =>
              PeriodosCompanion(
            id: id,
            periodo: periodo,
            fechaApertura: fechaApertura,
            registradoPor: registradoPor,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String periodo,
            required String fechaApertura,
            Value<String?> registradoPor = const Value.absent(),
          }) =>
              PeriodosCompanion.insert(
            id: id,
            periodo: periodo,
            fechaApertura: fechaApertura,
            registradoPor: registradoPor,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PeriodosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PeriodosTable,
    Periodo,
    $$PeriodosTableFilterComposer,
    $$PeriodosTableOrderingComposer,
    $$PeriodosTableAnnotationComposer,
    $$PeriodosTableCreateCompanionBuilder,
    $$PeriodosTableUpdateCompanionBuilder,
    (Periodo, BaseReferences<_$AppDatabase, $PeriodosTable, Periodo>),
    Periodo,
    PrefetchHooks Function()>;
typedef $$RecetasTableCreateCompanionBuilder = RecetasCompanion Function({
  Value<int> id,
  required String nombre,
  required String tipo,
  Value<int?> productoBaseId,
  Value<int?> productoFinalId,
  Value<double> cantidadProducida,
  Value<int> activo,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
});
typedef $$RecetasTableUpdateCompanionBuilder = RecetasCompanion Function({
  Value<int> id,
  Value<String> nombre,
  Value<String> tipo,
  Value<int?> productoBaseId,
  Value<int?> productoFinalId,
  Value<double> cantidadProducida,
  Value<int> activo,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
});

class $$RecetasTableFilterComposer
    extends Composer<_$AppDatabase, $RecetasTable> {
  $$RecetasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tipo => $composableBuilder(
      column: $table.tipo, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get productoBaseId => $composableBuilder(
      column: $table.productoBaseId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get productoFinalId => $composableBuilder(
      column: $table.productoFinalId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cantidadProducida => $composableBuilder(
      column: $table.cantidadProducida,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get activo => $composableBuilder(
      column: $table.activo, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$RecetasTableOrderingComposer
    extends Composer<_$AppDatabase, $RecetasTable> {
  $$RecetasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tipo => $composableBuilder(
      column: $table.tipo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get productoBaseId => $composableBuilder(
      column: $table.productoBaseId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get productoFinalId => $composableBuilder(
      column: $table.productoFinalId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cantidadProducida => $composableBuilder(
      column: $table.cantidadProducida,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get activo => $composableBuilder(
      column: $table.activo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$RecetasTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecetasTable> {
  $$RecetasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<int> get productoBaseId => $composableBuilder(
      column: $table.productoBaseId, builder: (column) => column);

  GeneratedColumn<int> get productoFinalId => $composableBuilder(
      column: $table.productoFinalId, builder: (column) => column);

  GeneratedColumn<double> get cantidadProducida => $composableBuilder(
      column: $table.cantidadProducida, builder: (column) => column);

  GeneratedColumn<int> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$RecetasTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RecetasTable,
    Receta,
    $$RecetasTableFilterComposer,
    $$RecetasTableOrderingComposer,
    $$RecetasTableAnnotationComposer,
    $$RecetasTableCreateCompanionBuilder,
    $$RecetasTableUpdateCompanionBuilder,
    (Receta, BaseReferences<_$AppDatabase, $RecetasTable, Receta>),
    Receta,
    PrefetchHooks Function()> {
  $$RecetasTableTableManager(_$AppDatabase db, $RecetasTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecetasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecetasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecetasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nombre = const Value.absent(),
            Value<String> tipo = const Value.absent(),
            Value<int?> productoBaseId = const Value.absent(),
            Value<int?> productoFinalId = const Value.absent(),
            Value<double> cantidadProducida = const Value.absent(),
            Value<int> activo = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              RecetasCompanion(
            id: id,
            nombre: nombre,
            tipo: tipo,
            productoBaseId: productoBaseId,
            productoFinalId: productoFinalId,
            cantidadProducida: cantidadProducida,
            activo: activo,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nombre,
            required String tipo,
            Value<int?> productoBaseId = const Value.absent(),
            Value<int?> productoFinalId = const Value.absent(),
            Value<double> cantidadProducida = const Value.absent(),
            Value<int> activo = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              RecetasCompanion.insert(
            id: id,
            nombre: nombre,
            tipo: tipo,
            productoBaseId: productoBaseId,
            productoFinalId: productoFinalId,
            cantidadProducida: cantidadProducida,
            activo: activo,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RecetasTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RecetasTable,
    Receta,
    $$RecetasTableFilterComposer,
    $$RecetasTableOrderingComposer,
    $$RecetasTableAnnotationComposer,
    $$RecetasTableCreateCompanionBuilder,
    $$RecetasTableUpdateCompanionBuilder,
    (Receta, BaseReferences<_$AppDatabase, $RecetasTable, Receta>),
    Receta,
    PrefetchHooks Function()>;
typedef $$RecetaComponentesTableCreateCompanionBuilder
    = RecetaComponentesCompanion Function({
  Value<int> id,
  required int recetaId,
  required int productoId,
  required double cantidad,
  Value<String> unidad,
  required String tipoComponente,
  Value<int> pesoVariable,
});
typedef $$RecetaComponentesTableUpdateCompanionBuilder
    = RecetaComponentesCompanion Function({
  Value<int> id,
  Value<int> recetaId,
  Value<int> productoId,
  Value<double> cantidad,
  Value<String> unidad,
  Value<String> tipoComponente,
  Value<int> pesoVariable,
});

class $$RecetaComponentesTableFilterComposer
    extends Composer<_$AppDatabase, $RecetaComponentesTable> {
  $$RecetaComponentesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get recetaId => $composableBuilder(
      column: $table.recetaId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get productoId => $composableBuilder(
      column: $table.productoId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cantidad => $composableBuilder(
      column: $table.cantidad, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unidad => $composableBuilder(
      column: $table.unidad, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tipoComponente => $composableBuilder(
      column: $table.tipoComponente,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get pesoVariable => $composableBuilder(
      column: $table.pesoVariable, builder: (column) => ColumnFilters(column));
}

class $$RecetaComponentesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecetaComponentesTable> {
  $$RecetaComponentesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get recetaId => $composableBuilder(
      column: $table.recetaId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get productoId => $composableBuilder(
      column: $table.productoId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cantidad => $composableBuilder(
      column: $table.cantidad, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unidad => $composableBuilder(
      column: $table.unidad, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tipoComponente => $composableBuilder(
      column: $table.tipoComponente,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get pesoVariable => $composableBuilder(
      column: $table.pesoVariable,
      builder: (column) => ColumnOrderings(column));
}

class $$RecetaComponentesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecetaComponentesTable> {
  $$RecetaComponentesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get recetaId =>
      $composableBuilder(column: $table.recetaId, builder: (column) => column);

  GeneratedColumn<int> get productoId => $composableBuilder(
      column: $table.productoId, builder: (column) => column);

  GeneratedColumn<double> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<String> get unidad =>
      $composableBuilder(column: $table.unidad, builder: (column) => column);

  GeneratedColumn<String> get tipoComponente => $composableBuilder(
      column: $table.tipoComponente, builder: (column) => column);

  GeneratedColumn<int> get pesoVariable => $composableBuilder(
      column: $table.pesoVariable, builder: (column) => column);
}

class $$RecetaComponentesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RecetaComponentesTable,
    RecetaComponente,
    $$RecetaComponentesTableFilterComposer,
    $$RecetaComponentesTableOrderingComposer,
    $$RecetaComponentesTableAnnotationComposer,
    $$RecetaComponentesTableCreateCompanionBuilder,
    $$RecetaComponentesTableUpdateCompanionBuilder,
    (
      RecetaComponente,
      BaseReferences<_$AppDatabase, $RecetaComponentesTable, RecetaComponente>
    ),
    RecetaComponente,
    PrefetchHooks Function()> {
  $$RecetaComponentesTableTableManager(
      _$AppDatabase db, $RecetaComponentesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecetaComponentesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecetaComponentesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecetaComponentesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> recetaId = const Value.absent(),
            Value<int> productoId = const Value.absent(),
            Value<double> cantidad = const Value.absent(),
            Value<String> unidad = const Value.absent(),
            Value<String> tipoComponente = const Value.absent(),
            Value<int> pesoVariable = const Value.absent(),
          }) =>
              RecetaComponentesCompanion(
            id: id,
            recetaId: recetaId,
            productoId: productoId,
            cantidad: cantidad,
            unidad: unidad,
            tipoComponente: tipoComponente,
            pesoVariable: pesoVariable,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int recetaId,
            required int productoId,
            required double cantidad,
            Value<String> unidad = const Value.absent(),
            required String tipoComponente,
            Value<int> pesoVariable = const Value.absent(),
          }) =>
              RecetaComponentesCompanion.insert(
            id: id,
            recetaId: recetaId,
            productoId: productoId,
            cantidad: cantidad,
            unidad: unidad,
            tipoComponente: tipoComponente,
            pesoVariable: pesoVariable,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RecetaComponentesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RecetaComponentesTable,
    RecetaComponente,
    $$RecetaComponentesTableFilterComposer,
    $$RecetaComponentesTableOrderingComposer,
    $$RecetaComponentesTableAnnotationComposer,
    $$RecetaComponentesTableCreateCompanionBuilder,
    $$RecetaComponentesTableUpdateCompanionBuilder,
    (
      RecetaComponente,
      BaseReferences<_$AppDatabase, $RecetaComponentesTable, RecetaComponente>
    ),
    RecetaComponente,
    PrefetchHooks Function()>;
typedef $$ProduccionesTableCreateCompanionBuilder = ProduccionesCompanion
    Function({
  Value<int> id,
  required int recetaId,
  required double cantidad,
  Value<String> estado,
  Value<String?> usuario,
  Value<String?> observaciones,
  Value<DateTime?> fechaProduccion,
  Value<String?> cocineros,
  Value<DateTime?> createdAt,
});
typedef $$ProduccionesTableUpdateCompanionBuilder = ProduccionesCompanion
    Function({
  Value<int> id,
  Value<int> recetaId,
  Value<double> cantidad,
  Value<String> estado,
  Value<String?> usuario,
  Value<String?> observaciones,
  Value<DateTime?> fechaProduccion,
  Value<String?> cocineros,
  Value<DateTime?> createdAt,
});

class $$ProduccionesTableFilterComposer
    extends Composer<_$AppDatabase, $ProduccionesTable> {
  $$ProduccionesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get recetaId => $composableBuilder(
      column: $table.recetaId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cantidad => $composableBuilder(
      column: $table.cantidad, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get estado => $composableBuilder(
      column: $table.estado, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get usuario => $composableBuilder(
      column: $table.usuario, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get observaciones => $composableBuilder(
      column: $table.observaciones, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fechaProduccion => $composableBuilder(
      column: $table.fechaProduccion,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cocineros => $composableBuilder(
      column: $table.cocineros, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$ProduccionesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProduccionesTable> {
  $$ProduccionesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get recetaId => $composableBuilder(
      column: $table.recetaId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cantidad => $composableBuilder(
      column: $table.cantidad, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get estado => $composableBuilder(
      column: $table.estado, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get usuario => $composableBuilder(
      column: $table.usuario, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get observaciones => $composableBuilder(
      column: $table.observaciones,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fechaProduccion => $composableBuilder(
      column: $table.fechaProduccion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cocineros => $composableBuilder(
      column: $table.cocineros, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ProduccionesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProduccionesTable> {
  $$ProduccionesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get recetaId =>
      $composableBuilder(column: $table.recetaId, builder: (column) => column);

  GeneratedColumn<double> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<String> get usuario =>
      $composableBuilder(column: $table.usuario, builder: (column) => column);

  GeneratedColumn<String> get observaciones => $composableBuilder(
      column: $table.observaciones, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaProduccion => $composableBuilder(
      column: $table.fechaProduccion, builder: (column) => column);

  GeneratedColumn<String> get cocineros =>
      $composableBuilder(column: $table.cocineros, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ProduccionesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProduccionesTable,
    Produccione,
    $$ProduccionesTableFilterComposer,
    $$ProduccionesTableOrderingComposer,
    $$ProduccionesTableAnnotationComposer,
    $$ProduccionesTableCreateCompanionBuilder,
    $$ProduccionesTableUpdateCompanionBuilder,
    (
      Produccione,
      BaseReferences<_$AppDatabase, $ProduccionesTable, Produccione>
    ),
    Produccione,
    PrefetchHooks Function()> {
  $$ProduccionesTableTableManager(_$AppDatabase db, $ProduccionesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProduccionesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProduccionesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProduccionesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> recetaId = const Value.absent(),
            Value<double> cantidad = const Value.absent(),
            Value<String> estado = const Value.absent(),
            Value<String?> usuario = const Value.absent(),
            Value<String?> observaciones = const Value.absent(),
            Value<DateTime?> fechaProduccion = const Value.absent(),
            Value<String?> cocineros = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              ProduccionesCompanion(
            id: id,
            recetaId: recetaId,
            cantidad: cantidad,
            estado: estado,
            usuario: usuario,
            observaciones: observaciones,
            fechaProduccion: fechaProduccion,
            cocineros: cocineros,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int recetaId,
            required double cantidad,
            Value<String> estado = const Value.absent(),
            Value<String?> usuario = const Value.absent(),
            Value<String?> observaciones = const Value.absent(),
            Value<DateTime?> fechaProduccion = const Value.absent(),
            Value<String?> cocineros = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              ProduccionesCompanion.insert(
            id: id,
            recetaId: recetaId,
            cantidad: cantidad,
            estado: estado,
            usuario: usuario,
            observaciones: observaciones,
            fechaProduccion: fechaProduccion,
            cocineros: cocineros,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProduccionesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProduccionesTable,
    Produccione,
    $$ProduccionesTableFilterComposer,
    $$ProduccionesTableOrderingComposer,
    $$ProduccionesTableAnnotationComposer,
    $$ProduccionesTableCreateCompanionBuilder,
    $$ProduccionesTableUpdateCompanionBuilder,
    (
      Produccione,
      BaseReferences<_$AppDatabase, $ProduccionesTable, Produccione>
    ),
    Produccione,
    PrefetchHooks Function()>;
typedef $$ProduccionDetallesTableCreateCompanionBuilder
    = ProduccionDetallesCompanion Function({
  Value<int> id,
  required int produccionId,
  required int productoId,
  required String tipo,
  required double cantidad,
  Value<String> unidad,
  Value<int?> movimientoId,
});
typedef $$ProduccionDetallesTableUpdateCompanionBuilder
    = ProduccionDetallesCompanion Function({
  Value<int> id,
  Value<int> produccionId,
  Value<int> productoId,
  Value<String> tipo,
  Value<double> cantidad,
  Value<String> unidad,
  Value<int?> movimientoId,
});

class $$ProduccionDetallesTableFilterComposer
    extends Composer<_$AppDatabase, $ProduccionDetallesTable> {
  $$ProduccionDetallesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get produccionId => $composableBuilder(
      column: $table.produccionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get productoId => $composableBuilder(
      column: $table.productoId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tipo => $composableBuilder(
      column: $table.tipo, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cantidad => $composableBuilder(
      column: $table.cantidad, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unidad => $composableBuilder(
      column: $table.unidad, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get movimientoId => $composableBuilder(
      column: $table.movimientoId, builder: (column) => ColumnFilters(column));
}

class $$ProduccionDetallesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProduccionDetallesTable> {
  $$ProduccionDetallesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get produccionId => $composableBuilder(
      column: $table.produccionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get productoId => $composableBuilder(
      column: $table.productoId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tipo => $composableBuilder(
      column: $table.tipo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cantidad => $composableBuilder(
      column: $table.cantidad, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unidad => $composableBuilder(
      column: $table.unidad, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get movimientoId => $composableBuilder(
      column: $table.movimientoId,
      builder: (column) => ColumnOrderings(column));
}

class $$ProduccionDetallesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProduccionDetallesTable> {
  $$ProduccionDetallesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get produccionId => $composableBuilder(
      column: $table.produccionId, builder: (column) => column);

  GeneratedColumn<int> get productoId => $composableBuilder(
      column: $table.productoId, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<double> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<String> get unidad =>
      $composableBuilder(column: $table.unidad, builder: (column) => column);

  GeneratedColumn<int> get movimientoId => $composableBuilder(
      column: $table.movimientoId, builder: (column) => column);
}

class $$ProduccionDetallesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProduccionDetallesTable,
    ProduccionDetalle,
    $$ProduccionDetallesTableFilterComposer,
    $$ProduccionDetallesTableOrderingComposer,
    $$ProduccionDetallesTableAnnotationComposer,
    $$ProduccionDetallesTableCreateCompanionBuilder,
    $$ProduccionDetallesTableUpdateCompanionBuilder,
    (
      ProduccionDetalle,
      BaseReferences<_$AppDatabase, $ProduccionDetallesTable, ProduccionDetalle>
    ),
    ProduccionDetalle,
    PrefetchHooks Function()> {
  $$ProduccionDetallesTableTableManager(
      _$AppDatabase db, $ProduccionDetallesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProduccionDetallesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProduccionDetallesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProduccionDetallesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> produccionId = const Value.absent(),
            Value<int> productoId = const Value.absent(),
            Value<String> tipo = const Value.absent(),
            Value<double> cantidad = const Value.absent(),
            Value<String> unidad = const Value.absent(),
            Value<int?> movimientoId = const Value.absent(),
          }) =>
              ProduccionDetallesCompanion(
            id: id,
            produccionId: produccionId,
            productoId: productoId,
            tipo: tipo,
            cantidad: cantidad,
            unidad: unidad,
            movimientoId: movimientoId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int produccionId,
            required int productoId,
            required String tipo,
            required double cantidad,
            Value<String> unidad = const Value.absent(),
            Value<int?> movimientoId = const Value.absent(),
          }) =>
              ProduccionDetallesCompanion.insert(
            id: id,
            produccionId: produccionId,
            productoId: productoId,
            tipo: tipo,
            cantidad: cantidad,
            unidad: unidad,
            movimientoId: movimientoId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProduccionDetallesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProduccionDetallesTable,
    ProduccionDetalle,
    $$ProduccionDetallesTableFilterComposer,
    $$ProduccionDetallesTableOrderingComposer,
    $$ProduccionDetallesTableAnnotationComposer,
    $$ProduccionDetallesTableCreateCompanionBuilder,
    $$ProduccionDetallesTableUpdateCompanionBuilder,
    (
      ProduccionDetalle,
      BaseReferences<_$AppDatabase, $ProduccionDetallesTable, ProduccionDetalle>
    ),
    ProduccionDetalle,
    PrefetchHooks Function()>;
typedef $$ComprasListaTableCreateCompanionBuilder = ComprasListaCompanion
    Function({
  Value<int> id,
  required int productoId,
  Value<DateTime?> createdAt,
});
typedef $$ComprasListaTableUpdateCompanionBuilder = ComprasListaCompanion
    Function({
  Value<int> id,
  Value<int> productoId,
  Value<DateTime?> createdAt,
});

class $$ComprasListaTableFilterComposer
    extends Composer<_$AppDatabase, $ComprasListaTable> {
  $$ComprasListaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get productoId => $composableBuilder(
      column: $table.productoId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$ComprasListaTableOrderingComposer
    extends Composer<_$AppDatabase, $ComprasListaTable> {
  $$ComprasListaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get productoId => $composableBuilder(
      column: $table.productoId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ComprasListaTableAnnotationComposer
    extends Composer<_$AppDatabase, $ComprasListaTable> {
  $$ComprasListaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get productoId => $composableBuilder(
      column: $table.productoId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ComprasListaTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ComprasListaTable,
    ComprasListaData,
    $$ComprasListaTableFilterComposer,
    $$ComprasListaTableOrderingComposer,
    $$ComprasListaTableAnnotationComposer,
    $$ComprasListaTableCreateCompanionBuilder,
    $$ComprasListaTableUpdateCompanionBuilder,
    (
      ComprasListaData,
      BaseReferences<_$AppDatabase, $ComprasListaTable, ComprasListaData>
    ),
    ComprasListaData,
    PrefetchHooks Function()> {
  $$ComprasListaTableTableManager(_$AppDatabase db, $ComprasListaTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ComprasListaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ComprasListaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ComprasListaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> productoId = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              ComprasListaCompanion(
            id: id,
            productoId: productoId,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int productoId,
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              ComprasListaCompanion.insert(
            id: id,
            productoId: productoId,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ComprasListaTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ComprasListaTable,
    ComprasListaData,
    $$ComprasListaTableFilterComposer,
    $$ComprasListaTableOrderingComposer,
    $$ComprasListaTableAnnotationComposer,
    $$ComprasListaTableCreateCompanionBuilder,
    $$ComprasListaTableUpdateCompanionBuilder,
    (
      ComprasListaData,
      BaseReferences<_$AppDatabase, $ComprasListaTable, ComprasListaData>
    ),
    ComprasListaData,
    PrefetchHooks Function()>;
typedef $$SyncQueueTableCreateCompanionBuilder = SyncQueueCompanion Function({
  Value<int> id,
  required String targetTable,
  required String operation,
  required String data,
  required DateTime createdAt,
  Value<int> retries,
  Value<String?> lastError,
  Value<String> status,
});
typedef $$SyncQueueTableUpdateCompanionBuilder = SyncQueueCompanion Function({
  Value<int> id,
  Value<String> targetTable,
  Value<String> operation,
  Value<String> data,
  Value<DateTime> createdAt,
  Value<int> retries,
  Value<String?> lastError,
  Value<String> status,
});

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get targetTable => $composableBuilder(
      column: $table.targetTable, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get retries => $composableBuilder(
      column: $table.retries, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get targetTable => $composableBuilder(
      column: $table.targetTable, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get retries => $composableBuilder(
      column: $table.retries, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get targetTable => $composableBuilder(
      column: $table.targetTable, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get retries =>
      $composableBuilder(column: $table.retries, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$SyncQueueTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncQueueData,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableAnnotationComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder,
    (
      SyncQueueData,
      BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>
    ),
    SyncQueueData,
    PrefetchHooks Function()> {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> targetTable = const Value.absent(),
            Value<String> operation = const Value.absent(),
            Value<String> data = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> retries = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            Value<String> status = const Value.absent(),
          }) =>
              SyncQueueCompanion(
            id: id,
            targetTable: targetTable,
            operation: operation,
            data: data,
            createdAt: createdAt,
            retries: retries,
            lastError: lastError,
            status: status,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String targetTable,
            required String operation,
            required String data,
            required DateTime createdAt,
            Value<int> retries = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            Value<String> status = const Value.absent(),
          }) =>
              SyncQueueCompanion.insert(
            id: id,
            targetTable: targetTable,
            operation: operation,
            data: data,
            createdAt: createdAt,
            retries: retries,
            lastError: lastError,
            status: status,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncQueueTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncQueueData,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableAnnotationComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder,
    (
      SyncQueueData,
      BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>
    ),
    SyncQueueData,
    PrefetchHooks Function()>;
typedef $$SyncMetadataTableCreateCompanionBuilder = SyncMetadataCompanion
    Function({
  required String key,
  Value<String?> value,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$SyncMetadataTableUpdateCompanionBuilder = SyncMetadataCompanion
    Function({
  Value<String> key,
  Value<String?> value,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

class $$SyncMetadataTableFilterComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$SyncMetadataTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$SyncMetadataTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SyncMetadataTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncMetadataTable,
    SyncMetadataData,
    $$SyncMetadataTableFilterComposer,
    $$SyncMetadataTableOrderingComposer,
    $$SyncMetadataTableAnnotationComposer,
    $$SyncMetadataTableCreateCompanionBuilder,
    $$SyncMetadataTableUpdateCompanionBuilder,
    (
      SyncMetadataData,
      BaseReferences<_$AppDatabase, $SyncMetadataTable, SyncMetadataData>
    ),
    SyncMetadataData,
    PrefetchHooks Function()> {
  $$SyncMetadataTableTableManager(_$AppDatabase db, $SyncMetadataTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncMetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncMetadataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncMetadataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String?> value = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncMetadataCompanion(
            key: key,
            value: value,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            Value<String?> value = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncMetadataCompanion.insert(
            key: key,
            value: value,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncMetadataTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncMetadataTable,
    SyncMetadataData,
    $$SyncMetadataTableFilterComposer,
    $$SyncMetadataTableOrderingComposer,
    $$SyncMetadataTableAnnotationComposer,
    $$SyncMetadataTableCreateCompanionBuilder,
    $$SyncMetadataTableUpdateCompanionBuilder,
    (
      SyncMetadataData,
      BaseReferences<_$AppDatabase, $SyncMetadataTable, SyncMetadataData>
    ),
    SyncMetadataData,
    PrefetchHooks Function()>;
typedef $$DispositivoUsuarioTableCreateCompanionBuilder
    = DispositivoUsuarioCompanion Function({
  Value<int> id,
  required String nombre,
  Value<String?> pinHash,
  required DateTime configuradoEn,
});
typedef $$DispositivoUsuarioTableUpdateCompanionBuilder
    = DispositivoUsuarioCompanion Function({
  Value<int> id,
  Value<String> nombre,
  Value<String?> pinHash,
  Value<DateTime> configuradoEn,
});

class $$DispositivoUsuarioTableFilterComposer
    extends Composer<_$AppDatabase, $DispositivoUsuarioTable> {
  $$DispositivoUsuarioTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pinHash => $composableBuilder(
      column: $table.pinHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get configuradoEn => $composableBuilder(
      column: $table.configuradoEn, builder: (column) => ColumnFilters(column));
}

class $$DispositivoUsuarioTableOrderingComposer
    extends Composer<_$AppDatabase, $DispositivoUsuarioTable> {
  $$DispositivoUsuarioTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pinHash => $composableBuilder(
      column: $table.pinHash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get configuradoEn => $composableBuilder(
      column: $table.configuradoEn,
      builder: (column) => ColumnOrderings(column));
}

class $$DispositivoUsuarioTableAnnotationComposer
    extends Composer<_$AppDatabase, $DispositivoUsuarioTable> {
  $$DispositivoUsuarioTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get pinHash =>
      $composableBuilder(column: $table.pinHash, builder: (column) => column);

  GeneratedColumn<DateTime> get configuradoEn => $composableBuilder(
      column: $table.configuradoEn, builder: (column) => column);
}

class $$DispositivoUsuarioTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DispositivoUsuarioTable,
    DispositivoUsuarioData,
    $$DispositivoUsuarioTableFilterComposer,
    $$DispositivoUsuarioTableOrderingComposer,
    $$DispositivoUsuarioTableAnnotationComposer,
    $$DispositivoUsuarioTableCreateCompanionBuilder,
    $$DispositivoUsuarioTableUpdateCompanionBuilder,
    (
      DispositivoUsuarioData,
      BaseReferences<_$AppDatabase, $DispositivoUsuarioTable,
          DispositivoUsuarioData>
    ),
    DispositivoUsuarioData,
    PrefetchHooks Function()> {
  $$DispositivoUsuarioTableTableManager(
      _$AppDatabase db, $DispositivoUsuarioTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DispositivoUsuarioTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DispositivoUsuarioTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DispositivoUsuarioTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nombre = const Value.absent(),
            Value<String?> pinHash = const Value.absent(),
            Value<DateTime> configuradoEn = const Value.absent(),
          }) =>
              DispositivoUsuarioCompanion(
            id: id,
            nombre: nombre,
            pinHash: pinHash,
            configuradoEn: configuradoEn,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nombre,
            Value<String?> pinHash = const Value.absent(),
            required DateTime configuradoEn,
          }) =>
              DispositivoUsuarioCompanion.insert(
            id: id,
            nombre: nombre,
            pinHash: pinHash,
            configuradoEn: configuradoEn,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DispositivoUsuarioTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DispositivoUsuarioTable,
    DispositivoUsuarioData,
    $$DispositivoUsuarioTableFilterComposer,
    $$DispositivoUsuarioTableOrderingComposer,
    $$DispositivoUsuarioTableAnnotationComposer,
    $$DispositivoUsuarioTableCreateCompanionBuilder,
    $$DispositivoUsuarioTableUpdateCompanionBuilder,
    (
      DispositivoUsuarioData,
      BaseReferences<_$AppDatabase, $DispositivoUsuarioTable,
          DispositivoUsuarioData>
    ),
    DispositivoUsuarioData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoriasTableTableManager get categorias =>
      $$CategoriasTableTableManager(_db, _db.categorias);
  $$ProductosTableTableManager get productos =>
      $$ProductosTableTableManager(_db, _db.productos);
  $$ProveedoresTableTableManager get proveedores =>
      $$ProveedoresTableTableManager(_db, _db.proveedores);
  $$ExistenciasTableTableManager get existencias =>
      $$ExistenciasTableTableManager(_db, _db.existencias);
  $$MovimientosTableTableManager get movimientos =>
      $$MovimientosTableTableManager(_db, _db.movimientos);
  $$MovimientosArchivoTableTableManager get movimientosArchivo =>
      $$MovimientosArchivoTableTableManager(_db, _db.movimientosArchivo);
  $$FacturasTableTableManager get facturas =>
      $$FacturasTableTableManager(_db, _db.facturas);
  $$FacturaPagosTableTableManager get facturaPagos =>
      $$FacturaPagosTableTableManager(_db, _db.facturaPagos);
  $$RequisicionesTableTableManager get requisiciones =>
      $$RequisicionesTableTableManager(_db, _db.requisiciones);
  $$RequisicionDetallesTableTableManager get requisicionDetalles =>
      $$RequisicionDetallesTableTableManager(_db, _db.requisicionDetalles);
  $$StockCheckpointTableTableManager get stockCheckpoint =>
      $$StockCheckpointTableTableManager(_db, _db.stockCheckpoint);
  $$PeriodosTableTableManager get periodos =>
      $$PeriodosTableTableManager(_db, _db.periodos);
  $$RecetasTableTableManager get recetas =>
      $$RecetasTableTableManager(_db, _db.recetas);
  $$RecetaComponentesTableTableManager get recetaComponentes =>
      $$RecetaComponentesTableTableManager(_db, _db.recetaComponentes);
  $$ProduccionesTableTableManager get producciones =>
      $$ProduccionesTableTableManager(_db, _db.producciones);
  $$ProduccionDetallesTableTableManager get produccionDetalles =>
      $$ProduccionDetallesTableTableManager(_db, _db.produccionDetalles);
  $$ComprasListaTableTableManager get comprasLista =>
      $$ComprasListaTableTableManager(_db, _db.comprasLista);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
  $$SyncMetadataTableTableManager get syncMetadata =>
      $$SyncMetadataTableTableManager(_db, _db.syncMetadata);
  $$DispositivoUsuarioTableTableManager get dispositivoUsuario =>
      $$DispositivoUsuarioTableTableManager(_db, _db.dispositivoUsuario);
}
