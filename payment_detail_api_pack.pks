create or replace package payment_detail_api_pack
/*==============================================================================
Purpose: API ��� ��������� ������� ��������
Autor: Shatalin A.A.
Note:
Fix:
==============================================================================*/
is
    c_message_insert_or_update constant varchar2 (200 char) := '������ ������� ��������� ��� ��������� �� ������ id_����/��������.';
    c_message_delete varchar2 (200 char) := '������ ������� ������� �� ������ id_�����.';

    c_message_error_field_is_null varchar2 (200 char) := '���� �� ����� ���� ������';
    c_message_error_field_id_is_null varchar2 (200 char) := 'ID ���� �� ����� ���� ������.';
    c_message_error_field_value_is_null varchar2 (200 char) := '�������� � ���� �� ����� ���� ������.';
    c_message_error_not_init_or_empty varchar2 (200 char) := '��������� �� ����������������/�������� ������.';

    c_timestamp_format constant varchar2 (25 char) := 'dd.mm.yy hh24:mi:ss.ff6';

/*==============================================================================
Purpose: ���������� ������� �������.
Autor: Shatalin A.A.
Parameter:
    p_payment_id - id �������;
    p_payment_detail - ������ �������;
Return:
Note:
Fix:
==============================================================================*/
procedure insert_or_update_payment_detail
    (p_payment_id in payment.payment_id%type,
    p_payment_detail in t_payment_detail_array);

/*==============================================================================
Purpose: �������� ������� �������.
Autor: Shatalin A.A.
Parameter:
    p_payment_id - id �������;
    p_payment_detail_field_ids - id ������� �������;
Return:
Note:
Fix:
==============================================================================*/
procedure delete_payment_detail
    (p_payment_id in payment.payment_id%type,
    p_payment_detail_field_ids in t_number_array);

end payment_detail_api_pack;