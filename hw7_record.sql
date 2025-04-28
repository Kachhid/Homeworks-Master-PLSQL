declare
    type t_rec is record
        (field1 varchar2 (5 char),
        field2 varchar2 (10 char) not null := 'NOT NULL',
        field3 varchar2 (10 char) := 'NOT NULL');

    v_rec_1 t_rec;
    v_rec_2 t_rec;
    v_rec_3 t_rec;
begin
    v_rec_1.field1 := '1ST';
    v_rec_2.field1 := '2ND';
    v_rec_3.field1 := '3RD';

    dbms_output.put_line ('v_rec_1.field1 - ' || v_rec_1.field1);
    dbms_output.put_line ('v_rec_2.field1 - ' || v_rec_2.field1);
    dbms_output.put_line ('v_rec_3.field1 - ' || v_rec_3.field1);

    v_rec_2 := null;
    case true
        when coalesce (v_rec_2.field1, v_rec_2.field2, v_rec_2.field3) is null
        then dbms_output.put_line ('It’s null');
        else dbms_output.put_line ('It’s not null');
    end case;
end;
/

declare
    r_payment_detail_field payment_detail_field%rowtype;
begin
    select *
    into r_payment_detail_field
    from payment_detail_field
    where rownum <= 1;

    dbms_output.put_line ('r_payment_detail_field.field_id - ' || r_payment_detail_field.field_id);
    dbms_output.put_line ('r_payment_detail_field.name - ' || r_payment_detail_field.name);
    dbms_output.put_line ('r_payment_detail_field.description - ' || r_payment_detail_field.description);
end;
/