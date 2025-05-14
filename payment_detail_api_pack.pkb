create or replace package body payment_detail_api_pack
is

procedure check_null
    (p_param in number,
    p_param_name in varchar2)
is
begin
    if p_param is null then
        dbms_output.put_line (p_param_name || ': ' || c_message_error_field_is_null);
    end if;
end;

procedure print_result
    (p_payment_id in payment.payment_id%type,
    p_message in varchar2,
    p_message2 in varchar2 default null)
is
begin
    dbms_output.put_line ('(' || to_char (systimestamp, c_timestamp_format) || ') ID платежа: ' || to_char (p_payment_id) || ' - ' || p_message || p_message2);
end print_result;

procedure insert_or_update_payment_detail
    (p_payment_id in payment.payment_id%type,
    p_payment_detail in t_payment_detail_array)
is
begin
    check_null (p_payment_id, 'p_payment_id');

    if p_payment_detail is null or not p_payment_detail is not empty then
        dbms_output.put_line (c_message_error_not_init_or_empty);
    else
        for i in p_payment_detail.first .. p_payment_detail.last
        loop
            if p_payment_detail(i).field_id is null then
                dbms_output.put_line (c_message_error_field_id_is_null);
            end if;
            if p_payment_detail(i).field_value is null then
                dbms_output.put_line (c_message_error_field_value_is_null);
            end if;
            dbms_output.put_line ('Field_id: ' || p_payment_detail(i).field_id || '. Field_value: ' || p_payment_detail(i).field_value);
        end loop;
    end if;

    merge into payment_detail pd
    using
        (select
            p_payment_id as payment_id,
            value(t).field_id as field_id,
            value(t).field_value as field_value
        from table (p_payment_detail) t) t
    on
        (pd.payment_id = t.payment_id
        and pd.field_id = t.field_id)
    when matched then
        update set
            pd.field_value = t.field_value
    when not matched then
        insert
            (pd.payment_id,
            pd.field_id,
            pd.field_value)
        values
            (t.payment_id,
            t.field_id,
            t.field_value);

    print_result (p_payment_id, c_message_insert_or_update);
end insert_or_update_payment_detail;

procedure delete_payment_detail
    (p_payment_id in payment.payment_id%type,
    p_payment_detail_field_ids in t_number_array)
is
begin
    check_null (p_payment_id, 'p_payment_id');

    if p_payment_detail_field_ids is null or not p_payment_detail_field_ids is not empty then
        dbms_output.put_line (c_message_error_not_init_or_empty);
    end if;

    delete from payment_detail pd
    where
        pd.payment_id = p_payment_id
        and pd.field_id in
            (select t.column_value as field_id
            from table (p_payment_detail_field_ids) t);

    print_result (p_payment_id, c_message_delete, ' Количество удаляемых полей: ' || to_char (p_payment_detail_field_ids.count()));
end delete_payment_detail;

end payment_detail_api_pack;