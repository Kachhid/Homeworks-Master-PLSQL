/*==============================================================================
Автор: Shatalin A.A.
Описание скрипта: API для сущностей “Платеж” и “Детали платежа”
==============================================================================*/

-- Создание платежа
declare
    v_message varchar2 (200 char) := 'Платеж создан.';

    c_status_create constant payment.status%type := 0;

    v_payment_id payment.payment_id%type;
    v_create_dtime timestamp := systimestamp;
    v_summa payment.summa%type := 100;
    v_currency_id payment.currency_id%type := 643;
    v_from_client_id payment.from_client_id%type := 1;
    v_to_client_id payment.to_client_id%type := 2;

    v_payment_detail t_payment_detail_array := t_payment_detail_array
        (t_payment_detail (1, 'Google Chrome'),
        t_payment_detail (2, '127.0.0.1'));
begin
    if v_payment_detail is not empty then
        for i in v_payment_detail.first .. v_payment_detail.last
        loop
            if v_payment_detail(i).field_id is null then
                dbms_output.put_line ('ID поля не может быть пустым.');
            end if;
            if v_payment_detail(i).field_value is null then
                dbms_output.put_line ('Значение в поле не может быть пустым.');
            end if;
            dbms_output.put_line ('Field_id: ' || v_payment_detail(i).field_id || '. Field_value: ' || v_payment_detail(i).field_value);
        end loop;
    else
        dbms_output.put_line ('Коллекция не содержит данных.');
    end if;

    insert into payment
        (payment_id,
        create_dtime,
        summa,
        currency_id,
        from_client_id,
        to_client_id,
        status) 
    values
        (payment_seq.nextval,
        v_create_dtime,
        v_summa,
        v_currency_id,
        v_from_client_id,
        v_to_client_id,
        c_status_create)
    returning payment_id into v_payment_id;

    insert into payment_detail
        (payment_id,
        field_id,
        field_value) 
    select
        v_payment_id,
        field_id,
        field_value
    from table (v_payment_detail);

    commit;

    dbms_output.put_line (v_message || ' Статус: ' || c_status_create || '. ID платежа: ' || to_char (v_payment_id) || '. Дата создания платежа: ' || to_char (v_create_dtime, 'dd.mm.yy hh24:mi:ss.ff6'));
    dbms_output.put_line (null);
end;
/

-- Перевод платежа на статус "Ошибка"
declare
    v_message varchar2 (200 char) := 'Сброс платежа в "ошибочный статус" с указанием причины.';
    v_reason payment.status_change_reason%type :=  'Недостаточно средств.';

    c_status_create constant payment.status%type := 0;
    c_status_error constant payment.status%type := 2;

    v_payment_id payment.payment_id%type;
    v_ts_sys timestamp := systimestamp;
begin
    if v_payment_id is null then
        dbms_output.put_line ('ID платежа не может быть пустым.');
    end if;
    if v_reason is null then
        dbms_output.put_line ('Причина не может быть пустой.');
    end if;

    update payment p
    set
        p.status = c_status_error,
        p.status_change_reason = v_reason
    where
        p.payment_id = v_payment_id
        and p.status = c_status_create;

    if sql%rowcount = 0 then
        dbms_output.put_line ('Сброс платежа в "ошибочный статус" невозможен. Текущий статус платежа не "Создан".');
    end if;

    commit;

    dbms_output.put_line (v_message || ' Статус: ' || c_status_error || '. Причина: ' || v_reason || ' ID платежа: ' || to_char (v_payment_id) || '. Выполнено в: ' || to_char (v_ts_sys, 'dd.mm.yy hh24:mi:ss.ff6'));
    dbms_output.put_line (null);
end;
/

-- Перевод платежа на статус "Отмена"
declare
    v_message varchar2 (200 char) := 'Отмена платежа с указанием причины.';
    v_reason payment.status_change_reason%type :=  'Ошибка пользователя.';

    c_status_create constant payment.status%type := 0;
    c_status_cancel constant payment.status%type := 3;

    v_payment_id payment.payment_id%type := 1;
    v_ts_sys timestamp := systimestamp;
begin
    if v_payment_id is null then
        dbms_output.put_line ('ID платежа не может быть пустым.');
    end if;
    if v_reason is null then
        dbms_output.put_line ('Причина не может быть пустой.');
    end if;

    update payment p
    set
        p.status = c_status_cancel,
        p.status_change_reason = v_reason
    where
        p.payment_id = v_payment_id
        and p.status = c_status_create;

    if sql%rowcount = 0 then
        dbms_output.put_line ('Отмена платежа невозможна. Текущий статус платежа не "Создан".');
    end if;

    commit;

    dbms_output.put_line (v_message || ' Статус: ' || to_char (c_status_cancel) || '. Причина: ' || v_reason || ' ID платежа: ' || to_char (v_payment_id) || '. Выполнено в: ' || to_char (v_ts_sys, 'dd.mm.yy hh24:mi:ss.ff6'));
    dbms_output.put_line (null);
end;
/

-- Перевод платежа на статус "Успешно"
declare
    v_message varchar2 (200 char) := 'Успешное завершение платежа.';

    c_status_create constant payment.status%type := 0;
    c_status_success constant payment.status%type := 1;

    v_payment_id payment.payment_id%type := 100;
    v_ts_sys timestamp := systimestamp;
begin
    if v_payment_id is null then
        dbms_output.put_line ('ID платежа не может быть пустым.');
    end if;

    update payment p
    set
        p.status = c_status_success,
        p.status_change_reason = null
    where
        p.payment_id = v_payment_id
        and p.status = c_status_create;

    if sql%rowcount = 0 then
        dbms_output.put_line ('Отмена платежа невозможна. Текущий статус платежа не "Создан".');
    end if;

    commit;

    dbms_output.put_line (v_message || ' Статус: ' || to_char (c_status_success) || '. ID платежа: ' || to_char (v_payment_id) || '. Выполнено в: ' || to_char (v_ts_sys, 'dd.mm.yy hh24:mi:ss.ff6'));
    dbms_output.put_line (null);
end;
/

-- Обновление деталей платежа
declare
    v_message varchar2 (200 char) := 'Данные платежа добавлены или обновлены по списку id_поля/значение.';

    v_payment_id payment.payment_id%type := 3;
    v_ts_sys timestamp := systimestamp;

    v_payment_detail t_payment_detail_array := t_payment_detail_array
        (t_payment_detail (1, 'Android'),
        t_payment_detail (2, '8.8.8.8'),
        t_payment_detail (3, 'Премия за работу.'),
        t_payment_detail (4, 'Yes'));
begin
    if v_payment_id is null then
        dbms_output.put_line ('ID платежа не может быть пустым.');
    end if;

    if v_payment_detail is not empty then
        for i in v_payment_detail.first .. v_payment_detail.last
        loop
            if v_payment_detail(i).field_id is null then
                dbms_output.put_line ('ID поля не может быть пустым.');
            end if;
            if v_payment_detail(i).field_value is null then
                dbms_output.put_line ('Значение в поле не может быть пустым.');
            end if;
            dbms_output.put_line ('Field_id: ' || v_payment_detail(i).field_id || '. Field_value: ' || v_payment_detail(i).field_value);
        end loop;
    else
        dbms_output.put_line ('Коллекция не содержит данных.');
    end if;

    merge into payment_detail pd
    using
        (select
            v_payment_id as payment_id,
            value(t).field_id as field_id,
            value(t).field_value as field_value
        from table (v_payment_detail) t) t
    on
        (pd.payment_id = t.payment_id
        and pd.field_id = t.field_id)
    when matched then
        update set
            pd.field_value = t.field_value
    when not matched then
        insert
            (pd.payment_id,
            pd.field_id,
            pd.field_value)
        values
            (t.payment_id,
            t.field_id,
            t.field_value);

    commit;

    dbms_output.put_line (v_message || ' ID платежа: ' || to_char (v_payment_id)|| '. Выполнено в: ' || to_char (v_ts_sys, 'dd.mm.yy hh24:mi:ss.ff6'));
    dbms_output.put_line (null);
end;
/

-- Удаление деталей платежа
declare
    v_message varchar2 (200 char) := 'Детали платежа удалены по списку id_полей.';
    v_payment_id payment.payment_id%type := 3;
    v_ts_sys timestamp := systimestamp;
    v_payment_detail_field_ids t_number_array := t_number_array (3, 44, 127);
begin
    if v_payment_id is null then
        dbms_output.put_line ('ID платежа не может быть пустым.');
    end if;

    if v_payment_detail_field_ids is not empty then
        for i in v_payment_detail_field_ids.first .. v_payment_detail_field_ids.last
        loop
            if v_payment_detail_field_ids(i) is null then
                dbms_output.put_line ('ID поля не может быть пустым.');
            end if;
        end loop;
    else
        dbms_output.put_line ('Коллекция не содержит данных.');
    end if;

    delete from payment_detail pd
    where
        pd.PAYMENT_ID = v_payment_id
        and pd.FIELD_ID in
            (select t.column_value as field_id
            from table (v_payment_detail_field_ids) t);

    commit;

    dbms_output.put_line (v_message || ' ID платежа: ' || to_char (v_payment_id) || '. Количество удаляемых полей: ' || to_char (v_payment_detail_field_ids.count()) || '. Выполнено в: ' || to_char (v_ts_sys, 'dd.mm.yy hh24:mi:ss.ff6'));
    dbms_output.put_line (null);
end;
/