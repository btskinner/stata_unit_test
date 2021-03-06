# Example

You can run an example testing process with these scripts. The
user-written command `term_code_to_yyyy`, defined in
`util_commands.do` is tested with
`./test_scripts/test-term_code_to_yyyy.do`. A version with a bug is
also tested. 

The `test-*.do` files are heavily commented and should be referenced
for how to set one up. Of course, the specific set up for your own
commands will change depending on the expected output and what you
want to test. 

After running, you can see that the buggy version of the command
passed all but one test. Because the test checked the accuracy of
specific data cells, the error could be quickly located and fixed.


## To run

```stata
// change into this directory (assuming you're in top-level directory)
cd ./examples

// run
do tests
```
