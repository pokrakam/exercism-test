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
    split CONDENSE( DIAGRAM ) at `\n` into table data(GARDEN_ROWS).

    data(STUDENT_ID) = LINE_INDEX( STUDENTS[ TABLE_LINE = TO_LOWER( STUDENT ) ] ) - 1.

    RESULTS = value #(
                for ROW in GARDEN_ROWS
                for SEED = 0 while SEED <= 1
                let OFFSET = ( STUDENT_ID * 2 ) + SEED in
                ( switch #( ROW+OFFSET(1)
                    when 'G' then 'grass'
                    when 'C' then 'clover'
                    when 'R' then 'radishes'
                    when 'V' then 'violets' ) ) ).
  endmethod.

endclass.