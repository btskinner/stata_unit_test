// test-term_code_to_yyyy.do
// found in: misc_programs.do

// -- purpose ------------------------------------

// To test that a year is correctly generated when given a term code
// value. We also need to test that is appropriately works when given
// an -if- conditional since that is included in the code.

clear

// -- set up -------------------------------------

// For this function, we'll build a nonce dataset in which we include
// the correct results as a column we can compare against. Because the
// program can take -if- statements, we'll include a group indicator.

input str3 term_code correct_yyyy group
	"004" 2000 0									 
	"005" 2000 1									 
	"006" 2000 1									 
	"104" 2010 1
	"995" 1999 0
	"506" 2050 0
	"516" 1951 1
end

// -- begin tests --------------------------------

// (1) Confirm that year is correctly created (exact rows)
test_command term_code_to_yyyy, termcodevar(term_code) generate(year)

test_assert "Row [1] is correct" year[1] == 2000
test_assert "Row [2] is correct" year[2] == 2000
test_assert "Row [3] is correct" year[3] == 2000
test_assert "Row [4] is correct" year[4] == 2010
test_assert "Row [5] is correct" year[5] == 1999
test_assert "Row [6] is correct" year[6] == 2050
test_assert "Row [7] is correct" year[7] == 1951

// (2) Confirm that -if- condition works
test_command term_code_to_yyyy if group == 1, termcodevar(term_code) generate(year2)

test_assert "Row [1] is correct" missing(year2[1])
test_assert "Row [2] is correct" year2[2] == 2000
test_assert "Row [3] is correct" year2[3] == 2000
test_assert "Row [4] is correct" year2[4] == 2010
test_assert "Row [5] is correct" missing(year2[5])
test_assert "Row [6] is correct" missing(year2[6])
test_assert "Row [7] is correct" year2[7] == 1951

// (3) Confirm that -in- condition works
test_command term_code_to_yyyy in 1/3, termcodevar(term_code) generate(year3)

test_assert "Row [1] is correct" year3[1] == 2000
test_assert "Row [2] is correct" year3[2] == 2000
test_assert "Row [3] is correct" year3[3] == 2000
test_assert "Row [4] is correct" missing(year3[4])
test_assert "Row [5] is correct" missing(year3[5])
test_assert "Row [6] is correct" missing(year3[6])
test_assert "Row [7] is correct" missing(year3[7])

// -- clean up -----------------------------------

clear
