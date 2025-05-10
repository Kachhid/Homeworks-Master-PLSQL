/*==============================================================================
Автор: Shatalin A.A.
Описание скрипта: API для сущностей “Платеж” и “Детали платежа”
==============================================================================*/

create or replace function create_payment
    (p_payment in t_payment,
    p_payment_detail in t_payment_detail_array)
return payment.payment_id%type
/*==============================================================================
Purpose: Создание платежа
Autor: Shatalin A.A.
Parameter:
Return: id платежа
Note:
Fix:
==============================================================================*/

is
    v_message varchar2 (200 char) := 'Платеж создан.';

    c_status_create constant payment.status%type := 0;

    v_payment_id payment.payment_id%type;
begin
    if p_payment.create_dtime is null then
        dbms_output.put_line ('Поле create_dtime не может быть пустым.');
    end if;
    if p_payment.summa is null then
        dbms_output.put_line ('Поле summa не может быть пустым.');
    end if;
    if p_payment.currency_id is null then
        dbms_output.put_line ('Поле currency_id не может быть пустым.');
    end if;
    if p_payment.from_client_id is null then
        dbms_output.put_line ('Поле from_client_id не может быть пустым.');
    end if;
    if p_payment.to_client_id is null then
        dbms_output.put_line ('Поле to_client_id не может быть пустым.');
    end if;

    if p_payment_detail is not empty then
        for i in p_payment_detail.first .. p_payment_detail.last
        loop
            if p_payment_detail(i).field_id is null then
                dbms_output.put_line ('ID поля не может быть пустым.');
            end if;
            if p_payment_detail(i).field_value is null then
                dbms_output.put_line ('Значение в поле не может быть пустым.');
            end if;
            dbms_output.put_line ('Field_id: ' || p_payment_detail(i).field_id || '. Field_value: ' || p_payment_detail(i).field_value);
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
        p_payment.create_dtime,
        p_payment.summa,
        p_payment.currency_id,
        p_payment.from_client_id,
        p_payment.to_client_id,
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
    from table (p_payment_detail);

    dbms_output.put_line (v_message || ' Статус: ' || c_status_create || '. ID платежа: ' || to_char (v_payment_id) || '. Дата создания платежа: ' || to_char (systimestamp, 'dd.mm.yy hh24:mi:ss.ff6'));
    dbms_output.put_line (null);

    return v_payment_id;
end create_payment;
/

create or replace procedure fail_payment
    (p_payment_id in payment.payment_id%type,
    p_reason in payment.status_change_reason%type)
/*==============================================================================
Purpose: Перевод платежа на статус "Ошибка".
Autor: Shatalin A.A.
Parameter:
    p_payment_id - id платежа;
    p_reason - причина ошибки платежа;
Return:
Note:
Fix:
==============================================================================*/
is
    v_message varchar2 (200 char) := 'Сброс платежа в "ошибочный статус" с указанием причины.';

    c_status_create constant payment.status%type := 0;
    c_status_error constant payment.status%type := 2;
begin
    if p_payment_id is null then
        dbms_output.put_line ('ID платежа не может быть пустым.');
    end if;
    if p_reason is null then
        dbms_output.put_line ('Причина не может быть пустой.');
    end if;

    update payment p
    set
        p.status = c_status_error,
        p.status_change_reason = p_reason
    where
        p.payment_id = p_payment_id
        and p.status = c_status_create;

    if sql%rowcount = 0 then
        dbms_output.put_line ('Сброс платежа в "ошибочный статус" невозможен. Текущий статус платежа не "Создан".');
    end if;

    dbms_output.put_line (v_message || ' Статус: ' || c_status_error || '. Причина: ' || p_reason || ' ID платежа: ' || to_char (p_payment_id) || '. Выполнено в: ' || to_char (systimestamp, 'dd.mm.yy hh24:mi:ss.ff6'));
    dbms_output.put_line (null);
end fail_payment;
/

create or replace procedure cancel_payment
    (p_payment_id in payment.payment_id%type,
    p_reason in payment.status_change_reason%type)
/*==============================================================================
Purpose: Перевод платежа на статус "Отмена".
Autor: Shatalin A.A.
Parameter:
    p_payment_id - id платежа;
    p_reason - причина отмены платежа;
Return:
Note:
Fix:
==============================================================================*/
is
    v_message varchar2 (200 char) := 'Отмена платежа с указанием причины.';

    c_status_create constant payment.status%type := 0;
    c_status_cancel constant payment.status%type := 3;
begin
    if p_payment_id is null then
        dbms_output.put_line ('ID платежа не может быть пустым.');
    end if;
    if p_reason is null then
        dbms_output.put_line ('Причина не может быть пустой.');
    end if;

    update payment p
    set
        p.status = c_status_cancel,
        p.status_change_reason = p_reason
    where
        p.payment_id = p_payment_id
        and p.status = c_status_create;

    if sql%rowcount = 0 then
        dbms_output.put_line ('Отмена платежа невозможна. Текущий статус платежа не "Создан".');
    end if;

    dbms_output.put_line (v_message || ' Статус: ' || to_char (c_status_cancel) || '. Причина: ' || p_reason || ' ID платежа: ' || to_char (p_payment_id) || '. Выполнено в: ' || to_char (systimestamp, 'dd.mm.yy hh24:mi:ss.ff6'));
    dbms_output.put_line (null);
end cancel_payment;
/

create or replace procedure successful_finish_payment
    (p_payment_id in payment.payment_id%type)
/*==============================================================================
Purpose: Перевод платежа на статус "Успешно".
Autor: Shatalin A.A.
Parameter:
    p_payment_id - id платежа;
Return:
Note:
Fix:
==============================================================================*/
is
    v_message varchar2 (200 char) := 'Успешное завершение платежа.';

    c_status_create constant payment.status%type := 0;
    c_status_success constant payment.status%type := 1;
begin
    if p_payment_id is null then
        dbms_output.put_line ('ID платежа не может быть пустым.');
    end if;

    update payment p
    set
        p.status = c_status_success,
        p.status_change_reason = null
    where
        p.payment_id = p_payment_id
        and p.status = c_status_create;

    if sql%rowcount = 0 then
        dbms_output.put_line ('Успешное завершение платежа невозможно. Текущий статус платежа не "Создан".');
    end if;

    dbms_output.put_line (v_message || ' Статус: ' || to_char (c_status_success) || '. ID платежа: ' || to_char (p_payment_id) || '. Выполнено в: ' || to_char (systimestamp, 'dd.mm.yy hh24:mi:ss.ff6'));
    dbms_output.put_line (null);
end successful_finish_payment;
/

create or replace procedure insert_or_update_payment_detail
    (p_payment_id in payment.payment_id%type,
    p_payment_detail in t_payment_detail_array)
/*==============================================================================
Purpose: Обновление деталей платежа.
Autor: Shatalin A.A.
Parameter:
    p_payment_id - id платежа;
    p_payment_detail - детади платежа;
Return:
Note:
Fix:
==============================================================================*/
is
    v_message varchar2 (200 char) := 'Данные платежа добавлены или обновлены по списку id_поля/значение.';
begin
    if p_payment_id is null then
        dbms_output.put_line ('ID платежа не может быть пустым.');
    end if;

    if p_payment_detail is not empty then
        for i in p_payment_detail.first .. p_payment_detail.last
        loop
            if p_payment_detail(i).field_id is null then
                dbms_output.put_line ('ID поля не может быть пустым.');
            end if;
            if p_payment_detail(i).field_value is null then
                dbms_output.put_line ('Значение в поле не может быть пустым.');
            end if;
            dbms_output.put_line ('Field_id: ' || p_payment_detail(i).field_id || '. Field_value: ' || p_payment_detail(i).field_value);
        end loop;
    else
        dbms_output.put_line ('Коллекция не содержит данных.');
    end if;

    merge into payment_detail pd
    using
        (select
            p_payment_id as payment_id,
            value(t).field_id as field_id,
            value(t).field_value as field_value
        from table (p_payment_detail) t) t
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

    dbms_output.put_line (v_message || ' ID платежа: ' || to_char (p_payment_id)|| '. Выполнено в: ' || to_char (systimestamp, 'dd.mm.yy hh24:mi:ss.ff6'));
    dbms_output.put_line (null);
end insert_or_update_payment_detail;
/

create or replace procedure delete_payment_detail
    (p_payment_id in payment.payment_id%type,
    p_payment_detail_field_ids in t_number_array)
/*==============================================================================
Purpose: Удаление деталей платежа.
Autor: Shatalin A.A.
Parameter:
    p_payment_id - id платежа;
    p_payment_detail_field_ids - id деталей платежа;
Return:
Note:
Fix:
==============================================================================*/
is
    v_message varchar2 (200 char) := 'Детали платежа удалены по списку id_полей.';
begin
    if p_payment_id is null then
        dbms_output.put_line ('ID платежа не может быть пустым.');
    end if;

    if p_payment_detail_field_ids is not empty then
        for i in p_payment_detail_field_ids.first .. p_payment_detail_field_ids.last
        loop
            if p_payment_detail_field_ids(i) is null then
                dbms_output.put_line ('ID поля не может быть пустым.');
            end if;
        end loop;
    else
        dbms_output.put_line ('Коллекция не содержит данных.');
    end if;

    delete from payment_detail pd
    where
        pd.payment_id = p_payment_id
        and pd.field_id in
            (select t.column_value as field_id
            from table (p_payment_detail_field_ids) t);

    dbms_output.put_line (v_message || ' ID платежа: ' || to_char (p_payment_id) || '. Количество удаляемых полей: ' || to_char (p_payment_detail_field_ids.count()) || '. Выполнено в: ' || to_char (systimestamp, 'dd.mm.yy hh24:mi:ss.ff6'));
    dbms_output.put_line (null);
end delete_payment_detail;
/