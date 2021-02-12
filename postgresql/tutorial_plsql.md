http://www.postgresqltutorial.com/plpgsql-block-structure/

```
[ <<label>> ]
[ DECLARE
    declarations ]
BEGIN
    statements;
   ...
END [ label ];
```

- Each block has two sections: declaration and body. The declaration section is optional while the body section is required. The block is ended with a semicolon (;) after the END keyword.

- A block may have an optional label located at the beginning and at the end. You use the block label in case you want to specify it in the EXIT statement of the block body or if you want to qualify the names of variables declared in the block.

- The declaration section is where you declare all variables used within the body section. Each statement in the declaration section is terminated with a semicolon (;).

- The body section is where you place the code. Each statement in the body section is also terminated with a semicolon (;).


#### PL/pgSQL block structure example

anonymous block sample.

```
DO $$
<<first_block>>
DECLARE
  counter integer := 0;
BEGIN
   counter := counter + 1;
   RAISE NOTICE 'The current value of counter is %', counter;
END first_block $$;
```

Notice that the DO statement does not belong to the block. It is used to execute an anonymous block. PostgreSQL introduced the DO statement since version 9.0.


**What is the double dollar ($$)?**

The double dollar ($$) is a substitution of a single quote (‘).  When you develop a PL/pgSQL block, a function, or a stored procedure, you have to pass its body in the form of a string literal. In addition, you have to escape all single quote (‘) in the body as follows:

If you use the double dollar ($$) you can avoid quoting issues. You can also use a token between $$ like  $function$ or $procedure$.

http://www.postgresguide.com/utilities/psql.html