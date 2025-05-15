create or replace package body payment_api_pack
is

procedure check_null
    (p_param in varchar2,
    p_param_name in varchar2)
is
begin
    if p_param is null then
        dbms_output.put_line (p_param_name || ': ' || c_message_error_field_is_null);
    end if;
end check_null;

procedure check_null
    (p_param in timestamp,
    p_param_name in varchar2)
is
begin
    if p_param is null then
        check_null (to_char (null), p_param_name);
    end if;
end check_null;

procedure check_null
    (p_param in number,
    p_param_name in varchar2)
is
begin
    if p_param is null then
        check_null (to_char (null), p_param_name);
    end if;
end check_null;

procedure print_result
    (p_payment_id in payment.payment_id%type,
    p_status in t_status,
    p_reason in payment.status_change_reason%type default null)
is
begin
    dbms_output.put_line ('(' || to_char (systimestamp, c_timestamp_format) || ') ID платежа: ' || to_char (p_payment_id) || '. Статус: ' || to_char (p_status.status) || ' - ' || p_status.message || '. Причина: ' || p_reason);
end print_result;

function create_payment
    (p_payment in t_payment,
    p_payment_detail in t_payment_detail_array)
return payment.payment_id%type
is
    v_payment_id payment.payment_id%type;
begin
    check_null (p_payment.create_dtime, 'create_dtime');
    check_null (p_payment.summa, 'summa');
    check_null (p_payment.currency_id, 'currency_id');
    check_null (p_payment.from_client_id, 'from_client_id');
    check_null (p_payment.to_client_id, 'to_client_id');

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
        c_status_create.status)
    returning payment_id into v_payment_id;

    payment_detail_api_pack.insert_or_update_payment_detail
        (p_payment_id => v_payment_id,
        p_payment_detail => p_payment_detail);

    print_result (v_payment_id, c_status_create);
    return v_payment_id;
end create_payment;

procedure fail_payment
    (p_payment_id in payment.payment_id%type,
    p_reason in payment.status_change_reason%type)
is
begin
    check_null (p_payment_id, 'p_payment_id');
    check_null (p_reason, 'p_reason');

    update payment p
    set
        p.status = c_status_error.status,
        p.status_change_reason = p_reason
    where
        p.payment_id = p_payment_id
        and p.status = c_status_create.status;

    if sql%rowcount = 0 then
        dbms_output.put_line (c_message_error_payment_not_on_status_created);
    end if;

    print_result (p_payment_id, c_status_error, p_reason);
end fail_payment;

procedure cancel_payment
    (p_payment_id in payment.payment_id%type,
    p_reason in payment.status_change_reason%type)
is
begin
    check_null (p_payment_id, 'p_payment_id');
    check_null (p_reason, 'p_reason');

    update payment p
    set
        p.status = c_status_cancel.status,
        p.status_change_reason = p_reason
    where
        p.payment_id = p_payment_id
        and p.status = c_status_create.status;

    if sql%rowcount = 0 then
        dbms_output.put_line (c_message_error_payment_not_on_status_created);
    end if;

    print_result (p_payment_id, c_status_error, p_reason);
end cancel_payment;

procedure successful_finish_payment
    (p_payment_id in payment.payment_id%type)
is
begin
    check_null (p_payment_id, 'p_payment_id');

    update payment p
    set
        p.status = c_status_success.status,
        p.status_change_reason = null
    where
        p.payment_id = p_payment_id
        and p.status = c_status_create.status;

    if sql%rowcount = 0 then
        dbms_output.put_line (c_message_error_payment_not_on_status_created);
    end if;

    print_result (p_payment_id, c_status_success);
end successful_finish_payment;

end payment_api_pack;