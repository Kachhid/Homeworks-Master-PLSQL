create or replace type t_payment as object
    (create_dtime timestamp(6),
    summa number(30,2),
    currency_id number(3),
    from_client_id number(30),
    to_client_id number(30));