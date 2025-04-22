/*==============================================================================
Автор: Shatalin A.A.
Описание скрипта: API для сущностей “Платеж” и “Детали платежа”
==============================================================================*/

-- Создание платежа
declare
    v_message varchar2 (200 char) := 'Платеж создан';
    c_status_create number := 0;
    v_dt_sys timestamp := systimestamp;
begin
    dbms_output.put_line (v_message || '. Статус: ' || c_status_create);
    dbms_output.put_line (to_char (v_dt_sys, 'fmDay, Month dd, yyyy'));
end;
/

-- Перевод платежа на статус "Ошибка"
declare
    v_message varchar2 (200 char) := 'Сброс платежа в "ошибочный статус" с указанием причины';
    v_reason varchar2 (200 char) :=  'Недостаточно средств.';
    c_status_error number (10) := 2;
    v_ts_sys timestamp := systimestamp;
begin
    dbms_output.put_line (v_message || '. Статус: ' || c_status_error || '. Причина: ' || v_reason);
    dbms_output.put_line ('Выполнено в: ' || to_char (v_ts_sys, 'mm-dd-yy hh12:mi:ss PM'));
end;
/

-- Перевод платежа на статус "Отмена"
declare
    v_message varchar2 (200 char) := 'Отмена платежа с указанием причины';
    v_reason varchar2 (200 char) :=  'ошибка пользователя';
    c_status_cancel number (10) := 3;
    v_ts_sys timestamp := systimestamp;
begin
    dbms_output.put_line (v_message || '. Статус: ' || c_status_cancel || '. Причина: ' || v_reason);
    dbms_output.put_line ('Выполнено в: ' || to_char (v_ts_sys, 'dd.mon.yy hh24:mi:ss.ff'));
end;
/

-- Перевод платежа на статус "Успешно"
declare
    v_message varchar2 (200 char) := 'Успешное завершение платежа';
    c_status_success number (10) := 1;
    v_ts_sys timestamp := systimestamp;
begin
    dbms_output.put_line (v_message || '. Статус: ' || c_status_success);
    dbms_output.put_line ('Время на сервере: ' || to_char (v_ts_sys, 'yy.mm.dd hh24:mi:ss.ff6'));
end;
/

-- Обновление деталей платежа
declare
    v_message varchar2 (200 char) := 'Данные платежа добавлены или обновлены по списку id_поля/значение';
    v_dt_sys date := sysdate;
begin
    dbms_output.put_line (v_message);
    dbms_output.put_line ('Текущее время: ' || to_char (v_dt_sys, 'hh24:mi'));
end;
/

-- Удаление деталей платежа
declare
    v_message varchar2 (200 char) := 'Детали платежа удалены по списку id_полей';
    v_dt_sys date := sysdate;
begin
    dbms_output.put_line (v_message);
    dbms_output.put_line ('Текущий день: ' || trim (to_char (v_dt_sys, 'DAY')) || ' of ' || trim (to_char (v_dt_sys, 'MONTH')) || '.' || to_char (v_dt_sys, 'YY'));
end;
/