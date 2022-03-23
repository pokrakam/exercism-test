CLASS zcl_scrabble_score DEFINITION PUBLIC .

  PUBLIC SECTION.
    METHODS score
      IMPORTING
        input         TYPE string OPTIONAL
      RETURNING
        VALUE(result) TYPE i.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.


CLASS zcl_scrabble_score IMPLEMENTATION.
  
  METHOD score.
    result =
  REDUCE string( INIT s = 0
                 FOR  i = 0 WHILE i < strlen( input )
                 NEXT s += COND i( LET current_val = to_upper( input+i(1) ) IN
                 WHEN contains( val = 'AEIOULNRST' sub = current_val ) THEN 1
                 WHEN contains( val = 'DG' sub = current_val ) THEN 2
                 WHEN contains( val = 'BCMP' sub = current_val ) THEN 3
                 WHEN contains( val = 'FHVWY' sub = current_val ) THEN 4
                 WHEN contains( val = 'K' sub = current_val ) THEN 5
                 WHEN contains( val = 'JX' sub = current_val ) THEN 8
                 WHEN contains( val = 'QZ' sub = current_val ) THEN 10
                 ELSE 0
                 ) ).
  ENDMETHOD.

ENDCLASS.