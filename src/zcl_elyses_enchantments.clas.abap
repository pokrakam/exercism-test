CLASS zcl_elyses_enchantments DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES ty_stack TYPE STANDARD TABLE OF i WITH EMPTY KEY.

    METHODS:

      get_item
        IMPORTING stack         TYPE ty_stack
                  position      TYPE i
        RETURNING VALUE(result) TYPE i,

      set_item
        IMPORTING stack         TYPE ty_stack
                  position      TYPE i
                  replacement   TYPE i
        RETURNING VALUE(result) TYPE ty_stack,

      insert_item_at_top
        IMPORTING stack         TYPE ty_stack
                  new_card      TYPE i
        RETURNING VALUE(result) TYPE ty_stack,

      remove_item
        IMPORTING stack         TYPE ty_stack
                  position      TYPE i
        RETURNING VALUE(result) TYPE ty_stack,

      remove_item_from_top
        IMPORTING stack         TYPE ty_stack
        RETURNING VALUE(result) TYPE ty_stack,

      insert_item_at_bottom
        IMPORTING stack         TYPE ty_stack
                  new_card      TYPE i
        RETURNING VALUE(result) TYPE ty_stack,

      remove_item_from_bottom
        IMPORTING stack         TYPE ty_stack
        RETURNING VALUE(result) TYPE ty_stack,

      get_size_of_stack
        IMPORTING stack         TYPE ty_stack
        RETURNING VALUE(result) TYPE i.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_elyses_enchantments IMPLEMENTATION.

  METHOD get_item.
    result = stack[ position ].
  ENDMETHOD.

  METHOD set_item.

    result = stack.

    " abaplint issue #2452, can't do: result[ position ] = replacement.

    READ TABLE result INDEX position ASSIGNING FIELD-SYMBOL(<card>).
    IF <card> IS ASSIGNED.
      <card> = replacement.
    ENDIF.

  ENDMETHOD.

  METHOD insert_item_at_top.
    result = stack.
    APPEND new_card TO result.
  ENDMETHOD.

  METHOD get_size_of_stack.
    result = lines( stack ).
  ENDMETHOD.

  METHOD insert_item_at_bottom.
    result = stack.
    INSERT new_card INTO result INDEX 1.
  ENDMETHOD.

  METHOD remove_item.
    result = stack.
    DELETE result INDEX position.
  ENDMETHOD.

  METHOD remove_item_from_bottom.
    result = stack.
    DELETE result INDEX 1.
  ENDMETHOD.

  METHOD remove_item_from_top.
    result = stack.
    DELETE result INDEX lines( stack ).
  ENDMETHOD.

ENDCLASS.