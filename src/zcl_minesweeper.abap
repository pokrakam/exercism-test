class zcl_minesweeper definition
  public
  final
  create public .

  public section.
    methods sweep importing input         type string_table
                  returning value(result) type string_table.
  protected section.
  private section.
    data board         type string_table.
    data: height type i,
          width  type i.
    methods count_adj_mines importing x             type i
                                      y             type i
                            returning value(result) type syinput.
endclass.



class zcl_minesweeper implementation.

  method sweep.
    data row type c length 255. "To allow substring access with write

    height = lines( input ).
    check height > 0.

    board = input.
    width = strlen( board[ 1 ] ).

    "Note the differene in coordinate origins:
    "y is a table and starts at 1, and x is a string offset and starts at 0. ABAP is fun.

    do height times.

      data(y) = sy-index.
      row = board[ sy-index ].

      do width times.

        data(x) = sy-index - 1.
        if row+x(1) = space.
          row+x(1) = count_adj_mines( x = x
                                      y = y ).
        endif.

      enddo.

      append |{ row width = width }| to result.
    enddo.

  endmethod.


  method count_adj_mines.

    data(off) = nmax( val1 = 0 val2 = x - 1 ).
    data(len) = nmin( val1 = 3 val2 = width - off val3 = x + 2 ).

    result = reduce i(
        init s = 0
        for i = nmax( val1 = 1 val2 = y - 1 ) until
            i > nmin( val1 = y + 1 val2 = height )
        let row = board[ i ] in
        next s = s + count( val = row+off(len)
                            sub = `*` ) ).

    if result = '0'.
      result = space.
    endif.

  endmethod.

endclass.