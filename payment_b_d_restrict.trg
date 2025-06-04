create or replace trigger payment_b_d_restrict
    before delete on payment
begin
    payment_api_pack.check_delete_rigths;
end payment_b_iu_tech_fields;