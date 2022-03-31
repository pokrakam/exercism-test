CLASS zcl_high_scores DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES integertab TYPE STANDARD TABLE OF i WITH EMPTY KEY.
    METHODS constructor
      IMPORTING
        scores TYPE integertab.

    METHODS list_scores
      RETURNING
        VALUE(result) TYPE integertab.

    METHODS latest
      RETURNING
        VALUE(result) TYPE i.

    METHODS personalbest
      RETURNING
        VALUE(result) TYPE i.

    METHODS personaltopthree
      RETURNING
        VALUE(result) TYPE integertab.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA scores_list TYPE integertab.

    METHODS get_top_score_upto
      IMPORTING
        hits          TYPE i
      RETURNING
        VALUE(result) TYPE zcl_high_scores=>integertab.

ENDCLASS.


CLASS zcl_high_scores IMPLEMENTATION.

  METHOD constructor.
    scores_list = scores.
  ENDMETHOD.

  METHOD list_scores.
    result = scores_list.
  ENDMETHOD.

  METHOD latest.
    CHECK scores_list IS NOT INITIAL.
    result = scores_list[ lines( scores_list ) ].
  ENDMETHOD.

  METHOD personalbest.
    CHECK scores_list IS NOT INITIAL.
    DATA(top_scores) = get_top_score_upto( 1 ).
    result = top_scores[ 1 ].
  ENDMETHOD.

  METHOD personaltopthree.
    CHECK scores_list IS NOT INITIAL.
    result = get_top_score_upto( 3 ).
  ENDMETHOD.

  METHOD get_top_score_upto.
    DATA(sorted_scores) = scores_list.
    SORT sorted_scores BY table_line DESCENDING.
    result = VALUE #( ( LINES OF sorted_scores TO hits ) ).
  ENDMETHOD.


ENDCLASS.