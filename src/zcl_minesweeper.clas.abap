CLASS zcl_minesweeper DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS sweep IMPORTING input         TYPE string_table
                  RETURNING VALUE(result) TYPE string_table.
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES syinput(1) TYPE c.
    DATA board         TYPE string_table.
    DATA: height TYPE i,
          width  TYPE i.
    METHODS count_adj_mines IMPORTING x             TYPE i
                                      y             TYPE i
                            RETURNING VALUE(result) TYPE syinput.
ENDCLASS.



CLASS zcl_minesweeper IMPLEMENTATION.

  METHOD sweep.
    DATA row TYPE c LENGTH 255. "To allow substring access with write

    height = lines( input ).
    CHECK height > 0.

    board = input.
    width = strlen( board[ 1 ] ).

    "Note the differene in coordinate origins:
    "y is a table and starts at 1, and x is a string offset and starts at 0. ABAP is fun.

    DO height TIMES.

      DATA(y) = sy-index.
      row = board[ sy-index ].

      DO width TIMES.

        DATA(x) = sy-index - 1.
        IF row+x(1) = space.
          row+x(1) = count_adj_mines( x = x
                                      y = y ).
        ENDIF.

      ENDDO.

      APPEND |{ row WIDTH = width }| TO result.
    ENDDO.

  ENDMETHOD.


  METHOD count_adj_mines.

    DATA(off) = nmax( val1 = 0
                      val2 = x - 1 ).

    DATA(len) = nmin( val1 = 3
                      val2 = width - off
                      val3 = x + 2 ).

    result = REDUCE i(
        INIT s = 0
        FOR i = nmax( val1 = 1 val2 = y - 1 ) UNTIL
            i > nmin( val1 = y + 1 val2 = height )
        LET row = board[ i ] IN
        NEXT s = s + count( val = row+off(len)
                            sub = `*` ) ).

    IF result = '0'.
      result = space.
    ENDIF.

  ENDMETHOD.

ENDCLASS.