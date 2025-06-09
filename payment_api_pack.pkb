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
        raise common_pack.e_invalid_input_parameter;
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
        common_pack.c_status_create.status)
    returning payment_id into v_payment_id;

    disallow_changes;

    payment_detail_api_pack.insert_or_update_payment_detail
        (p_payment_id => v_payment_id,
        p_payment_detail => p_payment_detail);

    return v_payment_id;
exception
    when common_pack.e_invalid_input_parameter then
        raise_application_error (common_pack.e_invalid_input_parameter_code, common_pack.e_invalid_input_parameter_message);
    when common_pack.e_invalid_collection then
        raise_application_error (common_pack.e_invalid_collection_code, common_pack.e_invalid_collection_message);
    when common_pack.e_invalid_collection_field_id then
        raise_application_error (common_pack.e_invalid_collection_field_id_code, common_pack.e_invalid_collection_field_id_message);
    when common_pack.e_invalid_collection_field_value then
        raise_application_error (common_pack.e_invalid_collection_field_value_code, common_pack.e_invalid_collection_field_value_message);
    when others then
        disallow_changes;
        raise;
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
        raise common_pack.e_invalid_input_parameter;
    end if;

    try_lock_payment (p_payment_id => p_payment_id);
    allow_changes;

    update payment p
    set
        p.status = common_pack.c_status_error.status,
        p.status_change_reason = p_reason
    where p.payment_id = p_payment_id;

    disallow_changes;
exception
    when common_pack.e_invalid_input_parameter then
        raise_application_error (common_pack.e_invalid_input_parameter_code, common_pack.e_invalid_input_parameter_message);
    when others then
        disallow_changes;
        raise;
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
        raise common_pack.e_invalid_input_parameter;
    end if;

    try_lock_payment (p_payment_id => p_payment_id);
    allow_changes;

    update payment p
    set
        p.status = common_pack.c_status_cancel.status,
        p.status_change_reason = p_reason
    where p.payment_id = p_payment_id;

    disallow_changes;
exception
    when common_pack.e_invalid_input_parameter then
        raise_application_error (common_pack.e_invalid_input_parameter_code, common_pack.e_invalid_input_parameter_message);
    when others then
        disallow_changes;
        raise;
end cancel_payment;

procedure successful_finish_payment
    (p_payment_id in payment.payment_id%type)
is
begin
    if p_payment_id is null then
        raise common_pack.e_invalid_input_parameter;
    end if;

    try_lock_payment (p_payment_id => p_payment_id);
    allow_changes;

    update payment p
    set
        p.status = common_pack.c_status_success.status,
        p.status_change_reason = null
    where p.payment_id = p_payment_id;

    disallow_changes;
exception
    when common_pack.e_invalid_input_parameter then
        raise_application_error (common_pack.e_invalid_input_parameter_code, common_pack.e_invalid_input_parameter_message);
    when others then
        disallow_changes;
        raise;
end successful_finish_payment;

procedure check_iu_possibility
is
begin
    if not g_is_api and not common_pack.is_manual_changes_allowed then
        raise_application_error (common_pack.e_invalid_operation_api_code, common_pack.e_invalid_operation_api_message);
    end if;
end check_iu_possibility;

procedure check_d_possibility
is
begin
    if not common_pack.is_manual_changes_allowed then
        raise_application_error (common_pack.e_invalid_operation_code, common_pack.e_invalid_operation_message);
    end if;
end check_d_possibility;

procedure try_lock_payment
    (p_payment_id in payment.payment_id%type)
is
    v_status payment.status%type;
begin
    select status
    into v_status
    from payment
    where payment_id = p_payment_id
    for update nowait;

    if v_status != common_pack.c_status_create.status then
        raise common_pack.e_inactive_object;
    end if;
exception
    when no_data_found then
        raise_application_error (common_pack.e_object_notfound_code, common_pack.e_object_notfound_message);
    when common_pack.e_row_locked then
        raise_application_error (common_pack.e_object_already_locked_code, common_pack.e_object_already_locked_message);
    when common_pack.e_inactive_object then
        raise_application_error (common_pack.e_inactive_object_code, common_pack.e_inactive_object_message);
end try_lock_payment;

end payment_api_pack;