create or replace trigger payment_b_iu_api
    before insert or update on payment
begin
    payment_api_pack.check_iu_possibility;
end payment_b_iu_tech_fields;