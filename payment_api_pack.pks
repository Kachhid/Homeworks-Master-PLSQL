create or replace package payment_api_pack
/*==============================================================================
Purpose: API для сущностей “Платеж”
Autor: Shatalin A.A.
Note:
Fix:
==============================================================================*/
is
    type t_status is record
        (status payment.status%type,
        message varchar2 (200 char));

    c_status_create constant t_status := t_status (0, 'Платеж создан.');
    c_status_success constant t_status := t_status (1, 'Успешное завершение платежа.');
    c_status_error constant t_status := t_status (2, 'Сброс платежа в "ошибочный статус" с указанием причины.');
    c_status_cancel constant t_status := t_status (3, 'Отмена платежа с указанием причины.');

    c_message_error_field_is_null varchar2 (200 char) := 'Поле не может быть пустым';
    c_message_error_payment_not_on_status_created varchar2 (200 char) := 'Ошибка, текущий статус платежа не "Создан".';

    c_timestamp_format constant varchar2 (25 char) := 'dd.mm.yy hh24:mi:ss.ff6';

/*==============================================================================
Purpose: Создание платежа
Autor: Shatalin A.A.
Parameter:
Return: id платежа
Note:
Fix:
==============================================================================*/
function create_payment
    (p_payment in t_payment,
    p_payment_detail in t_payment_detail_array)
return payment.payment_id%type;

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
procedure fail_payment
    (p_payment_id in payment.payment_id%type,
    p_reason in payment.status_change_reason%type);

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
procedure cancel_payment
    (p_payment_id in payment.payment_id%type,
    p_reason in payment.status_change_reason%type);

/*==============================================================================
Purpose: Перевод платежа на статус "Успешно".
Autor: Shatalin A.A.
Parameter:
    p_payment_id - id платежа;
Return:
Note:
Fix:
==============================================================================*/
procedure successful_finish_payment
    (p_payment_id in payment.payment_id%type);

end payment_api_pack;