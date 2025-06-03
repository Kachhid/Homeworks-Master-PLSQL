create or replace trigger payment_b_d_restrict
    before delete on payment
begin
    raise_application_error (payment_constant_pack.e_invalid_operation_code, payment_constant_pack.e_invalid_operation_message);
end payment_b_iu_tech_fields;