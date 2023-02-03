select * from rol

select * from USUARIO

select p.IdRol, p.NombreMenu from PERMISO p
inner join ROL r on r.IdRol = p.IdRol
inner join USUARIO u on u.IdRol = r.IdRol
where u.IdUsuario = 1



insert into USUARIO(Documento, NombreCompleto, Correo, Clave, IdRol, Estado) values 
('123456789', 'JuanPabloAdmin', 'jp.morgade@gmail.com', 'gallo1226', 1, 1)



update USUARIO set NombreCompleto = 'JuanPabloEmpleado' where NombreCompleto = 'JuanPabloAdmin'

/*
insert into PERMISO(IdRol, NombreMenu) values
(1, 'menuusuario'),
(1, 'menucontrolador'),
(1, 'menuventas'),
(1, 'menucompras'),
(1, 'menuclientes'),
(1, 'menuproveedor'),
(1, 'menureportes'),
(1, 'menuacercade')

insert into rol(Descripcion) values
('EMPLEADO')

insert into PERMISO(IdRol, NombreMenu) values
(2, 'menuventas'),
(2, 'menucompras'),
(2, 'menuclientes'),
(2, 'menuproveedor'),
(2, 'menuacercade') */

