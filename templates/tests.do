// =============================================================================
//
// [ PROJ ] < ... >
// [ FILE ] tests.do
// [ AUTH ] < ... >
// [ INIT ] < ... >
//
// =============================================================================

// -- PURPOSE ------------------------------------------------------------------
//
// The format of the scripts is very loosely based on R's testthat
// package. Stata doesn't have such a robust system---or at least not
// one that I'm aware of---so tests should generally consist of two
// steps:
// 
// (1) running the user-written command after -test_command- to produce
//     known results
// (2) running -test_assert- statements to confirm that actual
//     results match expectations.
//
// Like R's testthat package, each user-written command should have
// its own testing script called "test-*.do" where "*" is the name of
// the command. All tests of the command should live in the file. In
// general, it's probably best to either read in very small testing
// data sets or create them in each file as well as clean up at the
// end of each file.
//
// If the suite of test scripts runs without error, then all tests
// have passed. All passing tests will print using input font style
// (default: bold black). All failing tests will print error style
// (default: red). If the <stopiferror> option is given to the
// -run_tests_ command, then any failing test will halt the
// script. Otherwise, the failure will be noted, but the script will
// continue.
//
// -----------------------------------------------------------------------------

// load test commands
quietly include "< path / to / test_commands.do >"

// load file(s) with your user-written programs
quietly include "< path / to / user-written program files >"

// run tests version 1 (no stopping)
run_tests, testfiledirectory("< path / to / test-*.do dir >")

// run tests version 2 (stop on error)
run_tests, testfiledirectory("< path / to / test-*.do dir >)") stopiferror

// -----------------------------------------------------------------------------
// END TEST SCRIPT
// =============================================================================

