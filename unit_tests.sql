/*==============================================================================
Тест: payment_api_pack
==============================================================================*/
-- create_payment
declare
    type t_input is table of t_unit_test_input_rec;
    v_input t_input := t_input (

        t_unit_test_input_rec
            (result => 0,
            error_code => -20001,
            payment => null,
            payment_detail_array => null),

        t_unit_test_input_rec
            (result => 0,
            error_code => -20001,
            payment => t_payment
                (create_dtime => null,
                summa => null,
                currency_id => null,
                from_client_id => null,
                to_client_id => null),
            payment_detail_array => t_payment_detail_array()),

        t_unit_test_input_rec
            (result => 0,
            error_code => -20001,
            payment => t_payment
                (create_dtime => systimestamp,
                summa => null,
                currency_id => 643,
                from_client_id => null,
                to_client_id => 2),
            payment_detail_array => t_payment_detail_array
                (t_payment_detail (field_id => null, field_value => null))),

        t_unit_test_input_rec
            (result => 0,
            error_code => -20003,
            payment => t_payment
                (create_dtime => systimestamp,
                summa => 100,
                currency_id => 643,
                from_client_id => 1,
                to_client_id => 2),
            payment_detail_array => t_payment_detail_array()),

        t_unit_test_input_rec
            (result => 1,
            payment => t_payment
                (create_dtime => systimestamp,
                summa => 100,
                currency_id => 643,
                from_client_id => 1,
                to_client_id => 2),
            payment_detail_array => t_payment_detail_array
                (t_payment_detail (field_id => 1, field_value => 'Google Chrome'),
                t_payment_detail (field_id => 2, field_value => '127.0.0.1'))),

        t_unit_test_input_rec
            (result => 1,
            payment => t_payment
                (create_dtime => systimestamp,
                summa => 100,
                currency_id => 643,
                from_client_id => 1,
                to_client_id => 2),
            payment_detail_array => t_payment_detail_array
                (t_payment_detail (field_id => 1, field_value => 'Google Chrome'),
                t_payment_detail (field_id => 2, field_value => '127.0.0.1')),
            sql_code => 'select count(1) from payment where payment_id = :v_payment_id and create_dtime_tech = update_dtime_tech')
        );

    v_payment_id payment.payment_id%type;
    v_result number(1);
    v_error_code number(5);
begin
    for i in 1 .. v_input.count()
    loop
        dbms_output.put_line ('Case ' || to_char (i) || ':');
        v_result := 1;
        v_error_code := 0;
        begin
            v_payment_id := payment_api_pack.create_payment (p_payment => v_input(i).payment, p_payment_detail => v_input(i).payment_detail_array);
            dbms_output.put_line ('v_payment_id -> ' || to_char (v_payment_id));
            if v_input(i).sql_code is not null then
                execute immediate v_input(i).sql_code into v_result using v_payment_id;
            end if;
        exception
            when others then
                v_result := 0;
                v_error_code := sqlcode;
                dbms_output.put_line ('exception => ' || sqlerrm);
        end;
            if v_result = v_input(i).result and v_error_code = v_input(i).error_code then
                dbms_output.put_line ('===============PASSED===============');
            else
                dbms_output.put_line ('=============NOT PASSED=============');
            end if;
    end loop;
end;
/

-- fail_payment
declare
    type t_input is table of t_unit_test_input_rec;
    v_input t_input := t_input (

        t_unit_test_input_rec
            (result => 0,
            error_code => -20001,
            payment_id => null,
            reason => null),

        t_unit_test_input_rec
            (result => 0,
            error_code => -20001,
            payment_id => null,
            reason => 'Недостаточно средств.'),

        t_unit_test_input_rec
            (result => 0,
            error_code => -20001,
            payment_id => 22,
            reason => null),

        t_unit_test_input_rec
            (result => 0,
            error_code => -20002,
            payment_id => 22,
            reason => 'Недостаточно средств.'),

        t_unit_test_input_rec
            (result => 1,
            payment_id => 52,
            reason => 'Недостаточно средств.')
        );

    v_result number(1);
    v_error_code number(5);
begin
    for i in 1 .. v_input.count()
    loop
        dbms_output.put_line ('Case ' || to_char (i) || ':');
        v_result := 1;
        v_error_code := 0;
        begin
            payment_api_pack.fail_payment (p_payment_id => v_input(i).payment_id, p_reason => v_input(i).reason);
        exception
            when others then
                v_result := 0;
                v_error_code := sqlcode;
                dbms_output.put_line ('exception => ' || sqlerrm);
    end;
        if v_result = v_input(i).result and v_error_code = v_input(i).error_code then
            dbms_output.put_line ('===============PASSED===============');
        else
            dbms_output.put_line ('=============NOT PASSED=============');
        end if;
    end loop;
end;
/

-- cancel_payment
declare
    type t_input is table of t_unit_test_input_rec;
    v_input t_input := t_input (

        t_unit_test_input_rec
            (result => 0,
            error_code => -20001,
            payment_id => null,
            reason => null),

        t_unit_test_input_rec
            (result => 0,
            error_code => -20001,
            payment_id => null,
            reason => 'Недостаточно средств.'),

        t_unit_test_input_rec
            (result => 0,
            error_code => -20001,
            payment_id => 22,
            reason => null),

        t_unit_test_input_rec
            (result => 0,
            error_code => -20002,
            payment_id => 22,
            reason => 'Недостаточно средств.'),

        t_unit_test_input_rec
            (result => 1,
            payment_id => 53,
            reason => 'Недостаточно средств.'),

        t_unit_test_input_rec
            (result => 1,
            payment_id => 61,
            reason => 'Недостаточно средств.',
            sql_code => 'select count(1) from payment where payment_id = :v_payment_id and create_dtime_tech < update_dtime_tech')
        );

    v_result number(1);
    v_error_code number(5);
begin
    for i in 1 .. v_input.count()
    loop
        dbms_output.put_line ('Case ' || to_char (i) || ':');
        v_result := 1;
        v_error_code := 0;
        begin
            payment_api_pack.cancel_payment (p_payment_id => v_input(i).payment_id, p_reason => v_input(i).reason);
            if v_input(i).sql_code is not null then
                execute immediate v_input(i).sql_code into v_result using v_input(i).payment_id;
            end if;
        exception
            when others then
                v_result := 0;
                v_error_code := sqlcode;
                dbms_output.put_line ('exception => ' || sqlerrm);
    end;
        if v_result = v_input(i).result and v_error_code = v_input(i).error_code then
            dbms_output.put_line ('===============PASSED===============');
        else
            dbms_output.put_line ('=============NOT PASSED=============');
        end if;
    end loop;
end;
/

-- successful_finish_payment
declare
    type t_input is table of t_unit_test_input_rec;
    v_input t_input := t_input (

        t_unit_test_input_rec
            (result => 0,
            error_code => -20001,
            payment_id => null),

        t_unit_test_input_rec
            (result => 0,
            error_code => -20002,
            payment_id => 22),

        t_unit_test_input_rec
            (result => 1,
            payment_id => 52)
    );

    v_result number(1);
    v_error_code number(5);
begin
    for i in 1 .. v_input.count()
    loop
        dbms_output.put_line ('Case ' || to_char (i) || ':');
        v_result := 1;
        v_error_code := 0;
        begin
            payment_api_pack.successful_finish_payment (p_payment_id => v_input(i).payment_id);
        exception
            when others then
                v_result := 0;
                v_error_code := sqlcode;
                dbms_output.put_line ('exception => ' || sqlerrm);
    end;
        if v_result = v_input(i).result and v_error_code = v_input(i).error_code then
            dbms_output.put_line ('===============PASSED===============');
        else
            dbms_output.put_line ('=============NOT PASSED=============');
        end if;
    end loop;
end;
/

/*==============================================================================
Тест: payment_detail_api_pack
==============================================================================*/
-- insert_or_update_payment_detail
declare
    type t_input is table of t_unit_test_input_rec;
    v_input t_input := t_input (

        t_unit_test_input_rec
            (result => 0,
            error_code => -20001,
            payment_id => null,
            payment_detail_array => null),

        t_unit_test_input_rec
            (result => 0,
            error_code => -20001,
            payment_id => null,
            payment_detail_array => t_payment_detail_array ()),

        t_unit_test_input_rec
            (result => 0,
            error_code => -20003,
            payment_id => 23,
            payment_detail_array => null),

        t_unit_test_input_rec
            (result => 1,
            payment_id => 52,
            payment_detail_array => t_payment_detail_array
                (t_payment_detail (field_id => 1, field_value => 'Android'),
                t_payment_detail (field_id => 2, field_value => '8.8.8.8'),
                t_payment_detail (field_id => 3, field_value => 'Премия за работу.'),
                t_payment_detail (field_id => 4, field_value => 'Yes')))
        );

    v_result number(1);
    v_error_code number(5);
begin
    for i in 1 .. v_input.count()
    loop
        dbms_output.put_line ('Case ' || to_char (i) || ':');
        v_result := 1;
        v_error_code := 0;
        begin
            payment_detail_api_pack.insert_or_update_payment_detail (p_payment_id => v_input(i).payment_id, p_payment_detail =>  v_input(i).payment_detail_array);
        exception
            when others then
                v_result := 0;
                v_error_code := sqlcode;
                dbms_output.put_line ('exception => ' || sqlerrm);
    end;
        if v_result = v_input(i).result and v_error_code = v_input(i).error_code then
            dbms_output.put_line ('===============PASSED===============');
        else
            dbms_output.put_line ('=============NOT PASSED=============');
        end if;
    end loop;
end;
/

-- delete_payment_detail
declare
    type t_input is table of t_unit_test_input_rec;
    v_input t_input := t_input (

        t_unit_test_input_rec
            (result => 0,
            error_code => -20001,
            payment_id => null,
            payment_detail_field_ids => null),

        t_unit_test_input_rec
            (result => 0,
            error_code => -20001,
            payment_id => null,
            payment_detail_field_ids => t_number_array ()),

        t_unit_test_input_rec
            (result => 0,
            error_code => -20003,
            payment_id => 23,
            payment_detail_field_ids => t_number_array ()),

        t_unit_test_input_rec
            (result => 1,
            payment_id => 21,
            payment_detail_field_ids => t_number_array (1, 2))
    );

    v_result number(1);
    v_error_code number(5);
begin
    for i in 1 .. v_input.count()
    loop
        dbms_output.put_line ('Case ' || to_char (i) || ':');
        v_result := 1;
        v_error_code := 0;
        begin
            payment_detail_api_pack.delete_payment_detail (p_payment_id => v_input(i).payment_id, p_payment_detail_field_ids =>  v_input(i).payment_detail_field_ids);
        exception
            when others then
                v_result := 0;
                v_error_code := sqlcode;
                dbms_output.put_line ('exception => ' || sqlerrm);
    end;
        if v_result = v_input(i).result and v_error_code = v_input(i).error_code then
            dbms_output.put_line ('===============PASSED===============');
        else
            dbms_output.put_line ('=============NOT PASSED=============');
        end if;
    end loop;
end;
/

/*==============================================================================
Тест: payment&payment_detail triggers
==============================================================================*/

declare
    type t_input is table of t_unit_test_input_rec;
    v_input t_input := t_input (

        t_unit_test_input_rec
            (result => 0,
            error_code => -20007,
            sql_code => 'insert into payment (payment_id) values (-1)'),

        t_unit_test_input_rec
            (result => 0,
            error_code => -20007,
            sql_code => 'update payment set payment_id = payment_id where rownum = 1'),

        t_unit_test_input_rec
            (result => 0,
            error_code => -20006,
            sql_code => 'delete from payment where rownum = 1'),

        t_unit_test_input_rec
            (result => 0,
            error_code => -20007,
            sql_code => 'insert into payment_detail (payment_id) values (-1)'),

        t_unit_test_input_rec
            (result => 0,
            error_code => -20007,
            sql_code => 'update payment_detail set payment_id = payment_id where rownum = 1'),

        t_unit_test_input_rec
            (result => 0,
            error_code => -20007,
            sql_code => 'delete from payment_detail where rownum = 1')
    );

    v_result number(1);
    v_error_code number(5);
begin
    for i in 1 .. v_input.count()
    loop
        dbms_output.put_line ('Case ' || to_char (i) || ':');
        v_result := 1;
        v_error_code := 0;
        begin
            execute immediate v_input(i).sql_code into v_result;
        exception
            when others then
                v_result := 0;
                v_error_code := sqlcode;
                dbms_output.put_line ('exception => ' || sqlerrm);
    end;
        if v_result = v_input(i).result and v_error_code = v_input(i).error_code then
            dbms_output.put_line ('===============PASSED===============');
        else
            dbms_output.put_line ('=============NOT PASSED=============');
        end if;
    end loop;
end;