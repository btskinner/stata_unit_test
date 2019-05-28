// =============================================================================
//
// [ PROJ ] Stata unit testing
// [ FILE ] tests.do
// [ AUTH ] Benjamin Skinner (@btskinner [GitHub : Twitter])
// [ INIT ] 24 May 2019
//
// =============================================================================

// load test commands
quietly include "../test_commands"

// load example utility commands we wrote
quietly include "./util_commands"

// run tests
run_tests, testfiledirectory("./test_scripts")

// uncomment line below to run tests, but stop when there's an error
// run_tests, testfiledirectory("./test_scripts") stopiferror

// -----------------------------------------------------------------------------
// END TEST SCRIPT
// =============================================================================

