create or replace package payment_api_pack
/*==============================================================================
Purpose: API ��� ��������� �������
Autor: Shatalin A.A.
Note:
Fix:
==============================================================================*/
is
    type t_status is record
        (status payment.status%type,
        message varchar2 (200 char));

    c_status_create constant t_status := t_status (0, '������ ������.');
    c_status_success constant t_status := t_status (1, '�������� ���������� �������.');
    c_status_error constant t_status := t_status (2, '����� ������� � "��������� ������" � ��������� �������.');
    c_status_cancel constant t_status := t_status (3, '������ ������� � ��������� �������.');

    c_message_error_field_is_null varchar2 (200 char) := '���� �� ����� ���� ������';
    c_message_error_payment_not_on_status_created varchar2 (200 char) := '������, ������� ������ ������� �� "������".';

    c_timestamp_format constant varchar2 (25 char) := 'dd.mm.yy hh24:mi:ss.ff6';

/*==============================================================================
Purpose: �������� �������
Autor: Shatalin A.A.
Parameter:
Return: id �������
Note:
Fix:
==============================================================================*/
function create_payment
    (p_payment in t_payment,
    p_payment_detail in t_payment_detail_array)
return payment.payment_id%type;

/*==============================================================================
Purpose: ������� ������� �� ������ "������".
Autor: Shatalin A.A.
Parameter:
    p_payment_id - id �������;
    p_reason - ������� ������ �������;
Return:
Note:
Fix:
==============================================================================*/
procedure fail_payment
    (p_payment_id in payment.payment_id%type,
    p_reason in payment.status_change_reason%type);

/*==============================================================================
Purpose: ������� ������� �� ������ "������".
Autor: Shatalin A.A.
Parameter:
    p_payment_id - id �������;
    p_reason - ������� ������ �������;
Return:
Note:
Fix:
==============================================================================*/
procedure cancel_payment
    (p_payment_id in payment.payment_id%type,
    p_reason in payment.status_change_reason%type);

/*==============================================================================
Purpose: ������� ������� �� ������ "�������".
Autor: Shatalin A.A.
Parameter:
    p_payment_id - id �������;
Return:
Note:
Fix:
==============================================================================*/
procedure successful_finish_payment
    (p_payment_id in payment.payment_id%type);

end payment_api_pack;