create or replace type body t_payment_detail as
    constructor function t_payment_detail
        (self in out nocopy t_payment_detail,
        field_id number,
        field_value varchar2)
    return self as result
    is
    begin
        self.field_id := field_id;
        self.field_value := field_value;
        return;
    end;
end;
/