/*==============================================================================
Автор: Shatalin A.A.
Описание скрипта: API для сущностей “Платеж” и “Детали платежа”
==============================================================================*/

-- Создание платежа
declare
    v_message varchar2(200) := 'Платеж создан';
    c_status_create number := 0;
begin
    dbms_output.put_line (v_message || '. Статус: ' || c_status_create);
end;
/

-- Перевод платежа на 2 статус
declare
    v_message varchar2(200) := 'Сброс платежа в "ошибочный статус" с указанием причины';
    v_reason varchar2(200) :=  'недостаточно средств';
    c_status_error number := 2;
begin
    dbms_output.put_line (v_message || '. Статус: ' || c_status_error || '. Причина: ' || v_reason);
end;
/

-- Перевод платежа на 3 статус
declare
    v_message varchar2(200) := 'Отмена платежа с указанием причины';
    v_reason varchar2(200) :=  'ошибка пользователя';
    c_status_cancel number := 3;
begin
    dbms_output.put_line (v_message || '. Статус: ' || c_status_cancel || '. Причина: ' || v_reason);
end;
/

-- Перевод платежа на 1 статус
declare
    v_message varchar2(200) := 'Успешное завершение платежа';
    c_status_success number := 1;
begin
    dbms_output.put_line (v_message || '. Статус: ' || c_status_success);
end;
/

-- Обновление деталей платежа
declare
    v_message varchar2(200) := 'Данные платежа добавлены или обновлены по списку id_поля/значение';
begin
    dbms_output.put_line (v_message);
end;
/

-- Удаление деталей платежа
declare
    v_message varchar2(200) := 'Детали платежа удалены по списку id_полей';
begin
    dbms_output.put_line (v_message);
end;
/