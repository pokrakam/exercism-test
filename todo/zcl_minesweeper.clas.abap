CLASS zcl_minesweeper DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
 
    METHODS annotate
       IMPORTING
         !input        TYPE string_table
       RETURNING
         VALUE(result) TYPE string_table.
    CONSTANTS:
       c_left           TYPE i VALUE 1,
       c_right          TYPE i VALUE 2,
       c_up_left        TYPE i VALUE 3,
       c_up             TYPE i VALUE 4,
       c_up_right       TYPE i VALUE 5,
       c_down_right     TYPE i VALUE 6,
       c_down           TYPE i VALUE 7,
       c_down_left      TYPE i VALUE 8,
       c_all_directions TYPE i VALUE 8
       .
 " Exercism.org doesn't know these SAP Types
    TYPES: BEGIN OF ty_submatch_result,
               offset  TYPE i,
               length  TYPE i ,
              END OF ty_submatch_result.
    TYPES: ty_submatch_result_tab TYPE STANDARD TABLE OF ty_submatch_result WITH DEFAULT KEY.
 
    TYPES: BEGIN OF ty_match_result,
        line  TYPE i,
        offset  TYPE i,
        length  TYPE i ,
        submatches  TYPE ty_submatch_result_tab,
        END OF ty_match_result.
 
    TYPES: ty_match_result_tab TYPE STANDARD TABLE OF ty_match_result WITH DEFAULT KEY.
 
  PRIVATE SECTION.
    METHODS add_to_mine_counter
       IMPORTING
         i_direction         TYPE i
         i_mine_pos          TYPE ty_match_result
         i_minefield         TYPE string_table
       RETURNING
         VALUE(result_field) TYPE string_table.
 
ENDCLASS.
 
CLASS zcl_minesweeper IMPLEMENTATION.
 
  METHOD annotate.
    DATA lt_mine_pos TYPE ty_match_result_tab.
    FIELD-SYMBOLS: <ls_mine_pos> TYPE ty_match_result.
 
    result = input.
    FIND ALL OCCURRENCES OF '*' IN TABLE input RESULTS lt_mine_pos.
    DATA(lv_direction) = 1.
    LOOP AT lt_mine_pos ASSIGNING <ls_mine_pos>.
      lv_direction = c_left.
      WHILE lv_direction <= c_all_directions.
        result = add_to_mine_counter( i_direction = lv_direction i_minefield = result i_mine_pos = <ls_mine_pos> ).
        lv_direction = lv_direction + 1.
      ENDWHILE.
    ENDLOOP.
  ENDMETHOD.
 
 
  METHOD add_to_mine_counter.
     "Exercism.org doesn't know SAP Type text1000
    TYPES: ty_text1000  TYPE c LENGTH 1000.
    DATA: lv_counter_position TYPE i,
           lv_out_of_bounds    TYPE abap_bool,
           lv_counter_line     TYPE i.
 
    CONSTANTS: lc_mine TYPE i VALUE -1.
 
    DATA(lv_mineposition) = i_mine_pos-offset.
    DATA(lv_minefield_len) = strlen( i_minefield[ 1 ] ).
 
    result_field = i_minefield.
 
    CASE i_direction.
      WHEN c_left.
        lv_counter_position = lv_mineposition - 1.
        lv_counter_line = i_mine_pos-line.
        lv_out_of_bounds = COND abap_bool( WHEN lv_mineposition = 0 THEN abap_true ELSE abap_false ).
      WHEN c_up_left.
        lv_counter_position = lv_mineposition - 1.
        lv_counter_line = i_mine_pos-line - 1.
        lv_out_of_bounds = COND abap_bool( WHEN lv_mineposition = 0 THEN abap_true
                                            WHEN lv_counter_line = 0 THEN abap_true
                                            ELSE abap_false ).
      WHEN c_up.
        lv_counter_position = lv_mineposition.
        lv_counter_line = i_mine_pos-line - 1.
        lv_out_of_bounds = COND abap_bool( WHEN lv_counter_line = 0 THEN abap_true
                                            ELSE abap_false ).
      WHEN c_up_right.
        lv_counter_position = lv_mineposition + 1.
        lv_counter_line = i_mine_pos-line - 1.
        lv_out_of_bounds = COND abap_bool( WHEN lv_counter_line = 0 THEN abap_true
                                            WHEN lv_mineposition = lv_minefield_len - 1 THEN abap_true
                                            ELSE abap_false ).
      WHEN c_right.
        lv_counter_position = lv_mineposition + 1.
        lv_out_of_bounds = COND abap_bool( WHEN lv_mineposition = lv_minefield_len - 1 THEN abap_true ELSE abap_false ).
        lv_counter_line = i_mine_pos-line.
      WHEN c_down_right.
        lv_counter_position = lv_mineposition + 1.
        lv_counter_line = i_mine_pos-line + 1.
        lv_out_of_bounds = COND abap_bool( WHEN lv_counter_line > lines( i_minefield ) THEN abap_true
                                            WHEN lv_mineposition = lv_minefield_len - 1 THEN abap_true
                                            ELSE abap_false ).
      WHEN c_down.
        lv_counter_position = lv_mineposition.
        lv_counter_line = i_mine_pos-line + 1.
        lv_out_of_bounds = COND abap_bool( WHEN lv_counter_line > lines( i_minefield ) THEN abap_true
                                              ELSE abap_false ).
      WHEN c_down_left.
        lv_counter_position = lv_mineposition - 1.
        lv_counter_line = i_mine_pos-line + 1.
        lv_out_of_bounds = COND abap_bool( WHEN lv_mineposition = 0 THEN abap_true
                                              WHEN lv_counter_line > lines( i_minefield ) THEN abap_true
                                              ELSE abap_false ).
 
    ENDCASE.
 
    IF  lv_out_of_bounds = abap_false.
      DATA(lv_field_value) = COND i( LET lv_count = substring( val = i_minefield[ lv_counter_line ] off = lv_counter_position len = 1 ) IN
                                WHEN lv_count = ` ` THEN 0
                                WHEN lv_count = `*` THEN lc_mine
                                ELSE lv_count
                              ).
      IF lv_field_value <> lc_mine.
        DATA(lv_line_with_counter) = CONV ty_text1000( result_field[ lv_counter_line ] ).
 
        lv_line_with_counter+lv_counter_position(1) = |{ lv_field_value + 1 }|.
        result_field[ lv_counter_line ] = |{ lv_line_with_counter WIDTH = lv_minefield_len }|.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.