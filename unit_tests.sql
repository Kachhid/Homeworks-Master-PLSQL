/*==============================================================================
Тест "Создание платежа" (payment_api_pack.create_payment)
==============================================================================*/

-- успех
declare
    v_payment t_payment := t_payment (systimestamp, 100, 643, 1, 2);
    v_payment_detail t_payment_detail_array := t_payment_detail_array
        (t_payment_detail (1, 'Google Chrome'),
        t_payment_detail (2, '127.0.0.1'));

    v_payment_id payment.payment_id%type;
begin
    v_payment_id := payment_api_pack.create_payment (p_payment => v_payment, p_payment_detail => v_payment_detail);
    dbms_output.put_line ('v_payment_id -> ' || to_char (v_payment_id));
end;

-- v_payment_detail
declare
    v_payment t_payment := t_payment (systimestamp, 100, 643, 1, 2);
    v_payment_detail t_payment_detail_array := t_payment_detail_array();

    v_payment_id payment.payment_id%type;
begin
    v_payment_id := payment_api_pack.create_payment (p_payment => v_payment, p_payment_detail => v_payment_detail);
    dbms_output.put_line ('v_payment_id -> ' || to_char (v_payment_id));
end;

-- v_payment (summa)
declare
    v_payment t_payment := t_payment (systimestamp, null, 643, 1, 2);
    v_payment_detail t_payment_detail_array := t_payment_detail_array
        (t_payment_detail (1, 'Google Chrome'),
        t_payment_detail (2, '127.0.0.1'));

    v_payment_id payment.payment_id%type;
begin
    v_payment_id := payment_api_pack.create_payment (p_payment => v_payment, p_payment_detail => v_payment_detail);
    dbms_output.put_line ('v_payment_id -> ' || to_char (v_payment_id));
end;

/*==============================================================================
Тест "Перевод платежа на статус "Ошибка"" (payment_api_pack.fail_payment)
==============================================================================*/
begin
    payment_api_pack.fail_payment (p_payment_id => 22, p_reason => 'Недостаточно средств.');
    payment_api_pack.fail_payment (p_payment_id => null, p_reason => 'Недостаточно средств.');
    payment_api_pack.fail_payment (p_payment_id => null, p_reason => null);
end;

/*==============================================================================
Тест "Перевод платежа на статус "Отмена"" (payment_api_pack.cancel_payment)
==============================================================================*/
begin
    payment_api_pack.cancel_payment (p_payment_id => 1, p_reason => 'Ошибка пользователя.');
    payment_api_pack.cancel_payment (p_payment_id => 2, p_reason => null);
    payment_api_pack.cancel_payment (p_payment_id => null, p_reason => 'Ошибка пользователя.');
end;

/*==============================================================================
Тест "Перевод платежа на статус "Успешно"" (payment_api_pack.successful_finish_payment)
==============================================================================*/
begin
    payment_api_pack.successful_finish_payment (p_payment_id => 51);
    payment_api_pack.successful_finish_payment (p_payment_id => 100);
    payment_api_pack.successful_finish_payment (p_payment_id => null);
end;

/*==============================================================================
Тест "Обновление деталей платежа" (payment_detail_api_pack.insert_or_update_payment_detail)
==============================================================================*/

-- успех
declare
    v_payment_id payment.payment_id%type := 5;
    v_payment_detail t_payment_detail_array := t_payment_detail_array
        (t_payment_detail (1, 'Android'),
        t_payment_detail (2, '8.8.8.8'),
        t_payment_detail (3, 'Премия за работу.'),
        t_payment_detail (4, 'Yes'));
begin
    payment_detail_api_pack.insert_or_update_payment_detail (p_payment_id => v_payment_id, p_payment_detail => v_payment_detail);
end;

-- v_payment_detail
declare
    v_payment_id payment.payment_id%type := 6;
    v_payment_detail t_payment_detail_array := t_payment_detail_array ();
begin
    payment_detail_api_pack.insert_or_update_payment_detail (p_payment_id => v_payment_id, p_payment_detail => v_payment_detail);
end;

-- v_payment_detail 2
declare
    v_payment_id payment.payment_id%type := 6;
    v_payment_detail t_payment_detail_array;
begin
    payment_detail_api_pack.insert_or_update_payment_detail (p_payment_id => v_payment_id, p_payment_detail => v_payment_detail);
end;

-- v_payment_id
declare
    v_payment_id payment.payment_id%type;
    v_payment_detail t_payment_detail_array := t_payment_detail_array
        (t_payment_detail (1, 'Android'),
        t_payment_detail (2, '8.8.8.8'),
        t_payment_detail (3, 'Премия за работу.'),
        t_payment_detail (4, 'Yes'));
begin
    payment_detail_api_pack.insert_or_update_payment_detail (p_payment_id => v_payment_id, p_payment_detail => v_payment_detail);
end;

/*==============================================================================
Тест "Удаление деталей платежа" (payment_detail_api_pack.delete_payment_detail)
==============================================================================*/

-- успех
declare
    v_payment_id payment.payment_id%type := 1;
    v_payment_detail_field_ids t_number_array := t_number_array (3, 44, 127);
begin
    payment_detail_api_pack.delete_payment_detail (p_payment_id => v_payment_id, p_payment_detail_field_ids => v_payment_detail_field_ids);
end;

-- t_number_array
declare
    v_payment_id payment.payment_id%type := 1;
    v_payment_detail_field_ids t_number_array := t_number_array ();
begin
    payment_detail_api_pack.delete_payment_detail (p_payment_id => v_payment_id, p_payment_detail_field_ids => v_payment_detail_field_ids);
end;

-- t_number_array 2
declare
    v_payment_id payment.payment_id%type := 1;
    v_payment_detail_field_ids t_number_array;
begin
    payment_detail_api_pack.delete_payment_detail (p_payment_id => v_payment_id, p_payment_detail_field_ids => v_payment_detail_field_ids);
end;