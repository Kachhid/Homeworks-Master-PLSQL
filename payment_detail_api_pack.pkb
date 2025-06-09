create or replace package body payment_detail_api_pack
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

procedure insert_or_update_payment_detail
    (p_payment_id in payment.payment_id%type,
    p_payment_detail in t_payment_detail_array)
is
begin
    if p_payment_id is null then
        raise common_pack.e_invalid_input_parameter;
    end if;

    if p_payment_detail is null or not p_payment_detail is not empty then
        raise common_pack.e_invalid_collection;
    else
        for i in p_payment_detail.first .. p_payment_detail.last
        loop
            if p_payment_detail(i).field_id is null then
                raise common_pack.e_invalid_collection_field_id;
            end if;
            if p_payment_detail(i).field_value is null then
                raise common_pack.e_invalid_collection_field_value;
            end if;
            dbms_output.put_line ('Field_id: ' || p_payment_detail(i).field_id || '. Field_value: ' || p_payment_detail(i).field_value);
        end loop;
    end if;

    payment_api_pack.try_lock_payment (p_payment_id => p_payment_id);
    allow_changes;

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

    disallow_changes;
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
end insert_or_update_payment_detail;

procedure delete_payment_detail
    (p_payment_id in payment.payment_id%type,
    p_payment_detail_field_ids in t_number_array)
is
begin
    if p_payment_id is null then
        raise common_pack.e_invalid_input_parameter;
    end if;

    if p_payment_detail_field_ids is null or not p_payment_detail_field_ids is not empty then
        raise common_pack.e_invalid_collection;
    end if;

    payment_api_pack.try_lock_payment (p_payment_id => p_payment_id);
    allow_changes;

    delete from payment_detail pd
    where
        pd.payment_id = p_payment_id
        and pd.field_id in
            (select t.column_value as field_id
            from table (p_payment_detail_field_ids) t);

    disallow_changes;
exception
    when common_pack.e_invalid_input_parameter then
        raise_application_error (common_pack.e_invalid_input_parameter_code, common_pack.e_invalid_input_parameter_message);
    when common_pack.e_invalid_collection then
        raise_application_error (common_pack.e_invalid_collection_code, common_pack.e_invalid_collection_message);
    when others then
        allow_changes;
        raise;
end delete_payment_detail;

procedure check_iud_possibility
is
begin
    if not g_is_api and not common_pack.is_manual_changes_allowed then
        raise_application_error (common_pack.e_invalid_operation_api_code, common_pack.e_invalid_operation_api_message);
    end if;
end check_iud_possibility;

end payment_detail_api_pack;