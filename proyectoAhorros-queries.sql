-- ==========================================================
-- ARCHIVO: miproyecto-queries.sql
-- ESTE FICHERO CONTIENE LA INTELIGENCIA: FUNCIONES, PROCS Y TRIGGERS
-- ==========================================================

-- 1. FUNCIONES
-- ----------------------------------------------------------

DELIMITER //

CREATE FUNCTION estabilidad(id int) RETURNS int
    DETERMINISTIC
begin
    declare mov int;
    declare ing int;
    declare puntos int;
    if exists (select 1 from USUARIO u where u.id_usuario=id) then 
        SELECT count(*) as movimientos, 
        (select count(*) from TRANSACCION t2 where t2.id_usuario = t.id_usuario
        and t2.tipo like 'ingreso')
        into mov, ing
        from TRANSACCION t 
        where t.id_usuario = id;
        
        if(mov=ing) then 
            set puntos = 100;
        elseif(ing=0 or mov=0) then 
            set puntos=0;
        else 
            set puntos=(ing/mov)*100;
        end if;
    else 
        signal sqlstate '45000'
        set message_text = 'Error, el usuario no existe';
    end if;
    return puntos;
end //

CREATE FUNCTION meta_cercana(id int) RETURNS int
    DETERMINISTIC
begin
    declare metaProx int;
    if exists (select 1 from USUARIO u where u.id_usuario=id) then 
        select ma.id_meta 
        into metaProx
        from METAS_AHORRO ma 
        where (ma.cantidad_ahorrar-ma.cantidad_actual) =(
        select min((ma2.cantidad_ahorrar-ma2.cantidad_actual)) as resta
        from METAS_AHORRO ma2
        where ma2.estado != 'acabado' and ma2.id_usuarioCreador =id)
        and ma.id_usuarioCreador = id
        limit 1;
        
        if metaProx is null then 
            set metaProx = -1;
        end if;
    else 
        signal sqlstate '45000'
        set message_text='El usuario no existe';
    end if;
    return metaProx;
end //

DELIMITER ;

-- 2. PROCEDIMIENTOS
-- ----------------------------------------------------------

DELIMITER //

CREATE PROCEDURE actualizarTop_metasTerminadas()
begin
    delete from top_ganadores;
    insert into top_ganadores(id_usuario, metas_acabadas)
    select uma.idUsuario, count(*) as metas_acabadas
    from usuarios_metasAcabadas uma
    group by uma.idUsuario
    order by count(*) desc
    limit 3;
end //

CREATE PROCEDURE dar_marca()
begin
    declare idA int;
    declare cursorF boolean default false; 
    declare cursor_anio cursor for select u.id_usuario from USUARIO u;
    declare continue handler for not found set cursorF = true; 
    
    open cursor_anio;
    fin: loop
        fetch cursor_anio into idA;
        if cursorF = true then
            leave fin;
        end if;
        update USUARIO u set u.nombre_usuario = concat(u.nombre_usuario,'_1') 
        where (datediff(now(),u.fecha_nacimiento)/365)>30 and u.id_usuario=idA;
    end loop fin;
    close cursor_anio;
end //

CREATE PROCEDURE perfil_usuario(in id int)
begin
    declare puntos int;
    declare metaProx int;
    declare mensaje varchar(255);
    declare metas varchar(150);
    if exists(select 1 from USUARIO u where u.id_usuario = id) then 
        set puntos=estabilidad(id);
        set metaProx=meta_cercana(id);
        if(metaProx=-1) then 
            set metas='no hay metas que terminar';
        else 
            set metas=concat('la meta más proxima que tienes que acabar es ', metaProx);
        end if;

        if puntos >=70 then 
            set mensaje=concat('eres un ahorrador de elite. ', metas);
        elseif puntos between 30 and 70 then 
            set mensaje=concat('vas por buen camino. ', metas);
        else 
            set mensaje=concat('necesitas mejorar. ', metas);
        end if;
        select mensaje;
    else 
        signal sqlstate '45000'
        set message_text='Error, el usuario no existe';
    end if; 
end //

DELIMITER ;

-- 3. TRIGGERS
-- ----------------------------------------------------------

DELIMITER //

CREATE TRIGGER tg_historial_consejos BEFORE UPDATE ON CONSEJO FOR EACH ROW 
begin
    declare numeroCambios int;
    if exists (select 1 from USUARIO u where u.id_usuario=old.id_usuarioPublica) then 
        select count(*)
        into numeroCambios
        from historial_cambios ca
        where ca.idConsejo=old.id_consejo; -- IMPORTANTE: Contar cambios del consejo
        
        if numeroCambios < 3 then 
            if(new.contenido != old.contenido) then 
                insert into historial_cambios(idUsuario, idConsejo, contenido, fecha)
                values(old.id_usuarioPublica, old.id_consejo, old.contenido, curdate());
            else 
                signal sqlstate '45000'
                set message_text='El contenido nuevo es igual al anterior';
            end if;
        else 
            signal sqlstate '45000'
            set message_text='Límite alcanzado: No se puede actualizar más de 3 veces';
        end if;
    else 
        signal sqlstate '45000'
        set message_text='Error: El autor no existe';
    end if; 
end //

CREATE TRIGGER metas_acabadas AFTER INSERT ON TRANSACCION FOR EACH ROW 
begin
    declare cantidadActual decimal(15,2);
    declare cantidadAhorrar decimal(15,2);

    select ma.cantidad_actual, ma.cantidad_ahorrar
        into cantidadActual, cantidadAhorrar
        from METAS_AHORRO ma
        where ma.id_meta=new.id_meta;
    
    if new.tipo like 'ingreso' then 
        update METAS_AHORRO ma set ma.cantidad_actual = ma.cantidad_actual + new.cantidad
        where ma.id_meta = new.id_meta;

        if cantidadAhorrar <= (cantidadActual + new.cantidad) then
            insert into usuarios_metasAcabadas(idUsuario, idMeta, cantidadF) 
            values(new.id_usuario, new.id_meta, cantidadActual + new.cantidad);
            update METAS_AHORRO ma set ma.estado = 'acabado' where ma.id_meta = new.id_meta;
            call actualizarTop_metasTerminadas();
        end if;
    else 
        if cantidadActual - new.cantidad >= 0 then 
            update METAS_AHORRO ma set ma.cantidad_actual = ma.cantidad_actual - new.cantidad
            where ma.id_meta = new.id_meta;
        else 
            signal sqlstate '45000'
            set message_text='Error, estás retirando más de lo que puedes';
        end if;
    end if;
end //

DELIMITER ;