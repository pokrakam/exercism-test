CLASS zcl_kindergarten_garden DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS plants
      IMPORTING
        diagram        TYPE string
        student        TYPE string
      RETURNING
        VALUE(results) TYPE string_table.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA students TYPE string_table.

ENDCLASS.


CLASS zcl_kindergarten_garden IMPLEMENTATION.


  METHOD plants.

    SPLIT condense( replace(
                        val  = diagram
                        sub  = `\n`
                        with = ` `
                        occ  = 0 ) ) AT ` ` INTO TABLE DATA(garden_rows).

    DATA(student_id) = line_index( students[ table_line = to_lower( student ) ] ) - 1.

    results = VALUE #(
                FOR row IN garden_rows
                FOR seed = 0 WHILE seed <= 1
                LET offset = ( student_id * 2 ) + seed IN
                ( SWITCH #( row+offset(1)
                    WHEN 'G' THEN 'grass'
                    WHEN 'C' THEN 'clover'
                    WHEN 'R' THEN 'radishes'
                    WHEN 'V' THEN 'violets' ) ) ).

  ENDMETHOD.


ENDCLASS.