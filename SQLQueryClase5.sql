select u.IdUsuario,u.Documento,u.NombreCompleto,u.Correo,u.Clave,u.Estado, r.IdRol, r.Descripcion from usuario u
inner join rol r on r.IdRol = u.IdRol


update USUARIO set estado = 0 where IdUsuario = 2


select * from USUARIO

create proc SP_REGISTRARUSUARIO(
@Documento varchar(50),
@NombreCompleto varchar(100),
@Correo varchar(100),
@Clave varchar(100),
@IdRol int,
@Estado bit,
@IdUsuarioResultado int output,
@Mensaje varchar(500) output

)
as
begin
	set @IdUsuarioResultado = 0
	set @Mensaje = ''

	if not exists(select * from USUARIO where Documento = @Documento)
	begin
			insert into usuario(Documento, NombreCompleto, Correo, Clave, IdRol, Estado)values
			(@Documento, @NombreCompleto, @Correo, @Clave, @IdRol, @Estado)

			set @IdUsuarioResultado = SCOPE_IDENTITY()
	end
	else
		set @Mensaje = 'No se puede repetir el Documento para mas de un Usuario'

end



declare @idusuariogenerado int
declare @mensaje varchar(500)

exec SP_REGISTRARUSUARIO '123', 'pruebas', 'test@gmail.com', '456', 2, 1, @idusuariogenerado output, @mensaje output

select @idusuariogenerado

select @mensaje

//------------------------------

go

create proc SP_EDITARUSUARIO(
@IdUsuario int,
@Documento varchar(50),
@NombreCompleto varchar(100),
@Correo varchar(100),
@Clave varchar(100),
@IdRol int,
@Estado bit,
@Respuesta bit output,
@Mensaje varchar(500) output

)
as
begin
	set @Respuesta = 0
	set @Mensaje = ''

	if not exists(select * from USUARIO where Documento = @Documento and IdUsuario != @IdUsuario)
	begin
			update usuario set
			Documento = @Documento, 
			NombreCompleto = @NombreCompleto, 
			Correo = @Correo, 
			Clave = @Clave, 
			IdRol = @IdRol, 
			Estado = @Estado
			where IdUsuario = @IdUsuario


			set @Respuesta = 1
	end
	else
		set @Mensaje = 'No se puede repetir el Documento para mas de un Usuario'

end





declare @respuesta bit
declare @mensaje varchar(500)

exec SP_EDITARUSUARIO 5, '123', 'pruebas 2', 'test@gmail.com', '456', 2, 1, @respuesta output, @mensaje output

select @respuesta

select @mensaje


select * from USUARIO

//-----------------------------------------



go

create proc SP_ELIMINARUSUARIO(
@IdUsuario int,
@Respuesta bit output,
@Mensaje varchar(500) output

)
as
begin
	set @Respuesta = 0
	set @Mensaje = ''
	declare @pasoregla bit = 1

	if exists (select * from COMPRA C
		inner join USUARIO U on U.IdUsuario = C.IdUsuario
		where U.IdUsuario = @IdUsuario
	)
	begin
		set @pasoregla = 0
		set @Respuesta = 0
		set @Mensaje = @Mensaje + 'No se puede eliminar el Usuario Porque se encuentra relacionado a una COMPRA\n'
	end


	if exists (select * from VENTA V
		inner join USUARIO U on U.IdUsuario = V.IdUsuario
		where U.IdUsuario = @IdUsuario
	)
	begin
		set @pasoregla = 0
		set @Respuesta = 0
		set @Mensaje = @Mensaje + 'No se puede eliminar el Usuario Porque se encuentra relacionado a una VENTA\n'
	end

	if(@pasoregla = 1)
	begin
		delete from USUARIO where IdUsuario = @IdUsuario
		set @Respuesta = 1
	end

end


/*----------------------------- PROCEDIMIENTOS PARA CATEGORIA------------------------------------------------*/

CREATE PROCEDURE SP_RegistrarCategoria(
@Descripcion varchar(50),
@Resultado int output,
@Mensaje varchar(500) output
)as
begin
	SET @Resultado = 0
	if not exists (SELECT * from CATEGORIA where Descripcion = @Descripcion)
	begin
		insert into CATEGORIA(Descripcion) values (@Descripcion)
		set @Resultado = SCOPE_IDENTITY()
	end
	ELSE
		set @Mensaje = @Mensaje + 'No se puede repetir La Descripcion de una Categoria\n'
end

go

CREATE PROCEDURE sp_EditarCategoriaa(
@IdCategoria int,
@Descripcion varchar(50),
@Resultado bit output,
@Mensaje varchar(500) output
)as
begin
	SET @Resultado = 1
	if not exists (SELECT * from CATEGORIA where Descripcion = @Descripcion and IdCategoria != @IdCategoria)
		update CATEGORIA set
			Descripcion = @Descripcion
			where IdCategoria = @IdCategoria
	ELSE
	begin
		SET @Resultado = 0
		set @Mensaje = 'No se puede repetir La Descripcion de una Categoria\n'
	end
		
end

go

CREATE PROCEDURE sp_EliminarCategoriaa(
@IdCategoria int,
@Resultado bit output,
@Mensaje varchar(500) output
)as
begin
	SET @Resultado = 1
	if not exists (
	select * from CATEGORIA c
	inner join PRODUCTO p on p.IdCategoria = c.IdCategoria
	where c.IdCategoria = @IdCategoria
	)begin
		delete top(1) from CATEGORIA where IdCategoria = @IdCategoria
	end
		
	ELSE
	begin
		SET @Resultado = 0
		set @Mensaje = 'La Categoria se encuentra Relacionada a un producto\n'
	end
		
end


/*----------------------------- FIN PROCEDIMIENTOS PARA CATEGORIA------------------------------------------------*/


select IdCategoria, Descripcion, Estado from CATEGORIA

select * from CATEGORIA

insert into CATEGORIA(Descripcion, Estado) VALUES('Lacteos', 1)
insert into CATEGORIA(Descripcion, Estado) VALUES('Embutidos', 1)
insert into CATEGORIA(Descripcion, Estado) VALUES('Enlatados', 1)

update CATEGORIA set Estado = 1

/*----------------------------- PROCEDIMIENTOS PARA CATEGORIA------------------------------------------------*/

alter PROCEDURE SP_RegistrarCategoria(
@Descripcion varchar(50),
@Estado bit,
@Resultado int output,
@Mensaje varchar(500) output
)as
begin
	SET @Resultado = 0
	if not exists (SELECT * from CATEGORIA where Descripcion = @Descripcion)
	begin
		insert into CATEGORIA(Descripcion, Estado) values (@Descripcion, @Estado)
		set @Resultado = SCOPE_IDENTITY()
	end
	ELSE
		set @Mensaje = @Mensaje + 'No se puede repetir La Descripcion de una Categoria\n'
end

go

alter PROCEDURE sp_EditarCategoriaa(
@IdCategoria int,
@Estado bit,
@Descripcion varchar(50),
@Resultado bit output,
@Mensaje varchar(500) output
)as
begin
	SET @Resultado = 1
	if not exists (SELECT * from CATEGORIA where Descripcion = @Descripcion and IdCategoria != @IdCategoria)
		update CATEGORIA set
			Descripcion = @Descripcion,
			Estado = @Estado
			where IdCategoria = @IdCategoria
	ELSE
	begin
		SET @Resultado = 0
		set @Mensaje = 'No se puede repetir La Descripcion de una Categoria\n'
	end
		
end

go

CREATE PROCEDURE sp_EliminarCategoriaa(
@IdCategoria int,
@Resultado bit output,
@Mensaje varchar(500) output
)as
begin
	SET @Resultado = 1
	if not exists (
	select * from CATEGORIA c
	inner join PRODUCTO p on p.IdCategoria = c.IdCategoria
	where c.IdCategoria = @IdCategoria
	)begin
		delete top(1) from CATEGORIA where IdCategoria = @IdCategoria
	end
		
	ELSE
	begin
		SET @Resultado = 0
		set @Mensaje = 'La Categoria se encuentra Relacionada a un producto\n'
	end
		
end


/*----------------------------- FIN PROCEDIMIENTOS PARA CATEGORIA------------------------------------------------*/



/*----------------------------- PROCEDIMIENTOS PARA CLIENTES ----------------------------------------------------------*/

CREATE PROC SP_RegistrarCliente(
@Documento varchar(50),
@NombreCompleto varchar(50),
@Correo varchar(50),
@Telefono varchar(50),
@Estado bit,
@Resultado int output,
@Mensaje varchar(500) output
)as
begin
	SET @Resultado = 0
	Declare @IDPERSONA int
	if not exists (Select * From CLIENTE where Documento = @Documento)
	begin
		insert into CLIENTE(Documento, NombreCompleto, Correo, Telefono, Estado)values(
		@Documento, @NombreCompleto, @Correo, @Telefono, @Estado)

		set @Resultado = SCOPE_IDENTITY()
	end
	else
		set @Mensaje = 'El Numero de documento ya Existe'
end

go

Create Proc SP_ModificarCliente(
@IdCliente int,
@Documento varchar(50),
@NombreCompleto varchar(50),
@Correo varchar(50),
@Telefono varchar(50),
@Estado bit,
@Resultado bit output,
@Mensaje varchar(500) output
)as
begin
	SET @Resultado = 1
	Declare @IDPERSONA int
	if not exists (Select * From CLIENTE Where Documento = @Documento and IdCliente != @IdCliente)
	begin
		update CLIENTE set
		Documento = @Documento,
		NombreCompleto = @NombreCompleto,
		Correo = @Correo,
		Telefono = @Telefono,
		Estado = @Estado
		where IdCliente = @IdCliente
	end
	else
	begin
		SET @Resultado = 0
		set @Mensaje = 'El numero de documento ya existe'
	end
end


select IdCliente, Documento, NombreCompleto, Correo, Telefono, Estado from CLIENTE



/*----------------------------- FIN PROCEDIMIENTOS PARA CLIENTES ----------------------------------------------------------*/



/*----------------------------- PROCEDIMIENTOS PARA PROVEEDOR ----------------------------------------------------------*/
Create Proc sp_RegistrarProveedor(
@Documento varchar(50),
@RazonSocial varchar(50),
@Correo varchar(50),
@Telefono varchar(50),
@Estado bit,
@Resultado int output,
@Mensaje varchar(500) output
)as
begin
	SET @Resultado = 0
	DECLARE @IDPERSONA INT
	if not exists (Select * From PROVEEDOR where Documento = @Documento)
	begin
		insert into PROVEEDOR(Documento, RazonSocial, Correo, Telefono, Estado) values (
		@Documento, @RazonSocial, @Correo, @Telefono, @Estado)

		set @Resultado =SCOPE_IDENTITY()
	end
	else
		set @Mensaje = 'El Numero de documento ya existe'
end

go

Create Proc SP_ModificarProveedor(
@IdProveedor int,
@Documento varchar(50),
@RazonSocial varchar(50),
@Correo varchar(50),
@Telefono varchar(50),
@Estado bit,
@Resultado bit output,
@Mensaje varchar(500) output
)as
begin
	SET @Resultado = 1
	Declare @IDPERSONA int
	if not exists(Select * from PROVEEDOR where Documento = @Documento and IdProveedor != @IdProveedor)
	begin
		update PROVEEDOR set
		Documento = @Documento,
		RazonSocial = @RazonSocial,
		Correo = @Correo,
		Telefono = @Telefono,
		Estado = @Estado
		where IdProveedor = @IdProveedor
	end
	else
	begin
		set @Resultado = 0
		set @Mensaje = 'El Numero de Documento ya Existe'
	end
end

go

Create Procedure sp_EliminarProveedor(
@IdProveedor int,
@Resultado int output,
@Mensaje varchar(500) output
)as
begin
	set @Resultado = 1
	if not exists(
		select * from PROVEEDOR p
		inner join COMPRA c on p.IdProveedor = c.IdProveedor
		where p.IdProveedor = @IdProveedor
	)
	begin
		delete top(1) from PROVEEDOR where IdProveedor = @IdProveedor
	end
	ELSE
	begin
		set @Resultado = 0
		set @Mensaje = 'El Proveedor se encuentra relacionado a una compra'
	end
end

select * from PROVEEDOR

select IdProveedor, Documento, RazonSocial, Correo, Telefono, Estado from PROVEEDOR


/*----------------------------- FIN PROCEDIMIENTOS PARA PROVEEDOR ----------------------------------------------------------*/

/*----------------------------- PROCEDIMIENTOS PARA Tablas PDF ----------------------------------------------------------*/

create table NEGOCIO(
IdNegocio int primary key,
Nombre varchar(60),
RUC varchar(60),
Direccion varchar(60),
Logo varbinary(max) NULL
)

select * from NEGOCIO

insert into NEGOCIO(IdNegocio, Nombre, RUC, Direccion) values (1, 'Codigo Estudiante', '101010', 'av. codigo 123')


/*----------------------------- FIN PROCEDIMIENTOS PARA Tablas PDF ----------------------------------------------------------*/

/*----------------------------- PROCESOS PARA REGISTRAR UNA COMPRA ----------------------------------------------------------*/
CREATE TYPE [dbo].[EDetalle_Compra] AS TABLE (
[IdProducto] int NULL,
[PrecioCompra] decimal(18,2) NULL,
[PrecioVenta] decimal (18,2) NULL,
[Cantidad] int NULL,
[MontoTotal] decimal(18,2) NULL
)


CREATE PROCEDURE sp_RegistrarCompra(
	@IdUsuario int
	@IdProveedor int,
	@TipoDocumento varchar(500),
	@NumeroDocumento varchar(500),
	@MontoTotal decimal (18,2),
	@DetalleCompra [EDetalle_Compra] READONLY,
	@Resultado bit output,
	@Mensaje varchar(500) output
)
as
begin
	begin try
		declare @idcompra int = 0
		set @Resultado = 1
		set @Mensaje = ''

		begin transaction registro
			insert into COMPRA (IdUsuario, IdProveedor, TipoDocumento, NumeroDocumento, MontoTotal)
			values(@IdUsuario, @IdProveedor, @TipoDocumento, @NumeroDocumento, @MontoTotal)

			set @idcompra = SCOPE_IDENTITY()

			insert into DETALLE_COMPRA(IdCompra, IdProducto, PrecioCompra, PrecioVenta, Cantidad, MontoTotal)
			select @idcompra,IdProducto,PrecioCompra,PrecioVenta,Cantidad,MontoTotal from @DetalleCompra

			update p set p.Stock = p.Stock + dc.Cantidad,
			p.PrecioCompra = dc.PrecioCompra,
			p.PrecioVenta = dc.PrecioVenta
			from PRODUCTO p
			inner join @DetalleCompra dc on dc.IdProducto = p.IdProducto 

		commit transaction registro

	end try
	begin catch
		set @Resultado = 0
		set @Mensaje = ERROR_MESSAGE()
		rollback transaction registro 
	end catch
end


/*----------------------------- FIN PROCESOS PARA REGISTRAR UNA COMPRA ----------------------------------------------------------*/

/*-----------------------------PROCESOS PARA REGISTRAR UNA COMPRA ----------------------------------------------------------*/
CREATE TYPE [dbo].[EDetalle_Venta] AS TABLE(
	[IdProducto] int NULL,
	[PrecioVenta] decimal(18,2) NULL,
	[CANTIDAD] int NULL,
	[SubTotal] decimal(18,2) NULL
)




CREATE PROCEDURE sp_RegistrarVenta(
	@IdUsuario int,
	@TipoDocumento varchar(500),
	@NumeroDocumento varchar(500),
	@DocumentoCliente varchar(500),
	@NombreCliente varchar(500),
	@MontoPago decimal (18,2),
	@MontoCambio decimal (18,2),
	@MontoTotal decimal (18,2),
	@DetalleVenta [EDetalle_Venta] READONLY,
	@Resultado bit output,
	@Mensaje varchar(500) output
)
as
begin
	begin try
		declare @idventa int = 0
		set @Resultado = 1
		set @Mensaje = ''

		begin transaction registro
			insert into VENTA (IdUsuario, TipoDocumento, NumeroDocumento, DocumentoCliente, NombreCliente, MontoPago, MontoCambio,MontoTotal)
			values(@IdUsuario, @TipoDocumento, @NumeroDocumento, @DocumentoCliente, @NombreCliente, @MontoPago, @MontoCambio, @MontoTotal)

			set @idventa = SCOPE_IDENTITY()

			insert into DETALLE_VENTA(IdVenta, IdProducto, PrecioVenta,Cantidad, SubTotal)
			select @idventa,IdProducto,PrecioVenta,Cantidad,SubTotal from @DetalleVenta

			commit transaction registro

	end try
	begin catch
		set @Resultado = 0
		set @Mensaje = ERROR_MESSAGE()
		rollback transaction registro 
	end catch
end

select * from VENTA where NumeroDocumento = '00001'
select * from DETALLE_VENTA where IdVenta = 1

/*----------------------------- FIN PROCESOS PARA REGISTRAR UNA COMPRA ----------------------------------------------------------*/

select v.IdVenta, u.NombreCompleto,
v.DocumentoCliente, v.NombreCliente,
v.TipoDocumento, v.NumeroDocumento,
v.MontoPago, v.MontoCambio, v.MontoTotal,
convert(char(10), v.FechaRegistro, 103)[FechaRegistro]
from VENTA v
inner join USUARIO u on u.IdUsuario = v.IdUsuario
where v.NumeroDocumento = '00001'


select p.Nombre, dv.PrecioVenta, dv.Cantidad, dv.SubTotal
from DETALLE_VENTA dv
inner join PRODUCTO p on p.IdProducto = dv.IdProducto
where dv.IdVenta = 1