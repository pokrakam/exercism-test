class zcl_beer_song definition public.
  public section.
    methods:
      recite
        importing initial_bottles_count type i
                  take_down_count       type i
        returning value(result)         type string_table.

  private section.
    methods:
      create_verse
        importing bottle        type i
        returning value(result) type string_table,

      create_verse_for_positive
        importing bottle        type i
        returning value(result) type string_table,

      create_verse_for_zero
        returning value(result) type string_table.
endclass.


class zcl_beer_song implementation.
  method recite.
    data(current_bottle) = initial_bottles_count.

    do take_down_count times.
      append lines of create_verse( current_bottle ) to result.
      current_bottle -= 1.

      if current_bottle <> initial_bottles_count - take_down_count.
        append `` to result.
      endif.
    enddo.
  endmethod.


  method create_verse.
    result = cond #(
      when bottle > 0 then create_verse_for_positive( bottle )
      else create_verse_for_zero(  )
    ).
  endmethod.


  method create_verse_for_positive.
    data(bottle_count_with_unit) = |{ bottle } bottle{ cond #( when bottle > 1 then 's' ) }|.
    data(what_to_take_down) = cond #( when bottle > 1 then 'one' else 'it' ).
    data(bottles_left) = switch #( bottle - 1
      when 0 then 'no more bottles'
      when 1 then '1 bottle'
      else |{ bottle - 1 } bottles|
    ).

    result = value #(
      ( |{ bottle_count_with_unit } of beer on the wall, { bottle_count_with_unit } of beer.| )
      ( |Take { what_to_take_down } down and pass it around, { bottles_left } of beer on the wall.| )
    ).
  endmethod.


  method create_verse_for_zero.
    result = value #(
      ( `No more bottles of beer on the wall, no more bottles of beer.` )
      ( `Go to the store and buy some more, 99 bottles of beer on the wall.` )
    ).
  endmethod.
endclass.