create or replace package body payment_api_pack
is
    g_is_api boolean := false;

/*==============================================================================
Purpose: Разрешение изменений (IUD)
Autor: Shatalin A.A.
Parameter:
Return:
Note: Для конттроля, что все изменения идут через api.
Fix:
==============================================================================*/
procedure allow_changes
is
begin
    g_is_api := true;
end allow_changes;

/*==============================================================================
Purpose: Запрет изменений (IUD)
Autor: Shatalin A.A.
Parameter:
Return:
Note: Для конттроля, что все изменения идут через api.
Fix:
==============================================================================*/
procedure disallow_changes
is
begin
    g_is_api := false;
end disallow_changes;

procedure print_result
    (p_payment_id in payment.payment_id%type,
    p_status in payment_constant_pack.t_status,
    p_reason in payment.status_change_reason%type default null)
is
begin
    dbms_output.put_line ('(' || to_char (systimestamp, payment_constant_pack.c_timestamp_format) || ') ID платежа: ' || to_char (p_payment_id) || '. Статус: ' || to_char (p_status.status) || ' - ' || p_status.message || '. Причина: ' || p_reason);
end print_result;

function create_payment
    (p_payment in t_payment,
    p_payment_detail in t_payment_detail_array)
return payment.payment_id%type
is
    v_payment_id payment.payment_id%type;
begin
    if
        p_payment.create_dtime is null or
        p_payment.summa is null or
        p_payment.currency_id is null or
        p_payment.from_client_id is null or
        p_payment.to_client_id is null
    then
        raise payment_constant_pack.e_invalid_input_parameter;
    end if;

    allow_changes;
    insert into payment
        (payment_id,
        create_dtime,
        summa,
        currency_id,
        from_client_id,
        to_client_id,
        status)
    values
        (payment_seq.nextval,
        p_payment.create_dtime,
        p_payment.summa,
        p_payment.currency_id,
        p_payment.from_client_id,
        p_payment.to_client_id,
        payment_constant_pack.c_status_create.status)
    returning payment_id into v_payment_id;
    disallow_changes;

    payment_detail_api_pack.insert_or_update_payment_detail
        (p_payment_id => v_payment_id,
        p_payment_detail => p_payment_detail);

    print_result (v_payment_id, payment_constant_pack.c_status_create);
    return v_payment_id;
exception
    when payment_constant_pack.e_invalid_input_parameter then
        raise_application_error (payment_constant_pack.e_invalid_input_parameter_code, payment_constant_pack.e_invalid_input_parameter_message);
    when payment_constant_pack.e_invalid_collection then
        raise_application_error (payment_constant_pack.e_invalid_collection_code, payment_constant_pack.e_invalid_collection_message);
    when payment_constant_pack.e_invalid_collection_field_id then
        raise_application_error (payment_constant_pack.e_invalid_collection_field_id_code, payment_constant_pack.e_invalid_collection_field_id_message);
    when payment_constant_pack.e_invalid_collection_field_value then
        raise_application_error (payment_constant_pack.e_invalid_collection_field_value_code, payment_constant_pack.e_invalid_collection_field_value_message);
    when others then
        disallow_changes;
        raise_application_error (payment_constant_pack.e_other_code, payment_constant_pack.e_other_message);
end create_payment;

procedure fail_payment
    (p_payment_id in payment.payment_id%type,
    p_reason in payment.status_change_reason%type)
is
begin
    if
        p_payment_id is null or
        p_reason is null
    then
        raise payment_constant_pack.e_invalid_input_parameter;
    end if;

    allow_changes;
    update payment p
    set
        p.status = payment_constant_pack.c_status_error.status,
        p.status_change_reason = p_reason
    where
        p.payment_id = p_payment_id
        and p.status = payment_constant_pack.c_status_create.status;
    disallow_changes;

    if sql%rowcount = 0 then
        raise payment_constant_pack.e_invalid_payment_status;
    end if;

    print_result (p_payment_id, payment_constant_pack.c_status_error, p_reason);
exception
    when payment_constant_pack.e_invalid_input_parameter then
        raise_application_error (payment_constant_pack.e_invalid_input_parameter_code, payment_constant_pack.e_invalid_input_parameter_message);
    when payment_constant_pack.e_invalid_payment_status then
        raise_application_error (payment_constant_pack.e_invalid_payment_status_code, payment_constant_pack.e_invalid_payment_status_message);
    when others then
        disallow_changes;
        raise_application_error (payment_constant_pack.e_other_code, payment_constant_pack.e_other_message);
end fail_payment;

procedure cancel_payment
    (p_payment_id in payment.payment_id%type,
    p_reason in payment.status_change_reason%type)
is
begin
    if
        p_payment_id is null or
        p_reason is null
    then
        raise payment_constant_pack.e_invalid_input_parameter;
    end if;

    allow_changes;
    update payment p
    set
        p.status = payment_constant_pack.c_status_cancel.status,
        p.status_change_reason = p_reason
    where
        p.payment_id = p_payment_id
        and p.status = payment_constant_pack.c_status_create.status;
    disallow_changes;

    if sql%rowcount = 0 then
        raise payment_constant_pack.e_invalid_payment_status;
    end if;

    print_result (p_payment_id, payment_constant_pack.c_status_error, p_reason);
exception
    when payment_constant_pack.e_invalid_input_parameter then
        raise_application_error (payment_constant_pack.e_invalid_input_parameter_code, payment_constant_pack.e_invalid_input_parameter_message);
    when payment_constant_pack.e_invalid_payment_status then
        raise_application_error (payment_constant_pack.e_invalid_payment_status_code, payment_constant_pack.e_invalid_payment_status_message);
    when others then
        disallow_changes;
        raise_application_error (payment_constant_pack.e_other_code, payment_constant_pack.e_other_message);
end cancel_payment;

procedure successful_finish_payment
    (p_payment_id in payment.payment_id%type)
is
begin
    if p_payment_id is null then
        raise payment_constant_pack.e_invalid_input_parameter;
    end if;

    allow_changes;
    update payment p
    set
        p.status = payment_constant_pack.c_status_success.status,
        p.status_change_reason = null
    where
        p.payment_id = p_payment_id
        and p.status = payment_constant_pack.c_status_create.status;
    disallow_changes;

    if sql%rowcount = 0 then
        raise payment_constant_pack.e_invalid_payment_status;
    end if;

    print_result (p_payment_id, payment_constant_pack.c_status_success);
exception
    when payment_constant_pack.e_invalid_input_parameter then
        raise_application_error (payment_constant_pack.e_invalid_input_parameter_code, payment_constant_pack.e_invalid_input_parameter_message);
    when payment_constant_pack.e_invalid_payment_status then
        raise_application_error (payment_constant_pack.e_invalid_payment_status_code, payment_constant_pack.e_invalid_payment_status_message);
    when others then
        disallow_changes;
        raise_application_error (payment_constant_pack.e_other_code, payment_constant_pack.e_other_message);
end successful_finish_payment;

procedure check_dml_rigths
is
begin
    if not g_is_api then
        raise_application_error (payment_constant_pack.e_invalid_operation_api_code, payment_constant_pack.e_invalid_operation_api_message);
    end if;
end check_dml_rigths;

end payment_api_pack;