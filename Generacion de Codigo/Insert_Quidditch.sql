-- -----------------------------------------------------
-- Data for table CLUB
-- -----------------------------------------------------
START TRANSACTION;

INSERT INTO CLUB (Nombre_club, Calle, Numero_calle, DNI_Presidente, Telefono) VALUES ('Real Club Quidditch Anaga', 'Av. Marítima San Andrés', 6, '42347568R', 651248932);
INSERT INTO CLUB (Nombre_club, Calle, Numero_calle, DNI_Presidente, Telefono) VALUES ('Club Deportivo de Quidditch Tejina', 'Calle el Drago', 14, '43297832B', 641284691);
INSERT INTO CLUB (Nombre_club, Calle, Numero_calle, DNI_Presidente, Telefono) VALUES ('Club de Quidditch Las Escobitas', 'Calle el Pozo', 19, '44235883Y', 645981674);
INSERT INTO CLUB (Nombre_club, Calle, Numero_calle, DNI_Presidente, Telefono) VALUES ('Las Americas Quidditch Club', 'Av. de Chayofita', 54, '73256293C', 684512364);

-- Esta inserción falla, el dni ya existe en otro club
INSERT INTO CLUB (Nombre_club, Calle, Numero_calle, DNI_Presidente, Telefono) VALUES ('Asosiación Deportiva de Quidditch Las Arenas', 'Calle del calvario', 26, '42347568R', 615876489);

COMMIT;


-- -----------------------------------------------------
-- Data for table EQUIPO
-- -----------------------------------------------------
START TRANSACTION;

INSERT INTO EQUIPO (Nombre_equipo, CLUB_Nombre_club, Logotipo, Categoria, Acronimo) VALUES ('Anaga Quidditch Juvenil', 'Real Club Quidditch Anaga', NULL, 'Juvenil', 'ANQ');
INSERT INTO EQUIPO (Nombre_equipo, CLUB_Nombre_club, Logotipo, Categoria, Acronimo) VALUES ('Las Escobitas Senior', 'Club de Quidditch Las Escobitas', NULL, 'Senior', 'LEJ');
INSERT INTO EQUIPO (Nombre_equipo, CLUB_Nombre_club, Logotipo, Categoria, Acronimo) VALUES ('Little Americans', 'Las Americas Quidditch Club', NULL, 'Infantil', 'LA');
INSERT INTO EQUIPO (Nombre_equipo, CLUB_Nombre_club, Logotipo, Categoria, Acronimo) VALUES ('Quidditch Tejina Juventud', 'Club Deportivo de Quidditch Tejina', NULL, 'Juvenil', 'QTJ');

COMMIT;


-- -----------------------------------------------------
-- Data for table JUGADOR
-- -----------------------------------------------------
START TRANSACTION;

INSERT INTO JUGADOR (DNI, EQUIPO_Nombre_equipo, Nombre, Correo, Dorsal, Rol, Salario) VALUES ('45615216H', 'Las Escobitas Senior', 'Hector Gutierrez', 'rgutierrez@correo.com', 11, 'Buscador', 100);
INSERT INTO JUGADOR (DNI, EQUIPO_Nombre_equipo, Nombre, Correo, Dorsal, Rol, Salario) VALUES ('45541252V', 'Las Escobitas Senior', 'Alejandro Rijo', 'arijo@correo.com', 13, 'Guardian', 100);
INSERT INTO JUGADOR (DNI, EQUIPO_Nombre_equipo, Nombre, Correo, Dorsal, Rol, Salario) VALUES ('25441263C', 'Anaga Quidditch Juvenil', 'Cristo Salvador', 'csalvador@correo.com', 5, 'Guardian', 50);
INSERT INTO JUGADOR (DNI, EQUIPO_Nombre_equipo, Nombre, Correo, Dorsal, Rol, Salario) VALUES ('47512634T', 'Anaga Quidditch Juvenil', 'Enrique Potter', 'epotter@correo.com', 7, 'Buscador', 50);
INSERT INTO JUGADOR (DNI, EQUIPO_Nombre_equipo, Nombre, Correo, Dorsal, Rol, Salario) VALUES ('26758842G', 'Quidditch Tejina Juventud', 'Elena Weasley', 'ewisli@correo.com', 28, 'Cazador', 30);
INSERT INTO JUGADOR (DNI, EQUIPO_Nombre_equipo, Nombre, Correo, Dorsal, Rol, Salario) VALUES ('24454815U', 'Quidditch Tejina Juventud', 'Gabriel Muggle', 'grabi@correo.com', 3, 'Golpeador', 30);
INSERT INTO JUGADOR (DNI, EQUIPO_Nombre_equipo, Nombre, Correo, Dorsal, Rol, Salario) VALUES ('48795677P', 'Las Escobitas Senior', 'Ermayoni Watson', NULL, 19, 'Buscador', 150);
INSERT INTO JUGADOR (DNI, EQUIPO_Nombre_equipo, Nombre, Correo, Dorsal, Rol, Salario) VALUES ('11773399T', 'Quidditch Tejina Juventud', 'Ron Watson', NULL, 19, 'Buscador', 150);
INSERT INTO JUGADOR (DNI, EQUIPO_Nombre_equipo, Nombre, Correo, Dorsal, Rol, Salario) VALUES ('19482635U', 'Quidditch Tejina Juventud', 'Harry Parker', NULL, 19, 'Buscador', 400);

-- Esta inserción falla, el dni ya existe en un presidente de club
INSERT INTO JUGADOR (DNI, EQUIPO_Nombre_equipo, Nombre, Correo, Dorsal, Rol, Salario) VALUES ('44235883Y', 'Las Escobitas Senior', 'Crisitano Peraza', 'crperaza@correo.com', 42, 'Cazador', 460);

-- Esta actualización falla, el dni ya existe en otro jugador
UPDATE JUGADOR SET DNI = '45541252V' WHERE DNI = '25441263C';

COMMIT;


-- -----------------------------------------------------
-- Data for table PERSONAL
-- -----------------------------------------------------
START TRANSACTION;

INSERT INTO PERSONAL (DNI, EQUIPO_Nombre_equipo, Nombre, Correo, Puesto, Salario) VALUES ('35412561U', 'Las Escobitas Senior', 'Isabel Sanchez', 'isanchez@correo.com', 'Entrenador', 26400);
INSERT INTO PERSONAL (DNI, EQUIPO_Nombre_equipo, Nombre, Correo, Puesto, Salario) VALUES ('84512634N', 'Anaga Quidditch Juvenil', 'Pablo Ruiz', 'pruiz@correo.com', 'Entrenador', 25800);
INSERT INTO PERSONAL (DNI, EQUIPO_Nombre_equipo, Nombre, Correo, Puesto, Salario) VALUES ('11223344O', 'Quidditch Tejina Juventud', 'Paco Perez', NULL, 'Entrenador', 25000);

-- Esta inserción falla, el dni ya existe en JUGADOR
INSERT INTO PERSONAL (DNI, EQUIPO_Nombre_equipo, Nombre, Correo, Puesto, Salario) VALUES ('47512634T', 'Las Escobitas Senior', 'Enrique Potter', 'epotter@correo.com', 'Entrenador', 24200);

COMMIT;


-- -----------------------------------------------------
-- Data for table EMPRESA
-- -----------------------------------------------------
START TRANSACTION;

INSERT INTO EMPRESA (CIF, Nombre, Correo) VALUES ('29348527T', 'Universidad de La Laguna', 'universidadlalaguna@correo.com');
INSERT INTO EMPRESA (CIF, Nombre, Correo) VALUES ('83743957J', 'Fuentealta', 'fuentealta@correo.com');
INSERT INTO EMPRESA (CIF, Nombre, Correo) VALUES ('32513689T', 'Asociacion de Deportes Canarios', 'adeportescanarios@correo.com');
INSERT INTO EMPRESA (CIF, Nombre, Correo) VALUES ('78593875R', 'Federacion Canaria de Quidditch', 'fedcanariaquidditch@correo.com');

COMMIT;


-- -----------------------------------------------------
-- Data for table ARBITRO
-- -----------------------------------------------------
START TRANSACTION;

INSERT INTO ARBITRO (DNI, Salario, Correo, Nombre) VALUES ('46751265H', 30000, 'psanchiz@correo.com', 'Pedro Sanchis');
INSERT INTO ARBITRO (DNI, Salario, Correo, Nombre) VALUES ('92657435E', 29850, 'pmilkkelses@correo.com', 'Peter Mikkelsen');
INSERT INTO ARBITRO (DNI, Salario, Correo, Nombre) VALUES ('97667435L', 29800, NULL, 'Juan Roberto');

-- Esta inserción falla, el dni ya existe como otro árbitro
INSERT INTO ARBITRO (DNI, Salario, Correo, Nombre) VALUES ('46751265H', 35000, NULL, 'Pedro Sanchis');

COMMIT;


-- -----------------------------------------------------
-- Data for table NO_OFICIAL
-- -----------------------------------------------------
START TRANSACTION;

INSERT INTO NO_OFICIAL (Calle, Numero_calle, Fecha, EQUIPO_Nombre_equipo, ARBITRO_DNI) VALUES ('Calle Luis Lavaggi', 2, '20/12/2021', 'Las Escobitas Senior', '46751265H');
INSERT INTO NO_OFICIAL (Calle, Numero_calle, Fecha, EQUIPO_Nombre_equipo, ARBITRO_DNI) VALUES ('Avenida Arquitecto Gómez Cuesta', 17, '27/12/2021', 'Little Americans', '92657435E');
INSERT INTO NO_OFICIAL (Calle, Numero_calle, Fecha, EQUIPO_Nombre_equipo, ARBITRO_DNI) VALUES ('Calle Luis Lavaggi', 2, '20/12/2021', 'Quidditch Tejina Juventud', '46751265H');
INSERT INTO NO_OFICIAL (Calle, Numero_calle, Fecha, EQUIPO_Nombre_equipo, ARBITRO_DNI) VALUES ('Avenida Arquitecto Gómez Cuesta', 17, '27/12/2021', 'Anaga Quidditch Juvenil', '92657435E');

COMMIT;


-- -----------------------------------------------------
-- Data for table LIGA
-- -----------------------------------------------------
START TRANSACTION;

INSERT INTO LIGA (Año, Nombre_liga, EMPRESA_CIF) VALUES (2022, 'Liga Canaria de Quidditch', '32513689T');
INSERT INTO LIGA (Año, Nombre_liga, EMPRESA_CIF) VALUES (2021, 'Liga Canaria de Quidditch', '32513689T');
INSERT INTO LIGA (Año, Nombre_liga, EMPRESA_CIF) VALUES (2022, 'Liga Segunda División de Quidditch', '78593875R');

COMMIT;


-- -----------------------------------------------------
-- Data for table OFICIAL
-- -----------------------------------------------------
START TRANSACTION;

INSERT INTO OFICIAL (Calle, Numero_calle, Fecha, LIGA_Año, LIGA_Nombre_liga, EQUIPO_Nombre_equipo, ARBITRO_DNI) VALUES ('Calle Dr. Fernando Barajas Prat', 1, '28/01/2022', 2022, 'Liga Canaria de Quidditch', 'Las Escobitas Senior', '46751265H');
INSERT INTO OFICIAL (Calle, Numero_calle, Fecha, LIGA_Año, LIGA_Nombre_liga, EQUIPO_Nombre_equipo, ARBITRO_DNI) VALUES ('Calle Arquitecto Gomez Cuesta', 17, '04/02/2022', 2022, 'Liga Canaria de Quidditch', 'Las Escobitas Senior', '46751265H');
INSERT INTO OFICIAL (Calle, Numero_calle, Fecha, LIGA_Año, LIGA_Nombre_liga, EQUIPO_Nombre_equipo, ARBITRO_DNI) VALUES ('Playa Las Teresitas', 73, '29/01/2022', 2022, 'Liga Canaria de Quidditch', 'Anaga Quidditch Juvenil', '92657435E');
INSERT INTO OFICIAL (Calle, Numero_calle, Fecha, LIGA_Año, LIGA_Nombre_liga, EQUIPO_Nombre_equipo, ARBITRO_DNI) VALUES ('Avenda Milan', 27, '05/02/2022', 2022, 'Liga Canaria de Quidditch', 'Anaga Quidditch Juvenil', '92657435E');
INSERT INTO OFICIAL (Calle, Numero_calle, Fecha, LIGA_Año, LIGA_Nombre_liga, EQUIPO_Nombre_equipo, ARBITRO_DNI) VALUES ('Calle Dr. Fernando Barajas Prat', 1, '28/01/2022', 2022, 'Liga Canaria de Quidditch', 'Little Americans', '46751265H');
INSERT INTO OFICIAL (Calle, Numero_calle, Fecha, LIGA_Año, LIGA_Nombre_liga, EQUIPO_Nombre_equipo, ARBITRO_DNI) VALUES ('Calle Arquitecto Gomez Cuesta', 17, '04/02/2022', 2022, 'Liga Canaria de Quidditch', 'Little Americans', '46751265H');
INSERT INTO OFICIAL (Calle, Numero_calle, Fecha, LIGA_Año, LIGA_Nombre_liga, EQUIPO_Nombre_equipo, ARBITRO_DNI) VALUES ('Playa Las Teresitas', 73, '29/01/2022', 2022, 'Liga Canaria de Quidditch', 'Quidditch Tejina Juventud', '92657435E');
INSERT INTO OFICIAL (Calle, Numero_calle, Fecha, LIGA_Año, LIGA_Nombre_liga, EQUIPO_Nombre_equipo, ARBITRO_DNI) VALUES ('Avenida Milan', 27, '05/02/2022', 2022, 'Liga Canaria de Quidditch', 'Quidditch Tejina Juventud', '92657435E');
INSERT INTO OFICIAL (Calle, Numero_calle, Fecha, LIGA_Año, LIGA_Nombre_liga, EQUIPO_Nombre_equipo, ARBITRO_DNI) VALUES ('Avenida Milan', 27, '05/02/2022', 2022, 'Liga Canaria de Quidditch', 'Little Americans', '92657435E');

COMMIT;


-- -----------------------------------------------------
-- Data for table EMPRESA_patrocina_LIGAD
-- -----------------------------------------------------
START TRANSACTION;

INSERT INTO EMPRESA_patrocina_LIGA (PATROCINADOR_CIF, LIGA_Año, LIGA_Nombre_liga, Inversion) VALUES ('29348527T', 2022, 'Liga Canaria de Quidditch', 5000);
INSERT INTO EMPRESA_patrocina_LIGA (PATROCINADOR_CIF, LIGA_Año, LIGA_Nombre_liga, Inversion) VALUES ('83743957J', 2022, 'Liga Segunda División de Quidditch', 15000);
INSERT INTO EMPRESA_patrocina_LIGA (PATROCINADOR_CIF, LIGA_Año, LIGA_Nombre_liga, Inversion) VALUES ('32513689T', 2022, 'Liga Canaria de Quidditch', 25000);
INSERT INTO EMPRESA_patrocina_LIGA (PATROCINADOR_CIF, LIGA_Año, LIGA_Nombre_liga, Inversion) VALUES ('78593875R', 2022, 'Liga Segunda División de Quidditch', 13000);
INSERT INTO EMPRESA_patrocina_LIGA (PATROCINADOR_CIF, LIGA_Año, LIGA_Nombre_liga, Inversion) VALUES ('32513689T', 2021, 'Liga Canaria de Quidditch', 17500);
INSERT INTO EMPRESA_patrocina_LIGA (PATROCINADOR_CIF, LIGA_Año, LIGA_Nombre_liga, Inversion) VALUES ('29348527T', 2021, 'Liga Canaria de Quidditch', 35000);

COMMIT;