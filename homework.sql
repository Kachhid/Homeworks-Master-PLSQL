/*==============================================================================
Автор: Shatalin A.A.
Описание скрипта: API для сущностей “Платеж” и “Детали платежа”
==============================================================================*/

-- Создание платежа
declare
    v_message varchar2 (200 char) := 'Платеж создан.';
    c_status_create constant payment.status%type := 0;
    v_payment_id payment.payment_id%type;
    v_payment_detail t_payment_detail_array := t_payment_detail_array
        (t_payment_detail (1, 'Google Chrome'),
        t_payment_detail (2, '127.0.0.1'));
    v_dt_sys timestamp := systimestamp;
begin
    dbms_output.put_line (v_message || ' Статус: ' || c_status_create || '. ID платежа: ' || to_char (v_payment_id));
    dbms_output.put_line (to_char (v_dt_sys, 'fmDay, Month dd, yyyy'));
    dbms_output.put_line (null);
end;
/

-- Перевод платежа на статус "Ошибка"
declare
    v_message varchar2 (200 char) := 'Сброс платежа в "ошибочный статус" с указанием причины.';
    v_reason payment.status_change_reason%type :=  'Недостаточно средств.';
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
    dbms_output.put_line (v_message || ' Статус: ' || c_status_error || '. Причина: ' || v_reason || ' ID платежа: ' || to_char (v_payment_id));
    dbms_output.put_line ('Выполнено в: ' || to_char (v_ts_sys, 'mm-dd-yy hh12:mi:ss PM'));
    dbms_output.put_line (null);
end;
/

-- Перевод платежа на статус "Отмена"
declare
    v_message varchar2 (200 char) := 'Отмена платежа с указанием причины.';
    v_reason payment.status_change_reason%type :=  'Ошибка пользователя.';
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
    dbms_output.put_line (v_message || ' Статус: ' || to_char (c_status_cancel) || '. Причина: ' || v_reason || ' ID платежа: ' || to_char (v_payment_id));
    dbms_output.put_line ('Выполнено в: ' || to_char (v_ts_sys, 'dd.mon.yy hh24:mi:ss.ff'));
    dbms_output.put_line (null);
end;
/

-- Перевод платежа на статус "Успешно"
declare
    v_message varchar2 (200 char) := 'Успешное завершение платежа.';
    c_status_success constant payment.status%type := 1;
    v_payment_id payment.payment_id%type := 100;
    v_ts_sys timestamp := systimestamp;
begin
    if v_payment_id is null then
        dbms_output.put_line ('ID платежа не может быть пустым.');
    end if;
    dbms_output.put_line (v_message || ' Статус: ' || to_char (c_status_success) || '. ID платежа: ' || to_char (v_payment_id));
    dbms_output.put_line ('Время на сервере: ' || to_char (v_ts_sys, 'yy.mm.dd hh24:mi:ss.ff6'));
    dbms_output.put_line (null);
end;
/

-- Обновление деталей платежа
declare
    v_message varchar2 (200 char) := 'Данные платежа добавлены или обновлены по списку id_поля/значение.';
    v_payment_id payment.payment_id%type;
    v_dt_sys date := sysdate;
    v_payment_detail t_payment_detail_array := t_payment_detail_array
        (t_payment_detail (1, 'Android'),
        t_payment_detail (2, '8.8.8.8'),
        t_payment_detail (3, 'Премия за работу.'),
        t_payment_detail (4, 'Yes'));
begin
    if v_payment_id is null then
        dbms_output.put_line ('ID платежа не может быть пустым.');
    end if;
    dbms_output.put_line (v_message || ' ID платежа: ' || to_char (v_payment_id));
    dbms_output.put_line ('Текущее время: ' || to_char (v_dt_sys, 'hh24:mi'));
    dbms_output.put_line (null);
end;
/

-- Удаление деталей платежа
declare
    v_message varchar2 (200 char) := 'Детали платежа удалены по списку id_полей.';
    v_payment_id payment.payment_id%type := 3;
    v_dt_sys date := sysdate;
    v_payment_ids t_number_array := t_number_array (3, 44, 127);
begin
    if v_payment_id is null then
        dbms_output.put_line ('ID платежа не может быть пустым.');
    end if;
    dbms_output.put_line (v_message || ' ID платежа: ' || to_char (v_payment_id));
    dbms_output.put_line ('Текущий день: ' || trim (to_char (v_dt_sys, 'DAY')) || ' of ' || trim (to_char (v_dt_sys, 'MONTH')) || '.' || to_char (v_dt_sys, 'YY'));
    dbms_output.put_line (null);
end;
/