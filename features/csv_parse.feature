Feature: Parse csv input file
  The input to the system is a csv (comma separated values) file as defined by the Texas Ethics Committee for state
  office electronic filing.  We need to check that valid csv files are correctly parsed and that invalid cvs files are
  rejected with helpful error messages.

    APPENDIX A - FILE LAYOUT FOR IMPORTING / EXPORTING CONTRIBUTIONS
    NOTE (1): Files should be in comma-separated value format and the filename
    should end with a ".csv" extension. Trailing commas must be present for each
    field regardless of whether data is present. Note: double quotes (") may not be
    embedded in the data. If commas are embedded, the field should be surrounded by
    double quotes. Double quotes cannot surround the first 2 fields. If field
    names are on the first line, please begin that line with the “#” character.
    SAMPLE FILE: Contribs.csv
    (the contents of this file are also printed at the end of this Appendix)
    NOTE (2): The second column is a list of codes indicating whether a field is
    required for reporting purposes. “Rx” = Required field; TEC rejects filing if
    absent; “R” = Required field, but TEC accepts filing; “Cx” = Conditionally
    Required field; TEC rejects filing if absent; e.g., First Name is required only
    when Entity Code = “I”); “C” = Conditionally Required but TEC accepts filing;
    “o” = optional field; “Co” = conditionally optional; e.g., Field 07 (Contributor
    Title) is optional when Entity Code = “I”, but is not applicable (and should be
    blank) when Entity Code = “E”.
    NOTE (3): The first record of the export.csv file produced by TX-CFS contains a
    list of field names for informational purposes only. This record is not
    required for import files. If it is added, precede it with a “#” to indicate
    that it is for information only.

  Scenario Outline: Required input filename extension
    The input filename must end in ".csv"
    Given an empty file with a filename of <input_filename>
    When passed to the parser
    Then the output should contain: <result>

  Scenarios: empty file parsing
    | input_filename | result                                                            |
    | foo.csv        | filing is acceptable                                              |
    | foo.cvs        | filing is rejected because the filename's extension is not ".csv" |
    | foo            | filing is rejected because the filename's extension is not ".csv" |

  Scenario: Double quotes may not be embedded in the data

  Scenario: Commas may be embedded if surrounded by double quotes (",")

  Scenario: Double quotes may not surround the first two fields

  Scenario: If the file has field names, they must be the first line and start with a '#' character

  Scenario: Handles valid CSV that exercises all column data types

  Scenario: Missing Rx required data CSV input rejects filing

  Scenario: Missing R required data CSV input accepts filing

  Scenario: Missing Cx conditionally required data CSV input rejects filing

  Scenario: Missing C conditionally required data CSV input accepts filing

  Scenario: Missing Co conditionally optional data CSV input accepts filing

  Scenario: Missing conditionally optional data CSV input accepts filing


