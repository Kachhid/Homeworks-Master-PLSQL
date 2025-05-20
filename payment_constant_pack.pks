create or replace package payment_constant_pack
/*==============================================================================
Purpose: Константы для сущностей “Платеж” и “Детали платежа”
Autor: Shatalin A.A.
Note:
Fix:
==============================================================================*/
is

    c_timestamp_format constant varchar2 (25 char) := 'dd.mm.yy hh24:mi:ss.ff6';

    type t_status is record
        (status payment.status%type,
        message varchar2 (200 char));

    c_status_create constant t_status := t_status (0, 'Платеж создан.');
    c_status_success constant t_status := t_status (1, 'Успешное завершение платежа.');
    c_status_error constant t_status := t_status (2, 'Сброс платежа в "ошибочный статус" с указанием причины.');
    c_status_cancel constant t_status := t_status (3, 'Отмена платежа с указанием причины.');

    c_message_insert_or_update constant varchar2 (200 char) := 'Данные платежа добавлены или обновлены по списку id_поля/значение';
    c_message_delete constant varchar2 (200 char) := 'Детали платежа удалены по списку id_полей';

    c_message_error_field_is_null constant varchar2 (200 char) := 'Поле не может быть пустым';

    e_invalid_input_parameter exception;
    e_invalid_input_parameter_code constant number (5) := -20001;
    e_invalid_input_parameter_message constant varchar2 (200 char) := 'Недопустимый входной параметр.';

    e_invalid_payment_status exception;
    e_invalid_payment_status_code constant number (5) := -20002;
    e_invalid_payment_status_message constant varchar2 (200 char) := 'Недопустимый текущий статус платежа (не "Создан")';

    e_invalid_collection exception;
    e_invalid_collection_code constant number (5) := -20003;
    e_invalid_collection_message constant varchar2 (200 char) := 'Коллекция не инициализирована или содержит данных.';

    e_invalid_collection_field_id exception;
    e_invalid_collection_field_id_code constant number (5) := -20004;
    e_invalid_collection_field_id_message constant varchar2 (200 char) := 'ID поля не может быть пустым.';

    e_invalid_collection_field_value exception;
    e_invalid_collection_field_value_code constant number (5) := -20005;
    e_invalid_collection_field_value_message constant varchar2 (200 char) := 'Значение в поле не может быть пустым.';

    e_other exception;
    e_other_code constant number (5) := -20100;
    e_other_message constant varchar2 (200 char) := 'Непредвиденная ошибка.';

end payment_constant_pack;