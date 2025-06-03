create or replace type t_payment_detail force as object
    (field_id number (10),
    field_value varchar2 (200 char),
    constructor function t_payment_detail
        (self in out nocopy t_payment_detail,
        field_id number,
        field_value varchar2)
        return self as result
    )
;
/