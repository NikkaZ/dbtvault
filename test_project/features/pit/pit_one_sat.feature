@fixture.set_workdir
Feature: Point-In-Time (PIT) table - Base PIT behaviour with one hub and one satellite

############### READ BEFORE RUNNING THE TESTS ###############

# todo (or rather toanswer): will we allow the AS OF dates to be DATE in the PIT table or are we always going to convert them into DATETIME? What about LDTSs in the PIT?
# todo: Add cycles tests
# todo: Discuss with Neil the situation of the date/time format (of AS OF) or LDTSs;
  # Are we using only timestamps? do we allow for a difference in granularity?
  # If we allow for different gramnularities, do we define the lower granularity date as CONVERT_TO_TIME or do we keep at as it is?
  # (e.g. the AS OF are dates and LDTS are timestamps with nano seconds. Do we define AS OF as date + 00:00:00.000000 or we leave them as dates?)

######################### BASE LOAD #########################

  # DATES
  @fixture.pit_one_sat
#  Scenario: [BASE-LOAD] Base load into a pit table from two satellites with dates with AS OF dates all in the past
#    Given the PIT_CUSTOMER table does not exist
#    And the raw vault contains empty tables
#      | HUBS         | LINKS | SATS                 | PIT          |
#      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
#    And the RAW_STAGE_DETAILS table contains data
#      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
#      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 | *      |
#      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 | *      |
#      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-05 | *      |
#      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 | *      |
#      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-03 | *      |
#      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-05 | *      |
#    And I create the STG_CUSTOMER_DETAILS stage
#    # TODO: This is failing because 2018-06-31 isn't a valid date. There are only 30 days in June    .
#    And the AS_OF_DATE table is created and populated with data
#      | AS_OF_DATE |
#      | 2018-05-29 |
#      | 2018-06-30 |
#      | 2018-06-31 |
#    When I load the vault
#    Then the HUB_CUSTOMER table should contain expected data
#      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE   | SOURCE |
#      | md5('1001') | 1001        | 2018-06-01  | *      |
#      | md5('1002') | 1002        | 2018-06-01  | *      |
#      | md5('1003') | 1003        | 2018-06-01  | *      |
#    Then the SAT_CUSTOMER_DETAILS table should contain expected data
#      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
#      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01     | 2018-06-01 | *      |
#      | md5('1002') | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01     | 2018-06-01 | *      |
#      | md5('1002') | Bob           | 22 Forrest road Hampshire | 2006-04-17   | md5('22 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')  | 2018-06-05     | 2018-06-05 | *      |
#      | md5('1003') | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01     | 2018-06-01 | *      |
#      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAZ')  | 2018-06-03     | 2018-06-03 | *      |
#      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-11\|\|CHAZ')  | 2018-06-05     | 2018-06-05 | *      |
#    Then the PIT_CUSTOMER table should contain expected data
#      | CUSTOMER_PK | AS_OF_DATE | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
#      | md5('1001') | 2018-05-29 | 0000000000000000        | 1900-01-01                |
#      | md5('1001') | 2018-05-30 | 0000000000000000        | 1900-01-01                |
#      | md5('1001') | 2018-05-31 | 0000000000000000        | 1900-01-01                |
#      | md5('1002') | 2018-05-29 | 0000000000000000        | 1900-01-01                |
#      | md5('1002') | 2018-05-30 | 0000000000000000        | 1900-01-01                |
#      | md5('1002') | 2018-05-31 | 0000000000000000        | 1900-01-01                |
#      | md5('1003') | 2018-05-29 | 0000000000000000        | 1900-01-01                |
#      | md5('1003') | 2018-05-30 | 0000000000000000        | 1900-01-01                |
#      | md5('1003') | 2018-05-31 | 0000000000000000        | 1900-01-01                |

  @fixture.pit_one_sat
  Scenario: [BASE-LOAD] Base load into a pit table from two satellites with dates with AS OF dates in the past and in between LDTS
    Given the PIT_CUSTOMER table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS | SATS                 | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-05 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-03 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-05 | *      |
    And I create the STG_CUSTOMER_DETAILS stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-05-31 |
      | 2018-06-01 |
      | 2018-06-02 |
      | 2018-06-04 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE   | SOURCE |
      | md5('1001') | 1001        | 2018-06-01  | *      |
      | md5('1002') | 1002        | 2018-06-01  | *      |
      | md5('1003') | 1003        | 2018-06-01  | *      |
    Then the SAT_CUSTOMER_DETAILS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | Bob           | 22 Forrest road Hampshire | 2006-04-17   | md5('22 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')  | 2018-06-05     | 2018-06-05 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01     | 2018-06-01 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAZ')  | 2018-06-03     | 2018-06-03 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-11\|\|CHAZ')  | 2018-06-05     | 2018-06-05 | *      |
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2018-05-31 | 0000000000000000        | 1900-01-01                |
      | md5('1001') | 2018-06-01 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2018-06-02 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2018-06-04 | md5('1001')             | 2018-06-01                |
      | md5('1002') | 2018-05-31 | 0000000000000000        | 1900-01-01                |
      | md5('1002') | 2018-06-01 | md5('1002')             | 2018-06-01                |
      | md5('1002') | 2018-06-02 | md5('1002')             | 2018-06-01                |
      | md5('1002') | 2018-06-04 | md5('1002')             | 2018-06-01                |
      | md5('1003') | 2018-05-31 | 0000000000000000        | 1900-01-01                |
      | md5('1003') | 2018-06-01 | md5('1003')             | 2018-06-01                |
      | md5('1003') | 2018-06-02 | md5('1003')             | 2018-06-01                |
      | md5('1003') | 2018-06-04 | md5('1003')             | 2018-06-03                |

  @fixture.pit_one_sat
  Scenario: [BASE-LOAD] Base load into a pit table from two satellites with dates with AS OF dates in between LDTS and some in the future
    Given the PIT_CUSTOMER table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS | SATS                 | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-05 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-03 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-05 | *      |
    And I create the STG_CUSTOMER_DETAILS stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-06-02 |
      | 2018-06-04 |
      | 2018-06-06 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE   | SOURCE |
      | md5('1001') | 1001        | 2018-06-01  | *      |
      | md5('1002') | 1002        | 2018-06-01  | *      |
      | md5('1003') | 1003        | 2018-06-01  | *      |
    Then the SAT_CUSTOMER_DETAILS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | Bob           | 22 Forrest road Hampshire | 2006-04-17   | md5('22 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')  | 2018-06-05     | 2018-06-05 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01     | 2018-06-01 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAZ')  | 2018-06-03     | 2018-06-03 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-11\|\|CHAZ')  | 2018-06-05     | 2018-06-05 | *      |
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2016-06-02 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2016-06-04 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2016-06-06 | md5('1001')             | 2018-06-01                |
      | md5('1002') | 2016-06-02 | md5('1002')             | 2018-06-01                |
      | md5('1002') | 2016-06-04 | md5('1002')             | 2018-06-01                |
      | md5('1002') | 2016-06-06 | md5('1002')             | 2018-06-05                |
      | md5('1003') | 2016-06-02 | md5('1003')             | 2018-06-01                |
      | md5('1003') | 2016-06-04 | md5('1003')             | 2018-06-03                |
      | md5('1003') | 2016-06-06 | md5('1003')             | 2018-06-05                |

  @fixture.pit_one_sat
  Scenario: [BASE-LOAD] Base load into a pit table from two satellites with dates with all AS OF dates in the future
    Given the PIT_CUSTOMER table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS | SATS                 | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-05 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-03 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-05 | *      |
    And I create the STG_CUSTOMER_DETAILS stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-06-06 |
      | 2018-06-07 |
      | 2018-06-08 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE   | SOURCE |
      | md5('1001') | 1001        | 2018-06-01  | *      |
      | md5('1002') | 1002        | 2018-06-01  | *      |
      | md5('1003') | 1003        | 2018-06-01  | *      |
    Then the SAT_CUSTOMER_DETAILS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | Bob           | 22 Forrest road Hampshire | 2006-04-17   | md5('22 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')  | 2018-06-05     | 2018-06-05 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01     | 2018-06-01 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAZ')  | 2018-06-03     | 2018-06-03 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-11\|\|CHAZ')  | 2018-06-05     | 2018-06-05 | *      |
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2016-06-06 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2016-06-07 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2016-06-08 | md5('1001')             | 2018-06-01                |
      | md5('1002') | 2016-06-06 | md5('1002')             | 2018-06-05                |
      | md5('1002') | 2016-06-07 | md5('1002')             | 2018-06-05                |
      | md5('1002') | 2016-06-08 | md5('1002')             | 2018-06-05                |
      | md5('1003') | 2016-06-06 | md5('1003')             | 2018-06-05                |
      | md5('1003') | 2016-06-07 | md5('1003')             | 2018-06-05                |
      | md5('1003') | 2016-06-08 | md5('1003')             | 2018-06-05                |

  @fixture.pit_one_sat
  Scenario: [BASE-LOAD] Base load into a pit table from one satellite with dates with an encompassing range of AS OF dates
    Given the PIT_CUSTOMER table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS | SATS                 | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-05 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-03 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-05 | *      |
    And I create the STG_CUSTOMER_DETAILS stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-05-31 |
      | 2018-06-01 |
      | 2018-06-02 |
      | 2018-06-03 |
      | 2018-06-04 |
      | 2018-06-05 |
      | 2018-06-06 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE   | SOURCE |
      | md5('1001') | 1001        | 2018-06-01  | *      |
      | md5('1002') | 1002        | 2018-06-01  | *      |
      | md5('1003') | 1003        | 2018-06-01  | *      |
    Then the SAT_CUSTOMER_DETAILS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | Bob           | 22 Forrest road Hampshire | 2006-04-17   | md5('22 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')  | 2018-06-05     | 2018-06-05 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01     | 2018-06-01 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAZ')  | 2018-06-03     | 2018-06-03 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-11\|\|CHAZ')  | 2018-06-05     | 2018-06-05 | *      |
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2018-05-31 | 0000000000000000        | 1900-01-01                |
      | md5('1001') | 2018-06-01 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2018-06-02 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2018-06-03 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2018-06-04 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2018-06-05 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2018-06-06 | md5('1001')             | 2018-06-01                |
      | md5('1002') | 2018-05-31 | 0000000000000000        | 1900-01-01                |
      | md5('1002') | 2018-06-01 | md5('1002')             | 2018-06-01                |
      | md5('1002') | 2018-06-02 | md5('1002')             | 2018-06-01                |
      | md5('1002') | 2018-06-03 | md5('1002')             | 2018-06-01                |
      | md5('1002') | 2018-06-04 | md5('1002')             | 2018-06-01                |
      | md5('1002') | 2018-06-05 | md5('1002')             | 2018-06-05                |
      | md5('1002') | 2018-06-06 | md5('1002')             | 2018-06-05                |
      | md5('1003') | 2018-05-31 | 0000000000000000        | 1900-01-01                |
      | md5('1003') | 2018-06-01 | md5('1003')             | 2018-06-01                |
      | md5('1003') | 2018-06-02 | md5('1003')             | 2018-06-01                |
      | md5('1003') | 2018-06-03 | md5('1003')             | 2018-06-03                |
      | md5('1003') | 2018-06-04 | md5('1003')             | 2018-06-03                |
      | md5('1003') | 2018-06-05 | md5('1003')             | 2018-06-05                |
      | md5('1003') | 2018-06-06 | md5('1003')             | 2018-06-05                |

  # TIMESTAMPS
  # todo: the satellite sourced column names in the PIT might need to 
  @fixture.pit_one_sat
  Scenario: [BASE-LOAD-TS] Base load into a pit table from one satellite with timestamps with al AS OF timestamps in the past
    Given the PIT_CUSTOMER_TS table does not exist
    And the raw vault contains empty tables
      | HUBS            | LINKS | SATS                    | PIT             |
      | HUB_CUSTOMER_TS |       | SAT_CUSTOMER_DETAILS_TS | PIT_CUSTOMER_TS |
    And the RAW_STAGE_DETAILS_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATE                  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-01 23:59:59.999999 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 00:00:00.000000 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 12:00:00.000001 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-01 23:59:59.999999 | *      |
    And I create the STG_CUSTOMER_DETAILS_TS stage
    And the AS_OF_DATE_TS table is created and populated with data
      | AS_OF_DATE                 |
      | 2018-05-31 12:00:00.000001 |
      | 2018-05-31 23:59:59.999998 |
      | 2018-05-31 23:59:59.999999 |
    When I load the vault
    Then the HUB_CUSTOMER_TS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE                  | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000000 | *      |
    Then the SAT_CUSTOMER_DETAILS_TS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | Bob           | 22 Forrest road Hampshire | 2006-04-17   | md5('22 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')  | 2018-06-01 23:59:59.999999 | 2018-06-01 23:59:59.999999 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAZ')  | 2018-06-01 12:00:00.000001 | 2018-06-01 12:00:00.000001 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-11\|\|CHAZ')  | 2018-06-01 23:59:59.999999 | 2018-06-01 23:59:59.999999 | *      |
    Then the PIT_CUSTOMER_TS table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE                 | SAT_CUSTOMER_DETAILS_TS_PK | SAT_CUSTOMER_DETAILS_TS_LDTS  |
      | md5('1001') | 2018-05-31 12:00:00.000001 | 0000000000000000           | 1900-01-01 00:00:00.000000    |
      | md5('1001') | 2018-05-31 23:59:59.999998 | 0000000000000000           | 1900-01-01 00:00:00.000000    |
      | md5('1001') | 2018-05-31 23:59:59.999999 | 0000000000000000           | 1900-01-01 00:00:00.000000    |
      | md5('1002') | 2018-05-31 12:00:00.000001 | 0000000000000000           | 1900-01-01 00:00:00.000000    |
      | md5('1002') | 2018-05-31 23:59:59.999998 | 0000000000000000           | 1900-01-01 00:00:00.000000    |
      | md5('1002') | 2018-05-31 23:59:59.999999 | 0000000000000000           | 1900-01-01 00:00:00.000000    |
      | md5('1003') | 2018-05-31 12:00:00.000001 | 0000000000000000           | 1900-01-01 00:00:00.000000    |
      | md5('1003') | 2018-05-31 23:59:59.999998 | 0000000000000000           | 1900-01-01 00:00:00.000000    |
      | md5('1003') | 2018-05-31 23:59:59.999999 | 0000000000000000           | 1900-01-01 00:00:00.000000    |

  @fixture.pit_one_sat
  Scenario: [BASE-LOAD-TS] Base load into a pit table from one satellite with timestamps with some AS OF timestamps in the past and sone in between LDTS
    Given the PIT_CUSTOMER_TS table does not exist
    And the raw vault contains empty tables
      | HUBS            | LINKS | SATS                    | PIT             |
      | HUB_CUSTOMER_TS |       | SAT_CUSTOMER_DETAILS_TS | PIT_CUSTOMER_TS |
    And the RAW_STAGE_DETAILS_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATE                  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-01 23:59:59.999999 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 00:00:00.000000 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 12:00:00.000001 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-01 23:59:59.999999 | *      |
    And I create the STG_CUSTOMER_DETAILS_TS stage
    And the AS_OF_DATE_TS table is created and populated with data
      | AS_OF_DATE                 |
      | 2018-05-31 23:59:59.999999 |
      | 2019-06-01 00:00:00.000000 |
      | 2019-06-01 12:00:00.000000 |
      | 2019-06-01 23:59:59.999998 |
    When I load the vault
    Then the HUB_CUSTOMER_TS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE                  | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000000 | *      |
    Then the SAT_CUSTOMER_DETAILS_TS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | Bob           | 22 Forrest road Hampshire | 2006-04-17   | md5('22 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')  | 2018-06-01 23:59:59.999999 | 2018-06-01 23:59:59.999999 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAZ')  | 2018-06-01 12:00:00.000001 | 2018-06-01 12:00:00.000001 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-11\|\|CHAZ')  | 2018-06-01 23:59:59.999999 | 2018-06-01 23:59:59.999999 | *      |
    Then the PIT_CUSTOMER_TS table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE                 | SAT_CUSTOMER_DETAILS_TS_PK | SAT_CUSTOMER_DETAILS_TS_LDTS |
      | md5('1001') | 2018-05-31 23:59:59.999999 | 0000000000000000           | 1900-01-01 00:00:00.000000   |
      | md5('1001') | 2018-06-01 00:00:00.000000 | md5('1001')                | 2018-06-01 00:00:00.000000   |
      | md5('1001') | 2018-06-01 12:00:00.000000 | md5('1001')                | 2018-06-01 00:00:00.000000   |
      | md5('1001') | 2018-06-01 23:59:59.999998 | md5('1001')                | 2018-06-01 00:00:00.000000   |
      | md5('1002') | 2018-05-31 23:59:59.999999 | 0000000000000000           | 1900-01-01 00:00:00.000000   |
      | md5('1002') | 2018-06-01 00:00:00.000000 | md5('1002')                | 2018-06-01 00:00:00.000000   |
      | md5('1002') | 2018-06-01 12:00:00.000000 | md5('1002')                | 2018-06-01 00:00:00.000000   |
      | md5('1002') | 2018-06-01 23:59:59.999998 | md5('1002')                | 2018-06-01 00:00:00.000000   |
      | md5('1003') | 2018-05-31 23:59:59.999999 | 0000000000000000           | 1900-01-01 00:00:00.000000   |
      | md5('1003') | 2018-06-01 00:00:00.000000 | md5('1003')                | 2018-06-01 00:00:00.000000   |
      | md5('1003') | 2018-06-01 12:00:00.000000 | md5('1003')                | 2018-06-01 00:00:00.000000   |
      | md5('1003') | 2018-06-01 23:59:59.999998 | md5('1003')                | 2018-06-01 12:00:00.000001   |

  @fixture.pit_one_sat
  Scenario: [BASE-LOAD-TS] Base load into a pit table from two satellites with timestamps with AS OF timestamps in between LDTS and some in the future
    Given the PIT_CUSTOMER_TS table does not exist
    And the raw vault contains empty tables
      | HUBS            | LINKS | SATS                    | PIT             |
      | HUB_CUSTOMER_TS |       | SAT_CUSTOMER_DETAILS_TS | PIT_CUSTOMER_TS |
    And the RAW_STAGE_DETAILS_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATE                  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-01 23:59:59.999999 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 00:00:00.000000 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 12:00:00.000001 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-01 23:59:59.999999 | *      |
    And I create the STG_CUSTOMER_DETAILS_TS stage
    And the AS_OF_DATE_TS table is created and populated with data
      | AS_OF_DATE                 |
      | 2019-06-01 00:00:00.000001 |
      | 2019-06-01 12:00:00.000000 |
      | 2019-06-01 12:00:00.000001 |
      | 2019-06-01 23:59:59.999999 |
      | 2019-06-02 00:00:00.000000 |
    When I load the vault
    Then the HUB_CUSTOMER_TS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE                  | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000000 | *      |
    Then the SAT_CUSTOMER_DETAILS_TS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | Bob           | 22 Forrest road Hampshire | 2006-04-17   | md5('22 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')  | 2018-06-01 23:59:59.999999 | 2018-06-01 23:59:59.999999 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAZ')  | 2018-06-01 12:00:00.000001 | 2018-06-01 12:00:00.000001 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-11\|\|CHAZ')  | 2018-06-01 23:59:59.999999 | 2018-06-01 23:59:59.999999 | *      |
    Then the PIT_CUSTOMER_TS table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE                 | SAT_CUSTOMER_DETAILS_TS_PK | SAT_CUSTOMER_DETAILS_TS_LDTS |
      | md5('1001') | 2019-06-01 00:00:00.000001 | md5('1001')                | 2018-06-01 00:00:00.000000   |
      | md5('1001') | 2019-06-01 12:00:00.000000 | md5('1001')                | 2018-06-01 00:00:00.000000   |
      | md5('1001') | 2019-06-01 12:00:00.000001 | md5('1001')                | 2018-06-01 00:00:00.000000   |
      | md5('1001') | 2019-06-01 23:59:59.999999 | md5('1001')                | 2018-06-01 00:00:00.000000   |
      | md5('1001') | 2019-06-02 00:00:00.000000 | md5('1001')                | 2018-06-01 00:00:00.000000   |
      | md5('1002') | 2019-06-01 00:00:00.000001 | md5('1002')                | 2018-06-01 00:00:00.000000   |
      | md5('1002') | 2019-06-01 12:00:00.000000 | md5('1002')                | 2018-06-01 00:00:00.000000   |
      | md5('1002') | 2019-06-01 12:00:00.000001 | md5('1002')                | 2018-06-01 00:00:00.000000   |
      | md5('1002') | 2019-06-01 23:59:59.999999 | md5('1002')                | 2018-06-01 23:59:59.999999   |
      | md5('1002') | 2019-06-02 00:00:00.000000 | md5('1002')                | 2018-06-01 23:59:59.999999   |
      | md5('1003') | 2019-06-01 00:00:00.000001 | md5('1003')                | 2018-06-01 00:00:00.000000   |
      | md5('1003') | 2019-06-01 12:00:00.000000 | md5('1003')                | 2018-06-01 00:00:00.000000   |
      | md5('1003') | 2019-06-01 12:00:00.000001 | md5('1003')                | 2018-06-01 12:00:00.000001   |
      | md5('1003') | 2019-06-01 23:59:59.999999 | md5('1003')                | 2018-06-01 23:59:59.999999   |
      | md5('1003') | 2019-06-02 00:00:00.000000 | md5('1003')                | 2018-06-01 23:59:59.999999   |

  @fixture.pit_one_sat
  Scenario: [BASE-LOAD-TS] Base load into a pit table from two satellites with timestamps with all AS OF timestamps in the future
    Given the PIT_CUSTOMER_TS table does not exist
    And the raw vault contains empty tables
      | HUBS            | LINKS | SATS                    | PIT             |
      | HUB_CUSTOMER_TS |       | SAT_CUSTOMER_DETAILS_TS | PIT_CUSTOMER_TS |
    And the RAW_STAGE_DETAILS_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATE                  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-01 23:59:59.999999 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 00:00:00.000000 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 12:00:00.000001 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-01 23:59:59.999999 | *      |
    And I create the STG_CUSTOMER_DETAILS_TS stage
    And the AS_OF_DATE_TS table is created and populated with data
      | AS_OF_DATE                 |
      | 2019-06-02 00:00:00.000000 |
    When I load the vault
    Then the HUB_CUSTOMER_TS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE                  | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000000 | *      |
    Then the SAT_CUSTOMER_DETAILS_TS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | Bob           | 22 Forrest road Hampshire | 2006-04-17   | md5('22 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')  | 2018-06-01 23:59:59.999999 | 2018-06-01 23:59:59.999999 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAZ')  | 2018-06-01 12:00:00.000001 | 2018-06-01 12:00:00.000001 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-11\|\|CHAZ')  | 2018-06-01 23:59:59.999999 | 2018-06-01 23:59:59.999999 | *      |
    Then the PIT_CUSTOMER_TS table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE                 | SAT_CUSTOMER_DETAILS_TS_PK | SAT_CUSTOMER_DETAILS_TS_LDTS |
      | md5('1001') | 2019-06-01 00:00:00.000001 | md5('1001')                | 2018-06-01 00:00:00.000000   |
      | md5('1001') | 2019-06-01 12:00:00.000000 | md5('1001')                | 2018-06-01 00:00:00.000000   |
      | md5('1001') | 2019-06-01 12:00:00.000001 | md5('1001')                | 2018-06-01 00:00:00.000000   |
      | md5('1001') | 2019-06-01 23:59:59.999999 | md5('1001')                | 2018-06-01 00:00:00.000000   |
      | md5('1001') | 2019-06-02 00:00:00.000000 | md5('1001')                | 2018-06-01 00:00:00.000000   |
      | md5('1002') | 2019-06-01 00:00:00.000001 | md5('1002')                | 2018-06-01 00:00:00.000000   |
      | md5('1002') | 2019-06-01 12:00:00.000000 | md5('1002')                | 2018-06-01 00:00:00.000000   |
      | md5('1002') | 2019-06-01 12:00:00.000001 | md5('1002')                | 2018-06-01 00:00:00.000000   |
      | md5('1002') | 2019-06-01 23:59:59.999999 | md5('1002')                | 2018-06-01 23:59:59.999999   |
      | md5('1002') | 2019-06-02 00:00:00.000000 | md5('1002')                | 2018-06-01 23:59:59.999999   |
      | md5('1003') | 2019-06-01 00:00:00.000001 | md5('1003')                | 2018-06-01 00:00:00.000000   |
      | md5('1003') | 2019-06-01 12:00:00.000000 | md5('1003')                | 2018-06-01 00:00:00.000000   |
      | md5('1003') | 2019-06-01 12:00:00.000001 | md5('1003')                | 2018-06-01 12:00:00.000001   |
      | md5('1003') | 2019-06-01 23:59:59.999999 | md5('1003')                | 2018-06-01 23:59:59.999999   |
      | md5('1003') | 2019-06-02 00:00:00.000000 | md5('1003')                | 2018-06-01 23:59:59.999999   |

  @fixture.pit_one_sat
  Scenario: [BASE-LOAD-TS] Base load into a pit table from one satellite with timestamps with an encompassing range of AS OF timestamps
    Given the PIT_CUSTOMER_TS table does not exist
    And the raw vault contains empty tables
      | HUBS            | LINKS | SATS                    | PIT             |
      | HUB_CUSTOMER_TS |       | SAT_CUSTOMER_DETAILS_TS | PIT_CUSTOMER_TS |
    And the RAW_STAGE_DETAILS_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATE                  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-01 23:59:59.999999 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 00:00:00.000000 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 12:00:00.000001 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-01 23:59:59.999999 | *      |
    And I create the STG_CUSTOMER_DETAILS_TS stage
    And the AS_OF_DATE_TS table is created and populated with data
      | AS_OF_DATE                 |
      | 2018-05-31 23:59:59.999999 |
      | 2018-06-01 00:00:00.000000 |
      | 2018-06-01 12:00:00.000000 |
      | 2018-06-01 12:00:00.000001 |
      | 2018-06-01 23:59:59.999998 |
      | 2018-06-01 23:59:59.999999 |
      | 2018-06-02 00:00:00.000000 |
    When I load the vault
    Then the HUB_CUSTOMER_TS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE                  | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000000 | *      |
    Then the SAT_CUSTOMER_DETAILS_TS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | Bob           | 22 Forrest road Hampshire | 2006-04-17   | md5('22 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')  | 2018-06-01 23:59:59.999999 | 2018-06-01 23:59:59.999999 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAZ')  | 2018-06-01 12:00:00.000001 | 2018-06-01 12:00:00.000001 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-11\|\|CHAZ')  | 2018-06-01 23:59:59.999999 | 2018-06-01 23:59:59.999999 | *      |
    Then the PIT_CUSTOMER_TS table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE                 | SAT_CUSTOMER_DETAILS_TS_PK | SAT_CUSTOMER_DETAILS_TS_LDTS |
      | md5('1001') | 2018-05-31 23:59:59.999999 | 0000000000000000           | 1900-01-01 00:00:00.000000   |
      | md5('1001') | 2018-06-01 00:00:00.000000 | md5('1001')                | 2018-06-01 00:00:00.000000   |
      | md5('1001') | 2018-06-01 12:00:00.000000 | md5('1001')                | 2018-06-01 00:00:00.000000   |
      | md5('1001') | 2018-06-01 12:00:00.000001 | md5('1001')                | 2018-06-01 00:00:00.000000   |
      | md5('1001') | 2018-06-01 23:59:59.999998 | md5('1001')                | 2018-06-01 00:00:00.000000   |
      | md5('1001') | 2018-06-01 23:59:59.999999 | md5('1001')                | 2018-06-01 00:00:00.000000   |
      | md5('1001') | 2018-06-02 00:00:00.000000 | md5('1001')                | 2018-06-01 00:00:00.000000   |
      | md5('1002') | 2018-05-31 23:59:59.999999 | 0000000000000000           | 1900-01-01 00:00:00.000000   |
      | md5('1002') | 2018-06-01 00:00:00.000000 | md5('1002')                | 2018-06-01 00:00:00.000000   |
      | md5('1002') | 2018-06-01 12:00:00.000000 | md5('1002')                | 2018-06-01 00:00:00.000000   |
      | md5('1002') | 2018-06-01 12:00:00.000001 | md5('1002')                | 2018-06-01 00:00:00.000000   |
      | md5('1002') | 2018-06-01 23:59:59.999998 | md5('1002')                | 2018-06-01 00:00:00.000000   |
      | md5('1002') | 2018-06-01 23:59:59.999999 | md5('1002')                | 2018-06-01 23:59:59.999999   |
      | md5('1002') | 2018-06-02 00:00:00.000000 | md5('1002')                | 2018-06-01 23:59:59.999999   |
      | md5('1003') | 2018-05-31 23:59:59.999999 | 0000000000000000           | 1900-01-01 00:00:00.000000   |
      | md5('1003') | 2018-06-01 00:00:00.000000 | md5('1003')                | 2018-06-01 00:00:00.000000   |
      | md5('1003') | 2018-06-01 12:00:00.000000 | md5('1003')                | 2018-06-01 00:00:00.000000   |
      | md5('1003') | 2018-06-01 12:00:00.000001 | md5('1003')                | 2018-06-01 12:00:00.000001   |
      | md5('1003') | 2018-06-01 23:59:59.999998 | md5('1003')                | 2018-06-01 12:00:00.000001   |
      | md5('1003') | 2018-06-01 23:59:59.999999 | md5('1003')                | 2018-06-01 23:59:59.999999   |
      | md5('1003') | 2018-06-02 00:00:00.000000 | md5('1003')                | 2018-06-01 23:59:59.999999   |

  # AS OF - LOWER GRANULARITY
  @fixture.pit_one_sat
  Scenario: [BASE-LOAD-LG] Base load into a pit table from one satellite with timestamps where AS OF dates are in the future
    Given the PIT_CUSTOMER_LG table does not exist
    And the raw vault contains empty tables
      | HUBS            | LINKS | SATS                    | PIT             |
      | HUB_CUSTOMER_TS |       | SAT_CUSTOMER_DETAILS_TS | PIT_CUSTOMER_LG |
    And the RAW_STAGE_DETAILS_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE                  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 00:00:00.000001 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire | 1988-02-12   | 2018-06-01 00:00:00.000002 | *      |
    And I create the STG_CUSTOMER_DETAILS_TS stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-06-02 |
      | 2018-06-03 |
      | 2018-06-04 |
    When I load the vault
    Then the HUB_CUSTOMER_TS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE                  | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000001 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000002 | *      |
    Then the SAT_CUSTOMER_DETAILS_TS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01 00:00:00.000001 | 2018-06-01 00:00:00.000001 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01 00:00:00.000002 | 2018-06-01 00:00:00.000002 | *      |
    Then the PIT_CUSTOMER_LG table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE | SAT_CUSTOMER_DETAILS_TS_PK | SAT_CUSTOMER_DETAILS_TS_LDTS |
      | md5('1001') | 2018-06-02 | md5('1001')                | 2018-06-01 00:00:00.000000   |
      | md5('1001') | 2018-06-03 | md5('1001')                | 2018-06-01 00:00:00.000000   |
      | md5('1001') | 2018-06-04 | md5('1001')                | 2018-06-01 00:00:00.000000   |
      | md5('1002') | 2018-06-02 | md5('1002')                | 2018-06-01 00:00:00.000001   |
      | md5('1002') | 2018-06-03 | md5('1002')                | 2018-06-01 00:00:00.000001   |
      | md5('1002') | 2018-06-04 | md5('1002')                | 2018-06-01 00:00:00.000001   |
      | md5('1003') | 2018-06-02 | md5('1003')                | 2018-06-01 00:00:00.000002   |
      | md5('1003') | 2018-06-03 | md5('1003')                | 2018-06-01 00:00:00.000002   |
      | md5('1003') | 2018-06-04 | md5('1003')                | 2018-06-01 00:00:00.000002   |

  @fixture.pit_one_sat
  Scenario: [BASE-LOAD-LG] Base load into a pit table from one satellite with timestamps where AS OF dates are in the past
    Given the PIT_CUSTOMER_LG table does not exist
    And the raw vault contains empty tables
      | HUBS            | LINKS | SATS                    | PIT             |
      | HUB_CUSTOMER_TS |       | SAT_CUSTOMER_DETAILS_TS | PIT_CUSTOMER_LG |
    And the RAW_STAGE_DETAILS_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE                  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 00:00:00.000001 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire | 1988-02-12   | 2018-06-01 00:00:00.000002 | *      |
    And I create the STG_CUSTOMER_DETAILS_TS stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-05-29 |
      | 2018-05-30 |
      | 2018-05-31 |
    When I load the vault
    Then the HUB_CUSTOMER_TS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE                  | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000001 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000002 | *      |
    Then the SAT_CUSTOMER_DETAILS_TS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01 00:00:00.000001 | 2018-06-01 00:00:00.000001 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01 00:00:00.000002 | 2018-06-01 00:00:00.000002 | *      |
    Then the PIT_CUSTOMER_LG table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE | SAT_CUSTOMER_DETAILS_TS_PK | SAT_CUSTOMER_DETAILS_TS_LDTS |
      | md5('1001') | 2018-05-29 | 0000000000000000           | 1900-01-01 00:00:00.000000   |
      | md5('1001') | 2018-05-30 | 0000000000000000           | 1900-01-01 00:00:00.000000   |
      | md5('1001') | 2018-05-31 | 0000000000000000           | 1900-01-01 00:00:00.000000   |
      | md5('1002') | 2018-05-29 | 0000000000000000           | 1900-01-01 00:00:00.000000   |
      | md5('1002') | 2018-05-30 | 0000000000000000           | 1900-01-01 00:00:00.000000   |
      | md5('1002') | 2018-05-31 | 0000000000000000           | 1900-01-01 00:00:00.000000   |
      | md5('1003') | 2018-05-29 | 0000000000000000           | 1900-01-01 00:00:00.000000   |
      | md5('1003') | 2018-05-30 | 0000000000000000           | 1900-01-01 00:00:00.000000   |
      | md5('1003') | 2018-05-31 | 0000000000000000           | 1900-01-01 00:00:00.000000   |

  @fixture.pit_one_sat
  Scenario: [BASE-LOAD-LG] Base load into a pit table from one satellite with timestamps with an encompassing range of AS OF timestamps
    Given the PIT_CUSTOMER_LG table does not exist
    And the raw vault contains empty tables
      | HUBS            | LINKS | SATS                    | PIT             |
      | HUB_CUSTOMER_TS |       | SAT_CUSTOMER_DETAILS_TS | PIT_CUSTOMER_LG |
    And the RAW_STAGE_DETAILS_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE                  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 00:00:00.000001 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire | 1988-02-12   | 2018-06-01 00:00:00.000002 | *      |
    And I create the STG_CUSTOMER_DETAILS_TS stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-05-31 |
      | 2018-06-01 |
      | 2018-06-02 |
    When I load the vault
    Then the HUB_CUSTOMER_TS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE   | SOURCE |
      | md5('1001') | 1001        | 2018-06-01  | *      |
      | md5('1002') | 1002        | 2018-06-01  | *      |
      | md5('1003') | 1003        | 2018-06-01  | *      |
    Then the SAT_CUSTOMER_DETAILS_TS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01     | 2018-06-01 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01     | 2018-06-01 | *      |
    Then the PIT_CUSTOMER_LG table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE | SAT_CUSTOMER_DETAILS_TS_PK | SAT_CUSTOMER_DETAILS_TS_LDTS |
      | md5('1001') | 2018-05-31 | 0000000000000000           | 1900-01-01 00:00:00.000000   |
      | md5('1001') | 2018-06-01 | md5('1001')                | 2018-06-01 00:00:00.000000   |
      | md5('1001') | 2018-06-02 | md5('1001')                | 2018-06-01 00:00:00.000000   |
      | md5('1002') | 2018-05-31 | 0000000000000000           | 1900-01-01 00:00:00.000000   |
      | md5('1002') | 2018-06-01 | 0000000000000000           | 1900-01-01 00:00:00.000000   |
      | md5('1002') | 2018-06-02 | md5('1002')                | 2018-06-01 00:00:00.000001   |
      | md5('1003') | 2018-05-31 | 0000000000000000           | 1900-01-01 00:00:00.000000   |
      | md5('1003') | 2018-06-01 | 0000000000000000           | 1900-01-01 00:00:00.000000   |
      | md5('1003') | 2018-06-02 | md5('1003')                | 2018-06-01 00:00:00.000002   |

  # AS OF - HIGHER GRANULARITY
  @fixture.pit_one_sat
  Scenario: [BASE-LOAD-HG] Base load into a pit table from one satellite with dates where AS OF timestamps are in the future
    Given the PIT_CUSTOMER_HG table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS | SATS                 | PIT             |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER_HG |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire | 1988-02-12   | 2018-06-01 | *      |
    And I create the STG_CUSTOMER_DETAILS stage
    And the AS_OF_DATE_TS table is created and populated with data
      | AS_OF_DATE                 |
      | 2018-06-01 00:00:00.000001 |
      | 2018-06-01 12:00:00.000001 |
      | 2018-06-02 00:00:00.000001 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 | *      |
      | md5('1002') | 1002        | 2018-06-01 | *      |
      | md5('1003') | 1003        | 2018-06-01 | *      |
    Then the SAT_CUSTOMER_DETAILS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01     | 2018-06-01 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01     | 2018-06-01 | *      |
    Then the PIT_CUSTOMER_HG table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE                 | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2018-06-01 00:00:00.000001 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2018-06-01 12:00:00.000001 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2018-06-02 00:00:00.000001 | md5('1001')             | 2018-06-01                |
      | md5('1002') | 2018-06-01 00:00:00.000001 | md5('1002')             | 2018-06-01                |
      | md5('1002') | 2018-06-01 12:00:00.000001 | md5('1002')             | 2018-06-01                |
      | md5('1002') | 2018-06-02 00:00:00.000001 | md5('1002')             | 2018-06-01                |
      | md5('1003') | 2018-06-01 00:00:00.000001 | md5('1003')             | 2018-06-01                |
      | md5('1003') | 2018-06-01 12:00:00.000001 | md5('1003')             | 2018-06-01                |
      | md5('1003') | 2018-06-02 00:00:00.000001 | md5('1003')             | 2018-06-01                |

  @fixture.pit_one_sat
  Scenario: [BASE-LOAD-HG] Base load into a pit table from one satellite with dates where AS OF timestamps are in the past
    Given the PIT_CUSTOMER_HG table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS | SATS                 | PIT             |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER_HG |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire | 1988-02-12   | 2018-06-01 | *      |
    And I create the STG_CUSTOMER_DETAILS stage
    And the AS_OF_DATE_TS table is created and populated with data
      | AS_OF_DATE                 |
      | 2018-05-31 00:00:00.000000 |
      | 2018-05-31 12:30:00.000001 |
      | 2018-05-31 23:59:59.999999 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 | *      |
      | md5('1002') | 1002        | 2018-06-01 | *      |
      | md5('1003') | 1003        | 2018-06-01 | *      |
    Then the SAT_CUSTOMER_DETAILS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01     | 2018-06-01 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01     | 2018-06-01 | *      |
    Then the PIT_CUSTOMER_HG table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE                 | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2018-05-31 00:00:00.000000 | 0000000000000000        | 1900-01-01                |
      | md5('1001') | 2018-05-31 12:30:00.000001 | 0000000000000000        | 1900-01-01                |
      | md5('1001') | 2018-05-31 23:59:59.999999 | 0000000000000000        | 1900-01-01                |
      | md5('1002') | 2018-05-31 00:00:00.000000 | 0000000000000000        | 1900-01-01                |
      | md5('1002') | 2018-05-31 12:30:00.000001 | 0000000000000000        | 1900-01-01                |
      | md5('1002') | 2018-05-31 23:59:59.999999 | 0000000000000000        | 1900-01-01                |
      | md5('1003') | 2018-05-31 00:00:00.000000 | 0000000000000000        | 1900-01-01                |
      | md5('1003') | 2018-05-31 12:30:00.000001 | 0000000000000000        | 1900-01-01                |
      | md5('1003') | 2018-05-31 23:59:59.999999 | 0000000000000000        | 1900-01-01                |

  @fixture.pit_one_sat
  Scenario: [BASE-LOAD-HG] Base load into a pit table from one satellite with dates with an encompassing range of AS OF timestamps
    Given the PIT_CUSTOMER_HG table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS | SATS                 | PIT             |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER_HG |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire | 1988-02-12   | 2018-06-01 | *      |
    And I create the STG_CUSTOMER_DETAILS stage
    And the AS_OF_DATE_TS table is created and populated with data
      | AS_OF_DATE                 |
      | 2018-05-31 23:59:59.999999 |
      | 2018-06-01 00:00:00.000000 |
      | 2018-06-01 00:00:00.000001 |
      | 2018-06-01 23:59:59.999999 |
      | 2018-06-02 00:00:00.000001 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE   | SOURCE |
      | md5('1001') | 1001        | 2018-06-01  | *      |
      | md5('1002') | 1002        | 2018-06-01  | *      |
      | md5('1003') | 1003        | 2018-06-01  | *      |
    Then the SAT_CUSTOMER_DETAILS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01     | 2018-06-01 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01     | 2018-06-01 | *      |
    Then the PIT_CUSTOMER_HG table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE                 | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2018-05-31 23:59:59.999999 | 0000000000000000        | 1900-01-01                |
      | md5('1001') | 2018-06-01 00:00:00.000000 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2018-06-01 00:00:00.000001 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2018-06-01 23:59:59.999999 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2018-06-02 00:00:00.000001 | md5('1001')             | 2018-06-01                |
      | md5('1002') | 2018-05-31 23:59:59.999999 | 0000000000000000        | 1900-01-01                |
      | md5('1002') | 2018-06-01 00:00:00.000000 | md5('1002')             | 1900-01-01                |
      | md5('1002') | 2018-06-01 00:00:00.000001 | md5('1002')             | 2018-06-01                |
      | md5('1002') | 2018-06-01 23:59:59.999999 | md5('1002')             | 2018-06-01                |
      | md5('1002') | 2018-06-02 00:00:00.000001 | md5('1002')             | 2018-06-01                |
      | md5('1003') | 2018-05-31 23:59:59.999999 | 0000000000000000        | 1900-01-01                |
      | md5('1003') | 2018-06-01 00:00:00.000000 | md5('1003')             | 1900-01-01                |
      | md5('1003') | 2018-06-01 00:00:00.000001 | md5('1003')             | 2018-06-01                |
      | md5('1003') | 2018-06-01 23:59:59.999999 | md5('1003')             | 2018-06-01                |
      | md5('1003') | 2018-06-02 00:00:00.000001 | md5('1003')             | 2018-06-01                |


#  # NULLS
#  @fixture.pit_one_sat
#  Scenario: [BASE-LOAD-NULL] Base load into a pit table from one satellite with NULL values & with dates where the AS OF table is already established with increments of a day & all as of dates are in the future
#    Given the PIT table does not exist
#    And the raw vault contains empty tables
#      | HUBS         | LINKS | SATS                 | PIT          |
#      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
#    And the RAW_STAGE_DETAILS table contains data
#      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE   | SOURCE |
#      | <null>      | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01  | *      |
#      | 1002        | <null>        | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01  | *      |
#      | 1003        | Chad          | <null>                   | 1988-02-12   | 2018-06-01  | *      |
#    And I create the STG_CUSTOMER_DETAILS stage
#    And the AS_OF_DATE table is created and populated with data
#      | AS_OF_DATE |
#      | 2019-01-02 |
#      | 2019-01-03 |
#      | 2019-01-04 |
#    When I load the vault
#    Then the HUB_CUSTOMER table should contain expected data
#      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE   | SOURCE |
#      | md5('1002') | 1002        | 2018-06-01  | *      |
#      | md5('1003') | 1003        | 2018-06-01  | *      |
#    Then the SAT_CUSTOMER_DETAILS table should contain expected data
#      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | HASHDIFF                                            | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
#      | md5('1002') | <null>        | 2 Forrest road Hampshire | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|^^') | 2018-06-01     | 2018-06-01 | *      |
#      | md5('1003') | Chad          | <null>                   | 1988-02-12   | md5('^^\|\|1988-02-12\|\|CHAD')                     | 2018-06-01     | 2018-06-01 | *      |
#    Then the PIT_CUSTOMER table should contain expected data
#      | CUSTOMER_PK | AS_OF_DATE | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
#      | md5('1002') | 2019-01-02 | md5('1002')             | 2018-06-01                |
#      | md5('1002') | 2019-01-03 | md5('1002')             | 2018-06-01                |
#      | md5('1002') | 2019-01-04 | md5('1002')             | 2018-06-01                |
#      | md5('1003') | 2019-01-02 | md5('1003')             | 2018-06-01                |
#      | md5('1003') | 2019-01-03 | md5('1003')             | 2018-06-01                |
#      | md5('1003') | 2019-01-04 | md5('1003')             | 2018-06-01                |
#
#  @fixture.pit_one_sat
#  Scenario: [BASE-LOAD-NULL] Base load into a pit table from one satellite with NULL values & with dates where the AS OF table is already established with increments of a day & all as of dates are in the past
#    Given the PIT table does not exist
#    And the raw vault contains empty tables
#      | HUBS         | LINKS | SATS                 | PIT          |
#      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
#    And the RAW_STAGE_DETAILS table contains data
#      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE   | SOURCE |
#      | <null>      | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01  | *      |
#      | 1002        | <null>        | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01  | *      |
#      | 1003        | Chad          | <null>                   | 1988-02-12   | 2018-06-01  | *      |
#    And I create the STG_CUSTOMER_DETAILS stage
#    And the AS_OF_DATE table is created and populated with data
#      | AS_OF_DATE |
#      | 2018-01-02 |
#      | 2018-01-03 |
#      | 2018-01-04 |
#    When I load the vault
#    Then the HUB_CUSTOMER table should contain expected data
#      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE   | SOURCE |
#      | md5('1002') | 1002        | 2018-06-01  | *      |
#      | md5('1003') | 1003        | 2018-06-01  | *      |
#    Then the SAT_CUSTOMER_DETAILS table should contain expected data
#      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | HASHDIFF                                            | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
#      | md5('1002') | <null>        | 2 Forrest road Hampshire | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|^^') | 2018-06-01     | 2018-06-01 | *      |
#      | md5('1003') | Chad          | <null>                   | 1988-02-12   | md5('^^\|\|1988-02-12\|\|CHAD')                     | 2018-06-01     | 2018-06-01 | *      |
#    Then the PIT_CUSTOMER table should contain expected data
#      | CUSTOMER_PK | AS_OF_DATE | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
#      | md5('1002') | 2018-01-02 | 0000000000000000        | 1900-01-01                |
#      | md5('1002') | 2018-01-03 | 0000000000000000        | 1900-01-01                |
#      | md5('1002') | 2018-01-04 | 0000000000000000        | 1900-01-01                |
#      | md5('1003') | 2018-01-02 | 0000000000000000        | 1900-01-01                |
#      | md5('1003') | 2018-01-03 | 0000000000000000        | 1900-01-01                |
#      | md5('1003') | 2018-01-04 | 0000000000000000        | 1900-01-01                |
#
#  @fixture.pit_one_sat
#  Scenario: [BASE-LOAD-NULL] Base load into a pit table from one satellite with NULL values & with dates where the AS OF table is already established with increments of a day & some as of dates are in the past
#    Given the PIT table does not exist
#    And the raw vault contains empty tables
#      | HUBS         | LINKS | SATS                 | PIT          |
#      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
#    And the RAW_STAGE_DETAILS table contains data
#      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE   | SOURCE |
#      | <null>      | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01  | *      |
#      | 1002        | <null>        | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01  | *      |
#      | 1003        | Chad          | <null>                   | 1988-02-12   | 2018-06-01  | *      |
#    And I create the STG_CUSTOMER_DETAILS stage
#    And the AS_OF_DATE table is created and populated with data
#      | AS_OF_DATE |
#      | 2018-01-02 |
#      | 2019-06-01 |
#      | 2019-06-02 |
#    When I load the vault
#    Then the HUB_CUSTOMER table should contain expected data
#      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE   | SOURCE |
#      | md5('1002') | 1002        | 2018-06-01  | *      |
#      | md5('1003') | 1003        | 2018-06-01  | *      |
#    Then the SAT_CUSTOMER_DETAILS table should contain expected data
#      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | HASHDIFF                                            | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
#      | md5('1002') | <null>        | 2 Forrest road Hampshire | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|^^') | 2018-06-01     | 2018-06-01 | *      |
#      | md5('1003') | Chad          | <null>                   | 1988-02-12   | md5('^^\|\|1988-02-12\|\|CHAD')                     | 2018-06-01     | 2018-06-01 | *      |
#    Then the PIT_CUSTOMER table should contain expected data
#      | CUSTOMER_PK | AS_OF_DATE | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
#      | md5('1002') | 2019-01-02 | 0000000000000000        | 1900-01-01                |
#      | md5('1002') | 2019-01-03 | md5('1002')             | 2018-06-01                |
#      | md5('1002') | 2019-01-04 | md5('1002')             | 2018-06-01                |
#      | md5('1003') | 2019-01-02 | 0000000000000000        | 1900-01-01                |
#      | md5('1003') | 2019-01-03 | md5('1003')             | 2018-06-01                |
#      | md5('1003') | 2019-01-04 | md5('1003')             | 2018-06-01                |

  # DUPLICATES
  # For later

######################### INCREMENTAL LOAD #########################

  # DATES
  @fixture.pit_one_sat
  Scenario: [INCR-LOAD] Incremental load with the more recent AS OF dates into an already populated pit table from one satellite with dates
    Given the HUB_CUSTOMER hub is already populated with data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE   | SOURCE |
      | md5('1001') | 1001        | 2018-06-01  | *      |
      | md5('1002') | 1002        | 2018-06-01  | *      |
      | md5('1003') | 1003        | 2018-06-01  | *      |
    And the SAT_CUSTOMER_DETAILS sat is already populated with data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | Bob           | 22 Forrest road Hampshire | 2006-04-17   | md5('22 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')  | 2018-06-03     | 2018-06-03 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01     | 2018-06-01 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAZ')  | 2018-06-02     | 2018-06-02 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-11\|\|CHAZ')  | 2018-06-03     | 2018-06-03 | *      |
    And the PIT_CUSTOMER pit is already populated with data
      | CUSTOMER_PK | AS_OF_DATE | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2018-05-31 | 0000000000000000        | 1900-01-01                |
      | md5('1001') | 2018-06-02 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2018-06-04 | md5('1001')             | 2018-06-01                |
      | md5('1002') | 2018-05-31 | 0000000000000000        | 1900-01-01                |
      | md5('1002') | 2018-06-02 | md5('1002')             | 2018-06-01                |
      | md5('1002') | 2018-06-04 | md5('1002')             | 2018-06-03                |
      | md5('1003') | 2018-05-31 | 0000000000000000        | 1900-01-01                |
      | md5('1003') | 2018-06-02 | md5('1003')             | 2018-06-02                |
      | md5('1003') | 2018-06-04 | md5('1003')             | 2018-06-03                |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1992-04-24   | 2018-06-04 | *      |
      | 1004        | Dom           | 4 Forrest road Hampshire  | 1950-01-01   | 2018-06-05 | *      |
    And I create the STG_CUSTOMER_DETAILS stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-06-01 |
      | 2018-06-03 |
      | 2018-06-05 |
    When I load the vault
#    When I load the HUB_CUSTOMER hub
#    And I load the SAT_CUSTOMER_DETAILS sat
#    And I load the PIT_CUSTOMER pit
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE   | SOURCE |
      | md5('1001') | 1001        | 2018-06-01  | *      |
      | md5('1002') | 1002        | 2018-06-01  | *      |
      | md5('1003') | 1003        | 2018-06-01  | *      |
      | md5('1004') | 1004        | 2018-06-04  | *      |
    Then the SAT_CUSTOMER_DETAILS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | Bob           | 22 Forrest road Hampshire | 2006-04-17   | md5('22 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')  | 2018-06-03     | 2018-06-03 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01     | 2018-06-01 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAZ')  | 2018-06-02     | 2018-06-02 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-11\|\|CHAZ')  | 2018-06-03     | 2018-06-03 | *      |
      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1992-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-04     | 2018-06-04 | *      |
      | md5('1004') | Dom           | 4 Forrest road Hampshire  | 1950-01-01   | md5('4 FORREST ROAD HAMPSHIRE\|\|1950-01-01\|\|DOM')   | 2018-06-05     | 2018-06-05 | *      |
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2018-06-01 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2018-06-03 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2018-06-05 | md5('1001')             | 2018-06-04                |
      | md5('1002') | 2018-06-01 | md5('1002')             | 2018-06-01                |
      | md5('1002') | 2018-06-03 | md5('1002')             | 2018-06-03                |
      | md5('1002') | 2018-06-05 | md5('1002')             | 2018-06-03                |
      | md5('1003') | 2018-06-01 | md5('1003')             | 2018-06-01                |
      | md5('1003') | 2018-06-03 | md5('1003')             | 2018-06-03                |
      | md5('1003') | 2018-06-05 | md5('1003')             | 2018-06-03                |
      | md5('1004') | 2018-06-01 | 0000000000000000        | 1900-01-01                |
      | md5('1004') | 2018-06-03 | 0000000000000000        | 1900-01-01                |
      | md5('1004') | 2018-06-05 | md5('1003')             | 2018-06-05                |

  # TIMESTAMPS
  @fixture.pit_one_sat
  Scenario: [INCR-LOAD] Incremental load with the more recent AS OF timestamps into an already populated pit table from one satellite with timestamps
    Given the HUB_CUSTOMER_TS hub is already populated with data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE                  | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000000 | *      |
    And the SAT_CUSTOMER_DETAILS_TS sat is already populated with data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | Bob           | 22 Forrest road Hampshire | 2006-04-17   | md5('22 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')  | 2018-06-01 23:59:59.999999 | 2018-06-01 23:59:59.999999 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAZ')  | 2018-06-01 12:00:00.000001 | 2018-06-01 12:00:00.000001 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-11\|\|CHAZ')  | 2018-06-01 23:59:59.999999 | 2018-06-01 23:59:59.999999 | *      |
    And the PIT_CUSTOMER_TS pit is already populated with data
      | CUSTOMER_PK | AS_OF_DATE                 | SAT_CUSTOMER_DETAILS_TS_PK | SAT_CUSTOMER_DETAILS_TS_LDTS |
      | md5('1001') | 2018-05-31 12:00:00.000000 | 0000000000000000           | 1900-01-01 00:00:00.000000   |
      | md5('1001') | 2018-06-01 00:00:00.000000 | md5('1001')                | 2018-06-01 00:00:00.000000   |
      | md5('1001') | 2018-06-01 12:00:00.000000 | md5('1001')                | 2018-06-01 00:00:00.000000   |
      | md5('1001') | 2018-06-02 00:00:00.000000 | md5('1001')                | 2018-06-01 00:00:00.000000   |
      | md5('1001') | 2018-06-02 12:00:00.000000 | md5('1001')                | 2018-06-01 00:00:00.000000   |
      | md5('1002') | 2018-05-31 12:00:00.000000 | 0000000000000000           | 1900-01-01 00:00:00.000000   |
      | md5('1002') | 2018-06-01 00:00:00.000000 | md5('1002')                | 2018-06-01 00:00:00.000000   |
      | md5('1002') | 2018-06-01 12:00:00.000000 | md5('1002')                | 2018-06-01 00:00:00.000000   |
      | md5('1002') | 2018-06-02 00:00:00.000000 | md5('1002')                | 2018-06-01 23:59:59.999999   |
      | md5('1002') | 2018-06-02 12:00:00.000000 | md5('1002')                | 2018-06-01 23:59:59.999999   |
      | md5('1003') | 2018-05-31 12:00:00.000000 | 0000000000000000           | 1900-01-01 00:00:00.000000   |
      | md5('1003') | 2018-06-01 00:00:00.000000 | md5('1003')                | 2018-06-01 00:00:00.000000   |
      | md5('1003') | 2018-06-01 12:00:00.000000 | md5('1003')                | 2018-06-01 00:00:00.000000   |
      | md5('1003') | 2018-06-02 00:00:00.000000 | md5('1003')                | 2018-06-01 23:59:59.999999   |
      | md5('1003') | 2018-06-02 12:00:00.000000 | md5('1003')                | 2018-06-01 23:59:59.999999   |
    And the RAW_STAGE_DETAILS_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATE                  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1992-04-24   | 2018-06-02 12:00:00.000001 | *      |
      | 1004        | Dom           | 4 Forrest road Hampshire  | 1950-01-01   | 2018-06-02 23:59:59.999999 | *      |
    And I create the STG_CUSTOMER_DETAILS_TS stage
    And the AS_OF_DATE_TS table is created and populated with data
      | AS_OF_DATE                 |
      | 2018-06-02 00:00:00.000000 |
      | 2018-06-02 12:00:00.000000 |
      | 2018-06-03 00:00:00.000000 |
    When I load the vault
#    When I load the HUB_CUSTOMER hub
#    And I load the SAT_CUSTOMER_DETAILS sat
#    And I load the PIT_CUSTOMER pit
    Then the HUB_CUSTOMER_TS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE                  | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1004') | 1004        | 2018-06-02 23:59:59.999999 | *      |
    Then the SAT_CUSTOMER_DETAILS_TS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | Bob           | 22 Forrest road Hampshire | 2006-04-17   | md5('22 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')  | 2018-06-01 23:59:59.999999 | 2018-06-01 23:59:59.999999 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAZ')  | 2018-06-01 12:00:00.000001 | 2018-06-01 12:00:00.000001 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-11\|\|CHAZ')  | 2018-06-01 23:59:59.999999 | 2018-06-01 23:59:59.999999 | *      |
      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1992-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1004') | Dom           | 4 Forrest road Hampshire  | 1950-01-01   | md5('4 FORREST ROAD HAMPSHIRE\|\|1950-01-01\|\|DOM')   | 2018-06-02 23:59:59.999999 | 2018-06-02 23:59:59.999999 | *      |
    Then the PIT_CUSTOMER_TS table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE                 | SAT_CUSTOMER_DETAILS_TS_PK | SAT_CUSTOMER_DETAILS_TS_LDTS |
      | md5('1001') | 2018-06-02 00:00:00.000000 | md5('1001')                | 2018-06-01 00:00:00.000000   |
      | md5('1001') | 2018-06-02 12:00:00.000000 | md5('1001')                | 2018-06-01 00:00:00.000000   |
      | md5('1001') | 2018-06-03 00:00:00.000000 | md5('1001')                | 2018-06-02 12:00:00.000001   |
      | md5('1002') | 2018-06-02 00:00:00.000000 | md5('1002')                | 2018-06-01 23:59:59.999999   |
      | md5('1002') | 2018-06-02 12:00:00.000000 | md5('1002')                | 2018-06-01 23:59:59.999999   |
      | md5('1002') | 2018-06-03 00:00:00.000000 | md5('1002')                | 2018-06-01 23:59:59.999999   |
      | md5('1003') | 2018-06-02 00:00:00.000000 | md5('1003')                | 2018-06-01 23:59:59.999999   |
      | md5('1003') | 2018-06-02 12:00:00.000000 | md5('1003')                | 2018-06-01 23:59:59.999999   |
      | md5('1003') | 2018-06-03 00:00:00.000000 | md5('1003')                | 2018-06-01 23:59:59.999999   |
      | md5('1004') | 2018-06-02 00:00:00.000000 | 0000000000000000           | 1900-01-01 00:00:00.000000   |
      | md5('1004') | 2018-06-02 12:00:00.000000 | 0000000000000000           | 1900-01-01 00:00:00.000000   |
      | md5('1004') | 2018-06-03 00:00:00.000000 | md5('1004')                | 2018-06-02 23:59:59.999999   |

  # AS OF - LOWER GRANULARITY
  @fixture.pit_one_sat
  Scenario: [INCR-LOAD-LG] Incremental load with the more recent AS OF dates into an already populated pit table from one satellite with timestamps
    Given the HUB_CUSTOMER_TS hub is already populated with data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE                  | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000000 | *      |
    And the SAT_CUSTOMER_DETAILS_TS sat is already populated with data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | Bob           | 22 Forrest road Hampshire | 2006-04-17   | md5('22 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')  | 2018-06-01 23:59:59.999999 | 2018-06-01 23:59:59.999999 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAZ')  | 2018-06-01 12:00:00.000001 | 2018-06-01 12:00:00.000001 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-11\|\|CHAZ')  | 2018-06-01 23:59:59.999999 | 2018-06-01 23:59:59.999999 | *      |
    And the PIT_CUSTOMER_LG pit is already populated with data
      | CUSTOMER_PK | AS_OF_DATE                | SAT_CUSTOMER_DETAILS_TS_PK | SAT_CUSTOMER_DETAILS_TS_LDTS |
      | md5('1001') | 2018-05-31 00:00:00.00000 | 0000000000000000           | 1900-01-01 00:00:00.000000   |
      | md5('1001') | 2018-06-01 00:00:00.00000 | md5('1001')                | 2018-06-01 00:00:00.000000   |
      | md5('1001') | 2018-06-02 00:00:00.00000 | md5('1001')                | 2018-06-01 00:00:00.000000   |
      | md5('1002') | 2018-05-31 00:00:00.00000 | 0000000000000000           | 1900-01-01 00:00:00.000000   |
      | md5('1002') | 2018-06-01 00:00:00.00000 | md5('1002')                | 2018-06-01 00:00:00.000000   |
      | md5('1002') | 2018-06-02 00:00:00.00000 | md5('1002')                | 2018-06-01 23:59:59.999999   |
      | md5('1003') | 2018-05-31 00:00:00.00000 | 0000000000000000           | 1900-01-01 00:00:00.000000   |
      | md5('1003') | 2018-06-01 00:00:00.00000 | md5('1003')                | 2018-06-01 00:00:00.000000   |
      | md5('1003') | 2018-06-02 00:00:00.00000 | md5('1003')                | 2018-06-01 23:59:59.999999   |
    And the RAW_STAGE_DETAILS_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATE                  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1992-04-24   | 2018-06-02 12:00:00.000001 | *      |
      | 1004        | Dom           | 4 Forrest road Hampshire  | 1950-01-01   | 2018-06-02 23:59:59.999999 | *      |
    And I create the STG_CUSTOMER_DETAILS_TS stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-06-01 |
      | 2018-06-02 |
      | 2018-06-03 |
    When I load the vault
#    When I load the HUB_CUSTOMER hub
#    And I load the SAT_CUSTOMER_DETAILS sat
#    And I load the PIT_CUSTOMER pit
    Then the HUB_CUSTOMER_TS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE                  | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1004') | 1004        | 2018-06-02 23:59:59.999999 | *      |
    Then the SAT_CUSTOMER_DETAILS_TS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | Bob           | 22 Forrest road Hampshire | 2006-04-17   | md5('22 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')  | 2018-06-01 23:59:59.999999 | 2018-06-01 23:59:59.999999 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAZ')  | 2018-06-01 12:00:00.000001 | 2018-06-01 12:00:00.000001 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-11\|\|CHAZ')  | 2018-06-01 23:59:59.999999 | 2018-06-01 23:59:59.999999 | *      |
      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1992-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1004') | Dom           | 4 Forrest road Hampshire  | 1950-01-01   | md5('4 FORREST ROAD HAMPSHIRE\|\|1950-01-01\|\|DOM')   | 2018-06-02 23:59:59.999999 | 2018-06-02 23:59:59.999999 | *      |
    Then the PIT_CUSTOMER_LG table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE                 | SAT_CUSTOMER_DETAILS_TS_PK | SAT_CUSTOMER_DETAILS_TS_LDTS |
      | md5('1001') | 2018-06-01 00:00:00.000000 | md5('1001')                | 2018-06-01 00:00:00.000000   |
      | md5('1001') | 2018-06-02 00:00:00.000000 | md5('1001')                | 2018-06-01 00:00:00.000000   |
      | md5('1001') | 2018-06-03 00:00:00.000000 | md5('1001')                | 2018-06-02 12:00:00.000001   |
      | md5('1002') | 2018-06-01 00:00:00.000000 | md5('1002')                | 2018-06-01 00:00:00.000000   |
      | md5('1002') | 2018-06-02 00:00:00.000000 | md5('1002')                | 2018-06-01 23:59:59.999999   |
      | md5('1002') | 2018-06-03 00:00:00.000000 | md5('1002')                | 2018-06-01 23:59:59.999999   |
      | md5('1003') | 2018-06-01 00:00:00.000000 | md5('1003')                | 2018-06-01 00:00:00.000000   |
      | md5('1003') | 2018-06-02 00:00:00.000000 | md5('1003')                | 2018-06-01 23:59:59.999999   |
      | md5('1003') | 2018-06-03 00:00:00.000000 | md5('1003')                | 2018-06-01 23:59:59.999999   |
      | md5('1004') | 2018-06-01 00:00:00.000000 | 0000000000000000           | 1900-01-01 00:00:00.000000   |
      | md5('1004') | 2018-06-02 00:00:00.000000 | 0000000000000000           | 1900-01-01 00:00:00.000000   |
      | md5('1004') | 2018-06-03 00:00:00.000000 | md5('1004')                | 2018-06-02 23:59:59.999999   |

  # AS OF - HIGHER GRANULARITY
  @fixture.pit_one_sat
  Scenario: [INCR-LOAD-HG] Incremental load with the more recent AS OF timestamps into an already populated pit table from one satellite with dates
    Given the HUB_CUSTOMER hub is already populated with data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE   | SOURCE |
      | md5('1001') | 1001        | 2018-06-01  | *      |
      | md5('1002') | 1002        | 2018-06-01  | *      |
      | md5('1003') | 1003        | 2018-06-01  | *      |
    And the SAT_CUSTOMER_DETAILS sat is already populated with data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | Bob           | 22 Forrest road Hampshire | 2006-04-17   | md5('22 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')  | 2018-06-03     | 2018-06-03 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01     | 2018-06-01 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAZ')  | 2018-06-02     | 2018-06-02 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-11\|\|CHAZ')  | 2018-06-03     | 2018-06-03 | *      |
    And the PIT_CUSTOMER_HG pit is already populated with data
      | CUSTOMER_PK | AS_OF_DATE                 | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS  |
      | md5('1001') | 2018-05-31 12:00:00.000000 | 0000000000000000        | 1900-01-01 00:00:00.000000 |
      | md5('1001') | 2018-06-02 12:00:00.000000 | md5('1001')             | 2018-06-01 00:00:00.000000 |
      | md5('1001') | 2018-06-04 12:00:00.000000 | md5('1001')             | 2018-06-01 00:00:00.000000 |
      | md5('1002') | 2018-05-31 12:00:00.000000 | 0000000000000000        | 1900-01-01 00:00:00.000000 |
      | md5('1002') | 2018-06-02 12:00:00.000000 | md5('1002')             | 2018-06-01 00:00:00.000000 |
      | md5('1002') | 2018-06-04 12:00:00.000000 | md5('1002')             | 2018-06-03 00:00:00.000000 |
      | md5('1003') | 2018-05-31 12:00:00.000000 | 0000000000000000        | 1900-01-01 00:00:00.000000 |
      | md5('1003') | 2018-06-02 12:00:00.000000 | md5('1003')             | 2018-06-02 00:00:00.000000 |
      | md5('1003') | 2018-06-04 12:00:00.000000 | md5('1003')             | 2018-06-03 00:00:00.000000 |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1992-04-24   | 2018-06-04 | *      |
      | 1004        | Dom           | 4 Forrest road Hampshire  | 1950-01-01   | 2018-06-05 | *      |
    And I create the STG_CUSTOMER_DETAILS stage
    And the AS_OF_DATE_TS table is created and populated with data
      | AS_OF_DATE                 |
      | 2018-06-02 00:00:00.000000 |
      | 2018-06-04 00:00:00.000000 |
      | 2018-06-06 00:00:00.000000 |
    When I load the vault
#    When I load the HUB_CUSTOMER hub
#    And I load the SAT_CUSTOMER_DETAILS sat
#    And I load the PIT_CUSTOMER pit
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE   | SOURCE |
      | md5('1001') | 1001        | 2018-06-01  | *      |
      | md5('1002') | 1002        | 2018-06-01  | *      |
      | md5('1003') | 1003        | 2018-06-01  | *      |
      | md5('1004') | 1004        | 2018-06-04  | *      |
    Then the SAT_CUSTOMER_DETAILS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | Bob           | 22 Forrest road Hampshire | 2006-04-17   | md5('22 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')  | 2018-06-03     | 2018-06-03 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01     | 2018-06-01 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAZ')  | 2018-06-02     | 2018-06-02 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-11\|\|CHAZ')  | 2018-06-03     | 2018-06-03 | *      |
      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1992-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-04     | 2018-06-04 | *      |
      | md5('1004') | Dom           | 4 Forrest road Hampshire  | 1950-01-01   | md5('4 FORREST ROAD HAMPSHIRE\|\|1950-01-01\|\|DOM')   | 2018-06-05     | 2018-06-05 | *      |
    Then the PIT_CUSTOMER_HG table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE                 | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS  |
      | md5('1001') | 2018-06-02 00:00:00.000000 | md5('1001')             | 2018-06-01 00:00:00.000000 |
      | md5('1001') | 2018-06-04 00:00:00.000000 | md5('1001')             | 2018-06-04 00:00:00.000000 |
      | md5('1001') | 2018-06-06 00:00:00.000000 | md5('1001')             | 2018-06-04 00:00:00.000000 |
      | md5('1002') | 2018-06-02 00:00:00.000000 | md5('1002')             | 2018-06-01 00:00:00.000000 |
      | md5('1002') | 2018-06-04 00:00:00.000000 | md5('1002')             | 2018-06-03 00:00:00.000000 |
      | md5('1002') | 2018-06-06 00:00:00.000000 | md5('1002')             | 2018-06-03 00:00:00.000000 |
      | md5('1003') | 2018-06-02 00:00:00.000000 | md5('1003')             | 2018-06-02 00:00:00.000000 |
      | md5('1003') | 2018-06-04 00:00:00.000000 | md5('1003')             | 2018-06-03 00:00:00.000000 |
      | md5('1003') | 2018-06-06 00:00:00.000000 | md5('1003')             | 2018-06-03 00:00:00.000000 |
      | md5('1004') | 2018-06-02 00:00:00.000000 | 0000000000000000        | 1900-01-01 00:00:00.000000 |
      | md5('1004') | 2018-06-04 00:00:00.000000 | 0000000000000000        | 1900-01-01 00:00:00.000000 |
      | md5('1004') | 2018-06-06 00:00:00.000000 | md5('1004')             | 2018-06-05 00:00:00.000000 |