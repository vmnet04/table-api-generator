DECLARE
  v_count   PLS_INTEGER;
  PRAGMA autonomous_transaction; -- we need this to ensure om_tapigen is initialized
BEGIN
  om_tapigen.util_set_debug_on;
  om_tapigen.compile_api(
    p_table_name                    => 'COUNTRIES',
    p_reuse_existing_api_params     => false,
    p_enable_column_defaults        => true,
    p_enable_proc_with_out_params   => false,
    p_enable_getter_and_setter      => false,
    p_return_row_instead_of_pk      => false,
    p_enable_dml_view               => false,
    p_enable_generic_change_log     => false,
    p_api_name                      => 'COUNTRIES_API',
    p_enable_custom_defaults        => true,
    p_custom_default_values         => xmltype(q'[
      <custom_defaults>
        <column name="REGION_ID"><![CDATA[1]]></column>
      </custom_defaults>
    ]')
  );

  SELECT
    COUNT(*)
  INTO
    v_count
  FROM
    TABLE ( om_tapigen.view_existing_apis )
  WHERE
    owner = 'HR'
    AND   table_name = 'COUNTRIES'
    AND   spec_status = 'VALID'
    AND   body_status = 'VALID';

  IF
    v_count = 0
  THEN
    raise_application_error(
      -20000,
      'Package invalid'
    );
  END IF;
END;
/