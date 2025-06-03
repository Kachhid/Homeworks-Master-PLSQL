create or replace type body t_unit_test_input_rec as

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
    return self as result
    is
    begin
        self.result := result;
        self.error_code := error_code;
        self.payment_id := payment_id;
        self.payment := payment;
        self.payment_detail_array := payment_detail_array;
        self.payment_detail_field_ids := payment_detail_field_ids;
        self.reason := reason;
        self.sql_code := sql_code;
        return;
    end t_unit_test_input_rec;

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
    is
    begin
        self.result := result;
        self.error_code := 0;
        self.payment_id := payment_id;
        self.payment := payment;
        self.payment_detail_array := payment_detail_array;
        self.payment_detail_field_ids :=  payment_detail_field_ids;
        self.reason := reason;
        self.sql_code := sql_code;
        return;
    end t_unit_test_input_rec;
end;
/