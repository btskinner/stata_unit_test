In the course of putting together code for a large project, I wrote a
number of project-specific functions to reduce the number of repeated
blocks of code. I wanted to perform unit tests to confirm they worked
as expected, but was unable to find an existing process for doing so.

These helper functions and the process I ended up with are loosely
based on R's [testthat](https://testthat.r-lib.org) package /
process. The idea is basically the same:

1. For every command, create a file called `test-*.do` where `*` is
   the name of the function: *e.g.*, `test-my_command.do`. Store all
   these files in a single directory.  
1. Within each `test-*.do` file, use the twin helper commands,
   `test_command` and `test_assert` to first run your command and then
   test the results with `assert`-like expressions.  
1. Batch process all `test-*.do` scripts using `run_tests` in a
   primary test script. Results from passed and failed tests will be
   printed in a nice fashion in the results window. If the
   `stopiferror` option is used, errors will halt the test script and
   the problem can be investigated.  
   
More information about these commands and an outline of an example
process are below. These commands are not part of a proper `ado` file,
but rather should just be `run` or `include`d at the top of the
testing script. Someone more adept with writing Stata programs can
definitely improve on them.

## Helper functions

#### `test_command`

Use `test_command` just before your user-written command. It is a
simple wrapper that displays a message before running your command as
if you had typed it directly.

**USAGE**
```stata
. test_command < command to test >
```

**EXAMPLE**
```stata
// EXAMPLE: to test "my_command x y, gen(z)"
. test_command my_command x y, gen(z)

VALIDATING: my_command x y, gen(z)
```

#### `test_assert`

After running your command, use `test_assert` to see that your command
worked as expected.

**USAGE**
```stata
test_assert " < testing message string > " < assertion to test >
```

The first argument is a string that should be an informative message
about your test. The second argument should be an expression like you
would use with Stata's `assert` command. In fact, `test_assert` is
just a wrapper for the `assert` command that displays cleaner output
and by default captures error codes rather than halting.

**EXAMPLE**
```stata
// EXAMPLE: expect that new variable z is x + y
. test_assert "New variable z equals x plus y" z = x + y 

> PASS: New variable z equals x plus y
```

If the test fails, the font color will change to that of error codes
(red by default). The return message simply repeats the assertion
expression you used, which should be helpful in tracking down the
bug.

#### `run_tests`

Run all tests by calling `run_tests` from a separate do file. If you
add the `stopiferror` option, then Stata will halt if a test
fails. Otherwise, the font color and output will change as noted
above, but Stata will not stop.

**USAGE**
```stata
run_tests, testfiledirectory(path/to/test-*.do) [ stopiferror ]
```

## Example process

See the scripts in the `example` directory for an example testing
process. The user-written command converts a school system-specific
term code into a four-digit year. Two versions of the code are
included: one that is correct and on that has a bug (indicated with
`_bug` at the end of the file name). Normally, the buggy version of
the command would be overwritten by the patched version, but both are
included so you can see how `run_tests` handles both passing and
failing tests.

To run:

```stata
// change into example directy
cd ./examples

// run
do tests
```

## Templates

The `template` directory has two template files:  

1. `test-example.do`  
1. `tests.do`  

These can be used to build command-specific test files and the main
processing script, respectively.
