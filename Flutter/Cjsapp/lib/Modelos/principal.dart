import 'package:intl/intl.dart';

class Cargo {
  final int? idCargo;
  final String cargo;

  Cargo({
    this.idCargo,
    required this.cargo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_cargo': idCargo,
      'cargo': cargo,
    };
  }

  factory Cargo.fromMap(Map<String, dynamic> map) {
    return Cargo(
      idCargo: map['id_cargo'],
      cargo: map['cargo'],
    );
  }

  Cargo copyWith({
    int? idCargo,
    String? cargo,
  }) {
    return Cargo(
      idCargo: idCargo ?? this.idCargo,
      cargo: cargo ?? this.cargo,
    );
  }

  @override
  String toString() {
    return 'Cargo{idCargo: $idCargo, cargo: $cargo}';
  }
}

class Cliente {
  final int? idCliente;
  final String nombre;
  final String telefono;

  Cliente({
    this.idCliente,
    required this.nombre,
    required this.telefono,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_cliente': idCliente,
      'nombre': nombre,
      'telefono': telefono,
    };
  }

  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      idCliente: map['id_cliente'],
      nombre: map['nombre'],
      telefono: map['telefono'],
    );
  }

  Cliente copyWith({
    int? idCliente,
    String? nombre,
    String? telefono,
  }) {
    return Cliente(
      idCliente: idCliente ?? this.idCliente,
      nombre: nombre ?? this.nombre,
      telefono: telefono ?? this.telefono,
    );
  }

  @override
  String toString() {
    return 'Cliente{idCliente: $idCliente, nombre: $nombre, telefono: $telefono}';
  }
}

class Proveedor {
  final int? idProveedor;
  final String nombre;
  final String telefono;
  final String tipoDeProductos;

  Proveedor({
    this.idProveedor,
    required this.nombre,
    required this.telefono,
    required this.tipoDeProductos,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_proveedor': idProveedor,
      'nombre': nombre,
      'telefono': telefono,
      'tipo_de_productos': tipoDeProductos,
    };
  }

  factory Proveedor.fromMap(Map<String, dynamic> map) {
    return Proveedor(
      idProveedor: map['id_proveedor'],
      nombre: map['nombre'],
      telefono: map['telefono'],
      tipoDeProductos: map['tipo_de_productos'],
    );
  }

  Proveedor copyWith({
    int? idProveedor,
    String? nombre,
    String? telefono,
    String? tipoDeProductos,
  }) {
    return Proveedor(
      idProveedor: idProveedor ?? this.idProveedor,
      nombre: nombre ?? this.nombre,
      telefono: telefono ?? this.telefono,
      tipoDeProductos: tipoDeProductos ?? this.tipoDeProductos,
    );
  }

  @override
  String toString() {
    return 'Proveedor{idProveedor: $idProveedor, nombre: $nombre, telefono: $telefono, tipoDeProductos: $tipoDeProductos}';
  }
}

class Empleado {
  final int? idPersonal;
  final String nombre;
  final int idCargo;
  final String telefono;

  Empleado({
    this.idPersonal,
    required this.nombre,
    required this.idCargo,
    required this.telefono,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_personal': idPersonal,
      'nombre': nombre,
      'id_cargo': idCargo,
      'telefono': telefono,
    };
  }

  factory Empleado.fromMap(Map<String, dynamic> map) {
    return Empleado(
      idPersonal: map['id_personal'],
      nombre: map['nombre'],
      idCargo: map['id_cargo'],
      telefono: map['telefono'],
    );
  }

  Empleado copyWith({
    int? idPersonal,
    String? nombre,
    int? idCargo,
    String? telefono,
  }) {
    return Empleado(
      idPersonal: idPersonal ?? this.idPersonal,
      nombre: nombre ?? this.nombre,
      idCargo: idCargo ?? this.idCargo,
      telefono: telefono ?? this.telefono,
    );
  }

  @override
  String toString() {
    return 'Empleado{idPersonal: $idPersonal, nombre: $nombre, idCargo: $idCargo, telefono: $telefono}';
  }
}

class Articulo {
  final int? idArticulo;
  final String nombre;
  final String especificacion;
  final int idProveedor;

  Articulo({
    this.idArticulo,
    required this.nombre,
    required this.especificacion,
    required this.idProveedor,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_articulo': idArticulo,
      'nombre': nombre,
      'especificacion': especificacion,
      'id_proveedor': idProveedor,
    };
  }

  factory Articulo.fromMap(Map<String, dynamic> map) {
    return Articulo(
      idArticulo: map['id_articulo'],
      nombre: map['nombre'],
      especificacion: map['especificacion'],
      idProveedor: map['id_proveedor'],
    );
  }

  Articulo copyWith({
    int? idArticulo,
    String? nombre,
    String? especificacion,
    int? idProveedor,
  }) {
    return Articulo(
      idArticulo: idArticulo ?? this.idArticulo,
      nombre: nombre ?? this.nombre,
      especificacion: especificacion ?? this.especificacion,
      idProveedor: idProveedor ?? this.idProveedor,
    );
  }

  @override
  String toString() {
    return 'Articulo{idArticulo: $idArticulo, nombre: $nombre, especificacion: $especificacion, idProveedor: $idProveedor}';
  }
}

class Inventario {
  final int? idTransaccion;
  final int idArticulo;
  final int idPersonal;
  final int cantidad;
  final DateTime fecha;
  final String? notas;

  Inventario({
    this.idTransaccion,
    required this.idArticulo,
    required this.idPersonal,
    required this.cantidad,
    required this.fecha,
    this.notas,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_transaccion': idTransaccion,
      'id_articulo': idArticulo,
      'id_personal': idPersonal,
      'cantidad': cantidad,
      'fecha': DateFormat('yyyy-MM-dd').format(fecha),
      'notas': notas,
    };
  }

  factory Inventario.fromMap(Map<String, dynamic> map) {
    return Inventario(
      idTransaccion: map['id_transaccion'],
      idArticulo: map['id_articulo'],
      idPersonal: map['id_personal'],
      cantidad: map['cantidad'],
      fecha: DateFormat('yyyy-MM-dd').parse(map['fecha']),
      notas: map['notas'],
    );
  }

  Inventario copyWith({
    int? idTransaccion,
    int? idArticulo,
    int? idPersonal,
    int? cantidad,
    DateTime? fecha,
    String? notas,
  }) {
    return Inventario(
      idTransaccion: idTransaccion ?? this.idTransaccion,
      idArticulo: idArticulo ?? this.idArticulo,
      idPersonal: idPersonal ?? this.idPersonal,
      cantidad: cantidad ?? this.cantidad,
      fecha: fecha ?? this.fecha,
      notas: notas ?? this.notas,
    );
  }

  @override
  String toString() {
    return 'Inventario{idTransaccion: $idTransaccion, idArticulo: $idArticulo, idPersonal: $idPersonal, cantidad: $cantidad, fecha: $fecha, notas: $notas}';
  }
}

class EstadoServicio {
  final int? idEstado;
  final String descripcion;

  EstadoServicio({
    this.idEstado,
    required this.descripcion,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_estado': idEstado,
      'descripcion': descripcion,
    };
  }

  factory EstadoServicio.fromMap(Map<String, dynamic> map) {
    return EstadoServicio(
      idEstado: map['id_estado'],
      descripcion: map['descripcion'],
    );
  }

  EstadoServicio copyWith({
    int? idEstado,
    String? descripcion,
  }) {
    return EstadoServicio(
      idEstado: idEstado ?? this.idEstado,
      descripcion: descripcion ?? this.descripcion,
    );
  }

  @override
  String toString() {
    return 'EstadoServicio{idEstado: $idEstado, descripcion: $descripcion}';
  }
}

class Servicio {
  final int? idServicio;
  final String nombre;
  final DateTime fecha;
  final String? telefonoExtra;
  final String? detalles;
  final int estadoId;
  final int clienteId;
  final int personalId;

  Servicio({
    this.idServicio,
    required this.nombre,
    required this.fecha,
    this.telefonoExtra,
    this.detalles,
    required this.estadoId,
    required this.clienteId,
    required this.personalId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_servicio': idServicio,
      'nombre': nombre,
      'fecha': DateFormat('yyyy-MM-dd').format(fecha),
      'telefono_extra': telefonoExtra,
      'Detalles': detalles,
      'estado_id': estadoId,
      'cliente_id': clienteId,
      'personal_id': personalId,
    };
  }

  factory Servicio.fromMap(Map<String, dynamic> map) {
    return Servicio(
      idServicio: map['id_servicio'],
      nombre: map['nombre'],
      fecha: DateFormat('yyyy-MM-dd').parse(map['fecha']),
      telefonoExtra: map['telefono_extra'],
      detalles: map['Detalles'],
      estadoId: map['estado_id'],
      clienteId: map['cliente_id'],
      personalId: map['personal_id'],
    );
  }

  Servicio copyWith({
    int? idServicio,
    String? nombre,
    DateTime? fecha,
    String? telefonoExtra,
    String? detalles,
    int? estadoId,
    int? clienteId,
    int? personalId,
  }) {
    return Servicio(
      idServicio: idServicio ?? this.idServicio,
      nombre: nombre ?? this.nombre,
      fecha: fecha ?? this.fecha,
      telefonoExtra: telefonoExtra ?? this.telefonoExtra,
      detalles: detalles ?? this.detalles,
      estadoId: estadoId ?? this.estadoId,
      clienteId: clienteId ?? this.clienteId,
      personalId: personalId ?? this.personalId,
    );
  }

  @override
  String toString() {
    return 'Servicio{idServicio: $idServicio, nombre: $nombre, fecha: $fecha, telefonoExtra: $telefonoExtra, detalles: $detalles, estadoId: $estadoId, clienteId: $clienteId, personalId: $personalId}';
  }
}