class zcl_isogram definition public.
  public section.
    methods:
      is_isogram
        importing value(phrase) type string
        returning value(result) type abap_bool.

  private section.
    constants:
      english_alphabet_const type string value 'abcdefghijklmnopqrstuvwxyz'.

    types:
      char1 type c length 1,

      begin of letter_is_seen_struct,
        letter  type char1,
        is_seen type abap_bool,
      end of letter_is_seen_struct,
      letter_is_seen_tab type hashed table of letter_is_seen_struct with unique key letter.

    methods:
      char_at_index
        importing string        type string
                  index         type i
        returning value(result) type char1,

      create_init_seen_letters_tab
        returning value(result) type letter_is_seen_tab.
endclass.


class zcl_isogram implementation.
  method is_isogram.
    data(seen_letters) = create_init_seen_letters_tab(  ).
    data(phrase_lowercase) = to_lower( phrase ).
    data(number_of_chars_in_phrase) = strlen( phrase ).

    data(i) = 0.
    do number_of_chars_in_phrase times.
      i += 1.
      data(c) = char_at_index( string = phrase_lowercase index = i ).

      if not c ca english_alphabet_const.
        continue.  " we ignore white space and hyphens
      endif.

      if seen_letters[ letter = c ]-is_seen = abap_true.
        result = abap_false.
        return.
      else.
        seen_letters[ letter = c ]-is_seen = abap_true.
      endif.
    enddo.

    result = abap_true.
  endmethod.


  method char_at_index.
    result = substring( val = string off = index - 1 len = 1 ).
  endmethod.


  method create_init_seen_letters_tab.
    data(number_of_letters) = strlen( english_alphabet_const ).

    data(i) = 0.
    do number_of_letters times.
      i += 1.
      data(letter) = char_at_index( string = english_alphabet_const index = i ).
      insert value #( letter = letter is_seen = abap_false ) into table result.
    enddo.
  endmethod.
endclass.