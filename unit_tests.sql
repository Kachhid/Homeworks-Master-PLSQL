/*==============================================================================
Тест: payment_api_pack
==============================================================================*/
-- create_payment
declare
    type t_input_rec is record
        (result boolean,
        payment t_payment,
        payment_detail t_payment_detail_array);
    type t_input is table of t_input_rec;
    v_input t_input := t_input (
        t_input_rec (false,
            null,
            null),
        t_input_rec (false,
            t_payment (null, null, null, null, null),
            t_payment_detail_array()),
        t_input_rec (false,
            t_payment (systimestamp, null, 643, null, 2),
            t_payment_detail_array (t_payment_detail (null, null))),
        t_input_rec (false,
            t_payment (systimestamp, 100, 643, 1, 2),
            t_payment_detail_array()),
        t_input_rec (true,
            t_payment (systimestamp, 100, 643, 1, 2),
            t_payment_detail_array (t_payment_detail (1, 'Google Chrome'), t_payment_detail (2, '127.0.0.1')))
        );

    v_payment_id payment.payment_id%type;
    v_result boolean;
begin
    for i in 1 .. v_input.count()
    loop
        dbms_output.put_line ('Case ' || to_char (i) || ':');
        v_result := true;
        begin
            v_payment_id := payment_api_pack.create_payment (p_payment => v_input(i).payment, p_payment_detail => v_input(i).payment_detail);
            dbms_output.put_line ('v_payment_id -> ' || to_char (v_payment_id));
        exception
            when others then
                v_result := false;
                dbms_output.put_line ('exception => ' || sqlerrm);
        end;
            if v_result = v_input(i).result then
                dbms_output.put_line ('===============PASSED===============');
            else
                dbms_output.put_line ('=============NOT PASSED=============');
            end if;
    end loop;
end;

-- fail_payment
declare
    type t_input_rec is record
        (result boolean,
        payment_id payment.payment_id%type,
        reason payment.status_change_reason%type);
    type t_input is table of t_input_rec;
    v_input t_input := t_input (
        t_input_rec (false, null, null),
        t_input_rec (false, null, 'Недостаточно средств.'),
        t_input_rec (false, 22, null),
        t_input_rec (false, 22, 'Недостаточно средств.'),
        t_input_rec (true, 51, 'Недостаточно средств.'));

    v_result boolean;
begin
    for i in 1 .. v_input.count()
    loop
        dbms_output.put_line ('Case ' || to_char (i) || ':');
        v_result := true;
        begin
            payment_api_pack.fail_payment (p_payment_id => v_input(i).payment_id, p_reason => v_input(i).reason);
        exception
            when others then
                v_result := false;
                dbms_output.put_line ('exception => ' || sqlerrm);
    end;
        if v_result = v_input(i).result then
            dbms_output.put_line ('===============PASSED===============');
        else
            dbms_output.put_line ('=============NOT PASSED=============');
        end if;
    end loop;
end;

-- cancel_payment
declare
    type t_input_rec is record
        (result boolean,
        payment_id payment.payment_id%type,
        reason payment.status_change_reason%type);
    type t_input is table of t_input_rec;
    v_input t_input := t_input (
        t_input_rec (false, null, null),
        t_input_rec (false, null, 'Недостаточно средств.'),
        t_input_rec (false, 22, null),
        t_input_rec (false, 22, 'Недостаточно средств.'),
        t_input_rec (true, 51, 'Недостаточно средств.'));

    v_result boolean;
begin
    for i in 1 .. v_input.count()
    loop
        dbms_output.put_line ('Case ' || to_char (i) || ':');
        v_result := true;
        begin
            payment_api_pack.cancel_payment (p_payment_id => v_input(i).payment_id, p_reason => v_input(i).reason);
        exception
            when others then
                v_result := false;
                dbms_output.put_line ('exception => ' || sqlerrm);
    end;
        if v_result = v_input(i).result then
            dbms_output.put_line ('===============PASSED===============');
        else
            dbms_output.put_line ('=============NOT PASSED=============');
        end if;
    end loop;
end;

-- successful_finish_payment
declare
    type t_input_rec is record
        (result boolean,
        payment_id payment.payment_id%type);
    type t_input is table of t_input_rec;
    v_input t_input := t_input (
        t_input_rec (false, null),
        t_input_rec (false, 22),
        t_input_rec (true, 51));

    v_result boolean;
begin
    for i in 1 .. v_input.count()
    loop
        dbms_output.put_line ('Case ' || to_char (i) || ':');
        v_result := true;
        begin
            payment_api_pack.successful_finish_payment (p_payment_id => v_input(i).payment_id);
        exception
            when others then
                v_result := false;
                dbms_output.put_line ('exception => ' || sqlerrm);
    end;
        if v_result = v_input(i).result then
            dbms_output.put_line ('===============PASSED===============');
        else
            dbms_output.put_line ('=============NOT PASSED=============');
        end if;
    end loop;
end;

/*==============================================================================
Тест: payment_detail_api_pack
==============================================================================*/
-- insert_or_update_payment_detail
declare
    type t_input_rec is record
        (result boolean,
        payment_id payment.payment_id%type,
        payment_detail t_payment_detail_array);
    type t_input is table of t_input_rec;
    v_input t_input := t_input (
        t_input_rec (false, null, null),
        t_input_rec (false, null, t_payment_detail_array ()),
        t_input_rec (false, 23, t_payment_detail_array ()),
        t_input_rec (true, 51, t_payment_detail_array (t_payment_detail (1, 'Android'), t_payment_detail (2, '8.8.8.8'), t_payment_detail (3, 'Премия за работу.'), t_payment_detail (4, 'Yes'))));

    v_result boolean;
begin
    for i in 1 .. v_input.count()
    loop
        dbms_output.put_line ('Case ' || to_char (i) || ':');
        v_result := true;
        begin
            payment_detail_api_pack.insert_or_update_payment_detail (p_payment_id => v_input(i).payment_id, p_payment_detail =>  v_input(i).payment_detail);
        exception
            when others then
                v_result := false;
                dbms_output.put_line ('exception => ' || sqlerrm);
    end;
        if v_result = v_input(i).result then
            dbms_output.put_line ('===============PASSED===============');
        else
            dbms_output.put_line ('=============NOT PASSED=============');
        end if;
    end loop;
end;

-- delete_payment_detail
declare
    type t_input_rec is record
        (result boolean,
        payment_id payment.payment_id%type,
        payment_detail_field_ids t_number_array);
    type t_input is table of t_input_rec;
    v_input t_input := t_input (
        t_input_rec (false, null, null),
        t_input_rec (false, null, t_number_array ()),
        t_input_rec (false, 23, t_number_array ()),
        t_input_rec (true, 23, t_number_array (3, 44, 127)));

    v_result boolean;
begin
    for i in 1 .. v_input.count()
    loop
        dbms_output.put_line ('Case ' || to_char (i) || ':');
        v_result := true;
        begin
            payment_detail_api_pack.delete_payment_detail (p_payment_id => v_input(i).payment_id, p_payment_detail_field_ids =>  v_input(i).payment_detail_field_ids);
        exception
            when others then
                v_result := false;
                dbms_output.put_line ('exception => ' || sqlerrm);
    end;
        if v_result = v_input(i).result then
            dbms_output.put_line ('===============PASSED===============');
        else
            dbms_output.put_line ('=============NOT PASSED=============');
        end if;
    end loop;
end;