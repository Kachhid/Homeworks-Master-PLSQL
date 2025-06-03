create or replace package payment_api_pack
/*==============================================================================
Purpose: API для сущностей “Платеж”
Autor: Shatalin A.A.
Note:
Fix:
==============================================================================*/
is

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

/*==============================================================================
Purpose: Проверка прав на IU в payment.
Autor: Shatalin A.A.
Parameter:
Return:
Note:
Fix:
==============================================================================*/
procedure check_dml_rigths;

end payment_api_pack;