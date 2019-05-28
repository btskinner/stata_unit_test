// -----------------------------------------------------------------------------
// BEGIN util_commands.do
// -----------------------------------------------------------------------------

// -- PURPOSE ----------------------------------------------
//
// Let's say we are working with administrative files (1980 - 2010)
// from a school system that uses its own code for identifying
// terms. This term_code takes the form:
//
//     term_code := YYT
//
// where:
//
//     YY := is 2-digit year (2010 --> 10; 1996 --> 96)
//     T  := is term digit (spring --> 4; summer --> 5; fall --> 6)
//
// For our analyses, we need to pull the calendar year from the term
// code repeatedly. Rather than cutting/pasting, we want a quick
// function that will take the term_code and generate the correct
// four-digit year. For example:
//
// code_term = 996
//
// -->
//
// year = 1999
//
// Below are two programs we wrote. The first is the original version,
// which has a bug. In the second, the bug has been fixed. Normally,
// we wouldn't keep both, but for this example, they are both
// included.
//
// ---------------------------------------------------------

capture program drop term_code_to_yyyy_bug
program define term_code_to_yyyy_bug
version 12
	syntax [if] [in],             ///
		 TERMCodevar(varname)      ///
		 GENerate(name)

	// confirm that output name doesn't already exist
	capture confirm variable `generate'
	if _rc == 0 {
	 	display as error "Error! `generate' already exists"
		exit `syntaxError'
	}
	
	// marks sample subset using if / in commands
	marksample touse

	// check if term code is string; convert if not
	capture confirm string variable `termcodevar'
	if _rc != 0 {
		local termcodevar = string(`termcodevar')
	}
	
	// substring term_code and put together YYYY
	// NB: We assume any years greater > 50 are in 1990s
	tempvar tmpcen tmpyy
	generate int `tmpyy'  = real(substr(`termcodevar',1,2))
	generate int `tmpcen' = cond(`tmpyy' > 49, 1900, 2000, .) // <-- ERROR
	generate int `generate' = `tmpcen' + `tmpyy' if `touse'

end

capture program drop term_code_to_yyyy
program define term_code_to_yyyy
version 12
	syntax [if] [in],             ///
		 TERMCodevar(varname)      ///
		 GENerate(name)

	// confirm that output name doesn't already exist
	capture confirm variable `generate'
	if _rc == 0 {
	 	display as error "Error! `generate' already exists"
		exit `syntaxError'
	}
	
	// marks sample subset using if / in commands
	marksample touse

	// check if term code is string; convert if not
	capture confirm string variable `termcodevar'
	if _rc != 0 {
		local termcodevar = string(`termcodevar')
	}
	
	// substring term_code and put together YYYY
	// NB: We assume any years greater > 50 are in 1990s
	tempvar tmpcen tmpyy
	generate int `tmpyy'  = real(substr(`termcodevar',1,2))
	generate int `tmpcen' = cond(`tmpyy' > 50, 1900, 2000, .) // <-- FIXED
	generate int `generate' = `tmpcen' + `tmpyy' if `touse'

end

// -----------------------------------------------------------------------------
// END util_commands.do
// -----------------------------------------------------------------------------
