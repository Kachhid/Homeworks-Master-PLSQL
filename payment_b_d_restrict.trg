create or replace trigger payment_b_d_restrict
    before delete on payment
begin
    payment_api_pack.check_d_possibility;
end payment_b_iu_tech_fields;