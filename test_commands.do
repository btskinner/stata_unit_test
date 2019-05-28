// -----------------------------------------------------------------------------
// BEGIN test_commands.do
// -----------------------------------------------------------------------------

capture program drop test_command
program define test_command
version 12
	// -- USE -----------------------------------------------------
	//
	// Prepend this command to the command you want to test:
	//
	// test_command < -command_to_test- >
	//
	// ------------------------------------------------------------
	local command `0'
	display as input _newline "VALIDATING: `command'" _newline
	`command'
end

capture program drop test_assert
program define test_assert
version 12
	// -- USE -----------------------------------------------------
	//
	// Prepend this command to a message and the assertion you want
	// to test:
	//
	// test_assert "< message string >" < -command_to_test- >
	//
	// ------------------------------------------------------------
	local message `1'
	macro shift 1
	local test_statement "`*'"
   capture assert `test_statement'
	if _rc == 0 {
		display as input "> PASS: `message'"
	}
	else {
		display as error "> FAIL: `message'" _newline			
		display as error _col(3) "-- ERROR MESSAGE " _dup(48) "-"
		display as error _col(3) "Assertion returned false: `test_statement'"
		display as error _col(3) _dup(65) "-" _newline
		if "$stopiferror" == "1" {
			macro drop stopiferror
			error 9
		}
	}
end

capture program drop run_tests
program define run_tests
version 12
	// -- USE -----------------------------------------------------
	//
	// Give directory of "test-*.do" files.
	//
	// run_tests, testfiledirectory(< path/to/tests-*.do >)
	//
	// OPTIONAL ARGUMENT
	//
	// - stopiferror: include if you want Stata to stop on false
	//                assertion; good for inspecting error
	//
	// ------------------------------------------------------------
	syntax, TESTFiledirectory(string) [ stopiferror ]
	if "`stopiferror'" != "" {
		global stopiferror = 1
	}
	local tfiles: dir "`testfiledirectory'" files "test-*.do"
	foreach tf of local tfiles {
		display as input _newline _dup(80) "="
		display as input "FILE: `tf'"
		display as input _dup(80) "="
		quietly do "`testfiledirectory'/`tf'"
	}
	macro drop stopiferror
end


// -----------------------------------------------------------------------------
// END test_commands.do
// -----------------------------------------------------------------------------
