create or replace package payment_constant_pack
/*==============================================================================
Purpose: ��������� ��� ��������� ������� � ������� ��������
Autor: Shatalin A.A.
Note:
Fix:
==============================================================================*/
is

    c_timestamp_format constant varchar2 (25 char) := 'dd.mm.yy hh24:mi:ss.ff6';

    type t_status is record
        (status payment.status%type,
        message varchar2 (200 char));

    c_status_create constant t_status := t_status (0, '������ ������.');
    c_status_success constant t_status := t_status (1, '�������� ���������� �������.');
    c_status_error constant t_status := t_status (2, '����� ������� � "��������� ������" � ��������� �������.');
    c_status_cancel constant t_status := t_status (3, '������ ������� � ��������� �������.');

    c_message_insert_or_update constant varchar2 (200 char) := '������ ������� ��������� ��� ��������� �� ������ id_����/��������';
    c_message_delete constant varchar2 (200 char) := '������ ������� ������� �� ������ id_�����';

    c_message_error_field_is_null constant varchar2 (200 char) := '���� �� ����� ���� ������';

    e_invalid_input_parameter exception;
    e_invalid_input_parameter_code constant number (5) := -20001;
    e_invalid_input_parameter_message constant varchar2 (200 char) := '������������ ������� ��������.';

    e_invalid_payment_status exception;
    e_invalid_payment_status_code constant number (5) := -20002;
    e_invalid_payment_status_message constant varchar2 (200 char) := '������������ ������� ������ ������� (�� "������")';

    e_invalid_collection exception;
    e_invalid_collection_code constant number (5) := -20003;
    e_invalid_collection_message constant varchar2 (200 char) := '��������� �� ���������������� ��� �������� ������.';

    e_invalid_collection_field_id exception;
    e_invalid_collection_field_id_code constant number (5) := -20004;
    e_invalid_collection_field_id_message constant varchar2 (200 char) := 'ID ���� �� ����� ���� ������.';

    e_invalid_collection_field_value exception;
    e_invalid_collection_field_value_code constant number (5) := -20005;
    e_invalid_collection_field_value_message constant varchar2 (200 char) := '�������� � ���� �� ����� ���� ������.';

    e_other exception;
    e_other_code constant number (5) := -20100;
    e_other_message constant varchar2 (200 char) := '�������������� ������.';

end payment_constant_pack;