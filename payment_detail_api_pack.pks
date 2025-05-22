create or replace package payment_detail_api_pack
/*==============================================================================
Purpose: API для сущностей “Детали платежа”
Autor: Shatalin A.A.
Note:
Fix:
==============================================================================*/
is

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