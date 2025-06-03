create or replace type t_unit_test_input_rec as object
    (result number(1),
    error_code number(5),
    payment_id number(38),
    payment t_payment,
    payment_detail_array t_payment_detail_array,
    payment_detail_field_ids t_number_array,
    reason varchar2(200 char),
    sql_code varchar2(4000 char),

    constructor function t_unit_test_input_rec
        (self in out nocopy t_unit_test_input_rec,
        result number,
        error_code number,
        payment_id number default null,
        payment t_payment default null,
        payment_detail_array t_payment_detail_array default null,
        payment_detail_field_ids t_number_array default null,
        reason varchar2 default null,
        sql_code varchar2 default null)
        return self as result,

    constructor function t_unit_test_input_rec
        (self in out nocopy t_unit_test_input_rec,
        result number,
        payment_id number default null,
        payment t_payment default null,
        payment_detail_array t_payment_detail_array default null,
        payment_detail_field_ids t_number_array default null,
        reason varchar2 default null,
        sql_code varchar2 default null)
        return self as result
    )
;
/