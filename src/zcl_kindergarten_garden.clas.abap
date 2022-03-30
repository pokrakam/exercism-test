class ZCL_KINDERGARTEN_GARDEN definition
  public
  final
  create public.

  public section.
    methods CONSTRUCTOR.
    methods PLANTS
      importing
        DIAGRAM        type STRING
        STUDENT        type STRING
      returning
        value(RESULTS) type STRING_TABLE.

  private section.
    data STUDENTS type STRING_TABLE.
    methods GET_PLANT
      importing
        GARDEN_ROW    type STRING
        PLANT_NUMBER  type I
      returning
        value(RESULT) type STRING.

endclass.


class ZCL_KINDERGARTEN_GARDEN implementation.
  method CONSTRUCTOR.
    STUDENTS = value #( ( |alice| )
                        ( |bob| )
                        ( |charlie| )
                        ( |david| )
                        ( |eve| )
                        ( |fred| )
                        ( |ginny| )
                        ( |harriet| )
                        ( |ileana| )
                        ( |joseph| )
                        ( |kincaid| )
                        ( |larry| ) ).
  endmethod.

  method PLANTS.
    constants PLANTS_PER_STUDENT type I value 2.

    split CONDENSE( DIAGRAM ) at `\n` into table data(GARDEN_ROWS).

    data(STUDENT_ID) = ( LINE_INDEX( STUDENTS[ TABLE_LINE = TO_LOWER( STUDENT ) ] ) - 1 ).

    loop at GARDEN_ROWS into data(ROW).
      do PLANTS_PER_STUDENT times.
        insert GET_PLANT( GARDEN_ROW   = ROW
                          PLANT_NUMBER = ( ( STUDENT_ID * PLANTS_PER_STUDENT ) + ( SY-INDEX - 1 ) ) )
               into table RESULTS.
      enddo.
    endloop.
  endmethod.

  method GET_PLANT.
    RESULT = switch #(
                GARDEN_ROW+PLANT_NUMBER(1)
                when 'G' then 'grass'
                when 'C' then 'clover'
                when 'R' then 'radishes'
                when 'V' then 'violets' ).
  endmethod.
endclass.