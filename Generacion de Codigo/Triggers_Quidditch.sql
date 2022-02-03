
-- ----------------------------------------------------
-- Functions
-- ----------------------------------------------------

-- Correo

CREATE OR REPLACE FUNCTION crear_email() RETURNS TRIGGER AS $example_table$
  BEGIN
    IF NEW.Correo IS NULL THEN
      NEW.Correo = REPLACE(CONCAT(NEW.Nombre,'@',TG_ARGV[0]), ' ', '');
    ELSIF NEW.Correo !~ '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$' THEN
      NEW.Correo = REPLACE(CONCAT(NEW.Nombre,'@',TG_ARGV[0]), ' ', '');
    END IF;
    RETURN NEW;
  END;
$example_table$ LANGUAGE plpgsql;

-- Dorsal

CREATE OR REPLACE FUNCTION comprobar_dorsal() RETURNS TRIGGER AS $example_table$
  BEGIN
    IF NEW.Dorsal IN (SELECT Dorsal FROM JUGADOR WHERE EQUIPO_Nombre_equipo = NEW.EQUIPO_Nombre_equipo) THEN
      RAISE NOTICE 'Ya existe un jugador con este dorsal en el equipo' ;
      RETURN NULL ;
    END IF;
    RETURN NEW;
  END;
$example_table$ LANGUAGE plpgsql;

-- DNI no existente

CREATE OR REPLACE FUNCTION comprobar_dni_no_existente_club() RETURNS TRIGGER AS $dni_no_existente_club$
  BEGIN
    IF NEW.DNI_PRESIDENTE = ANY (
      SELECT DNI FROM JUGADOR UNION
      SELECT DNI FROM PERSONAL UNION
      SELECT DNI FROM ARBITRO UNION
      SELECT DNI_PRESIDENTE FROM CLUB
    ) THEN
      RAISE NOTICE 'Este DNI ya existe en alguna tabla de la base de datos';
      RETURN NULL;
    ELSE
      RETURN NEW;
    END IF;
  END;
$dni_no_existente_club$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION comprobar_dni_no_existente() RETURNS TRIGGER AS $dni_no_existente$
  BEGIN
     IF NEW.DNI = ANY (
      SELECT DNI FROM JUGADOR UNION
      SELECT DNI FROM PERSONAL UNION
      SELECT DNI FROM ARBITRO UNION
      SELECT DNI_PRESIDENTE FROM CLUB
    ) THEN
      RAISE NOTICE 'Este DNI ya existe en alguna tabla de la base de datos';
      RETURN NULL;
    ELSE
      RETURN NEW;
    END IF;
  END;
$dni_no_existente$ LANGUAGE plpgsql;

-- Devolver si un equipo juega ese dia en otro lugar

CREATE OR REPLACE FUNCTION comprobar_equipo_misma_fecha_distinto_lugar(nombre_entrada varchar(45), fecha_entrada date, calle_entrada varchar(45), numero_entrada integer) RETURNS boolean AS $$
  DECLARE
    juega_en_otro_lugar boolean := false;
    n_partidos_iguales integer;
  BEGIN
    SELECT COUNT(*) into n_partidos_iguales FROM(
      SELECT EQUIPO_Nombre_equipo FROM NO_OFICIAL WHERE EQUIPO_Nombre_equipo = nombre_entrada AND fecha = fecha_entrada AND NOT (Calle = calle_entrada AND Numero_calle = numero_entrada)

      UNION ALL

      SELECT EQUIPO_Nombre_equipo FROM OFICIAL WHERE EQUIPO_Nombre_equipo = nombre_entrada AND fecha = fecha_entrada AND NOT (Calle = calle_entrada AND Numero_calle = numero_entrada)
    ) as Contador;
    IF n_partidos_iguales = 0 THEN
      RETURN false;
    ELSE
      RETURN true;
    END IF;
  END;
  $$ LANGUAGE plpgsql;

-- Devolver si un arbitro arbitra ese dia en otro lugar

CREATE OR REPLACE FUNCTION comprobar_arbitro_misma_fecha_distinto_lugar(nombre_entrada varchar(9), fecha_entrada date, calle_entrada varchar(45), numero_entrada integer) RETURNS boolean AS $$
  DECLARE
    juega_en_otro_lugar boolean := false;
    n_partidos_iguales integer;
  BEGIN
    SELECT COUNT(*) into n_partidos_iguales FROM(
      SELECT ARBITRO_DNI FROM NO_OFICIAL WHERE ARBITRO_DNI = nombre_entrada AND fecha = fecha_entrada AND NOT (Calle = calle_entrada AND Numero_calle = numero_entrada)

      UNION ALL

      SELECT ARBITRO_DNI FROM OFICIAL WHERE ARBITRO_DNI = nombre_entrada AND fecha = fecha_entrada AND NOT (Calle = calle_entrada AND Numero_calle = numero_entrada)
    ) as Contador;
    IF n_partidos_iguales = 0 THEN
      RETURN false;
    ELSE
      RETURN true;
    END IF;
  END;
  $$ LANGUAGE plpgsql;

-- Funcion que utiliza el trigger de comprobacion al insertar o actualizar partidos

CREATE OR REPLACE FUNCTION comprobar_partido() RETURNS TRIGGER AS $partidos$
  DECLARE
    partidos_iguales integer;
    arbitro_igual integer;
    partido_oficial OFICIAL%ROWTYPE;
  BEGIN
    --Comprobamos si un equipo juega ya ese mismo dia pero en otro lugar
    IF comprobar_equipo_misma_fecha_distinto_lugar(NEW.EQUIPO_Nombre_equipo, NEW.fecha, NEW.Calle, NEW.Numero_calle) THEN
      RAISE NOTICE 'Este equipo ya juega ese mismo dia';
      RETURN NULL;
    END IF;
    ----Comprobamos si el arbitro arbitra ya ese mismo dia pero en otro lugar
    IF comprobar_arbitro_misma_fecha_distinto_lugar(NEW.ARBITRO_DNI, NEW.Fecha, NEW.Calle, NEW.Numero_calle) THEN
      RAISE NOTICE 'Este arbitro ya esta asignado a otro partido en esa fecha';
      RETURN NULL;
    END IF;
    --Vemos cuantos partidos hay en esa fecha y lugar
    SELECT COUNT(*) into partidos_iguales FROM(
      SELECT EQUIPO_Nombre_equipo FROM NO_OFICIAL WHERE fecha = NEW.fecha AND Calle = NEW.Calle AND Numero_calle = NEW.Numero_calle

      UNION ALL

      SELECT EQUIPO_Nombre_equipo FROM OFICIAL WHERE fecha = NEW.fecha AND Calle = NEW.Calle AND Numero_calle = NEW.Numero_calle
    ) as Contador;
    -- Ningun partido se celebra ese dia en ese lugar
    IF partidos_iguales = 0 THEN
      RAISE NOTICE 'Ha insertado un solo equipo, recuerde insertar contrincante';
      RETURN NEW;
    -- Ya existe un partido juntos a sus dos equipos
    ELSIF partidos_iguales = 2 THEN
      RAISE NOTICE 'Ya existe un partido con sus dos equipos en esta fecha y lugar';
      RETURN NULL;
    ELSE
    -- Comprobamos que el arbitro es el mismo
      IF NEW.ARBITRO_DNI in (
        SELECT ARBITRO_DNI FROM NO_OFICIAL WHERE fecha = NEW.fecha AND Calle = NEW.Calle AND Numero_calle = NEW.Numero_calle

        UNION ALL

        SELECT ARBITRO_DNI FROM OFICIAL WHERE fecha = NEW.fecha AND Calle = NEW.Calle AND Numero_calle = NEW.Numero_calle
        ) THEN
          -- Vemos si el partido de entrada es oficial o no
          SELECT * INTO partido_oficial FROM OFICIAL
          WHERE fecha = NEW.fecha 
          AND Calle = NEW.Calle
          AND Numero_calle = NEW.Numero_calle;
          IF TG_ARGV[0] = 'OFICIAL' THEN
            IF NEW.LIGA_Año = partido_oficial.LIGA_Año AND NEW.LIGA_Nombre_liga = partido_oficial.LIGA_Nombre_liga AND NEW.ARBITRO_DNI = partido_oficial.ARBITRO_DNI THEN
              RETURN NEW;
            ELSE
              RAISE NOTICE 'Los partidos no coinciden en liga';
              RETURN NULL;
            END IF;
          --Comprobamos si el partido no oficial se juega con uno oficial
          ELSE
            IF partido_oficial.EQUIPO_Nombre_equipo IS NOT NULL THEN
              RAISE NOTICE 'Un partido no oficial no puede mezclarse con uno oficial';
            ELSE
              RETURN NEW;
            END IF;
          END IF;
      ELSE
        RAISE NOTICE 'Los arbitros no coinciden';
      END IF;
    END IF;
    RETURN NULL;
  END;
  $partidos$ LANGUAGE plpgsql;

-- ----------------------------------------------------
-- Triggers
-- ----------------------------------------------------

-- Correo

CREATE TRIGGER trigger_crear_email_before_insert_jugador BEFORE INSERT ON JUGADOR
FOR EACH ROW EXECUTE PROCEDURE crear_email('quidditch.jugador.es');

CREATE TRIGGER trigger_crear_email_before_update_jugador BEFORE UPDATE ON JUGADOR
FOR EACH ROW EXECUTE PROCEDURE crear_email('quidditch.jugador.es');

CREATE TRIGGER trigger_crear_email_before_insert_personal BEFORE INSERT ON PERSONAL
FOR EACH ROW EXECUTE PROCEDURE crear_email('quidditch.personal.es');

CREATE TRIGGER trigger_crear_email_before_update_personal BEFORE UPDATE ON PERSONAL
FOR EACH ROW EXECUTE PROCEDURE crear_email('quidditch.personal.es');

CREATE TRIGGER trigger_crear_email_before_insert_arbitro BEFORE INSERT ON ARBITRO
FOR EACH ROW EXECUTE PROCEDURE crear_email('quidditch.arbitro.es');

CREATE TRIGGER trigger_crear_email_before_update_arbitro BEFORE UPDATE ON ARBITRO
FOR EACH ROW EXECUTE PROCEDURE crear_email('quidditch.arbitro.es');

-- Dorsal

CREATE TRIGGER trigger_comprobar_dorsal_before_insert_jugador BEFORE INSERT ON JUGADOR
FOR EACH ROW EXECUTE PROCEDURE comprobar_dorsal();

CREATE TRIGGER trigger_comprobar_dorsal_before_update_jugador BEFORE UPDATE ON JUGADOR
FOR EACH ROW EXECUTE PROCEDURE comprobar_dorsal();

-- Partido

CREATE TRIGGER trigger_comprobar_oficial_before_insert_oficial BEFORE INSERT ON OFICIAL
FOR EACH ROW EXECUTE PROCEDURE comprobar_partido('OFICIAL');

CREATE TRIGGER trigger_comprobar_oficial_before_update_oficial BEFORE UPDATE ON OFICIAL
FOR EACH ROW EXECUTE PROCEDURE comprobar_partido('OFICIAL');

CREATE TRIGGER trigger_comprobar_no_oficial_before_insert_no_oficial BEFORE INSERT ON NO_OFICIAL
FOR EACH ROW EXECUTE PROCEDURE comprobar_partido('NO_OFICIAL');

CREATE TRIGGER trigger_comprobar_no_oficial_before_update_no_oficial BEFORE UPDATE ON NO_OFICIAL
FOR EACH ROW EXECUTE PROCEDURE comprobar_partido('NO_OFICIAL');

-- DNI no existente

CREATE TRIGGER trigger_comprobar_dni_no_existente_before_insert_jugador BEFORE INSERT ON JUGADOR
FOR EACH ROW EXECUTE PROCEDURE comprobar_dni_no_existente();

CREATE TRIGGER trigger_comprobar_dni_no_existente_before_update_jugador BEFORE UPDATE ON JUGADOR
FOR EACH ROW EXECUTE PROCEDURE comprobar_dni_no_existente();

CREATE TRIGGER trigger_comprobar_dni_no_existente_before_insert_personal BEFORE INSERT ON PERSONAL
FOR EACH ROW EXECUTE PROCEDURE comprobar_dni_no_existente();

CREATE TRIGGER trigger_comprobar_dni_no_existente_before_update_personal BEFORE UPDATE ON PERSONAL
FOR EACH ROW EXECUTE PROCEDURE comprobar_dni_no_existente();

CREATE TRIGGER trigger_comprobar_dni_no_existente_before_insert_arbitro BEFORE INSERT ON ARBITRO
FOR EACH ROW EXECUTE PROCEDURE comprobar_dni_no_existente();

CREATE TRIGGER trigger_comprobar_dni_no_existente_before_update_arbitro BEFORE UPDATE ON ARBITRO
FOR EACH ROW EXECUTE PROCEDURE comprobar_dni_no_existente();

CREATE TRIGGER trigger_comprobar_dni_no_existente_before_insert_club BEFORE INSERT ON CLUB
FOR EACH ROW EXECUTE PROCEDURE comprobar_dni_no_existente_club();

CREATE TRIGGER trigger_comprobar_dni_no_existente_before_update_club BEFORE UPDATE ON CLUB
FOR EACH ROW EXECUTE PROCEDURE comprobar_dni_no_existente_club();
