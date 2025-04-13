/*==============================================================================
�����: Shatalin A.A.
�������� �������: API ��� ��������� ������� � ������� ��������
==============================================================================*/

-- �������� �������
declare
    v_message varchar2(200) := '������ ������';
    c_status_create number := 0;
begin
    dbms_output.put_line (v_message || '. ������: ' || c_status_create);
end;
/

-- ������� ������� �� 2 ������
declare
    v_message varchar2(200) := '����� ������� � "��������� ������" � ��������� �������';
    v_reason varchar2(200) :=  '������������ �������';
    c_status_error number := 2;
begin
    dbms_output.put_line (v_message || '. ������: ' || c_status_error || '. �������: ' || v_reason);
end;
/

-- ������� ������� �� 3 ������
declare
    v_message varchar2(200) := '������ ������� � ��������� �������';
    v_reason varchar2(200) :=  '������ ������������';
    c_status_cancel number := 3;
begin
    dbms_output.put_line (v_message || '. ������: ' || c_status_cancel || '. �������: ' || v_reason);
end;
/

-- ������� ������� �� 1 ������
declare
    v_message varchar2(200) := '�������� ���������� �������';
    c_status_success number := 1;
begin
    dbms_output.put_line (v_message || '. ������: ' || c_status_success);
end;
/

-- ���������� ������� �������
declare
    v_message varchar2(200) := '������ ������� ��������� ��� ��������� �� ������ id_����/��������';
begin
    dbms_output.put_line (v_message);
end;
/

-- �������� ������� �������
declare
    v_message varchar2(200) := '������ ������� ������� �� ������ id_�����';
begin
    dbms_output.put_line (v_message);
end;
/