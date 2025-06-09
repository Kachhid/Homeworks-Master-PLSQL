create or replace package common_pack
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
    pragma exception_init (e_invalid_input_parameter, e_invalid_input_parameter_code);

    e_invalid_collection exception;
    e_invalid_collection_code constant number (5) := -20003;
    e_invalid_collection_message constant varchar2 (200 char) := 'Коллекция не инициализирована или содержит данных.';
    pragma exception_init (e_invalid_collection, e_invalid_collection_code);

    e_invalid_collection_field_id exception;
    e_invalid_collection_field_id_code constant number (5) := -20004;
    e_invalid_collection_field_id_message constant varchar2 (200 char) := 'ID поля не может быть пустым.';
    pragma exception_init (e_invalid_collection_field_id, e_invalid_collection_field_id_code);

    e_invalid_collection_field_value exception;
    e_invalid_collection_field_value_code constant number (5) := -20005;
    e_invalid_collection_field_value_message constant varchar2 (200 char) := 'Значение в поле не может быть пустым.';
    pragma exception_init (e_invalid_collection_field_value, e_invalid_collection_field_value_code);

    e_invalid_operation exception;
    e_invalid_operation_code constant number (5) := -20006;
    e_invalid_operation_message constant varchar2 (200 char) := 'Данная операция запрещена.';
    pragma exception_init (e_invalid_operation, e_invalid_operation_code);

    e_invalid_operation_api exception;
    e_invalid_operation_api_code constant number (5) := -20007;
    e_invalid_operation_api_message constant varchar2 (200 char) := 'Данная операция запрещена (используйте API).';
    pragma exception_init (e_invalid_operation_api, e_invalid_operation_api_code);

    e_inactive_object exception;
    e_inactive_object_code constant number (5) := -20008;
    e_inactive_object_message constant varchar2 (200 char) := 'Объект в конечном статусе. Изменения невозможны.';
    pragma exception_init (e_inactive_object, e_inactive_object_code);

    e_object_notfound exception;
    e_object_notfound_code constant number (5) := -20009;
    e_object_notfound_message constant varchar2 (200 char) := 'Объект не найден.';
    pragma exception_init (e_object_notfound, e_object_notfound_code);

    e_object_already_locked exception;
    e_object_already_locked_code constant number (5) := -20009;
    e_object_already_locked_message constant varchar2 (200 char) := 'Объект уже заблокирован.';
    pragma exception_init (e_object_already_locked, e_object_already_locked_code);

    e_row_locked exception;
    pragma exception_init (e_row_locked, -00054);

    e_other exception;
    e_other_code constant number (5) := -20100;
    e_other_message constant varchar2 (200 char) := 'Непредвиденная ошибка.';

/*==============================================================================
Purpose: Разрешение изменений (IUD)
Autor: Shatalin A.A.
Parameter:
Return:
Note: Для прямых изменений в payment и payment_detail.
Fix:
==============================================================================*/
procedure enable_manual_changes;

/*==============================================================================
Purpose: Запрет изменений (IUD)
Autor: Shatalin A.A.
Parameter:
Return:
Note: Для прямых изменений в payment и payment_detail.
Fix:
==============================================================================*/
procedure disable_manual_changes;

/*==============================================================================
Purpose: Проверка возможности изменений (IUD)
Autor: Shatalin A.A.
Parameter:
Return:
Note: Для прямых изменений в payment и payment_detail.
Fix:
==============================================================================*/
function is_manual_changes_allowed return boolean;

end common_pack;