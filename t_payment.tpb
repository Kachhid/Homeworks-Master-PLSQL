create or replace type body t_payment as
    constructor function t_payment
        (self in out nocopy t_payment,
        create_dtime timestamp,
        summa number,
        currency_id number,
        from_client_id number,
        to_client_id number)
    return self as result
    is
    begin
        self.create_dtime := create_dtime;
        self.summa := summa;
        self.currency_id := currency_id;
        self.from_client_id := from_client_id;
        self.to_client_id := to_client_id;
        return;
    end;
end;
/