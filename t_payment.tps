create or replace type t_payment force as object
    (create_dtime timestamp(6),
    summa number(30,2),
    currency_id number(3),
    from_client_id number(30),
    to_client_id number(30),
    constructor function t_payment
        (self in out nocopy t_payment,
        create_dtime timestamp,
        summa number,
        currency_id number,
        from_client_id number,
        to_client_id number)
        return self as result
    )
;
/