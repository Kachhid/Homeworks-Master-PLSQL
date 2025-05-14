create or replace package payment_detail_api_pack
/*==============================================================================
Purpose: API для сущностей “Детали платежа”
Autor: Shatalin A.A.
Note:
Fix:
==============================================================================*/
is
    c_message_insert_or_update constant varchar2 (200 char) := 'Данные платежа добавлены или обновлены по списку id_поля/значение.';
    c_message_delete varchar2 (200 char) := 'Детали платежа удалены по списку id_полей.';

    c_message_error_field_is_null varchar2 (200 char) := 'Поле не может быть пустым';
    c_message_error_field_id_is_null varchar2 (200 char) := 'ID поля не может быть пустым.';
    c_message_error_field_value_is_null varchar2 (200 char) := 'Значение в поле не может быть пустым.';
    c_message_error_not_init_or_empty varchar2 (200 char) := 'Коллекция не инициализирована/содержит данных.';

    c_timestamp_format constant varchar2 (25 char) := 'dd.mm.yy hh24:mi:ss.ff6';

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
procedure insert_or_update_payment_detail
    (p_payment_id in payment.payment_id%type,
    p_payment_detail in t_payment_detail_array);

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
procedure delete_payment_detail
    (p_payment_id in payment.payment_id%type,
    p_payment_detail_field_ids in t_number_array);

end payment_detail_api_pack;